---
layout: post
title: "Linux and the HiDPI weirdness"
date: 2014-06-15 16:21:52 +0200
comments: true
published: false
categories: 
- Dell XSP 15 9530
- linux
- HiDPI
- xorg
- freedesktop
---

- [freedesktop Bug 23705](https://bugs.freedesktop.org/show_bug.cgi?id=23705)
- [freedesktop Bug 41115](https://bugs.freedesktop.org/show_bug.cgi?id=41115)
- [Ubuntu Bug 589485](https://bugs.launchpad.net/ubuntu/+source/xorg-server/+bug/589485)

- [irc log](http://pastebin.com/vtzyBK6e)

## Archlinux Wiki
- [HiDPI](https://wiki.archlinux.org/index.php/HiDPI)
- [Xorg (setting DPI)](https://wiki.archlinux.org/index.php/Xorg#Display_size_and_DPI)
- [Xorg (Talk)](https://wiki.archlinux.org/index.php/Talk:Xorg)

## Gnome

- Comment in gnome settings source code: [xsettings](https://git.gnome.org/browse/gnome-settings-daemon/tree/plugins/xsettings/gsd-xsettings-manager.c#n70)

## Other

- [Phoronix thread about HiDPI](http://www.phoronix.com/forums/showthread.php?95685-GNOME-Shell-Lands-High-DPI-Support)


# logs

Output of `xdpyinfo` (wrong DPI and physical size):

    screen #0:
      dimensions:    3200x1800 pixels (846x476 millimeters)
      resolution:    96x96 dots per inch

Output of  `xrandr` (correct physical size):

    Screen 0: minimum 320 x 200, current 3200 x 1800, maximum 8192 x 8192
    eDP1 connected primary 3200x1800+0+0 (normal left inverted right x axis y axis) 346mm x 194mm

Xorg log `/var/log/Xorg.0.log`:

    [    16.236] (==) intel(0): DPI set to (96, 96)
    [    16.237] (==) NOUVEAU(G0): DPI set to (96, 96)

# code

{% include_code lang:bash 90-monitor.conf %}
