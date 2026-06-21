/**
 * Progressive enhancement: marks the in-page nav link for the section currently
 * in view with aria-current="true". Pure visual aid; the page is fully usable
 * without it.
 */
export function initSectionNav({ navSelector, sectionSelector }) {
  const nav = document.querySelector(navSelector);
  const sections = Array.from(document.querySelectorAll(sectionSelector));

  if (!nav || sections.length === 0 || !("IntersectionObserver" in window)) {
    return;
  }

  const linkById = new Map();
  for (const link of nav.querySelectorAll("a[href^='#']")) {
    const id = link.getAttribute("href")?.slice(1);
    if (id) {
      linkById.set(id, link);
    }
  }

  const setCurrent = (id) => {
    for (const [linkId, link] of linkById) {
      if (linkId === id) {
        link.setAttribute("aria-current", "true");
      } else {
        link.removeAttribute("aria-current");
      }
    }
  };

  const observer = new IntersectionObserver(
    (entries) => {
      const visible = entries
        .filter((entry) => entry.isIntersecting)
        .sort((a, b) => b.intersectionRatio - a.intersectionRatio);

      if (visible.length > 0) {
        setCurrent(visible[0].target.id);
      }
    },
    { rootMargin: "-20% 0px -70% 0px", threshold: [0, 0.25, 0.5, 1] },
  );

  for (const section of sections) {
    observer.observe(section);
  }
}
