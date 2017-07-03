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

### Cleaning `PackageKit` cache

[StackExchange answer][PackageKit] on cleaning `PackageKit` cache.

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
