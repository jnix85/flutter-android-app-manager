# Domain Glossary

Ubiquitous language for Android App Manager. Terms here are the canonical names used in the UI, the code, and the docs.

## Device
An Android target reachable through ADB. Identified by its serial. Connection kinds: **USB**, **WIFI** (TCP/IP pairing), **EMULATOR**. A device may be *online*, *offline*, or *unauthorized* (USB debugging not yet approved on the phone).

## App
A package installed on the Device for the current user. Attributes: **Label** (in the device's language), **Package** (e.g. `com.example.foo`), **ID** (user id), **APK path**, **Type** (`system` or `user`).

## State
The App's current condition on the Device: **ENABLED**, **DISABLED**, or **UNINSTALLED** (removed for the current user but still present on the system image).

## Action
A change the user intends to apply to an App: **activate**, **deactivate**, **uninstall**, or **install**. An Action is derived from checking/unchecking an App relative to its State: unchecking an ENABLED app implies uninstall (or deactivate under *Never Uninstall*); checking a DISABLED or UNINSTALLED app implies activate or install.

## Applicable
An App whose current selection implies an Action, i.e. one that will change when the user applies. The *Applicable* filter shows exactly these.

## Never Uninstall
A policy setting: every *uninstall* Action is downgraded to *deactivate* (the App is disabled and its data cleared instead of removed).

## Action List
A list of `{package, action}` pairs, exported as JSON. Colloquially a *debloat list*. Importing an Action List selects/deselects Apps accordingly without applying anything.

## App List Backup
An Action List that covers every App, not only Applicable ones, so the full State of a Device can be replicated or restored elsewhere.

## Remote List
An Action List published by the community and fetched on demand from a repository in the `AppManager-Repo` GitHub organization.

## ADB Path
The `adb` executable the app uses. Either auto-detected (system PATH, then well-known install locations) or chosen by the user via *Select ADB*, which picks the folder containing the executable.

## Setup Wizard
The first-launch flow that lets the user pick a language and introduces the interface before the main screen appears.
