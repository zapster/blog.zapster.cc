---
layout: post
title: "Identifying DHCP clients"
date: 2013-04-30 09:43
comments: true
published: true
categories:
- dhclient
- dhcp
- RaspberryPi
- linux
---

Last Saturday I finally got my RaspberryPi (model B). Right from the beginning it was clear that I will be using
at least two operating system. One with OpenELEC as a *home entertainment system* (I don't really like this term).
The other one with Raspbian for development stuff. For both of them the
first act was to connect via SSH to see what is going on. Of course, they have assigned different hostnames as they
serve a completely different purpose.
While the first connection to `openelec` (by the way, [dns search suffix FTW!](/blog/2012/01/30/dns-search-suffix-and-dhclient/))
worked like expected, the following error message occurred when I tried to connect to `raspbian`:

```
Warning: the ECDSA host key for 'raspbian' differs from the key for the IP address '192.168.11.62'
Offending key for IP in /home/zapster/.ssh/known_hosts:57
Matching host key in /home/zapster/.ssh/known_hosts:59
Are you sure you want to continue connecting (yes/no)? yes
```

<!-- more -->

My SSH client is trying to warn me that something is strange, and she is damn right to do so. There IP address
(in my case `192.168.11.62`) is already associated with another host (i.e. `openelec`).
While this problem might be caused by other issues (e.g. [this one][superuser]), in my case the DHCP server should have
assigned different a IP to each host but the she can not differentiate them by MAC address. I was surprised (and relieved)
that the MAC address is not the first thing the server uses to assign leases to clients as this mailing list
post revealed ([dhcp-users][]). More important is the `dhcp-client-identifier` option ([dhcp-options(5)][]). So I can
use any string to tell the server which client tries to get an IP address.

With more recent versions of dhcp client things are even better. You can use the function `gethostname()` directly
in your [dhclient.conf(5)][]:

```
...
send dhcp-client-identifier = gethostname();
...
```

In this case every host gets its own IP independent of its current MAC address. This might be a problem if you
want to use more than one network interface at the same time but in this case you can set the identifier for
each interface individually. In a private network, e.g. with a notebook with a wireless and a wired interface,
the setting above would ensure that the computer always gets the same IP.

If you stuck with an older version of the dhcp client you have to hardcode the identifier. While there are
some workarounds [(use at your own risk!)](http://www.steubentech.com/~talon/blog/blosxom.cgi/2012/04/09)
a hostname is normally nothing that changes on a daily basis so fixing it is probably not too bad.


References:
-----------

* [dhcp-users][]: dhcp users mailing list
* [dhclient.conf(5)][]: manual page
* [dhcp-options(5)][]: manual page


[superuser]: http://superuser.com/questions/421004/how-to-fix-warning-about-ecdsa-host-key
[dhcp-users]: https://lists.isc.org/pipermail/dhcp-users/2012-March/015052.html
[identify-client-host]: http://www.justskins.com/forums/identify-dhcp-client-to-134421.html
[dhclient.conf(5)]: http://linux.die.net/man/5/dhclient.conf
[dhcp-options(5)]: http://linux.die.net/man/5/dhcp-options
