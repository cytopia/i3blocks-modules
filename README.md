# i3blocks modules

High-quality, highly configurable [i3blocks](https://github.com/vivien/i3blocks/) modules.

1. Use of **placeholders** to configure your output (`-f`)
2. **Conditional output format** based on any placeholder value (`-fe`)
3. Custom **threshold** configuration (`-tg|-ti|-tw|-tc`)
4. Unlimited **greater than**, **less than**, **regex** or **not equals** comparison against all placeholder for threshold settings (`<`, `>`, `=`, `!=`)
5. Use of global or specific **colors** for all types of stati
6. Custom pango **markup** via color placeholders (`-np`)
7. All modules based on the same bash template for easy module building


## Available Modules

1. All placeholders can be used in the format argument (e.g.: `-f 'Signal: {percent}%'`) to format your output.
2. All placeholders can be checked and according to their value the output will differ (e.g.: `-fe '{status}' '=' 'up' '{iface} {ip} ({ssid} {signal}%)'`)
3. All placeholders can be used to determine the status (e.g.: `-tc '{percent}' '<' 50` or `-tc '{date}' '=' '^(Sat|Sun)*'` and thus affect the final output color..

| Module | Placeholders | Description |
|--------|--------------|-------------|
| **[backlight](modules/backlight)** | {percent} | Show percentage of current screen brightness |
| **[bitcoin](modules/bitcoin)** | {usd} {eur} | Show current bitcoin price (either from coindesk or btc-e |
| **[cputemp](modules/cputemp)** | {temp} | Show current cpu temperature |
| **[date](modules/date)** | {time} | Show defined date/time string |
| **[disk](modules/disk)** | {total} {used} {free} {pused} {pfree} {uunit} {funit} {tunit} | Show space consumption of a disk |
| **[iface](modules/iface)** | {ip} {ip_nm} {ip6} {ip6_nm} {mac} {mtu} {iface} {status} {status_or_ip} {status_or_ip6} | Show status and various values of network interface |
| **[memory](modules/memory)** | {total} {used} {free} {pused} {pfree} {uunit} {funit} {tunit} | Show RAM memory consumption |
| **[online](modules/online)** | {status} {status_or_ip} {ip} {country} {city} | Show online status with IP including your location |
| **[wifi](modules/wifi)** | {ip} {ip_nm} {ip6} {ip6_nm} {mac} {mtu} {iface} {status} {status_or_ip} {status_or_ip6} {ssid} {freq} {freq_unit} {tx_power} {tx_power_unit} {quality} {signal} {signal_unit} {noise} | Show info about your wireless connection |


Additionally each module has color placeholders in case you want to create your own markup output (see `-np`):
* {color}
* {color_def}
* {color_good}
* {color_warn}
* {color_crit}
* {color_info}



## Threshold and stati

Depending on the status of a module (self-evaluated or custom threshold comparison), the output text will be shown in different colors. There are different ways to determine the final status:

1. **Self evaluation**: Some modules are able to evaluate their status independently. E.g.: `iface` will have a *good status* if it is up and has an IP assigned or it will have a *critical status* if it is down or absent.
2. **Argument thresholds**: You can specify custom command line arguments with which you can compare the value of *placeholders* (less than, greater then or a regex comparison). This can be done for *good*, *info*, *warning* and *critical* states.
3. **Status precedence**: Even though the module is in *good state* it can still show up in a *critical state*. This is evaluated by the precedence. Precedence is evaluated in the following order (later ones always override previous ones):
  - good
  - info
  - warning
  - critical

## Placeholder format examples

There are two types of placeholders:

1. Static output format
2. Extended conditional output format

**Static output format**

Use placeholders to specify how the module should output the provided information:

```
$ wifi -f 'WIFI: {ip} {ssid} ({signal}%)'
```

Sometime however, you want the output to be dynamic in case the module reports a different state and the placeholders will not have any values. In the above case, if the wifi is not connected or not present, the output would be `WIFI:  (%)`

**Extended conditional output format**

For this to overcome, you can evaluate *placeholders* that a module provides and decide upon their value what output format you want to have:

```
$ wifi -fe '{status}' '=' 'up' '{iface} {ip} ({ssid})' -fe '{status}' '!=' 'up' 'WIFI: down'
```
In the above example you will have different outputs based on whether the Wifi interface is up or not up.


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
