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
