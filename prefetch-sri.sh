#!/usr/bin/env bash
set -euo pipefail
url="${1}"

output="$(nix-prefetch-url --type sha256 "${url}")"
sri="$(nix hash to-sri --type sha256 "${output}")"
echo "${sri}"
