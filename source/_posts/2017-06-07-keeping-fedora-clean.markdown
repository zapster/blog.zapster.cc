---
layout: post
title: "Keeping Fedora Clean"
date: 2017-06-07 11:40:36 +0200
comments: true
published: false
categories: fedora linux
---

Auxiliary files can account for a lot of space in a long running Linux installation.

<!-- more -->

### Cleaning `journalctl` logs


[StackExchange answer][journalctl-disk-usage] proposing `journalctl --disk-usage`.
[StackExchange answer][journalctl] on cleaning `journalctl` logs.

> Retain only the past two days:

    journalctl --vacuum-time=2d

> Retain only the past 500 MB:

    journalctl --vacuum-size=500M

### Cleaning `PackageKit` cache

[StackExchange answer][PackageKit] on cleaning `PackageKit` cache.

> You can get rid of these files using PackageKit console client `pkcon`

<!-- language: lang-sh -->

    $ sudo pkcon refresh force -c -1

> It takes some time but is provided by PackageKit itself. (and you may set a cron job for it)
>
> from the man page of [pkcon(1)](https://www.mankier.com/1/pkcon)

       refresh [force]
           Refresh the cached information about available updates.
> and

       -c, --cache-age AGE
           Set the maximum acceptable age for cached metadata, in seconds. Use -1 for 'never'.

> So this tells PackageKit to delete cached information (refresh cached information with maximum acceptable age of : never)

### Pruning `docker` images

This [StackOverflow answer][docker-clean] suggests the following command to remove all unused
`docker` images.

```
docker rmi $(docker images -f "dangling=true" -q)
```

They also mention that with docker 1.13 new maintenance commands like `docker system prune` are available.


References:
-----------


* [journalctl][]: StackExchange answer on cleaning `journalctl` logs
* [journalctl-disk-usage][]: StackExchange answer proposing `journalctl --disk-usage`
* [PackageKit][]: StackExchange answer on cleaning `PackageKit` cache
* [docker-clean][]: StackOverflow answer on cleaning unused `docker` data

[PackageKit]: https://unix.stackexchange.com/a/290636/99344
[journalctl]: https://unix.stackexchange.com/a/194058/99344
[journalctl-disk-usage]: https://unix.stackexchange.com/a/130802/99344
[docker-clean]: https://stackoverflow.com/a/32723127/2761742
