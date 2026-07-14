#!/usr/bin/env bash
# Перегенерирует sources.json на последнюю версию helium-linux.
# Пин версии: ./update.sh 0.14.5.1
set -euo pipefail
cd "$(dirname "$0")"

ver="${1:-$(curl -fsSL https://api.github.com/repos/imputnet/helium-linux/releases/latest | jq -r .tag_name)}"
[ -n "$ver" ] && [ "$ver" != "null" ] || { echo "could not determine latest version" >&2; exit 1; }

# system -> суффикс арки в имени AppImage
systems="x86_64-linux:x86_64 aarch64-linux:arm64"

json=$(jq -n --arg version "$ver" '{version: $version, systems: {}}')
for entry in $systems; do
  sys="${entry%%:*}"; target="${entry#*:}"
  url="https://github.com/imputnet/helium-linux/releases/download/$ver/helium-$ver-$target.AppImage"
  hash=$(nix store prefetch-file --json "$url" | jq -r .hash)
  json=$(jq --arg s "$sys" --arg t "$target" --arg h "$hash" \
    '.systems[$s] = {target: $t, hash: $h}' <<<"$json")
done

printf '%s\n' "$json" > sources.json
echo "updated to $ver"
