---
layout: post
title: "Install Fedora 20 on a bcache device"
date: 2014-06-15 13:45
comments: true
published: false
categories: 
- bcache
- Fedora 20
- solid state disc
- linux
- Dell XSP 15 9530
---

[Fedora forum](http://forums.fedoraforum.org) user [l3iggs](http://forums.fedoraforum.org/member.php?u=204744)
posted a very interesting description entitled [HowTo: use bcache on a fresh F20 install](http://forums.fedoraforum.org/showpost.php?p=1681469&postcount=1)
on installing Fedora 20 directly on a bcache device.

I want keep this copy around together with some personal notes. All kudos to the original author!

{% raw %}
<blockquote>
{% endraw %}
<p>Hello Fedora people.</p>

<p>bcache is cool. It&#8217;s a recent (3.10) addition to the Linux kernel that allows you to use a ssd to cache reads and writes to/from your hdd in hopes of getting better I/O performance than you&#8217;d get from a hdd alone.</p>

<p>I have recently successfully setup bcache in my Fedora version 20 install. I am a brand new Fedora user here so bear with me. I&#8217;ll try to describe how I did this here.</p>

<p>If your ssd is larger than 60GB, it probably only makes sense to use the first 64GB for your bcache, you&#8217;ll likely not see any benefit to using a larger amount of ssd cache space and you can use the remaining ssd space for something more useful. Taking care of a larger ssd is done in step 4a below, if your ssd is 60GB or smaller, just skip step 4a.</p>

<h1>Disclaimer</h1>

<p>You should assume that following this guide will leave you with only zeros in all of the drives attached to your machine. Also note that even if you get things set up properly here, you&#8217;ll be in an inherantly precarious situation. Following this guide will have you running an experimental file system (btrfs) on an experimental caching system (bcache) which can be impacted by hardware errors on either one of two physical drives.</p>

<h1>Assumptions</h1>

<ul>
<li> Your machine is set up for BIOS type booting (not EFI, there are probably simple modifications you can make to get this to work under a EFI boot scenario, but I don&#8217;t know them)</li>
<li> <code>/dev/sda</code> is the rotating magnetic disk with nothing important on it you want to cache with a ssd</li>
<li> <code>/dev/sdb</code> is your ssd with nothing important on it you intend to use as a cache for <code>/dev/sda</code></li>
</ul>


<h1>Do this</h1>

<h2>Step #1: Boot from F20 live media.</h2>

<h2>Step #2: Choose &#8220;Try Fedora&#8221; and open a terminal.</h2>

<h2>Step #3: Install bcache tools and gparted.</h2>

<pre><code>sudo yum install bcache-tools gparted
</code></pre>

<h2>Step #4: Repartition your HDD.</h2>

<pre><code>sudo gparted
</code></pre>

<p>Then use gparted to:</p>

<ul>
<li>Create a new gpt partition table for <code>/dev/sda</code> (msdos works too but it&#8217;s old and may cause problems later)</li>
<li>Make a new partition: <code>/dev/sda1</code> cleared, 2MiB, bios_grub flag set (this is needed to boot with BIOS from gpt disks)</li>
<li>Make a new partition: <code>/dev/sda2</code> ext4, 512MiB (this will be your /boot partition)</li>
<li>Make a new partition: <code>/dev/sda3</code> swap</li>
<li>Make a new partition: <code>/dev/sda4</code> cleared (this will be part of your bcache)</li>
</ul>


<p>You should figure out the proper sizes for <code>/dev/sda3</code> and <code>/dev/sda4</code> yourself</p>

<h2>Step #5: Repartition your SSD.</h2>

<p>Still using gparted:</p>

<ul>
<li>Create a new gpt partition table for <code>/dev/sdb</code> (msdos works too but it&#8217;s old and may cause problems later)</li>
<li>Make a new partition: <code>/dev/sdb1</code> cleared (this will be part of your bcache)</li>
</ul>


<p>I recommend that if your ssd is larger than 64 GB you make <code>/dev/sdb1</code> only 64 GB in size (making it bigger is probably a waste). You can use the rest of your ssd for someting else more useful.</p>

<h2>Step #5.1: Remove any existing file systems on the targets.</h2>

<p>In case you&#8217;re not following this guide exactly and you have junk left over in your target partitions from something else, clean them up like this. You shouldn&#8217;t need to do this if you just made them &#8220;unformatted&#8221; as described in steps 4 and 5 above</p>

<pre><code>sudo wipefs -f -a /dev/sda4
sudo wipefs -f -a /dev/sdb
</code></pre>

<h2>Step #6: Create your bcache.</h2>

<pre><code>sudo make-bcache --wipe-bcache -w512 --discard --writeback -B /dev/sda4 -C /dev/sdb
</code></pre>

<p>Your hybrid hdd/ssd bcache will now appear as <code>/dev/bcache0</code>, we&#8217;ll install Fedora there later.</p>

<h2>Step #7: Put a file system in your bcache.</h2>

<pre><code>sudo mkfs.btrfs /dev/bcache0
</code></pre>

<p>Here I use btrfs because it&#8217;s new and shiny and I like shiny new things. You can use whatever filesystem you&#8217;d like to (ext4 is the more conservative choice here, but if you&#8217;re following this guide you&#8217;re not very conservative, are you?). The rest of the guide assumes you chose btrfs.</p>

<h2>Step #8: Start the Fedora installer</h2>

<h2>Step #9: Click some things in the installer</h2>

<ul>
<li>Click the &#8220;Installation Destination&#8221; button
  select bcache0 and sda (black check marks)</li>
<li>Click &#8220;Full disk summary and bootloader&#8230;&#8221; in the lower left hand corner
  Make sure your hdd (NOT YOUR SSD) has a green check mark indicating that grub will be installed there</li>
<li>Click the Done button (upper left corner)
  Choose BTRFS from the Partition scheme dropdown
  Select I want to review/modify my disk partitions before continuing.</li>
<li>Click the Continue button
  Expand Unknown</li>
<li>Click the sda2 partition, set Mount point as /boot, check Reformat, Click Update Settings button</li>
<li>Click the swap partition, check Reformat, Click Update Settings button</li>
<li>Click the sda1 partition, check Reformat, Click Update Settings button</li>
<li>Click the Plus (+) button in the lower left, select &#8220;/&#8221; for Mount Point:, click Add mount point button, Choose btrfs&#8230; in the Volume: dropdown menu, Click Update Settings button</li>
<li>Click the Plus (+) button in the lower left, select &#8220;/home&#8221; for Mount Point:, click Add mount point button, Choose Btrfs 1.1 in the Volume: dropdown menu, check Reformat, Click Update Settings button</li>
<li>Click the Done button (upper left corner)</li>
<li>Click the Accept Changes button</li>
</ul>


<h2>Step #11: Finish the install as you would normally.</h2>

<h2>Step #12: Chroot into your new install.</h2>

<p>Once the install has completed,</p>

<pre><code>sudo chroot /mnt/sysimage
</code></pre>

<h2>Step #13: install bcache-tools</h2>

<pre><code>yum install bcache-tools
</code></pre>

<p>This puts bcache-tools into your new install.</p>

<h2>Step #14: Rebuild initramfs.</h2>

<pre><code>yum update kernel
</code></pre>

<p>or</p>

<pre><code>dracut -f
</code></pre>

<p>This will update the kernel which will trigger a regeneration of your initramfs which will now pull in the proper udev rules (since we&#8217;ve installed bcache-tools) to allow your system to boot properly going forward.</p>

<h2>Step #15: Reboot into your new bcached system.</h2>

<p>That&#8217;s it, just 15 easy steps!</p>

<p>You should now have a fully functioning system. All of this should be one-time and you should never have to do any of this again for this install.</p>

<p>Note you can get various performance stats on your bcache like this</p>

<pre><code>bcache-status
</code></pre>

<p>Thanks to emesix for the great chroot idea.</p>

<p>Good luck!</p>
<footer><strong>l3iggs</strong> <cite><a href='http://forums.fedoraforum.org/showpost.php?p=1681469&postcount=1'>HowTo: Use Bcache on a Fresh F20 Install</a></cite></footer>
{% raw %}
</blockquote>
{% endraw %}
