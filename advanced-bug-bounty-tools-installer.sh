#!/usr/bin/env bash
# ==================================================
# Advanced Bug Bounty Tools Installer (Cross-Platform)
# Linux (apt) | macOS (brew) | Windows (Git Bash + Choco)
# Adds aria2c multi-threaded downloads (default ON)
# Disable with --no-aria
# ==================================================

INSTALL_DIR="$HOME/.local/share/security-tools"
mkdir -p "$INSTALL_DIR"

export PATH="$INSTALL_DIR/go/bin:$INSTALL_DIR/ruby/ruby/bin:$PATH"
export GEM_HOME="$INSTALL_DIR/ruby/gems"
export GEM_PATH="$INSTALL_DIR/ruby/gems"

PROFILE_FILE="$HOME/.zshrc"
[ ! -f "$PROFILE_FILE" ] && PROFILE_FILE="$HOME/.bashrc"

if ! grep -q "security-tools/ruby" "$PROFILE_FILE"; then
    echo "export PATH=\"$INSTALL_DIR/ruby/ruby/bin:\$PATH\"" >> "$PROFILE_FILE"
    echo "export GEM_HOME=\"$INSTALL_DIR/ruby/gems\"" >> "$PROFILE_FILE"
    echo "export GEM_PATH=\"$INSTALL_DIR/ruby/gems\"" >> "$PROFILE_FILE"
    echo "[+] Ruby environment persisted in $PROFILE_FILE"
fi

# ==================================================
# Flags
# ==================================================
USE_ARIA=1
for arg in "$@"; do
  if [[ "$arg" == "--no-aria" ]]; then
    USE_ARIA=0
  fi
done

OS=$(uname | tr '[:upper:]' '[:lower:]')
echo "[+] Detected OS: $OS"

# ==================================================
# Windows (Git Bash) — PowerShell + Chocolatey
# ==================================================
if [[ "$OS" =~ "mingw" || "$OS" =~ "msys" ]]; then
    echo "[+] Running on Windows (Git Bash)"
    echo "[+] Installing dependencies with Chocolatey (requires admin)"
    powershell.exe -Command "
        if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
            Set-ExecutionPolicy Bypass -Scope Process -Force
            iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        }
        choco install -y ruby nodejs golang python git make wget curl aria2
    "
    echo "[+] Dependencies installed via Chocolatey"
fi

# ==================================================
# macOS / Linux dependency install
# ==================================================
if [[ "$OS" == "darwin" ]]; then
    echo "[+] macOS detected — installing dependencies with Homebrew..."
    brew install -q libyaml gmp openssl@3 pkg-config autoconf automake libtool bison git curl wget python3 go ruby aria2
elif [[ "$OS" == "linux" ]]; then
    echo "[+] Linux detected — installing dependencies with apt..."
    sudo apt-get update -qq
    sudo apt-get install -y build-essential libssl-dev libreadline-dev zlib1g-dev libyaml-dev libgmp-dev \
        autoconf automake libtool bison pkg-config git curl wget python3 python3-pip golang ruby-full aria2
fi

# ==================================================
# Ruby local build (Linux/macOS only)
# ==================================================
if [[ ! "$OS" =~ "mingw" && ! "$OS" =~ "msys" ]]; then
    echo "[+] Installing Ruby >=3.2 locally..."
    mkdir -p "$INSTALL_DIR/ruby"
    if [ ! -d "$INSTALL_DIR/ruby/ruby-build" ]; then
        git clone https://github.com/rbenv/ruby-build.git "$INSTALL_DIR/ruby/ruby-build"
    else
        cd "$INSTALL_DIR/ruby/ruby-build" && git pull
    fi
    LATEST_RUBY="3.3.3"
    if [ ! -d "$INSTALL_DIR/ruby/ruby-$LATEST_RUBY" ]; then
        "$INSTALL_DIR/ruby/ruby-build/bin/ruby-build" "$LATEST_RUBY" "$INSTALL_DIR/ruby/ruby"
    fi
    if [ -x "$INSTALL_DIR/ruby/ruby/bin/ruby" ]; then
        RUBY_VERSION_INSTALLED=$("$INSTALL_DIR/ruby/ruby/bin/ruby" -v)
        echo "[✔] Ruby $RUBY_VERSION_INSTALLED installed"
    else
        echo "[!] Ruby not installed — skipping Ruby-based tools"
    fi
fi

