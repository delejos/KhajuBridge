# KhajuBridge

KhajuBridge is a Linux-based firewall layer for Psiphon Conduit that enables region-restricted access using nftables. It mirrors the behavior of an existing Windows firewall implementation by allowing global TCP connectivity while restricting UDP traffic to a configurable region using CIDR-based filtering. Both IPv4 and IPv6 are supported.

KhajuBridge provides a simple and transparent way to apply region-based network restrictions to Psiphon Conduit on Linux systems. It is designed as a lightweight wrapper around nftables and does not modify Conduit itself. All filtering is applied at the firewall level and can be safely enabled, updated, or disabled.

The project operates using a straightforward workflow: first, a script fetches IPv4 and IPv6 CIDR ranges for a specific region from public sources; second, an nftables ruleset defines how traffic should be handled, allowing TCP traffic to Conduit ports globally while restricting UDP traffic to the configured region and leaving all other traffic unaffected; finally, a helper script applies the rules and populates nftables sets atomically, allowing safe re-application and updates without interrupting existing connections.

Features include region-restricted access using CIDR-based filtering, IPv4 and IPv6 support, efficient updates via nftables sets, safe re-runs at any time, no modification or patching of Psiphon Conduit, and a design intended for Debian-based Linux systems.

Repository structure consists of scripts for fetching CIDR lists and applying firewall rules, an nftables ruleset defining the base filtering logic, optional systemd units for future automation, and this README file.

Requirements are a Linux system with nftables support, Debian 11 / 12 or a compatible distribution, root or sudo privileges, and Psiphon Conduit installed and running.

Quick start (manual): install dependencies with `sudo apt install nftables curl`, fetch region CIDR ranges using `sudo ./scripts/update_region_cidrs.sh`, apply firewall rules with `sudo ./scripts/apply_firewall.sh`, and verify the rules using `sudo nft list table inet khajubridge`.

Currently, KhajuBridge supports a normal mode where TCP traffic is allowed globally and UDP traffic is restricted to the configured region. Future versions may introduce a strict mode where both TCP and UDP traffic are region-restricted.

Safety notes: KhajuBridge only affects traffic matching the configured Conduit ports; other services on the system are not modified; CIDR lists can change over time and should be updated regularly; always test firewall rules on non-critical systems before production use.

This project is inspired by an existing Windows-based firewall implementation for Psiphon Conduit and adapts the same core ideas to Linux using nftables.
