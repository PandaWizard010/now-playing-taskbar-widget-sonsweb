# Packaging and distribution of the independent fork

Product: **Now Playing - Sonos Fork**
Maintainer: **PandaWizard010**

The original Microsoft Store product and publisher identity belong to MechanicWB. This fork has no Store listing, Pro purchase flow, or association with that listing.

## Build an installer

On Windows, publish using the command in README.md, then compile `setup.iss` with Inno Setup. The installer produces `SonosTaskbarWidget-Setup.exe` and includes `LICENSE` and `NOTICE.md`.

The installer uses a separate AppId, installation folder, and startup registry entry so it does not replace the original application.

## Build a local MSIX

Run `Packaging\build-msix.ps1` on Windows. The result is an unsigned `Packaging\out\SonosTaskbarWidget.msix`.

The manifest uses `PandaWizard010.SonosTaskbarWidget` and local publisher `CN=PandaWizard010`. Sign with your own certificate whose subject matches that publisher; install the certificate as appropriate for your test machine.

For a future Microsoft Store submission, reserve a new product under your own account and replace the manifest identity and publisher with your own Partner Center values. This local manifest is not an existing Store reservation. Do not use the original application's identity or Store ID.

## Release assets

Publish this fork's own builds at:
https://github.com/PandaWizard010/now-playing-taskbar-widget-sonsweb/releases

Use a numeric tag such as `v1.3.2` and attach `SonosTaskbarWidget.exe` for the in-app updater. Include `LICENSE` and `NOTICE.md` in any downloadable build bundle.

## Attribution and feature claims

Credit MechanicWB and link the original project. Preserve LICENSE and NOTICE.md in source/build distributions. The source currently targets Spotify; Sonos support is pending integration. Do not advertise upstream Pro purchases as features of this fork.
