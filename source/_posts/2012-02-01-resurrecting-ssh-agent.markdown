---
layout: post
title: "resurrecting ssh-agent"
date: 2012-02-01 21:55
comments: true
published: true 
categories:
- linux
- ssh
---

There are many articles and blog entries out there about `ssh-agent` and what is
the best way of using it. The start script I am using is a slightly modified version
of the code proposed in this [Cygwin mailing list post](http://www.cygwin.com/ml/cygwin/2001-06/msg00537.html).

It fixes an issue that occurs if the home directory is shared among
different machines (e.g. nfs mount).

<!-- more -->
{% include_code lang:bash sshagentrc %}

