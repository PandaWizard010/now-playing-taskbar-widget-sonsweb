# Now Playing - Sonos Fork

An independent development fork of [Now Playing - Taskbar Widget](https://github.com/mechanicwb2-hub/now-playing-taskbar-widget), originally created by **MechanicWB**. Fork maintenance and modifications: **PandaWizard010**.

The goal is to add Sonos playback support, including playback started from the Sonos web player. **The Sonos add-on has not yet been merged into this repository.** The checked-in playback code currently targets the Spotify desktop app. The upstream Store application may contain newer features than this source snapshot.

This fork is not affiliated with or endorsed by MechanicWB, Sonos, or Spotify.

![Original upstream widget demo](docs/demo.gif)

*This inherited demo does not demonstrate Sonos support.*

## Pro and Microsoft Store

This fork has **no Pro purchase or upgrade flow**. It does not activate the original app's paid Store add-on or bundle separately distributed paid components. The MIT-licensed source remains under its original license.

The original Microsoft Store listing and winget package belong to MechanicWB's app. Installing either installs the original application. Use this repository's source or its own release assets for this fork.

## Build and run

Requires Windows and the .NET 8 SDK. This source snapshot retains the original Windows 11 taskbar integration.

```powershell
dotnet publish SpotifyTaskbarWidget.csproj -c Release -o publish
.\publish\SonosTaskbarWidget.exe
```

The executable requires the .NET 8 Desktop Runtime. For a standalone build:

```powershell
dotnet publish SpotifyTaskbarWidget.csproj -c Release -o publish -p:SelfContained=true
```

Keep `LICENSE` and `NOTICE.md` alongside the executable when sharing a build; publishing copies them automatically. Installer builds also include both notices.

There is no Microsoft Store listing or published winget manifest for this fork. See [packaging guidance](docs/store-listing.md) for local MSIX signing.

## Current behavior

- Reads Spotify's local Windows media session for title, artist, artwork, play state, and timeline.
- Provides play/pause, previous/next, and seeking.
- Reads Spotify desktop accessibility controls for favorites, shuffle, repeat, and volume.
- Supports automatic taskbar positioning, manual placement, multiple monitors, sizing, brightness, and hiding during fullscreen applications.
- UI languages: English and Portuguese.
- Right-click → **About this fork** shows attribution and the fork's status.
- Right-click → **Support original developer (MechanicWB) ☕** opens the original developer's Ko-fi page.

Settings and error logs use `%APPDATA%\SonosTaskbarWidget\`. The fork has its own executable, startup entry, single-instance mutex, installer ID, install folder, and package identity. Its settings start independently of the original app.

Updates check [this fork's releases](https://github.com/PandaWizard010/now-playing-taskbar-widget-sonsweb/releases), matching only the `SonosTaskbarWidget.exe` asset. Publish a numeric tag such as `v1.3.2` with that asset to distribute an update.

## Sonos status

The previously prepared Sonos integration kit is separate from this repository. Sonos detection, speaker configuration, LAN communication, and playback controls must be integrated before this fork can be described as supporting Sonos. This attribution and distribution update does not add that integration.

## Help

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md). Report fork problems in [this repository's issues](https://github.com/PandaWizard010/now-playing-taskbar-widget-sonsweb/issues).

## Credits and license

Original software copyright (c) 2026 **MechanicWB**, released under the **MIT License**. The original [LICENSE](LICENSE) is preserved. Fork modifications are also provided under MIT; see [NOTICE.md](NOTICE.md).

To support the original developer: [MechanicWB on Ko-fi](https://ko-fi.com/mechanicwb2).

## Structure

| File | Role |
|---|---|
| `MainWindow.xaml(.cs)` | Widget UI, positioning, menu, and fork About dialog |
| `MediaService.cs` | Spotify Windows media session |
| `SpotifyUiaService.cs` | Spotify accessibility controls |
| `SpotifyVolume.cs` | Spotify app volume via Windows audio |
| `Interop.cs` | Win32 taskbar, fullscreen detection, and input |
| `WidgetSettings.cs` | Local fork settings |
| `UpdateService.cs` | Updates from this fork's GitHub releases |

The existing project filename and C# namespace are retained for compatibility with the separate integration kit. The output executable is `SonosTaskbarWidget.exe`.
