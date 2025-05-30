#!/bin/bash

set -e

# Colors for styled output
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔧 Starting n8n setup...${NC}"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
  echo -e "${GREEN}🐳 Docker not found. Installing Docker...${NC}"
  sudo apt-get update
  sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  echo -e "${GREEN}✅ Docker installed.${NC}"
else
  echo -e "${GREEN}✅ Docker is already installed.${NC}"
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
  echo -e "${GREEN}📦 docker-compose not found. Installing docker-compose...${NC}"
  sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.1/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  echo -e "${GREEN}✅ docker-compose installed.${NC}"
else
  echo -e "${GREEN}✅ docker-compose is already installed.${NC}"
fi

# Check if htpasswd is installed
if ! command -v htpasswd &> /dev/null; then
  echo -e "${GREEN}🔐 htpasswd not found. Installing apache2-utils...${NC}"
  sudo apt-get update && sudo apt-get install -y apache2-utils
fi

# Prompt for credentials
echo -e "${GREEN}👤 Please enter your n8n credentials:${NC}"
read -p "Username: " N8N_USER
read -s -p "Password: " N8N_PASS
echo ""

# Create .htpasswd file
mkdir -p ./nginx
htpasswd -bc ./nginx/.htpasswd "$N8N_USER" "$N8N_PASS"

# Start containers
echo -e "${GREEN}🚀 Starting n8n with Docker...${NC}"
N8N_USER="$N8N_USER" N8N_PASS="$N8N_PASS" docker-compose up -d

# Configure UFW for basic security
echo -e "${GREEN}🛡️  Configuring UFW firewall rules...${NC}"
sudo ufw --force enable
sudo ufw allow 22/tcp      # SSH
sudo ufw allow 80/tcp      # HTTP
sudo ufw allow 443/tcp     # HTTPS (if added later)
sudo ufw allow 8080/tcp    # nginx custom port

echo -e "${GREEN}📊 Current UFW status:${NC}"
sudo ufw status verbose

# Final message
echo -e "\n${BOLD}${CYAN}🎉 All done! Your n8n instance is live.${NC}"
echo -e "${CYAN}🌐 Open: ${BOLD}http://localhost:8080${NC}"
echo -e "${CYAN}🔐 Login with: ${BOLD}$N8N_USER${NC} / [your password]"

echo -e "\n${GREEN}✨ Thank you for using this setup script.${NC}"
echo -e "${BOLD}💡 Built with love by https://RunYar.com — Your Automation Partner.${NC}\n"
