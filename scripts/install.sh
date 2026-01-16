#!/bin/bash

#############################################
#  OpenMind OM1 Node - Automated Installer  #
#############################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print banner
echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║          OpenMind OM1 Node - Automated Setup              ║"
echo "║                      v1.0.0                               ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}[ERROR] Please do not run this script as root.${NC}"
    exit 1
fi

# Function to print status
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

# Step 1: Update system
echo ""
print_info "Step 1/6: Updating system packages..."
sudo apt update -qq && sudo apt upgrade -y -qq
print_status "System updated successfully"

# Step 2: Install dependencies
echo ""
print_info "Step 2/6: Installing required dependencies..."
sudo apt install -y -qq \
    build-essential \
    python3 \
    python3-pip \
    python3-dev \
    python3-venv \
    git \
    ffmpeg \
    portaudio19-dev \
    alsa-utils \
    screen \
    curl \
    wget
print_status "Dependencies installed"

# Step 3: Configure audio
echo ""
print_info "Step 3/6: Configuring audio module..."
sudo modprobe snd-dummy 2>/dev/null || true
if ! grep -q "snd-dummy" /etc/modules 2>/dev/null; then
    echo "snd-dummy" | sudo tee -a /etc/modules > /dev/null
fi
print_status "Audio module configured"

# Step 4: Install UV
echo ""
print_info "Step 4/6: Installing UV package manager..."
if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$PATH"
    print_status "UV installed"
else
    print_warning "UV already installed, skipping..."
fi

# Step 5: Clone OM1 repository
echo ""
print_info "Step 5/6: Setting up OM1 repository..."
cd ~
if [ -d "OM1" ]; then
    print_warning "OM1 directory exists. Updating..."
    cd OM1
    git pull
else
    git clone https://github.com/openmind-ai/OM1.git
    cd OM1
fi
git submodule update --init --recursive
print_status "Repository ready"

# Step 6: Create virtual environment
echo ""
print_info "Step 6/6: Setting up Python environment..."
export PATH="$HOME/.cargo/bin:$PATH"
uv venv
source .venv/bin/activate
uv sync 2>/dev/null || uv pip install -r requirements.txt 2>/dev/null || true
print_status "Python environment ready"

# Create .env if not exists
if [ ! -f ".env" ] && [ -f "env.example" ]; then
    cp env.example .env
    print_info "Created .env file from template"
fi

# Final message
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              Installation Complete! 🎉                    ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Get your API key from: https://fabric.openmindnetwork.xyz"
echo "  2. Edit the .env file: nano ~/OM1/.env"
echo "  3. Add your API key to the OM_API_KEY= line"
echo "  4. Run the node:"
echo ""
echo "     screen -S om1"
echo "     cd ~/OM1"
echo "     source .venv/bin/activate"
echo "     uv run src/run.py conversation"
echo ""
print_info "Detach from screen: Ctrl+A, then D"
print_info "Reattach to screen: screen -r om1"
echo ""
