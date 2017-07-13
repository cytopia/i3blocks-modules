# i3blocks modules

High-quality, highly configurable [i3blocks](https://github.com/vivien/i3blocks/) modules.

1. Use of **placeholders** to configure your output (`-f`)
2. **Conditional output format** based on placeholder comparison (`-fe`)
3. **Threshold** settings by checking against placeholders (`-tg|-ti|-tw|-tc`)
4. **Arithmetic** and **regex** comparison against all placeholder for threshold settings (`<`, `>`, `=`, `!=`)
5. Use of global or specific **colors** for all types of stati
6. Custom pango **markup** via color placeholders (`-np`)

---

**This repository is part of the [i3-utils](https://github.com/cytopia/i3-utils).**

---

## Available Modules

| Module | Placeholders | Description |
|--------|--------------|-------------|
| **[backlight](modules/backlight)** | {percent} | Show percentage of current screen brightness |
| **[battery](modules/battery)** | {time} {percent} {status} {capacity} {ucapacity} | Show battery information |
| **[bitcoin](modules/bitcoin)** | {usd} {eur} | Show current bitcoin price (either from coindesk or btc-e) |
| **[cpu](modules/cpu)** | {speed} {uspeed} {percent} {usage5} {usage10} {usage15} | Show current cpu statistics |
| **[cputemp](modules/cputemp)** | {temp} | Show current cpu temperature |
| **[date](modules/date)** | {time} | Show defined date/time string |
| **[disk](modules/disk)** | {total} {used} {free} {pused} {pfree} {uunit} {funit} {tunit} | Show space consumption of a disk |
| **[ethereum](modules/ethereum)** | {usd} {eur} | Show current Ethereum price (from btc-e) |
| **[gateway](modules/gateway)** | {iface} {ip} {ip_gw} {metric} {num_def_routes} | Show information about default gateways and routes |
| **[iface](modules/iface)** | {ip} {ip_nm} {ip6} {ip6_nm} {mac} {mtu} {iface} {status} {status_or_ip} {status_or_ip6} | Show status and various values of network interface |
| **[memory](modules/memory)** | {total} {used} {free} {pused} {pfree} {uunit} {funit} {tunit} | Show RAM memory consumption |
| **[online](modules/online)** | {status} {status_or_ip} {ip} {country} {city} | Show online status with IP including your location |
| **[volume](modules/volume)** | {volume} {muted} {port} {dev_api} {dev_bus} {dev_form_factor} {dev_profile} {dev_icon_name} {dev_description} {alsa_name} {alsa_card} {alsa_driver} {alsa_mixer} {icon} | Show info about current volume (auto-changes when headphone or usb/bluetooth is connected) |
| **[wifi](modules/wifi)** | {ip} {ip_nm} {ip6} {ip6_nm} {mac} {mtu} {iface} {status} {status_or_ip} {status_or_ip6} {ssid} {freq} {freq_unit} {tx_power} {tx_power_unit} {quality} {signal} {signal_unit} {noise} | Show info about your wireless connection |

1. All placeholders can be used in the format argument to format your output.<br/> (e.g.: `-f 'Signal: {percent}%'`)
2. All placeholders can be checked and according to their value the output will differ<br/>(e.g.: `-fe '{status}' '=' 'up' '{iface} {ip} ({ssid} {signal}%)'`)
3. All placeholders can be used to determine the status and thus affect the final output color.<br/>(e.g.: `-tc '{percent}' '<' 50` or `-tc '{date}' '=' '^(Sat|Sun)*'`)


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

```shell
$ wifi -f 'WIFI: {ip} {ssid} ({signal}%)'
```

Sometime however, you want the output to be dynamic in case the module reports a different state and the placeholders will not have any values. In the above case, if the wifi is not connected or not present, the output would be `WIFI:  (%)`

**Extended conditional output format**

For this to overcome, you can evaluate *placeholders* that a module provides and decide upon their value what output format you want to have:

```shell
$ wifi -fe '{status}' '=' 'up' '{iface} {ip} ({ssid})' -fe '{status}' '!=' 'up' 'WIFI: down'
```
In the above example you will have different outputs based on whether the Wifi interface is up or not up.


## Threshold examples

Colorize date with 'good status' during weekends:
```shell
date -f " {time}" -t "%a, %d.%m.%Y" -tg '{time}' '=' '^(Sat|Sun).*'
```
Colorize time with warning state after 23 o'clock and between 0 and 3 with critical state:
```shell
date -f " {time}" -t "%H:%M" -tw '{time}' '=' '^23.*' -tc '{time}' '=' '^0(0|1|2|3).*'
```


## i3blocks example:

```shell
# output:  51°C
# shows 'goog color' at temperatures below 71 degrees
# shows 'warn color' at temperatures above 70 degrees
# shows 'crit color' at temperatures above 90 degrees
[cputemp]
command=~/.config/i3blocks-modules/modules/cputemp -tg '{temp}' '<' 71 -tw '{temp}' '>' 70 -tc '{temp}' '>' 90
instance=Core 0
interval=2

# output discharging:   31% (01:50)
# output charging:     ⚡ 31% (00:23)
# output full:          100% (08:32)
# output full with ac: ⚡ 100%
# shows 'good color' when fully charged
# shows 'warn color' when remaining percentage is below 30%
# shows 'crit color' when remaining percentage is below 10%
# shows different icons depending on remaining percent
# shows different icon for charging and discharging
[battery]
command=~/.config/i3blocks-modules/modules/battery -fe '{percent}' '<' 90 ' {percent}% ({time})' -fe '{percent}' '<' 75 ' {percent}% ({time})' -fe '{percent}' '<' 60 ' {percent}% ({time})' -fe '{percent}' '<' 35 ' {percent}% ({time})' -fe '{percent}' '<' 5 ' {percent}% ({time})' -fe '{status}' '=' '^charging' '⚡ {percent}% ({time})' -fe '{status}' '=' 'full' ' {percent}%' -tg '{status}' '=' 'full' -tg '{percent}' '=' 100 -ti '{status}' '=' '^charging' -tw '{percent}' '<' 30 -tc '{percent}' '<' 5
instance=Battery 0
interval=1

# output:  375 GiB / 435 GiB (10%)
# show 'warn color' when disk space is less than 20%
# show 'crit color' when disk space is less than 10%
[disk]
command=~/.config/i3blocks-modules/modules/disk -f " {free} {funit}iB / {total} {tunit}iB ({pused}%)" -tc '{pfree}' '<' 20 -tc '{pfree}' '<' 10
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

```shell
# i3blocks contrib module configuration

# Set your default colors
color_def="#666666"
color_good="#88b090"
color_warn="#ccdc90"
color_crit="#e89393"
color_info="#FCE94F"
```

If the above file is present, those colors are used as the defaults.
