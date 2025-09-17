# Advanced-Bug-Bounty-Tools-Installer

**A cross-platform, user-level installer for 20+ popular recon & bug-bounty tools.**

This repository provides a single script — `advanced-bug-bounty-tools-installer.sh` — which clones, builds, and installs a curated set of widely-used open-source recon tools into a single, wipeable local directory:

`$HOME/.local/share/security-tools` (default).

> Designed for offline safety and reproducibility: installs are done in user-space, tools are kept isolated, downloads can be accelerated with `aria2c`, and Ruby/Python/Go tooling is handled locally where possible.

---

## Features

- Installs/clones 20+ well-known recon/bug-bounty tools (see list below).
- Per-tool isolated Python virtual environments (no global pip pollution).
- Build automation for Go (`go build`), C/Make (`make`), Ruby (`gem`), and bash scripts.
- Multi-threaded download acceleration with `aria2c` (default). Use `--no-aria` to disable.
- Cross-platform support: Linux (apt), macOS (Homebrew), Windows (Chocolatey + Git Bash).
- User-level install by default (no `sudo`). Use `--sudo` to allow system-level installs.
- Skips incompatible builds (e.g. `massdns` on macOS due to `epoll.h`) with clear messages.
- Optional pin/checksum workflow via a `pins.sh` template (for high-security usage).

---

## Included Tools (cloned and installed)

- Sublist3r — `https://github.com/aboul3la/Sublist3r.git`
- dirsearch — `https://github.com/maurosoria/dirsearch.git`
- JSParser — `https://github.com/darkoperator/JSParser.git`
- knock — `https://github.com/guelfoweb/knock.git`
- lazys3 — `https://github.com/nahamsec/lazys3.git`
- recon_profile — `https://github.com/nahamsec/recon_profile.git`
- lazyrecon — `https://github.com/nahamsec/lazyrecon.git`
- ReconDevBashClient — `https://github.com/nahamsec/ReconDevBashClient.git`
- teh_s3_bucketeers — `https://github.com/tehskeen/teh_s3_bucketeers.git`
- virtual-host-discovery — `https://github.com/jobertabma/virtual-host-discovery.git`
- wpscan — `https://github.com/wpscanteam/wpscan.git`
- webscreenshot — `https://github.com/maaaaz/webscreenshot.git`
- massdns — `https://github.com/blechschmidt/massdns.git`
- Asnlookup — `https://github.com/0x3f/Asnlookup.git`
- unfurl — `https://github.com/tomnomnom/unfurl.git`
- waybackurls — `https://github.com/tomnomnom/waybackurls.git`
- httprobe — `https://github.com/tomnomnom/httprobe.git`
- SecLists — `https://github.com/danielmiessler/SecLists.git`
- sqlmap — `https://github.com/sqlmapproject/sqlmap.git`
- ReconDevBashClient & recon profile related small helpers

> All of these are kept in the repository list and will be cloned by the installer.

---

## Quick start

1. Make script executable:
```bash
chmod +x advanced-bug-bounty-tools-installer.sh


2 Run (default):

./advanced-bug-bounty-tools-installer.sh


3. Disable aria2 download acceleration:

Make script executable:

./advanced-bug-bounty-tools-installer.sh --no-aria


4. Allow system installs (sudo) for prerequisites:

./advanced-bug-bounty-tools-installer.sh --sudo


5. Skip building Ruby and Ruby-based tools:

./advanced-bug-bounty-tools-installer.sh --skip-ruby
