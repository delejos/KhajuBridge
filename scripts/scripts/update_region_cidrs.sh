#!/usr/bin/env bash
set -euo pipefail

# Directory to store downloaded CIDR lists
DATA_DIR="/etc/khajubridge"
REGION_V4="${DATA_DIR}/region_ipv4.cidr"
REGION_V6="${DATA_DIR}/region_ipv6.cidr"

# CIDR sources (same structure as Windows implementation)
IP_SOURCES_V4=(
  "https://www.ipdeny.com/ipblocks/data/countries/ir.zone"
)

IP_SOURCES_V6=(
  "https://www.ipdeny.com/ipv6/ipaddresses/blocks/ir.zone"
)

echo "Updating region CIDR lists..."

mkdir -p "${DATA_DIR}"

fetch_and_clean() {
  local output="$1"
  shift
  : > "${output}"

  for url in "$@"; do
    echo "Fetching ${url}"
    curl -fsSL "${url}" | grep -E '/' >> "${output}" || true
  done

  sort -u "${output}" -o "${output}"
}

fetch_and_clean "${REGION_V4}" "${IP_SOURCES_V4[@]}"
fetch_and_clean "${REGION_V6}" "${IP_SOURCES_V6[@]}"

echo "Update complete:"
echo "IPv4 ranges: $(wc -l < "${REGION_V4}")"
echo "IPv6 ranges: $(wc -l < "${REGION_V6}")"
