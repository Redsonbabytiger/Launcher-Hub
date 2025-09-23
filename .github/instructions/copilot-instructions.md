# Copilot Instructions for Launcher Hub

## Project Overview
Launcher Hub is a customizable GUI launcher written in Bash using YAD. It provides a tabbed interface to launch websites, applications, scripts, and VMs from a single menu. The main script is `src/launcherhub.sh` and configuration is user-editable at `~/.launcherhub.conf`.

## Architecture & Key Files
- `src/launcherhub.sh`: Main Bash script, handles GUI, config parsing, and launching actions.
- `~/.launcherhub.conf`: User config, INI-style, sections for [Websites], [Apps], [Scripts].
- `usr/share/applications/launcherhub.desktop`: Desktop entry for system menu integration.
- `DEBIAN/`: Packaging scripts and control files for .deb builds.
- `Makefile`: Build logic for .deb packaging.
- `release.sh`: Automates version bump, changelog, tagging, and release process.

## Build & Release Workflow
- **Build .deb locally:**
  ```bash
  make clean build
  ```
  Output: `.deb` file in project root.
- **Release:**
  ```bash
  ./release.sh vX.Y
  ```
  - Updates version in all relevant files
  - Commits, tags, and pushes to `main`
  - Triggers GitHub Actions to build and publish APT repo
- **GitHub Actions:** See `.github/workflows/deb-build.yml` for CI/CD pipeline.

## Project Conventions
- All user-editable config is in `~/.launcherhub.conf` (auto-created if missing).
- Bash/YAD is used for all GUI logic; avoid introducing other languages.
- New launcher tabs/sections can be added by extending config and `load_section` in `launcherhub.sh`.
- Use `xdg-open` for URLs, `gnome-terminal` for terminal apps, and `code` for editors by default.
- Packaging expects the main script at `src/launcherhub.sh` and installs to `/usr/local/bin/launcherhub`.

## External Dependencies
- **YAD** (Yet Another Dialog) for GUI
- **gnome-terminal**, **xdg-utils** for launching apps/URLs
- See `DEBIAN/control` for full dependency list

## Examples
- To add a new app to the launcher, append to `[Apps]` in `~/.launcherhub.conf`:
  ```ini
  [Apps]
  Terminal=gnome-terminal
  Editor=code
  MyApp=myapp-command
  ```
- To add a new tab, update both the config and `main_menu` in `launcherhub.sh`.

## Debugging
- Run `src/launcherhub.sh` directly for local testing:
  ```bash
  bash src/launcherhub.sh
  ```
- Logs/errors are printed to the terminal.

## Do Not
- Do not hardcode user-specific paths except for `~/.launcherhub.conf`.
- Do not introduce non-Bash/YAD dependencies without discussion.

---
For more, see `README.md`, `Makefile`, and `src/launcherhub.sh`.
