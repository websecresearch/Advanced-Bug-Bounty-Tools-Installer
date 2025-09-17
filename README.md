# 🕵️ Advanced Bug Bounty Tools Installer

A **cross-platform bootstrap installer** for 20+ bug bounty & recon tools.  
Supports **Linux (apt)**, **macOS (brew)**, and **Windows (Git Bash + Chocolatey)**.  

Built for **bug bounty hunters**, **pentesters**, and **researchers** — with **multi-threaded downloads (aria2c)** enabled by default for **maximum speed**.

---

## ✨ Features
- ✅ Cross-platform: Linux, macOS, Windows Git Bash
- ✅ 20+ recon & bug bounty tools (Python, Ruby, Go, Bash, Make)
- ✅ Automatic dependency install (`apt`, `brew`, `choco`)
- ✅ Multi-threaded downloads (`aria2c`, 8 connections)  
- ✅ Local Ruby (3.3.x) install isolated from system
- ✅ Skips gracefully if dependencies/repos unavailable
- ✅ Updates tools if already installed (`git pull`)

---

## 📦 Installed Tools
This installer bootstraps **20+ essential bug bounty tools**, including:

- **Sublist3r** → Subdomain enumeration  
- **teh_s3_bucketeers** → S3 bucket recon  
- **virtual-host-discovery** → Virtual host scanner  
- **wpscan** → WordPress vulnerability scanner (Ruby)  
- **lazyrecon** → Recon automation framework  
- **recon_profile** → Recon environment configs  
- **ReconDevBashClient** → Recon dev helper client  
- **massdns** → Fast DNS resolver  
- **Asnlookup** → ASN info lookup  
- **unfurl, waybackurls, httprobe** (by tomnomnom) → URL parsing, archives, probing  
- **dirsearch** → Directory brute-forcer  
- **JSParser** → JavaScript analysis  
- **knock** → Subdomain tool  
- **lazys3** → S3 enumeration  
- **sqlmap** → SQL injection scanner  

…and more (full list in script).

---

## 🚀 Installation
Clone the repo:
```bash
git clone https://github.com/YOURNAME/advanced-bug-bounty-tools-installer.git
cd advanced-bug-bounty-tools-installer


Make script executable and run:

chmod +x advanced-bug-bounty-tools-installer.sh
./advanced-bug-bounty-tools-installer.sh


Disable aria2c (fall back to normal git clone):

./advanced-bug-bounty-tools-installer.sh --no-aria
