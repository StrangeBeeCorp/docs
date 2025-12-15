(function () {
  const WIDGET_SRC = "https://widget.kapa.ai/kapa-widget.bundle.js";

  // --- Helpers --------------------------------------------------------------
  function normalizedPathname() {
    const baseEl = document.querySelector("head base");
    const baseHref = baseEl ? baseEl.getAttribute("href") || "/" : "/";
    const basePath = new URL(baseHref, location.origin).pathname.replace(/\/$/, "");
    return location.pathname.replace(new RegExp("^" + basePath), "") || "/";
  }
  const isCortexPath = () => /^\/cortex(\/|$)/.test(normalizedPathname());

  // All candidate hosts that Kapa tends to add (best-effort)
  const HOST_SELECTORS = [
    "kapa-widget",
    "#kapa-widget",
    '[id^="kapa-widget"]',
    '[data-kapa-root]',
    '.kapa-widget-launcher',
    '.kapa-widget-container',
    'iframe[src*="kapa.ai"]'
  ];

  function forEachKapaNode(fn) {
    document.querySelectorAll(HOST_SELECTORS.join(",")).forEach(fn);
  }

  // Apply/remove inline styles (works even with Shadow DOM because we style the host)
  const HIDDEN_ATTR = "data-hidden-by-router";

  function setVisible(visible) {
    forEachKapaNode((n) => {
      if (visible) {
        if (n.hasAttribute(HIDDEN_ATTR)) {
          n.style.removeProperty("display");
          n.style.removeProperty("visibility");
          n.style.removeProperty("opacity");
          n.style.removeProperty("pointer-events");
          n.removeAttribute(HIDDEN_ATTR);
        }
      } else {
        n.style.setProperty("display", "none", "important");
        n.style.setProperty("visibility", "hidden", "important");
        n.style.setProperty("opacity", "0", "important");
        n.style.setProperty("pointer-events", "none", "important");
        n.setAttribute(HIDDEN_ATTR, "1");
      }
    });
  }

  function injectScriptIfNeeded() {
    if (document.querySelector(`script[src="${WIDGET_SRC}"]`)) return;
    const s = document.createElement("script");
    s.src = WIDGET_SRC;
    s.async = true;
    s.setAttribute("data-website-id", "b049a95f-ba36-4734-9e30-bc91f5a6dc54");
    s.setAttribute("data-project-name", "Cortex");
    s.setAttribute("data-project-color", "#323232");
    s.setAttribute("data-project-logo", "/resources/images/cortex.png");
    s.setAttribute("data-font-family", "Bauziet");
    s.setAttribute("data-consent-required", "true");
    s.setAttribute("data-consent-screen-disclaimer", "By clicking the \"I agree, let's chat\" button, you agree to the necessary cookies.");
    s.setAttribute("data-button-text-font-size", "17px");
    s.setAttribute("data-scale-factor", "0.85");
    s.setAttribute("data-modal-disclaimer", "AI assistance is currently limited to Cortex documentation. Answers about TheHive aren't yet supported.");
    s.setAttribute("data-modal-disclaimer-bg-color", "#E8F2FB");
    s.addEventListener("load", () => {
      // If we're currently off Cortex, hide immediately
      if (!isCortexPath()) setVisible(false);
    });
    document.head.appendChild(s);
  }

  // Observe added nodes so if the widget re-mounts while off Cortex we hide it instantly
  let mo;
  let moScheduled = false;

  function ensureObserver() {
    if (mo) return;

    mo = new MutationObserver(() => {
      if (moScheduled) return;
      moScheduled = true;

      queueMicrotask(() => {
        moScheduled = false;
        if (!isCortexPath()) setVisible(false);
      });
    });

    mo.observe(document.documentElement || document.body, {
      childList: true,
      subtree: true
    });
  }

  function update() {
    if (isCortexPath()) {
      injectScriptIfNeeded();
      setVisible(true);
    } else {
      setVisible(false);
    }
  }

  // --- Wire up MkDocs Material + fallbacks ---------------------------------
  document.addEventListener("DOMContentLoaded", () => {
    ensureObserver();
    update();
  });

  // MkDocs Material instant navigation fires after the content swap
  if (window.document$ && typeof window.document$.subscribe === "function") {
    window.document$.subscribe(() => {
      // Defer a tick to let new content settle, then update
      setTimeout(update, 0);
    });
  }

  // Extra safety: catch manual history changes
  ["pushState", "replaceState"].forEach((fn) => {
    const orig = history[fn];
    history[fn] = function () {
      const r = orig.apply(this, arguments);
      setTimeout(update, 0);
      return r;
    };
  });
  window.addEventListener("popstate", () => setTimeout(update, 0));
})();
