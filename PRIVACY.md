# Privacy — Now Playing - Sonos Fork

Last updated: October 12, 2026.

This independent fork has no analytics, telemetry, user accounts, or Pro purchase flow.

- Settings and diagnostic logs are stored locally in `%APPDATA%\SonosTaskbarWidget\`.
- The current code reads track information from the local Windows media session and the Spotify desktop app's accessibility interface.
- Unpackaged builds contact GitHub's API to check this fork's releases and download an executable only when the user accepts an update. GitHub receives normal network request information, such as the IP address and app user agent. Packaged builds currently skip this update check.
- The **Support original developer (MechanicWB)** menu item opens the original developer's Ko-fi page in your browser. Interactions there follow Ko-fi's privacy policy.

Sonos integration is not yet included in this repository. This policy must be updated when LAN speaker communication or other Sonos integration is added.

This fork is independent of MechanicWB, Sonos, and Spotify.
Source and contact: https://github.com/PandaWizard010/now-playing-taskbar-widget-sonsweb
