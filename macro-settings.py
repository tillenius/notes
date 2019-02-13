def openInVsFromWinMerge():
    if window_text.startswith("WinMerge"):
        childwindows = macro.enum_child_windows(hwnd)
        statuswindows = [ h for h in childwindows if macro.get_class_name(h) == "msctls_statusbar32" ]
        editwindows = [ h for h in childwindows if macro.get_class_name(h) == "Edit" ]
        if len(editwindows) == 2 and len(statuswindows) == 2:
            filename = macro.get_window_text(editwindows[1])
            status = macro.get_sb_text(statuswindows[0], 4)
            words = status.split(" ")
            line = int(words[1])
            macro.notify(filename + ":" + str(line))
            macro.open_in_vs(filename, line)
