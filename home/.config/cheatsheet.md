#  Cheatsheet

| Command | Description |
| ------- | ----------- |
| `flatpak install flathub <app-id>` | Install a GUI app |
| `flatpak list --columns=application` | List installed flatpaks |
| `flatpak update` | Update all flatpaks |
| `brew install <tool>` | Install a CLI tool |
| `brew upgrade` | Update brew packages |
| `rpm-ostree install <pkg> && reboot` | Install a system package |
| `rpm-ostree upgrade && reboot` | Update the system image |
| `systemctl --user list-units` | List user services |
| `journalctl --user -f` | Follow user logs |
| `killall plasmashell && plasmashell &` | Restart Plasma shell |
| `glow ~/.config/cheatsheet.md` | Preview this cheatsheet |

---

**Config**: `~/.config/` · **Flatpak data**: `~/.var/app/<app-id>/` · **Brew**: `/home/linuxbrew/.linuxbrew/` · **Docs**: `~/agents.md`
