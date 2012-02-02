---
layout: post
title: "DNS search suffix and dhclient"
date: 2012-01-30 16:33
comments: false
published: true
categories: 
- dhclient
- dhcp
- dns
- dnsmasq
- linux
---

A long time I did not really care about DNS search suffixes. Suddenly,
a few months ago, I realized that it would be nice if I could use the same
URL (bookmarks, etc.) to reach my laptop, no matter which local network I am currently
using. 

I was aware that I can use [resolv.conf(5)][] but
editing your `/etc/resolv.conf` and using DHCP is often not a good idea because it
might get overwritten. Fortunately most (open) router operation systems support `dnsmasq` 
which is capable of providing IP addresses and supporting local DNS resolution. 

Anyway, sometimes adding a DNS search suffix only to your local computer is just what you need.
In this case [dhclient.conf(5)][] might become handy.

```
append domain-search "example.com", "sales.example.com";
```

The line above adds two suffixes to the DNS resolution list so instead of `ssh server.example.com`
one only need to type `ssh server`. The manual page for [dhcp-options(5)][] lists other 
useful options with can be used to configure the DHCP client.

References:
-----------

* [resolv.conf(5)][]: manual page
* [dhclient.conf(5)][]: manual page
* [dhcp-options(5)][]: manual page

[resolv.conf(5)]: http://linux.die.net/man/5/resolv.conf 
[dhclient.conf(5)]: http://linux.die.net/man/5/dhclient.conf
[dhcp-options(5)]: http://linux.die.net/man/5/dhcp-options
