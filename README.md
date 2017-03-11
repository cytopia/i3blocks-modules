# i3blocks modules

High-quality, highly configurable [i3blocks](https://github.com/vivien/i3blocks/) modules.

1. Use of **placeholders** to configure your output
2. Custom **threshold** configuration
3. Unlimited **regex** comparison against all placeholder for threshold settings
3. Use of global or specific **colors** for all types of stati
4. Custom pango **markup** via color placeholders
5. All modules based on the same bash template for easy module building


## Modules

| module | placeholders | description |
|--------|--------------|-------------|
| backlight | {percent} | Show percentage of current screen brightness |
| bitcoin | {usd} {eur} | Show current bitcoin price (either from coindesk or btc-e |
| cputemp | {temp} | Show current cpu temperature |
| date | {time} | Show defined date/time string |
| disk | {total} {used} {free} {pused} {pfree} {uunit} {funit} {tunit} | Show space consumption of a disk |
| iface | {ip} {ip_nm} {ip6} {ip6_nm} {mac} {mtu} {iface} {status} {status_or_ip} {status_or_ip6} | Show status and various values of network interface |
| memory | {total} {used} {free} {pused} {pfree} {uunit} {funit} {tunit} | Show RAM memory consumption |
| online | {status} {status_or_ip} {ip} {country} {city} | Show online status with IP including your location |

## Threshold and stati

Depending on the status of a module (self-evaluated or custom threshold comparison), the output text will be shown in different colors. There are different ways to determine the final status:

1. **Self evaluation**: Some modules are able to evaluate their status independently. E.g.: `iface` will have a *good status* if it is up and has an IP assigned or it will have a *critical status* if it is down or absent. Depen
2. **Argument thresholds**: you can specify custom command line arguments with which you can compare the value of *placeholders* (less than, greater then or a regex comparison). This can be done for *good*, *info*, *warning* and *critical* states.
3. **Status precedence**: Even though the module is in *good state* it can still show up in a *critical state*. This is evaluated by the precedence. Precedence is evaluated in the following order (later ones always override previous ones):
  - good
  - info
  - warning
  - critical


## Threshold examples

Colorize date with 'good status' during weekends:
```
date -f " {time}" -t "%a, %d.%m.%Y" -tg '{time}' '=' '^(Sat|Sun).*'
```
Colorize time with warning state after 23 o'clock and between 0 and 3 with critical state:
```
date -f " {time}" -t "%H:%M" -tw '{time}' '=' '^23.*' -tc '{time}' '=' '^0(0|1|2|3).*'
```


## i3blocks example:

```
# output:  51°C
[cputemp]
command=~/.config/i3blocks-modules/modules/cputemp
instance=Core 0
interval=2

# output:  375 GiB / 435 GiB (10%)
[disk]
command=~/.config/i3blocks-modules/modules/disk -f " {free} {funit}iB / {total} {tunit}iB ({pused}%)" -tc 20 -tc 10
instance=/
interval=30

# output: ☼ 100%
[backlight]
command=~/.config/i3blocks-modules/modules/backlight
instance=intel_backlight
interval=2

# output:  Sun, 05.03.2017
[date]
command=~/.config/i3blocks-modules/modules/date -f " {time}" -t "%a, %d.%m.%Y"
interval=60

# output:  14:36
[time]
command=~/.config/i3blocks-modules/modules/date -f " {time}" -t "%H:%M"
interval=5
```


## General module help

All modules are designed to work in the same way. The only difference are their custom specific options `Optional variables`.

Have a look at the [doc/](doc/) folder for usage.

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
