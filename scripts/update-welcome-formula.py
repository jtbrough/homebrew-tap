#!/usr/bin/env python3
"""Update the welcome formula from the latest published Forgejo release."""

import argparse
import hashlib
import json
import re
import sys
import urllib.error
import urllib.request
from pathlib import Path


RELEASE_API = "https://git.home.brough.org/api/v1/repos/jordan/welcome/releases/latest"
DOWNLOAD_BASE = "https://git.home.brough.org/jordan/welcome/releases/download"
SEMVER = re.compile(
    r"v?(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)"
    r"(?:\+[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?\Z"
)
URL_LINE = re.compile(rb'(?m)^(  url[ \t]+")([^"\r\n]+)("[ \t]*\r?$)')
SHA_LINE = re.compile(rb'(?m)^(  sha256[ \t]+")([0-9a-fA-F]{64})("[ \t]*\r?$)')
URL_DECLARATION = re.compile(rb"(?m)^  url\b")
SHA_DECLARATION = re.compile(rb"(?m)^  sha256\b")
FORMULA_URL = re.compile(
    rf"{re.escape(DOWNLOAD_BASE)}/([^/]+)/welcome-([^/]+)-src\.tar\.gz\Z"
)


class UpdateError(Exception):
    """Release or formula cannot be safely updated."""


def version(tag):
    if not isinstance(tag, str) or not (match := SEMVER.fullmatch(tag)):
        raise UpdateError(f"Invalid or prerelease version tag: {tag!r}")
    return tuple(int(part) for part in match.group(1, 2, 3))


def one_match(pattern, declaration, data, label):
    matches = list(pattern.finditer(data))
    if len(matches) != 1 or len(declaration.findall(data)) != 1:
        raise UpdateError(f"Expected exactly one valid {label} line in formula")
    return matches[0]


def fetch(url):
    with urllib.request.urlopen(url, timeout=30) as response:
        return response.read()


def update(path):
    original = path.read_bytes()
    url_line = one_match(URL_LINE, URL_DECLARATION, original, "url")
    sha_line = one_match(SHA_LINE, SHA_DECLARATION, original, "sha256")
    if url_line.end(2) > sha_line.start(2):
        raise UpdateError("Formula url must precede sha256")
    current_url = url_line.group(2).decode("ascii")
    match = FORMULA_URL.fullmatch(current_url)
    if not match or match.group(1) != match.group(2):
        raise UpdateError(f"Unexpected welcome formula URL: {current_url}")
    current_tag = match.group(1)
    current_version = version(current_tag)

    release = json.loads(fetch(RELEASE_API))
    if not isinstance(release, dict) or release.get("draft") is not False or release.get("prerelease") is not False:
        raise UpdateError("Latest release is not a published stable release")
    tag = release.get("tag_name")
    remote_version = version(tag)

    asset_name = f"welcome-{tag}-src.tar.gz"
    expected_url = f"{DOWNLOAD_BASE}/{tag}/{asset_name}"
    assets = release.get("assets")
    if not isinstance(assets, list):
        raise UpdateError("Release has no valid assets list")
    matches = [asset for asset in assets if isinstance(asset, dict) and asset.get("name") == asset_name]
    if len(matches) != 1 or matches[0].get("browser_download_url") != expected_url:
        raise UpdateError(f"Missing or mismatched release asset: {asset_name}")
    if remote_version <= current_version:
        print(f"No update: welcome {current_tag} is already at or ahead of {tag}")
        return

    digest = hashlib.sha256(fetch(expected_url)).hexdigest().encode("ascii")
    updated = (
        original[:url_line.start(2)]
        + expected_url.encode("ascii")
        + original[url_line.end(2):sha_line.start(2)]
        + digest
        + original[sha_line.end(2):]
    )
    path.write_bytes(updated)
    print(f"Updated welcome {current_tag} -> {tag} (sha256 {digest.decode('ascii')})")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("formula", type=Path, help="path to Formula/welcome.rb")
    args = parser.parse_args()
    try:
        update(args.formula)
    except (UpdateError, OSError, UnicodeError, ValueError, urllib.error.URLError) as exc:
        print(f"Cannot update welcome formula: {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
