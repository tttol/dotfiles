---
name: chrome-app-launchers
description: Create Raycast- and Spotlight-friendly macOS .app launchers for Chrome apps stored under directories such as ~/Applications/Chrome Apps.localized. Use when a user wants Raycast, Spotlight, or Launch Services to find Chrome-created app shortcuts, when symlinks to .app bundles are ignored, or when reproducing Chrome app launcher setup on another Mac.
---
# Chrome App Launchers
## Overview
Use this skill to expose Chrome-created app bundles to Raycast by creating lightweight launcher `.app` bundles in `~/Applications`. The launcher opens the original Chrome app and can be registered with Launch Services and Spotlight.
## Workflow
1. Inspect the source directory, normally `~/Applications/Chrome Apps.localized`, and confirm it contains `.app` bundles.
2. Prefer the bundled script for repeatable setup:
```bash
python3 scripts/create_chrome_app_launchers.py
```
3. Pass explicit paths when the user uses non-default locations:
```bash
python3 scripts/create_chrome_app_launchers.py --source-dir "/path/to/Chrome Apps.localized" --dest-dir "$HOME/Applications"
```
4. Use `--dry-run` before modifying files when existing destination apps may conflict.
5. Run with `--replace-existing` only when replacing existing launchers created by this script or when the user explicitly accepts replacing destination `.app` bundles.
6. After creation, verify one app:
```bash
mdls -name kMDItemContentType -name kMDItemKind -name kMDItemDisplayName "$HOME/Applications/Gmail.app"
open -Ra Gmail
```
7. If Raycast still does not show the apps, restart Raycast or trigger its app refresh command if available.
## Notes
- Do not rely on symlinks alone; Spotlight and Raycast may ignore symlinked `.app` bundles.
- The script creates a small standard `APPL` bundle with `Contents/Info.plist` and `Contents/MacOS/launcher`.
- The original Chrome apps stay in place; the generated launchers only call `/usr/bin/open` on the original app path.
- The script registers created launchers with Launch Services and imports the destination directory into Spotlight unless `--no-register` is passed.
