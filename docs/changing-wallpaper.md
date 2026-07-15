# Changing Wallpaper (KDE Plasma)

## Using the CLI

Download an image and set it as wallpaper with `qdbus-qt6`:

```bash
curl -L -o /tmp/wallpaper.jpg "<image-url>"

qdbus-qt6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
var allDesktops = desktops();
for (var i = 0; i < allDesktops.length; i++) {
  allDesktops[i].wallpaperPlugin = 'org.kde.image';
  allDesktops[i].currentConfigGroup = ['Wallpaper', 'org.kde.image', 'General'];
  allDesktops[i].writeConfig('Image', 'file:///tmp/wallpaper.jpg');
}
"
```

## Multi-monitor

To set wallpaper on a specific monitor, index into `desktops()`:

```bash
qdbus-qt6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
var d = desktops()[0];
d.wallpaperPlugin = 'org.kde.image';
d.currentConfigGroup = ['Wallpaper', 'org.kde.image', 'General'];
d.writeConfig('Image', 'file:///tmp/wallpaper.jpg');
"
```

## GUI

Right-click the desktop > *Configure Desktop and Wallpaper* > select an image or add one.
