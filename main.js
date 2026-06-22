/**
 * Progressive enhancement for the navigation menu. The <details> element
 * opens and closes on its own with no JavaScript; this only adds the
 * conveniences a native disclosure does not provide: closing after a
 * destination is chosen, on Escape, and when the pointer lands outside.
 */
const nav = document.querySelector(".page-nav");

if (nav instanceof HTMLDetailsElement) {
  const toggle = nav.querySelector("summary");

  const close = () => {
    nav.open = false;
  };

  nav.addEventListener("click", (event) => {
    if (event.target instanceof Element && event.target.closest("a")) {
      close();
    }
  });

  document.addEventListener("pointerdown", (event) => {
    if (nav.open && event.target instanceof Node && !nav.contains(event.target)) {
      close();
    }
  });

  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape" && nav.open) {
      close();
      toggle?.focus();
    }
  });
}

/**
 * Privacy-friendly, cookieless page analytics via GoatCounter. Loaded here
 * instead of as a tag in index.html so the page carries no inline script and
 * its Markdown mirror stays in sync. It loads only on the production host, so
 * the CloudFront domain, local files, and previews never count, and it makes
 * no request when the visitor signals Do Not Track or Global Privacy Control.
 */
const ANALYTICS_ENDPOINT = "https://gra.goatcounter.com/count";
const ANALYTICS_HOSTS = ["gra.dev", "www.gra.dev"];

const privacySignalSet =
  navigator.doNotTrack === "1" ||
  window.doNotTrack === "1" ||
  navigator.globalPrivacyControl === true;

if (!privacySignalSet && ANALYTICS_HOSTS.includes(location.hostname)) {
  const analytics = document.createElement("script");
  analytics.async = true;
  analytics.src = "https://gc.zgo.at/count.js";
  analytics.setAttribute("data-goatcounter", ANALYTICS_ENDPOINT);
  document.head.appendChild(analytics);
}