# ==================================================
# Tools array (20+ repos intact)
# ==================================================
TOOLS=(
"Sublist3r|https://github.com/aboul3la/Sublist3r.git|pip|$INSTALL_DIR/Sublist3r/requirements.txt"
"teh_s3_bucketeers|https://github.com/tehskeen/teh_s3_bucketeers.git|bash|"
"virtual-host-discovery|https://github.com/jobertabma/virtual-host-discovery.git|bash|"
"wpscan|https://github.com/wpscanteam/wpscan.git|gem|"
"lazyrecon|https://github.com/nahamsec/lazyrecon.git|bash|"
"recon_profile|https://github.com/nahamsec/recon_profile.git|bash|"
"ReconDevBashClient|https://github.com/nahamsec/ReconDevBashClient.git|bash|"
"massdns|https://github.com/blechschmidt/massdns.git|make|"
"Asnlookup|https://github.com/0x3f/Asnlookup.git|pip|$INSTALL_DIR/Asnlookup/requirements.txt"
"unfurl|https://github.com/tomnomnom/unfurl.git|go|"
"waybackurls|https://github.com/tomnomnom/waybackurls.git|go|"
"httprobe|https://github.com/tomnomnom/httprobe.git|go|"
"dirsearch|https://github.com/maurosoria/dirsearch.git|pip|$INSTALL_DIR/dirsearch/requirements.txt"
"JSParser|https://github.com/darkoperator/JSParser.git|pip|$INSTALL_DIR/JSParser/requirements.txt"
"knock|https://github.com/guelfoweb/knock.git|pip|$INSTALL_DIR/knock/requirements.txt"
"lazys3|https://github.com/nahamsec/lazys3.git|bash|"
"sqlmap|https://github.com/sqlmapproject/sqlmap.git|bash|"
)

# ==================================================
# Helper: accelerated git clone
# ==================================================
clone_repo() {
    local repo_url=$1
    local dest_dir=$2

    if [[ $USE_ARIA -eq 1 && $(command -v aria2c) ]]; then
        echo "[+] Using aria2c for accelerated clone of $repo_url"
        tmp_zip="/tmp/$(basename $dest_dir).zip"
        aria2c -x 8 -s 8 -k 1M -d /tmp -o "$(basename $tmp_zip)" "${repo_url%.git}/archive/refs/heads/master.zip" || return 1
        mkdir -p "$dest_dir"
        unzip -q "$tmp_zip" -d "$dest_dir-tmp"
        mv "$dest_dir-tmp"/*/* "$dest_dir"
        rm -rf "$dest_dir-tmp" "$tmp_zip"
    else
        git clone "$repo_url" "$dest_dir" || return 1
    fi
}

# ==================================================
# Install each tool
# ==================================================
for TOOL in "${TOOLS[@]}"; do
    NAME=$(echo $TOOL | cut -d'|' -f1)
    REPO=$(echo $TOOL | cut -d'|' -f2)
    TYPE=$(echo $TOOL | cut -d'|' -f3)
    REQ_FILE=$(echo $TOOL | cut -d'|' -f4)

    echo "[+] Installing $NAME ($TYPE)"

    TOOL_DIR="$INSTALL_DIR/$NAME"
    if [ ! -d "$TOOL_DIR" ]; then
        clone_repo "$REPO" "$TOOL_DIR" || {
            echo "[!] Failed to clone $NAME — repo may be private/unreachable"
            continue
        }
    else
        echo "[+] $NAME already exists — updating"
        cd "$TOOL_DIR" && git pull
    fi

    case $TYPE in
        pip)
            python3 -m pip install --upgrade pip
            [ -f "$REQ_FILE" ] && python3 -m pip install -r "$REQ_FILE"
            ;;
        bash)
            echo "[+] $NAME is a bash tool — no extra setup"
            ;;
        gem)
            if [ -x "$INSTALL_DIR/ruby/ruby/bin/gem" ]; then
                "$INSTALL_DIR/ruby/ruby/bin/gem" install bundler --no-document
                (cd "$TOOL_DIR" && "$INSTALL_DIR/ruby/ruby/bin/bundle" install || true)
            else
                echo "[!] Skipping $NAME (Ruby unavailable)"
            fi
            ;;
        go)
            cd "$TOOL_DIR" && go build
            ;;
        make)
            cd "$TOOL_DIR" && make
            ;;
    esac

    echo "[✔] $NAME installed"
done

echo "[+] All tools setup complete!"
