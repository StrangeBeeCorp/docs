# This file implements a hook for version badges.
# It is adapted from the MkDocs Material project:
# https://github.com/squidfunk/mkdocs-material/blob/master/src/overrides/hooks/shortcodes.py
#
# The original work is licensed under the MIT License:
# https://github.com/squidfunk/mkdocs-material/blob/master/LICENSE
# © Martin Donath / MkDocs Material
#
# More information on MkDocs hooks is available here:
# https://www.mkdocs.org/user-guide/configuration/#hooks

import posixpath
import re
from re import Match

from mkdocs.config.defaults import MkDocsConfig
from mkdocs.structure.files import File, Files
from mkdocs.structure.pages import Page


def on_page_markdown(
    markdown: str,
    *,
    page: Page,
    config: MkDocsConfig,
    files: Files,
) -> str:
    """Custom hook function that is called after the page's markdown is loaded:
    https://www.mkdocs.org/dev-guide/plugins/#on_page_markdown

    This hook will find and replace custom shortcodes with their respective HTML.

    Args:
        markdown (str): Markdown source text of page as string.
        page (Page): Markdown Page instance.
        config (MkDocsConfig): MkDocs global configuration object.
        files (Files): MkDocs global files collection.

    Returns
        Markdown source text of page as string.
    """
    # Replace callback
    def replace(match: Match):
        type, args = match.groups()
        args = args.strip()
        if type == "version":
            return _badge_for_version(args, page, files)
        # Otherwise, raise an error
        raise RuntimeError(f"Unknown shortcode: {type}")

    # Find and replace all external asset URLs in current page
    return re.sub(
        r"<!-- md:(\w+)(.*?) -->",
        replace, markdown, flags = re.I | re.M
    )


# Resolve path of file relative to given page - the posixpath always includes
# one additional level of `..` which we need to remove
def _resolve_path(path: str, page: Page, files: Files):
    path, anchor, *_ = f"{path}#".split("#")
    path = _resolve(files.get_file_from_path(path), page)
    return "#".join([path, anchor]) if anchor else path


# Resolve path of file relative to given page - the posixpath always includes
# one additional level of `..` which we need to remove
def _resolve(file: File, page: Page):
    path = posixpath.relpath(file.src_uri, page.file.src_uri)
    return posixpath.sep.join(path.split(posixpath.sep)[1:])


# Create badge
def _badge(icon: str, text: str = "", type: str = ""):
    classes = f"mdx-badge mdx-badge--{type}" if type else "mdx-badge"
    return "".join([
        f"<span class=\"{classes}\">",
        *([f"<span class=\"mdx-badge__icon\">{icon}</span>"] if icon else []),
        *([f"<span class=\"mdx-badge__text\">{text}</span>"] if text else []),
        f"</span>",
    ])


# Create badge for version
def _badge_for_version(text: str, page: Page, files: Files):
    spec = text
    path = f"thehive/release-notes/release-notes-5.4.md#{spec}"

    # Return badge
    icon = "material-tag-outline"
    href = _resolve_path(f"thehive/release-notes/release-notes-5.4.md#{text}", page, files)
    return _badge(
        icon = f"[:{icon}:]({href} 'Minimum version')",
        text = f"[{text}]({_resolve_path(path, page, files)})" if spec else ""
    )
