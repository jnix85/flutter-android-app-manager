# Android App Manager

<p align="center"><img src="pages/images/banner.jpg" style="width:600px;height:auto;"></p>

<p align="center">
  <a href="https://github.com/jnix85/flutter-android-app-manager/releases/latest"><img alt="Latest release" src="https://img.shields.io/github/v/release/jnix85/flutter-android-app-manager?include_prereleases"></a>
  <a href="https://github.com/jnix85/flutter-android-app-manager/actions/workflows/ci.yml"><img alt="CI" src="https://github.com/jnix85/flutter-android-app-manager/actions/workflows/ci.yml/badge.svg"></a>
  <img alt="Platforms" src="https://img.shields.io/badge/platforms-Windows%20%7C%20Linux%20%7C%20macOS-blue">
  <a href="./LICENSE"><img alt="License: GPL-3.0" src="https://img.shields.io/badge/license-GPL--3.0-green"></a>
</p>

**Android App Manager** is an open-source Flutter desktop app for managing and debloating the apps on an Android device over ADB. It lists every app on the device with its icon, label, and state, and lets you enable, disable, uninstall, or reinstall apps in bulk, export the changes as a shareable list, and pull community debloat lists straight into the interface.

It builds on the [App Manager](https://github.com/BlassGO/App_Manager) DalvikVM tool by [BlassGO](https://github.com/BlassGO), which extracts app details and icons on the device without installing anything on it.

## Table of contents

- [Screenshots](#screenshots)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
  - [Windows](#windows)
  - [Linux](#linux)
  - [macOS](#macos)
- [First launch](#first-launch)
- [Configuration](#configuration)
- [Usage tips](#usage-tips)
- [Building from source](#building-from-source)
- [Releasing](#releasing)
- [Contributing](#contributing)
- [Credits](#credits)
- [License](#license)

## Screenshots

> <p align="center"><img src="pages/images/setup.jpg" style="width:600px;height:auto;"></p>
> <p align="center"><img src="pages/images/gui.jpg" style="width:600px;height:auto;"></p>
> <p align="center"><img src="pages/images/gui-list-icon.jpg" style="width:600px;height:auto;"></p>
> <p align="center"><img src="pages/images/gui-icon.jpg" style="width:600px;height:auto;"></p>

## Features

| Feature | Description |
|---------|-------------|
| **App listing** | Every app for the current user with `Label` (in the device's language), `Package`, `ID`, `APK path`, and `Type` (system/user) |
| **Icon view** | An app-drawer style grid with icons and labels. Icons can be shown in the list view too, and extracted to PNG for any app |
| **Search and filters** | Filter by name, package, membership, or state (ENABLED / DISABLED / UNINSTALLED); show only "Checked", "Unchecked", or "Applicable" apps. *Applicable* shows exactly the apps that will change before you apply |
| **Sorting** | Sort by name (A→Z / Z→A), package, state, or type |
| **Bulk actions** | **Activate**, **deactivate**, **uninstall**, or **install** many apps at once by checking or unchecking them |
| **Device management** | Switch between devices connected over USB, Wi-Fi (TCP/IP), or Android emulators |
| **Log viewer** | Built-in log of every ADB command, error, and exception |
| **JSON export / import** | Export the pending actions as JSON to replicate them on another device, or import someone else's debloat list |
| **App list backup** | Export the full app list so a device's exact state can be restored or replicated later |
| **Remote lists** | Browse and apply community debloat lists from the [AppManager-Repo](https://github.com/orgs/AppManager-Repo/repositories) organization, sorted by popularity |
| **Themes** | Light, dark, or follow-the-system theme, switchable from the toolbar |
| **Multilingual** | English, Français, Español, Português (Brasil), 日本語, 中文 (简体), Bahasa Indonesia, Русский, Română, Türkçe |

## Requirements

- [**ADB**](https://developer.android.com/tools/releases/platform-tools) (Android platform-tools)
- One of:
  - **Windows 10** or later (x64)
  - **Linux** (x64, GTK 3)
  - **macOS 12 Monterey** or later (Apple Silicon and Intel; the build is universal)
- An Android device with **USB debugging** enabled (Settings › Developer options)

## Installation

Prebuilt binaries for every release are on the [Releases page](https://github.com/jnix85/flutter-android-app-manager/releases).

### Windows

1. Download `android_app_manager_windows_x64.zip`.
2. Extract it to a folder of your choice (for example `C:\AndroidAppManager`).
3. Run `android_app_manager.exe`.
4. If ADB is not on your `PATH`, use **Settings › Actions › Select ADB** and pick the folder that contains `adb.exe`.

### Linux

1. Download `android_app_manager_linux_x64.tar.gz`.
2. Extract and run:
   ```bash
   mkdir -p ~/AndroidAppManager
   tar -xzf android_app_manager_linux_x64.tar.gz -C ~/AndroidAppManager
   ~/AndroidAppManager/android_app_manager
   ```
3. Install ADB if you haven't (`sudo apt install android-tools-adb` on Debian/Ubuntu). The app looks on your `PATH` and in `~/Android/Sdk/platform-tools`; otherwise use **Settings › Actions › Select ADB**.

### macOS

1. Install ADB, e.g. with Homebrew:
   ```bash
   brew install --cask android-platform-tools
   ```
2. Download `android_app_manager_macos_universal.zip`, double-click it to extract, and drag **Android App Manager.app** into `/Applications`.
3. Open the app. Because it is not notarized by Apple, the first launch is blocked with *"Apple could not verify 'Android App Manager' is free of malware…"*. Click **Done**, then:
   - Open **System Settings › Privacy & Security**, scroll to the *Security* section, and click **Open Anyway** next to *"Android App Manager" was blocked to protect your Mac*. Confirm with your password and click **Open Anyway** once more. macOS remembers this; later launches are normal.
   - Or, from Terminal, clear the quarantine flag and open normally:
     ```bash
     xattr -dr com.apple.quarantine "/Applications/Android App Manager.app"
     ```
   > On macOS 15 Sequoia and later, Control-click › Open no longer bypasses this check; use one of the two methods above. The app is ad-hoc signed rather than notarized because notarization requires a paid Apple Developer account.
4. ADB is detected automatically from Homebrew (`/opt/homebrew/bin`, `/usr/local/bin`) or the Android SDK (`~/Library/Android/sdk/platform-tools`), even though apps launched from Finder don't see your shell `PATH`. If it still isn't found, use **Settings › Actions › Select ADB** and pick the folder that contains `adb`.
5. The macOS build runs inside the App Sandbox. If your phone is connected over USB but never shows up, start the ADB server outside the sandbox once and relaunch the app:
   ```bash
   adb start-server
   ```
   Wireless connections (**Settings › TCP/IP**) are unaffected.

## First launch

1. Enable **USB debugging** on the phone (Settings › Developer options).
2. Connect it over USB, or pair wirelessly and enter its IP and port under **Settings › TCP/IP**.
3. Accept the *Allow USB debugging?* prompt on the phone the first time it talks to this computer.
4. The **Setup Wizard** lets you pick a language and walks through the interface. After that the app loads the device's app list; with several devices attached, pick one from the device selector.

## Configuration

| Setting | Location | Description |
|---------|----------|-------------|
| **Never uninstall, only deactivate** | Settings › Options | Apps you uncheck are disabled and their data cleared instead of being uninstalled |
| **Export all apps list** | Settings › Options | Include every app in the JSON export (not just pending changes), deducing the action needed to replicate its state |
| **Refresh all icons** | Settings › Options | Icons are cached per device; force a full refresh every time at the cost of speed |
| **Always show icons** | Settings › Options | Show app icons by default in both the list and the grid view |
| **Select ADB** | Settings › Actions | Choose the folder containing the `adb` executable |
| **Language** | Settings › Language | Interface language for menus, alerts, and dialogs |
| **TCP/IP** | Settings › TCP/IP | Connect to or disconnect from a device over Wi-Fi (IP and port) |
| **Theme** | Toolbar | Light, dark, or system |
| **Sort** | Toolbar | Order the list by name, package, state, or type |

## Usage tips

- **Multi-select**: checking and unchecking is all you need. Active apps start checked; disabled or uninstalled apps start unchecked. Check an app to reactivate or reinstall it, uncheck it to disable or uninstall it, then apply:
  <p align="center"><img src="pages/images/multi-select.jpg" style="width:600px;height:auto;"></p>

- **Show info**: get the details of any app quickly:
  <p align="center"><img src="pages/images/show-info.jpg" style="width:600px;height:auto;"></p>

- **Logs**: open the log viewer when something goes wrong; every ADB command and its output is there:
  <p align="center"><img src="pages/images/log-viewer.jpg" style="width:600px;height:auto;"></p>

- **Devices**: switch between connected devices from the device manager:
  <p align="center"><img src="pages/images/device-selector.jpg" style="width:600px;height:auto;"></p>

- **Remote lists**: browse community debloat lists, sorted by popularity and with author details, and apply one directly:
  <p align="center"><img src="pages/images/remote.jpg" style="width:600px;height:auto;"></p>

## Building from source

You need the [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel, 3.47 or newer) plus the desktop toolchain for your platform:

| Platform | Toolchain |
|----------|-----------|
| Windows | Visual Studio 2022 with the *Desktop development with C++* workload |
| Linux | `sudo apt install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libstdc++-12-dev` |
| macOS | Xcode 26 or newer and CocoaPods (`brew install cocoapods`) |

Then:

```bash
git clone https://github.com/jnix85/flutter-android-app-manager.git
cd flutter-android-app-manager
flutter pub get
flutter run -d windows   # or: linux, macos
```

Release builds:

```bash
flutter build windows --release   # build/windows/x64/runner/Release/
flutter build linux --release     # build/linux/x64/release/bundle/
flutter build macos --release     # build/macos/Build/Products/Release/Android App Manager.app
```

The macOS build is universal (arm64 + x86_64) and ad-hoc signed; see the [macOS install notes](#macos) for the Gatekeeper prompt you'll get when running it from a download.

### Reproducible Linux build with Docker

The repository's `Dockerfile` builds the Linux bundle on Debian 12 for broad glibc compatibility:

```bash
docker build -t android-app-manager-linux .
docker create --name aam android-app-manager-linux
docker cp aam:/app/build/linux/x64/release/bundle ./linux-bundle
docker rm aam
```

## Releasing

Releases are built by GitHub Actions ([`release.yml`](.github/workflows/release.yml)):

1. Bump `version:` in `pubspec.yaml` and merge to `main`.
2. Tag and push: `git tag v1.2.3 && git push origin v1.2.3`. The tag must match the pubspec version.
3. The workflow builds Windows, Linux, and macOS, verifies the macOS bundle is universal and correctly signed, and opens a **draft** release with `android_app_manager_windows_x64.zip`, `android_app_manager_linux_x64.tar.gz`, and `android_app_manager_macos_universal.zip` attached plus auto-generated notes.
4. Review the draft on the Releases page and publish it.

Running the workflow manually (*Actions › Release › Run workflow*) builds the three artifacts without creating a release, which is handy for testing a branch.

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/jnix85/flutter-android-app-manager).

- Fork the repository and create a branch for your change.
- Run `flutter analyze` and `flutter test` before opening a pull request; CI runs the same checks.
- **Translations**: copy `assets/languages/en.xml` to `assets/languages/<code>.xml`, translate the values, and add an entry to `assets/languages.json`:
  ```json
  {"name": "Deutsch", "file_name": "de.xml"}
  ```

The in-app remote lists come from the community [AppManager-Repo](https://github.com/orgs/AppManager-Repo/repositories) organization, which is maintained upstream by BlassGO.

## Credits

- [**BlassGO**](https://github.com/BlassGO) — author of the original [App Manager GUI](https://github.com/BlassGO/AppManager-GUI) that this project is derived from, and of the [App Manager](https://github.com/BlassGO/App_Manager) DalvikVM tool it relies on.
- The [AppManager-Repo](https://github.com/AppManager-Repo) community for the shared debloat lists.

## License

**Android App Manager** is free software distributed under the GNU General Public License version 3.0 (`GPL-3.0`). You may use, modify, and redistribute it under the terms of that license. See [LICENSE](./LICENSE).
