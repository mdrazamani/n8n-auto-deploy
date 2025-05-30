# 🚀 n8n Auto Ready

> **Launch a secure, production-friendly [n8n](https://n8n.io) instance in seconds — with Docker, Nginx, and Basic Auth, all bundled in one sleek command.**

Easily automate your workflows, connect APIs, and manage powerful business logic — without wasting time on infrastructure setup.

---

## 🔧 Features

- ✅ **One-command bootstrap** with `start.sh`
- 🐳 **Docker-native**: Includes Docker + Docker Compose support
- 🔐 **Secure out-of-the-box**: Built-in HTTP Basic Auth
- 🧱 **Nginx reverse proxy**: Extendable, customizable, robust
- 🌍 Ideal for **local development** or **cloud server** deployment
- 🛡️ **Firewall auto-setup** using `ufw` (only opens essential ports)

---

## ⚡️ Quick Start

Clone and run:

```bash
git clone https://github.com/mdrazamani/n8n-auto-deploy.git n8n-auto-ready
cd n8n-auto-ready
chmod +x start.sh
./start.sh
