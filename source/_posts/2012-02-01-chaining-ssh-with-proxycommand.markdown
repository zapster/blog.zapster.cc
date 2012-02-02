---
layout: post
title: "chaining ssh connects with ProxyCommand"
date: 2012-02-01 16:25
comments: true
published: false
categories:
- git
- linux
- ssh
---


```
Host hidden.example.com
  ProxyCommand ssh -q public.example.com nc -q0 %h %p
```

I use ssh public key authentication with ssh-agent.

The nice thing is that this also works with scp, git and friends. E.g.:

```
git clone hidden.example.com:~/repo.git
```

Unfortunately this does not work with dns search suffixes so additional 
entries might be needed.

```
Host hidden
  ProxyCommand ssh -q public nc -q0 %h %p
```

References:
-----------

* [sshmenu][]: Transparent Multi-hop SSH &rarr; Soureforge page of the sshmenu project
* [ssh_config(5)][]: manual page

[sshmenu]:http://sshmenu.sourceforge.net/articles/transparent-mulithop.html
[ssh_config(5)]: http://linux.die.net/man/5/ssh_config
