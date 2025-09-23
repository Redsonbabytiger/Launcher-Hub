# Launcher Hub 🚀

[![Build and Release Launcher Hub](https://github.com/Redsonbabytiger/Launcher-Hub/actions/workflows/deb-build.yml/badge.svg)](https://github.com/Redsonbabytiger/Launcher-Hub/actions/workflows/deb-build.yml)

Launcher Hub is a **customizable GUI hub/launcher** built with **Bash + YAD**.  
It lets you quickly launch Virtual Machines, Websites, Applications, and Scripts  
from a single clean interface.  

## ✨ Features
- Tabbed GUI interface using YAD
- Config file at `~/.launcherhub.conf`
- Add / Edit / Remove items via GUI
- Launch **VMs, Apps, Scripts, Websites**
- Search for entries
- Debian `.deb` installer provided

## 📦 Installation
```bash
echo "deb [trusted=yes] https://redsonbabytiger.github.io/launcherhub stable main" | sudo tee /etc/apt/sources.list.d/launcherhub.list
sudo apt update
sudo apt install launcherhub
