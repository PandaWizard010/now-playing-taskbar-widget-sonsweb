; Installer for the independent Sonos fork (per-user, no UAC)
; Compilar: ISCC.exe setup.iss  (depois de dotnet publish)

#define MyAppName "Now Playing - Sonos Fork"
#define MyAppVersion "1.3.1"
#define MyAppPublisher "PandaWizard010"
#define MyAppURL "https://github.com/PandaWizard010/now-playing-taskbar-widget-sonsweb"
#define MyAppExeName "SonosTaskbarWidget.exe"

[Setup]
AppId={{C146F8D2-64B3-4BCB-A467-D077FE75BC72}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
DefaultDirName={userpf}\SonosTaskbarWidget
DisableProgramGroupPage=yes
DisableDirPage=yes
PrivilegesRequired=lowest
OutputDir=installer
OutputBaseFilename=SonosTaskbarWidget-Setup
LicenseFile=LICENSE
SetupIconFile=app.ico
UninstallDisplayIcon={app}\{#MyAppExeName}
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
ShowLanguageDialog=no
CloseApplications=yes

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "pt"; MessagesFile: "compiler:Languages\Portuguese.isl"

[Tasks]
Name: "autostart"; Description: "{cm:AutoStartProgram,{#MyAppName}}"

[Files]
Source: "publish\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "publish\LICENSE"; DestDir: "{app}"; Flags: ignoreversion
Source: "publish\NOTICE.md"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{userprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"

[Registry]
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; \
    ValueName: "SonosTaskbarWidget"; ValueData: """{app}\{#MyAppExeName}"""; \
    Flags: uninsdeletevalue; Tasks: autostart

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#MyAppName}}"; \
    Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "taskkill.exe"; Parameters: "/f /im {#MyAppExeName}"; Flags: runhidden; RunOnceId: "KillWidget"

[Code]
// A app precisa do .NET 8 Desktop Runtime; se faltar, descarrega e instala
// (link evergreen da Microsoft). Sem rede, a instalação continua na mesma.
function NeedsDotNet(): Boolean;
var
  RC: Integer;
begin
  Result := not (Exec('cmd.exe',
    '/c dotnet --list-runtimes | findstr /C:"Microsoft.WindowsDesktop.App 8." >nul',
    '', SW_HIDE, ewWaitUntilTerminated, RC) and (RC = 0));
end;

function PrepareToInstall(var NeedsRestart: Boolean): String;
var
  RC: Integer;
begin
  Result := '';
  if NeedsDotNet() then
  begin
    try
      DownloadTemporaryFile(
        'https://aka.ms/dotnet/8.0/windowsdesktop-runtime-win-x64.exe',
        'windowsdesktop-runtime.exe', '', nil);
      Exec(ExpandConstant('{tmp}\windowsdesktop-runtime.exe'),
        '/install /quiet /norestart', '', SW_SHOW, ewWaitUntilTerminated, RC);
    except
      // sem rede ou download falhou — a app avisa ao arrancar
    end;
  end;
end;
