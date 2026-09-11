-- DMS Window Rules — managed by DankMaterialShell
-- Do not edit manually; changes may be overwritten

-- DMS-RULE: id=wr_1788984200824774410, name=Steam Notifs
hl.window_rule({ match = { class = "^(steam)$", title = "^(notificationtoasts)", fullscreen = false }, float = true, no_focus = true, opacity = 0.7 })

-- DMS-RULE: id=wr_1789021598471044859, name=org.keepassxc.KeePassXC
hl.window_rule({ match = { class = "^org.keepassxc.KeePassXC$" }, float = true, size = { 800, 600 }, monitor = "DP-1", workspace = "3" })

-- DMS-RULE: id=wr_1789021762847346241, name=signal
hl.window_rule({ match = { class = "^signal$" }, float = true, size = { 600, 800 }, monitor = "DP-1", workspace = "3" })

-- DMS-RULE: id=wr_1789021800844543126, name=com.github.wwmm.easyeffects
hl.window_rule({ match = { class = "^com.github.wwmm.easyeffects$" }, float = true, size = { 400, 600 }, monitor = "DP-1", workspace = "3" })

-- DMS-RULE: id=wr_1789021864993328109, name=privateinternetaccess
hl.window_rule({ match = { class = "^privateinternetaccess$" }, float = true, size = { 400, 600 }, monitor = "DP-1", workspace = "3" })
