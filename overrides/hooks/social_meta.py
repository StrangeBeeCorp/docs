# Per-page title and description for link previews (Open Graph, Twitter cards)
# and for the <meta name="description"> tag.
#
# Front matter always wins:
#
#   ---
#   title: Short title shown in previews and the browser tab
#   description: One or two sentences shown under the title in previews.
#   ---
#
# Without a front matter title, previews use the page's first heading.
#
# Without a front matter description, previews use the page intro: the first
# paragraph between the first heading and the next heading, ignoring badges,
# buttons, and anything inside admonitions, tabs, lists or tables. When a
# second-level heading directly follows the first heading, such as
# "## Overview", the intro is read from that section instead.
#
# An intro that leads into a list ("…, featuring:") keeps only the sentences
# before it. A long intro keeps the whole sentences that fit. When there's no
# intro, or it doesn't end like a sentence, previews show the title only: the
# page gets no description tag, instead of the site-wide one from mkdocs.yml.
#
# The home page keeps the site-wide values.
#
# More information on MkDocs hooks is available here:
# https://www.mkdocs.org/user-guide/configuration/#hooks

import html
import re
from html.parser import HTMLParser

from markupsafe import Markup
from mkdocs.config.defaults import MkDocsConfig
from mkdocs.structure.files import Files
from mkdocs.structure.pages import Page

MAX_DESCRIPTION_LENGTH = 160

VOID_TAGS = {
    "area", "base", "br", "col", "embed", "hr", "img", "input",
    "link", "meta", "source", "track", "wbr",
}

IGNORED_CLASSES = ("mdx-badge", "headerlink", "md-button")


class _IntroExtractor(HTMLParser):
    """Collects the text of the first <h1> and of the intro paragraph.

    Attribute-less wrappers (such as the <div> that mkdocs-video puts around
    the whole page) don't count as nesting, so their children stay top-level.
    """

    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.depth = 0
        self.stack = []         # one bool per open element: counted in depth?
        self.skip_depth = None  # depth at which an ignored element started
        self.capture = None     # "h1" or "p" while inside one
        self.buffer = []
        self.h1 = ""
        self.paragraph = ""
        self.intro_over = False  # set at the next heading or non-empty <p>
        self.after_h1 = 0        # top-level elements seen since the <h1>

    def handle_starttag(self, tag, attrs):
        if tag in VOID_TAGS:
            return
        counted = not (tag in ("html", "body", "div") and not attrs)
        self.stack.append(counted)
        if not counted:
            return
        self.depth += 1
        classes = dict(attrs).get("class") or ""
        if self.skip_depth is None and (
            any(c in classes for c in IGNORED_CLASSES) or tag == "sup"
        ):
            self.skip_depth = self.depth
        if self.capture is None and self.depth == 1:
            if self.h1:
                self.after_h1 += 1
            if tag == "h1" and not self.h1:
                self.capture, self.buffer = "h1", []
            elif tag in ("h2", "h3", "h4", "h5", "h6"):
                # An <h2> right after the <h1> opens the intro section.
                if not (tag == "h2" and self.after_h1 == 1):
                    self.intro_over = True
            elif tag == "p" and not self.intro_over:
                self.capture, self.buffer = "p", []

    def handle_endtag(self, tag):
        if tag in VOID_TAGS:
            return
        if self.stack and not self.stack.pop():
            return
        if self.skip_depth is not None and self.depth == self.skip_depth:
            self.skip_depth = None
        if self.capture and self.depth == 1:
            text = _clean(" ".join(self.buffer))
            if self.capture == "h1":
                self.h1 = text
            elif text:
                # Only the first paragraph with text counts as the intro.
                self.paragraph = text
                self.intro_over = True
            self.capture = None
        self.depth = max(self.depth - 1, 0)

    def handle_data(self, data):
        if self.capture and self.skip_depth is None:
            self.buffer.append(data)


def _clean(text: str) -> str:
    text = re.sub(r"\s+", " ", text).strip()
    # Joining text nodes leaves a space before punctuation: "[link] ." -> "link."
    return re.sub(r" ([.,;:!?)])", r"\1", text)


def _description(text: str, limit: int = MAX_DESCRIPTION_LENGTH) -> str:
    """Turns the intro into a description, or "" when it isn't usable."""
    # An intro that leads into a list ("…, featuring:") reads oddly on its
    # own: keep the sentences before it, if any.
    if text.endswith(":"):
        head, sep, _ = text.rpartition(". ")
        text = head + "." if sep else ""
    # Labels and fragments such as "⚠️ IMPORTANT NOTE" aren't descriptions.
    if not text.endswith((".", "!", "?")):
        return ""
    if len(text) <= limit:
        return text
    # Keep the whole sentences that fit, else cut the first one at a word.
    kept = ""
    for sentence in re.split(r"(?<=[.!?]) ", text):
        candidate = f"{kept} {sentence}".strip()
        if len(candidate) > limit:
            break
        kept = candidate
    if kept:
        return kept
    cut = text[: limit - 1].rsplit(" ", 1)[0].rstrip(" ,;:")
    return cut + "…"


def on_page_content(
    html_content: str,
    *,
    page: Page,
    config: MkDocsConfig,
    files: Files,
) -> str:
    if page.is_homepage:
        return html_content

    parser = _IntroExtractor()
    parser.feed(html_content)

    # Escaped here and wrapped in Markup, so the theme's unescaped
    # <meta name="description"> and the escaping in main.html both render it
    # correctly.
    description = _description(parser.paragraph)
    if not page.meta.get("description") and description:
        page.meta["description"] = Markup(html.escape(description))
    if not page.meta.get("social_title") and parser.h1:
        page.meta["social_title"] = Markup(html.escape(parser.h1))

    return html_content


def on_post_page(output: str, *, page: Page, config: MkDocsConfig) -> str:
    # The theme falls back to the site-wide description on every page. Drop
    # that fallback so previews of pages without a description show the
    # title only.
    if page.is_homepage or page.meta.get("description") or not config.site_description:
        return output
    tag = f'<meta name="description" content="{config.site_description}">'
    return output.replace(tag, "", 1)
