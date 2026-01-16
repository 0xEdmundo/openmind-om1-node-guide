<p align="center">
  <img src="https://openmind.org/logo.png" alt="OpenMind Logo" width="120"/>
</p>

<h1 align="center">🤖 OpenMind OM1 Node Setup Guide</h1>

<p align="center">
  <strong>Complete guide to deploy your own OM1 agent on the OpenMind Fabric Network</strong>
</p>

<p align="center">
  <a href="https://openmind.org">Website</a> •
  <a href="https://fabric.openmindnetwork.xyz">Fabric Portal</a> •
  <a href="https://x.com/openmind_agi">Twitter</a> •
  <a href="https://github.com/openmind-ai/OM1">Official Repo</a>
</p>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Step-by-Step Installation](#-step-by-step-installation)
- [Running the Node](#-running-the-node)
- [Troubleshooting](#-troubleshooting)
- [FAQ](#-faq)
- [Contributing](#-contributing)

---

## 🌐 Overview

**OpenMind** is building the foundational infrastructure for intelligent, collaborative machines. The **OM1** operating system allows robots and AI agents to perceive, reason, and act in real-world environments.

By running an OM1 node, you:
- 🎯 Contribute to the decentralized robotics network
- 🏆 Earn badges and potential rewards
- 🔗 Participate in the FABRIC coordination layer
- 🚀 Support the future of AGI infrastructure

---

## 💻 Prerequisites

### System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| **OS** | Ubuntu 20.04+ | Ubuntu 22.04 LTS |
| **CPU** | 2 cores | 4+ cores |
| **RAM** | 4 GB | 8+ GB |
| **Storage** | 20 GB SSD | 50+ GB SSD |
| **Network** | Stable connection | Low latency preferred |

### Required Accounts

1. **OpenMind Account** - Register at [fabric.openmindnetwork.xyz](https://fabric.openmindnetwork.xyz)
2. **Base Network Wallet** - For purchasing credits (5 USDC minimum)

---

## ⚡ Quick Start

For experienced users, run this one-liner:

```bash
curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/openmind-om1-node-guide/main/scripts/install.sh | bash
```

> ⚠️ **Note**: Review the script before running. Always verify scripts from the internet.

---

## 📦 Step-by-Step Installation

### Step 1: Update System & Install Dependencies

First, ensure your system is up to date and install all required packages:

```bash
# Update package lists and upgrade existing packages
sudo apt update && sudo apt upgrade -y

# Install required dependencies
sudo apt install -y \
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
```

### Step 2: Configure Audio Module

The OM1 agent requires audio capabilities. Load the dummy sound module:

```bash
# Load the audio module
sudo modprobe snd-dummy

# Make it persistent across reboots
echo "snd-dummy" | sudo tee -a /etc/modules
```

### Step 3: Install UV Package Manager

[UV](https://github.com/astral-sh/uv) is a fast Python package installer:

```bash
# Download and install UV
curl -LsSf https://astral.sh/uv/install.sh | sh

# Reload shell configuration
source ~/.bashrc

# Verify installation
uv --version
```

### Step 4: Clone the OM1 Repository

```bash
# Navigate to home directory
cd ~

# Clone the official OM1 repository
git clone https://github.com/openmind-ai/OM1.git

# Enter the project directory
cd OM1

# Initialize submodules
git submodule update --init --recursive
```

### Step 5: Create Virtual Environment

```bash
# Create a new virtual environment using UV
uv venv

# Activate the virtual environment
source .venv/bin/activate

# Install project dependencies
uv sync
```

### Step 6: Obtain API Key

1. Navigate to [OpenMind Fabric Portal](https://fabric.openmindnetwork.xyz)
2. Connect your wallet and sign up/login
3. Go to **"Purchase Credits"** in the top-right menu
4. Add at least **5 USDC** on Base network
5. Click **"Create API Key"**
6. **Important**: Save your API key immediately - it won't be shown again!

### Step 7: Configure Environment

```bash
# Copy the example environment file
cp env.example .env

# Edit the configuration
nano .env
```

Find the line `OM_API_KEY=` and add your API key:

```env
OM_API_KEY=your_api_key_here
```

Save and exit: `Ctrl + X` → `Y` → `Enter`

---

## � Cost Optimization (Important!)

> ⚠️ **Warning**: Without optimization, your credits can drain within minutes! Follow these steps to significantly reduce costs.

By default, the node consumes credits very quickly. To reduce costs:

### Adjust the Hertz Setting

```bash
# Navigate to OM1 directory
cd ~/OM1

# Open the configuration file
nano config/spot.json5
```

Find the `"hertz"` value and change it to `0.05`:

```json
{
  "hertz": 0.05
}
```

Save and exit: `Ctrl + X` → `Y` → `Enter`

### Cost & Badge Economics

| Metric | Value |
|--------|-------|
| **Credit Rate** | ~100 credits per $1 USDC |
| **Developer Badge** | ~2,500 credits required |
| **Estimated Cost for Badge** | ~$25 USDC |

> 💡 **Tip**: With the hertz optimization, you can run the node much longer on the same budget. Always monitor your credit balance on the [Fabric Portal](https://fabric.openmindnetwork.xyz).

---

## �🚀 Running the Node

### Using Screen (Recommended)

Screen allows the node to run in the background:

```bash
# Create a new screen session
screen -S om1

# Navigate to OM1 directory
cd ~/OM1

# Activate virtual environment
source .venv/bin/activate

# Start the agent
uv run src/run.py conversation
```

### Screen Commands Reference

| Action | Command |
|--------|---------|
| Detach from session | `Ctrl + A`, then `D` |
| Reattach to session | `screen -r om1` |
| List all sessions | `screen -ls` |
| Kill session | `screen -X -S om1 quit` |

### Verify Node is Running

Your node is working correctly when you see conversation output in the terminal. The agent will start processing and responding to queries.

---

## 🔧 Troubleshooting

### Common Issues

<details>
<summary><b>❌ Error: "uv: command not found"</b></summary>

**Cause**: UV is not installed or not in PATH

**Solution**:
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc
```
</details>

<details>
<summary><b>❌ Error: ".venv/bin/activate: No such file"</b></summary>

**Cause**: Virtual environment was not created

**Solution**:
```bash
cd ~/OM1
uv venv
```
</details>

<details>
<summary><b>❌ Error: "401 Unauthorized" or "Insufficient Balance"</b></summary>

**Cause**: No credits or invalid API key

**Solution**:
1. Visit [Fabric Portal](https://fabric.openmindnetwork.xyz)
2. Add credits to your account
3. Generate a new API key if needed
4. Update `.env` file with new key
</details>

<details>
<summary><b>❌ Error: "portaudio.h not found"</b></summary>

**Cause**: PortAudio development files missing

**Solution**:
```bash
sudo apt install portaudio19-dev -y
```
</details>

<details>
<summary><b>❌ Error: "No output from LLM"</b></summary>

**Cause**: API key invalid or credits exhausted

**Solution**:
1. Check your `.env` file for correct API key
2. Verify credit balance on Fabric Portal
3. Regenerate API key if necessary
</details>

---

## ❓ FAQ

**Q: How much does it cost to run a node?**
> A: You need minimum 5 USDC in credits to start. Actual usage depends on your activity level.

**Q: Can I run this on Windows/Mac?**
> A: This guide is for Linux. WSL2 on Windows may work but is not officially supported.

**Q: How do I check my badge progress?**
> A: Visit [fabric.openmindnetwork.xyz](https://fabric.openmindnetwork.xyz) and check your profile.

**Q: Is there an airdrop?**
> A: Nothing confirmed. Running a node and earning badges may increase eligibility for future rewards.

---

## 🤝 Contributing

Contributions are welcome! Feel free to:

- 🐛 Report bugs by opening an issue
- 💡 Suggest improvements
- 📝 Submit pull requests

---

## 📜 License

This guide is provided under the [MIT License](LICENSE).

---

<p align="center">
  <sub>Built with ❤️ for the OpenMind community</sub>
</p>
