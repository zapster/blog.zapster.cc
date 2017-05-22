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
