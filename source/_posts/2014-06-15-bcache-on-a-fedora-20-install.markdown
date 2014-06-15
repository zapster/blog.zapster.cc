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

*** BEGIN QUOTE ***

Hello Fedora people.

bcache is cool. It's a recent (3.10) addition to the Linux kernel that allows you to use a ssd to cache reads and writes to/from your hdd in hopes of getting better I/O performance than you'd get from a hdd alone.

I have recently successfully setup bcache in my Fedora version 20 install. I am a brand new Fedora user here so bear with me. I'll try to describe how I did this here.

If your ssd is larger than 60GB, it probably only makes sense to use the first 64GB for your bcache, you'll likely not see any benefit to using a larger amount of ssd cache space and you can use the remaining ssd space for something more useful. Taking care of a larger ssd is done in step 4a below, if your ssd is 60GB or smaller, just skip step 4a.

# Disclaimer
You should assume that following this guide will leave you with only zeros in all of the drives attached to your machine. Also note that even if you get things set up properly here, you'll be in an inherantly precarious situation. Following this guide will have you running an experimental file system (btrfs) on an experimental caching system (bcache) which can be impacted by hardware errors on either one of two physical drives.

# Assumptions

-    Your machine is set up for BIOS type booting (not EFI, there are probably simple modifications you can make to get this to work under a EFI boot scenario, but I don't know them)
 -   `/dev/sda` is the rotating magnetic disk with nothing important on it you want to cache with a ssd
 -   `/dev/sdb` is your ssd with nothing important on it you intend to use as a cache for `/dev/sda`

# Do this
## Step #1: Boot from F20 live media.
## Step #2: Choose "Try Fedora" and open a terminal.
## Step #3: Install bcache tools and gparted.

    sudo yum install bcache-tools gparted

## Step #4: Repartition your HDD.

    sudo gparted

Then use gparted to:

- Create a new gpt partition table for `/dev/sda` (msdos works too but it's old and may cause problems later)
- Make a new partition: `/dev/sda1` cleared, 2MiB, bios_grub flag set (this is needed to boot with BIOS from gpt disks)
- Make a new partition: `/dev/sda2` ext4, 512MiB (this will be your /boot partition)
- Make a new partition: `/dev/sda3` swap
- Make a new partition: `/dev/sda4` cleared (this will be part of your bcache)

You should figure out the proper sizes for `/dev/sda3` and `/dev/sda4` yourself

## Step #5: Repartition your SSD.
Still using gparted:

- Create a new gpt partition table for `/dev/sdb` (msdos works too but it's old and may cause problems later)
- Make a new partition: `/dev/sdb1` cleared (this will be part of your bcache)

I recommend that if your ssd is larger than 64 GB you make `/dev/sdb1` only 64 GB in size (making it bigger is probably a waste). You can use the rest of your ssd for someting else more useful.

## Step #5.1: Remove any existing file systems on the targets.
In case you're not following this guide exactly and you have junk left over in your target partitions from something else, clean them up like this. You shouldn't need to do this if you just made them "unformatted" as described in steps 4 and 5 above

    sudo wipefs -f -a /dev/sda4
    sudo wipefs -f -a /dev/sdb

## Step #6: Create your bcache.

    sudo make-bcache --wipe-bcache -w512 --discard --writeback -B /dev/sda4 -C /dev/sdb

Your hybrid hdd/ssd bcache will now appear as `/dev/bcache0`, we'll install Fedora there later.
## Step #7: Put a file system in your bcache.

    sudo mkfs.btrfs /dev/bcache0

Here I use btrfs because it's new and shiny and I like shiny new things. You can use whatever filesystem you'd like to (ext4 is the more conservative choice here, but if you're following this guide you're not very conservative, are you?). The rest of the guide assumes you chose btrfs.

## Step #8: Start the Fedora installer
## Step #9: Click some things in the installer

- Click the "Installation Destination" button
    select bcache0 and sda (black check marks)
- Click "Full disk summary and bootloader..." in the lower left hand corner
    Make sure your hdd (NOT YOUR SSD) has a green check mark indicating that grub will be installed there
- Click the Done button (upper left corner)
    Choose BTRFS from the Partition scheme dropdown
    Select I want to review/modify my disk partitions before continuing.
- Click the Continue button
    Expand Unknown
- Click the sda2 partition, set Mount point as /boot, check Reformat, Click Update Settings button
- Click the swap partition, check Reformat, Click Update Settings button
- Click the sda1 partition, check Reformat, Click Update Settings button
- Click the Plus (+) button in the lower left, select "/" for Mount Point:, click Add mount point button, Choose btrfs... in the Volume: dropdown menu, Click Update Settings button
- Click the Plus (+) button in the lower left, select "/home" for Mount Point:, click Add mount point button, Choose Btrfs 1.1 in the Volume: dropdown menu, check Reformat, Click Update Settings button
- Click the Done button (upper left corner)
- Click the Accept Changes button

## Step #11: Finish the install as you would normally.
## Step #12: Chroot into your new install.
Once the install has completed,

    sudo chroot /mnt/sysimage

## Step #13: install bcache-tools

    yum install bcache-tools

This puts bcache-tools into your new install.
## Step #14: Rebuild initramfs.

    yum update kernel

or

    dracut -f

This will update the kernel which will trigger a regeneration of your initramfs which will now pull in the proper udev rules (since we've installed bcache-tools) to allow your system to boot properly going forward.
## Step #15: Reboot into your new bcached system.

That's it, just 15 easy steps!

You should now have a fully functioning system. All of this should be one-time and you should never have to do any of this again for this install.

Note you can get various performance stats on your bcache like this

    bcache-status

Thanks to emesix for the great chroot idea.

Good luck!

*** END QUOTE ***
