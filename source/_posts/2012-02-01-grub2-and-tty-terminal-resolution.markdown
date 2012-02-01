---
layout: post
title: "Grub2 and tty terminal resolution"
date: 2012-02-01 14:59
comments: true
published: false
categories: ['grub2', 'tty', 'linux', 'ubuntu', 'terminal']
---
* `/etc/default/grub`
* `/etc/grub.d/`
* `GRUB_GFXMODE`
* `GRUB_GFXPAYLOAD_LINUX` &rarr; `/etc/grub.d/10_linux`
* `update-grub`

Do not change `05_debian_theme!` &rarr; `update-grub` error no
```
Generating grub.cfg ...

No path or device is specified.

Try ``grub-probe --help'' for more information.
```

References:
-----------

* [Ubuntu Comunity Decumentation: Grub2][]

[Ubuntu Comunity Decumentation: Grub2]:https://help.ubuntu.com/community/Grub2
[Ubuntu Forum: change font size in tty terminal]:http://ubuntuforums.org/showthread.php?t=1787045
