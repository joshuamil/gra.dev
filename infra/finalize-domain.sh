#!/usr/bin/env bash
#
# Finalize the gra.dev custom domain once the ACM certificate has validated.
#
# Prerequisite: the Namecheap nameservers for gra.dev must point at the
# Route53 hosted zone (delegation live) so the ACM DNS validation can complete.
#
# This script is idempotent. It:
#   1. waits for the ACM certificate to reach ISSUED
#   2. attaches the gra.dev alias + certificate to the CloudFront distribution
#   3. creates Route53 alias A/AAAA records pointing gra.dev at CloudFront
#
# It reads no secrets; it relies on the ambient AWS credentials/profile.

set -euo pipefail

AWS_REGION="us-east-1"
HOSTED_ZONE_ID="Z03140913OKXO3O06B1M2"
DISTRIBUTION_ID="E1FH6PHW9L9J5L"
CERT_ARN="arn:aws:acm:us-east-1:563999587405:certificate/af4c7dbf-88f4-4150-a5b0-a841c862d308"
DOMAIN="gra.dev"
# CloudFront's fixed hosted zone id for alias records (global constant).
CLOUDFRONT_HOSTED_ZONE_ID="Z2FDTNDATAQYW2"

echo "Waiting for certificate to be issued (this requires DNS delegation to be live)..."
aws acm wait certificate-validated --certificate-arn "$CERT_ARN" --region "$AWS_REGION"
echo "Certificate ISSUED."

echo "Fetching current distribution config..."
TMP_DIR="$(mktemp -d)"
aws cloudfront get-distribution-config --id "$DISTRIBUTION_ID" > "$TMP_DIR/dist.json"
ETAG="$(python3 -c "import json,sys;print(json.load(open('$TMP_DIR/dist.json'))['ETag'])")"

python3 - "$TMP_DIR/dist.json" "$TMP_DIR/config.json" "$CERT_ARN" "$DOMAIN" <<'PY'
import json, sys
src, dst, cert_arn, domain = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
cfg = json.load(open(src))["DistributionConfig"]
cfg["Aliases"] = {"Quantity": 1, "Items": [domain]}
cfg["ViewerCertificate"] = {
    "ACMCertificateArn": cert_arn,
    "SSLSupportMethod": "sni-only",
    "MinimumProtocolVersion": "TLSv1.2_2021",
    "Certificate": cert_arn,
    "CertificateSource": "acm",
}
json.dump(cfg, open(dst, "w"))
PY

echo "Attaching alias + certificate to distribution..."
aws cloudfront update-distribution \
  --id "$DISTRIBUTION_ID" \
  --if-match "$ETAG" \
  --distribution-config "file://$TMP_DIR/config.json" \
  --query "Distribution.Status" --output text

CF_DOMAIN="$(aws cloudfront get-distribution --id "$DISTRIBUTION_ID" \
  --query "Distribution.DomainName" --output text)"

echo "Creating Route53 alias records for $DOMAIN -> $CF_DOMAIN ..."
cat > "$TMP_DIR/alias.json" <<JSON
{
  "Comment": "Alias gra.dev to CloudFront",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "$DOMAIN.",
        "Type": "A",
        "AliasTarget": {
          "HostedZoneId": "$CLOUDFRONT_HOSTED_ZONE_ID",
          "DNSName": "$CF_DOMAIN",
          "EvaluateTargetHealth": false
        }
      }
    },
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "$DOMAIN.",
        "Type": "AAAA",
        "AliasTarget": {
          "HostedZoneId": "$CLOUDFRONT_HOSTED_ZONE_ID",
          "DNSName": "$CF_DOMAIN",
          "EvaluateTargetHealth": false
        }
      }
    }
  ]
}
JSON

aws route53 change-resource-record-sets \
  --hosted-zone-id "$HOSTED_ZONE_ID" \
  --change-batch "file://$TMP_DIR/alias.json" \
  --query "ChangeInfo.Status" --output text

rm -rf "$TMP_DIR"
echo "Done. https://$DOMAIN will resolve once the distribution finishes deploying and DNS propagates."
