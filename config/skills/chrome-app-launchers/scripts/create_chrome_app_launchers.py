#!/usr/bin/env python3
import argparse
import hashlib
import plistlib
import shlex
import shutil
import subprocess
import sys
import unicodedata
from pathlib import Path
IDENTIFIER_PREFIX = "link.about-tttol.chrome-apps"
def parse_args():
    parser = argparse.ArgumentParser(description="Create Raycast-friendly launchers for Chrome app bundles.")
    parser.add_argument("--source-dir", default="~/Applications/Chrome Apps.localized", help="Directory containing Chrome-created .app bundles.")
    parser.add_argument("--dest-dir", default="~/Applications", help="Directory where launcher .app bundles are created.")
    parser.add_argument("--replace-existing", action="store_true", help="Replace existing destination .app bundles.")
    parser.add_argument("--no-register", action="store_true", help="Skip Launch Services registration and Spotlight import.")
    parser.add_argument("--dry-run", action="store_true", help="Print planned changes without writing files.")
    return parser.parse_args()
def app_name(app_path):
    return unicodedata.normalize("NFC", app_path.stem)
def bundle_identifier(name):
    digest = hashlib.sha1(name.encode("utf-8")).hexdigest()[:12]
    return f"{IDENTIFIER_PREFIX}.{digest}"
def info_plist(name):
    return {"CFBundleDisplayName": name, "CFBundleExecutable": "launcher", "CFBundleIdentifier": bundle_identifier(name), "CFBundleName": name, "CFBundlePackageType": "APPL", "CFBundleShortVersionString": "1.0", "CFBundleVersion": "1.0"}
def existing_generated_launcher(path):
    plist_path = path / "Contents" / "Info.plist"
    if not plist_path.exists():
        return False
    with plist_path.open("rb") as plist_file:
        identifier = plistlib.load(plist_file).get("CFBundleIdentifier", "")
    return isinstance(identifier, str) and identifier.startswith(f"{IDENTIFIER_PREFIX}.")
def create_launcher(source_app, launcher_app, replace_existing, dry_run):
    name = app_name(source_app)
    if launcher_app.exists() or launcher_app.is_symlink():
        if not replace_existing and not launcher_app.is_symlink() and not existing_generated_launcher(launcher_app):
            return f"SKIP existing app: {launcher_app}"
        if dry_run:
            return f"WOULD REPLACE {launcher_app}"
        if launcher_app.is_symlink() or launcher_app.is_file():
            launcher_app.unlink()
        else:
            shutil.rmtree(launcher_app)
    if dry_run:
        return f"WOULD CREATE {launcher_app} -> {source_app}"
    macos_dir = launcher_app / "Contents" / "MacOS"
    macos_dir.mkdir(parents=True, exist_ok=True)
    with (launcher_app / "Contents" / "Info.plist").open("wb") as plist_file:
        plistlib.dump(info_plist(name), plist_file)
    executable = macos_dir / "launcher"
    executable.write_text(f"#!/bin/sh\n/usr/bin/open {shlex.quote(str(source_app))}\n", encoding="utf-8")
    executable.chmod(0o755)
    return f"CREATED {launcher_app} -> {source_app}"
def register_launchers(dest_dir, launchers):
    if not launchers:
        return []
    lsregister = Path("/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister")
    subprocess.run([str(lsregister), "-f", *[str(path) for path in launchers]], check=False)
    subprocess.run(["mdimport", str(dest_dir)], check=False)
    return [f"REGISTERED {path}" for path in launchers]
def main():
    args = parse_args()
    source_dir = Path(args.source_dir).expanduser()
    dest_dir = Path(args.dest_dir).expanduser()
    if not source_dir.is_dir():
        print(f"Source directory not found: {source_dir}", file=sys.stderr)
        return 1
    source_apps = sorted(source_dir.glob("*.app"), key=lambda path: app_name(path).casefold())
    if not source_apps:
        print(f"No .app bundles found in: {source_dir}", file=sys.stderr)
        return 1
    if not args.dry_run:
        dest_dir.mkdir(parents=True, exist_ok=True)
    results = [create_launcher(source_app, dest_dir / source_app.name, args.replace_existing, args.dry_run) for source_app in source_apps]
    created_launchers = [dest_dir / source_app.name for source_app, result in zip(source_apps, results) if result.startswith("CREATED")]
    register_results = [] if args.no_register or args.dry_run else register_launchers(dest_dir, created_launchers)
    print("\n".join([*results, *register_results]))
    return 0
if __name__ == "__main__":
    raise SystemExit(main())
