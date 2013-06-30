---
layout: post
title: "Restore commit dates lost by Mercurial MQ extension"
date: 2013-06-30 13:27
comments: true
published: true
categories:
- mercurial
- bash
- linux
---

tl;dr
-----

The Mercurial [MQ extension][mq] does not store the creation date of a patch by default.
This behavior can be changed but what about existing patches? If the patch queue
is under version control it might be possible to restore at least some information.

<!-- more -->

Intro
-----

In course of working on the [CACAO VM](http://www.cacaojvm.org) I was forced to
use mercurial for the first time. Being a self-confessed git enthusiast it was
hard to give away most of the power over the history. After messing up the
repository meta data several times using extensions like [rebase] and [histedit]
I finally gave the [MQ Extension][mq] a try.

Issue
-----

I really like(d) the fact that its all about plain patches with only minimal meta data.
Unfortunately the creation date is also excluded by default. This can be changed by
adding the command line flag `-D/--currentdate` to the `hg qnew` and `hg qrecord`
commands (or even create an alias). There is still another problem with `qrefresh`
as it refreshes not only the patch but the also the date.
[This FAQ entry](http://mercurial.selenic.com/wiki/MqExtension#Prevent_qrefresh_from_updating_timestamps)
on the MQ Extension page provides a solution to the issue.

But it those not bring back date information for old patches. In my case a
few months and ~230 patches worth of date information.

Solution
--------

Fortunately not everything was lost. I put my patches under version control right from
the beginning (the `hg commit -mq` command makes it really convenient.).
I to commit my changes at least once a day. Therefor, the creation date of each
patch file is stored in the queue repository. The `hg log` command together with
some [revset magic][revsets] reveals the information:

```
hg log -r "sort(all(),date)" --template "{date|date}\n" patch_file

Sat Jun 08 14:57:22 2013 +0200
Wed Jun 26 11:51:34 2013 +0200
```

It returns the modification dates in chronological ascending order.

To get the date format desired for the patch meta data the
[template filter](http://hgbook.red-bean.com/read/customizing-the-output-of-mercurial.html#sec:template:filter)
`hgdate` can be used:

```
hg log -r "sort(all(),date)" --template "{date|hgdate}\n" patch_file

1370696242 -7200
1372240294 -7200
```

Remark: for some strange reason the `min()`, `limit()`, etc. [revsets][] functions did not work,
so I use good old [head(1)][] to select the first result.

The following script is intended to be run inside the patch directory (e.g. `.hg/patch/`).
It `grep`s for all patches without a `# Date `, fetches the creation time from the patch
repository and insert it into the patch file.

Please always do a `hg commit --mq` and `hg push --mq` to backup you patches before
touching anything.

{% include_code lang:bash fix-patch-dates.sh %}

Known Problems
--------------

The date is always inserted on the 3rd line. This might be a problem in some scenarios.
If the commit frequency in the patch repository low, you don't get much useful data.
Renamed and folded patches do not work.

Disclaimer
----------

As always, this information is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY. Kittens may die if you don't read the manual and know what
you are doing.

Retrospective
-------------

It seems that the [MQ Extension][mq] does not really fit my needs after all. The
mercurial community has its own way of dealing with _safe_ history editing, called
[ChangesetEvolution](http://mercurial.selenic.com/wiki/ChangesetEvolution) which
centers around [phases][], [histedit][], [evolve][], [rebase][] and other extensions.
This is probably the right way of doing history editing things with mercurial.

References
----------

* [rebase][]: Mercurial Rebase Extension
* [histedit][]: Mercurial Histedt Extension
* [mq][]: Mercurial MQ Extension
* [revsets]: RevSets
* [evolve]: Evolve Extension
* [phases]: Mercurial Phases

[rebase]: http://mercurial.selenic.com/wiki/RebaseExtension
[histedit]: http://mercurial.selenic.com/wiki/HisteditExtension
[mq]: http://mercurial.selenic.com/wiki/MqExtension
[revsets]: http://www.selenic.com/hg/help/revsets
[evolve]: http://mercurial.selenic.com/wiki/EvolveExtension
[phases]: http://mercurial.selenic.com/wiki/Phases
[head(1)]: http://linux.die.net/man/1/head
