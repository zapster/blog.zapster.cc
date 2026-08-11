---
layout: post
title: "UK keyboard layout with German umlauts"
date: 2015-01-20 09:41
comments: true
published: true
categories:
- linux
- X11
- XKB
---
> **Update (2024):** I now use `altgr-weur`, which is shipped with most Linux distributions. I have also switched to the US keyboard layout, mainly because US keyboards are more widely available.
<!-- more -->

Add to `/usr/share/X11/xkb/symbols/gb`:

{% include_code lang:bash gb_umlaut %}

Add to `/usr/share/X11/xkb/rules/evdev.xml`:

``` xml evdev.xml
     ...
     <configItem>
       <name>gb</name>

        <shortDescription>en</shortDescription>
        <description>English (UK)</description>
        <languageList>
          <iso639Id>eng</iso639Id>
        </languageList>
      </configItem>
      <variantList>

<!--- new content -->
        <variant>
          <configItem>
            <name>umlaut</name>
            <description>English (UK, with German umlauts)</description>
          </configItem>
        </variant>
<!--- end new content -->

        <variant>
          ...
```
