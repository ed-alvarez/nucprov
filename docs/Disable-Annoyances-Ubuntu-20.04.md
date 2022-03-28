# Disable Software Update startup popup:

Ubuntu by default displays a software update popup every time you boot up a machine. With this command, we can disable the service completely from "interrupting" our login sequence.

```
$ sudo echo "Hidden=yes" >> /etc/xdg/autostart/update-notifier.desktop
$ sudo sed --in-place 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/update-notifier.desktop
```

# Disable any sort of locking mechanism:

This will disable any sort of lock. Be it key combinations or software oriented. Timeouts get disabled as well.

```
$ dconf write /org/gnome/desktop/screensaver/lock-enabled false
$ dconf write /org/gnome/desktop/screensaver/lock-delay "uint32 0" 
$ dconf write /org/gnome/desktop/session/idle-delay "uint32 0"
$ dconf write /org/gnome/desktop/lockdown/disable-log-out true
$ dconf write /org/gnome/desktop/lockdown/disable-command-line true
$ dconf write /org/gnome/settings-daemon/plugins/media-keys/screensaver "['disabled']"
```

# Disable bubble notifications:

This will disable bubble notifications and startup notifications.

```
$ dconf write /org/gnome/todo/plugins/background/show-notifications false
$ dconf write /org/gnome/desktop/notifications/show-banners false
```

For good measure, we will also disable other services that utilize libnotify-bin. 

```
$ dconf write /org/gnome/desktop/notifications/application/org-gnome-nautilus/show-banners false
$ dconf write /org/gnome/desktop/notifications/application/update-manager/show-banners false
```

# Disable keybinds that can interact with the machine directly:

These keybinds can interact with the entire desktop and BroadSign Player. We want to disable these without affecting or disabling the entire keyboard.

```
$ dconf write /org/gnome/desktop/wm/keybindings/close "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/minimize "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/maximize "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/move-to-monitor-down "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/move-to-monitor-left "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/move-to-monitor-right "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/move-to-monitor-up "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-1 "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-down "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-last "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-left "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-right "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-up "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/panel-main-menu "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/panel-run-dialog "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/show-desktop "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/switch-applications "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/switch-applications-backward "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/switch-input-source "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/switch-input-source-backward "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/switch-panels "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/switch-panels-backward "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-1 "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-down "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-last "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-left "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-right "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-up "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/switch-windows "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/switch-windows-backward "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/toggle-maximized "['disabled']"
$ dconf write /org/gnome/desktop/wm/keybindings/unmaximize "['disabled']"
```

# Disable "Super" keybinds that can also interrupt the view and launch other applications:

```
$ for i in {1..10}; do dconf write /org/gnome/shell/extensions/dash-to-dock/app-ctrl-hotkey-$i "['disabled']"; done
$ for i in {1..10}; do dconf write /org/gnome/shell/extensions/dash-to-dock/app-hotkey-$i "['disabled']"; done
$ for i in {1..10}; do dconf write /org/gnome/shell/extensions/dash-to-dock/app-shift-hotkey-$i "['disabled']"; done
$ for i in {1..9}; do dconf write /org/gnome/shell/keybindings/switch-to-application-$i "['disabled']" done
$ dconf write /org/gnome/shell/keybindings/open-application-menu "['disabled']"
$ dconf write /org/gnome/shell/keybindings/toggle-application-view "['disabled']"
$ dconf write /org/gnome/shell/keybindings/toggle-message-tray "['disabled']"
$ dconf write /org/gnome/shell/keybindings/toggle-overview "['disabled']"
$ dconf write /org/gnome/mutter/overlay-key "''"
$ dconf write /org/gnome/shell/extensions/dash-to-dock/hot-keys false
$ dconf write /org/gnome/shell/extensions/dash-to-dock/hotkeys-overlay false
$ dconf write /org/gnome/shell/extensions/dash-to-dock/hotkeys-show-dock false
$ dconf write /orgn/gnome/mutter/wayland/keybindings/restore-shortcuts "['disabled']"
```

# Disable switching VT sessions within Gnome:

```
$ for i in {1..12}; do dconf write /org/gnome/mutter/wayland/keybindings/switch-to-session-$i "['disabled']" done
```

# Disable Ubuntu default app and media keybinds:

```
$ dconf write /org/gnome/settings-daemon/plugins/media-keys/active false
$ dconf write /org/gnome/settings-daemon/plugins/media-keys/help "['disabled']"
$ dconf write /org/gnome/settings-daemon/plugins/media-keys/hibernate-static "['disabled']"
$ dconf write /org/gnome/settings-daemon/plugins/media-keys/home-static "['disabled']"
$ dconf write /org/gnome/settings-daemon/plugins/media-keys/logout "['disabled']"
$ dconf write /org/gnome/settings-daemon/plugins/media-keys/www-static "['disabled']"
$ dconf write /org/gnome/settings-daemon/plugins/media-keys/terminal "['disabled']"
```

# Final steps:

After running all of these dconf commands, we need to update our user settings database to apply our new configuration. For this, simply run:

```
$ sudo dconf update
```
