# i3blocks modules


## i3blocks example:

```
[disk]
command=~/repo/cytopia/i3blocks-modules/disk -tc 20 -tc 10
instance=/
interval=30

[backlight]
command=~/repo/cytopia/i3blocks-modules/backlight
instance=intel_backlight
interval=2

[date]
command=~/repo/cytopia/i3blocks-modules/date -f " {time}" -t "%a, %d.%m.%Y"
interval=60

[time]
command=~/repo/cytopia/i3blocks-modules/date -f " {time}" -t "%H:%M"
interval=5
```


## General module help

All modules are designed to work in the same way. The only difference is that some have thresholds and additional options. Keep a look at the `disk` example for an overview:

```
$ /disk -h
Usage: disk [-f <format>] [-d <disk>] [-tw <int>] [-tc <int>]
       disk -h
       disk -v

Optional variables:
  -d <disk>    Specify the disk being used. This can also be set via
               i3blocks 'instance=' value. If neither is set,
               it will default to '/'.

Optional threshold arguments:
  -tw <int>    Specify percent of free disk space for warning (0-100)
               Default is: 20
  -tc <int>    Specify percent of free disk space for critical (0-100)
               Default is: 10

Optional markup (pango):

  -np          Disable pango markup

Optional color arguments:

If not specified, script default colors are used
If config file with color codes is present in:
'/home/cytopia/.config/i3blocks/contrib.conf', these colors will be used.

  -cd <code>   Default color (hexadecimal color code)
               Default value is: #666666
  -cg <code>   Good color (hexadecimal color code)
               Default value is: #88b090
  -cw <code>   Warning color (hexadecimal color code)
               Default value is: #ccdc90
  -cc <code>   Critical color (hexadecimal color code)
               Default value is: #e89393
  -ci <code>   Info color (hexadecimal color code)
               Default value is: #fce94f

Optional Format placeholders:

  Available color placeholders:
  (Use with pango disabled for custom markup) building
     {color}        Current active color depending on thresholds
     {color_def}    Default color
     {color_good}   Good color
     {color_warn}   Warning color
     {color_crit}   Critical color
     {color_info}   Info color
  Format example:
     -np -f "<span color='{color}'>Colored text</span>"

  Available specific placeholders:
     {total}        Total space
     {used}         Used space
     {free}         Free space
     {pused}        Percentage of used space
     {pfree}        Percentage of free space
     {uunit}        Used sace unit
     {funit}        Free space unit
     {tunit}        Total space unit
  Format example:
     -f " {free} {funit} ({pfree}%)"
     -f " {used} {uunit} / {total} {tunit}"
  Default:
     -f " {free} {funit}iB"

```


## Colors

Every module can set each own set of colors for

* Default
* Good status
* Info status
* Warning status
* Critical status

You can use parameters to overwrite these colors on a per module base. You can however also set the colors for all modules via a configuration file:

`~/.config/i3blocks-modules/contrib.conf:`

```
# i3blocks contrib module configuration

# Set your default colors
color_def="#666666"
color_good="#88b090"
color_warn="#ccdc90"
color_crit="#e89393"
color_info="#FCE94F"
```

If the above file is present, those colors are used as the defaults.
