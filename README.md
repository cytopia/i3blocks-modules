# i3blocks modules

---

**This repository is part of the [i3-utils](https://github.com/cytopia/i3-utils).**

---

**[Install](#tada-install)** |
**[Uninstall](#no_entry_sign-uninstall)** |
**[Modules](#star-available-modules)** |
**[Documentation](#information_source-documentation)** |
**[Examples](#bulb-examples)** |
**[Configuration](#wrench-configuration-file)** |
**[Usage](#computer-general-module-usage)** |
**[License](#page_facing_up-license)**

[![Build Status](https://travis-ci.com/cytopia/i3blocks-modules.svg?branch=master)](https://travis-ci.com/cytopia/i3blocks-modules)
![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/cytopia/i3blocks-modules)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

High-quality, highly configurable [i3blocks](https://github.com/vivien/i3blocks/) modules.

1. Use of **placeholders** to configure your output (`-f`)
2. **Conditional output format** based on placeholder comparison (`-fe`)
3. **Threshold** settings by checking against placeholders (`-tg|-ti|-tw|-tc`)
4. **Arithmetic** and **regex** comparison against all placeholder for threshold settings (`<`, `>`, `=`, `!=`)
5. Use of global or specific **colors** for all types of stati
6. Custom pango **markup** via color placeholders (`-np`)




## :tada: Install

```bash
make install
```



## :no_entry_sign: Uninstall
```bash
make uninstall
```



## :star: Available Modules

| Module | Placeholders | Description |
|--------|--------------|-------------|
| **[backlight](modules/backlight)** | {percent} | Show percentage of current screen brightness |
| **[battery](modules/battery)** | {time} {percent} {status} {capacity} {ucapacity} | Show battery information |
| **[bitcoin](modules/bitcoin)** | {usd} {eur} | Show current bitcoin price (either from coindesk or btc-e) |
| **[cpu](modules/cpu)** | {speed} {uspeed} {percent} {usage5} {usage10} {usage15} | Show current cpu statistics |
| **[cputemp](modules/cputemp)** | {temp} | Show current cpu temperature |
| **[date](modules/date)** | {time} | Show defined date/time string |
| **[disk](modules/disk)** | {total} {used} {free} {pused} {pfree} {uunit} {funit} {tunit} | Show space consumption of a disk |
| **[ethereum](modules/ethereum)** | {usd} {eur} | Show current Ethereum price (from ethereumprice) |
| **[gateway](modules/gateway)** | {iface} {ip} {ip_gw} {metric} {num_def_routes} | Show information about default gateways and routes |
| **[iface](modules/iface)** | {ip} {ip_nm} {ip6} {ip6_nm} {mac} {mtu} {iface} {status} {status_or_ip} {status_or_ip6} | Show status and various values of network interface |
| **[memory](modules/memory)** | {total} {used} {free} {pused} {pfree} {uunit} {funit} {tunit} | Show RAM memory consumption |
| **[online](modules/online)** | {status} {status_or_ip} {ip} {country} {city} | Show online status with IP including your location |
| **[stock](modules/stock)** | {usd} | Show current stock prices (by share) |
| **[volume](modules/volume)** | {volume} {muted} {port} {dev_api} {dev_bus} {dev_form_factor} {dev_profile} {dev_icon_name} {dev_description} {alsa_name} {alsa_card} {alsa_driver} {alsa_mixer} {icon} | Show info about current volume (auto-changes when headphone or usb/bluetooth is connected) |
| **[weather](modules/weather)** | {celsius} {fahrenheit} {wind_speed_kmh} {wind_speed_mph} {icon_weather} {icon_wind_speed} {icon_wind_direction} | Show current temperature (by city) |
| **[wifi](modules/wifi)** | {ip} {ip_nm} {ip6} {ip6_nm} {mac} {mtu} {iface} {status} {status_or_ip} {status_or_ip6} {ssid} {freq} {freq_unit} {tx_power} {tx_power_unit} {quality} {signal} {signal_unit} {noise} {bit_rate_} {bit_rate_unit} | Show info about your wireless connection |



## :information_source: Documentation

### Install paths

When using the provided Makefile to install i3blocks-modules, it will do so into the following locations:

| What                         | Install location                   |
|------------------------------|------------------------------------|
| i3blocks-modules config file | `~/.config/i3blocks-modules/conf`  |
| i3blocks-modules modules     | `~/.local/share/i3blocks-modules/` |


### Format string

When defining a module in the configuration file, you can either go with default settings or specify a custom **format string** (`-f '...'`) which can contain text, unicode icons or dynamic placeholder variables. This allows for full customization of each module.

Additionally to a **fixed format string**, you can also define as many **conditional format strings** as required for your ouput. *Conditional format strings* are based on the values of placeholders returned by each module. So when the `date` module for example returns any date between Saturday and Sunday, you could simply make it display `Weekend`. Or when the `iface` module returns that nothing is connected, you could simply hide all output completely. Another useful example would be the `battery` module which could display different icons depending on wether it is currently charging or discharging.


### Placeholders

Placeholders are **dynamic variables** (the names in curly braces) that can be placed anywhere in your fixed or conditional **format string** for each of your defined modules to make the look&feel of each module according to your needs.
Each module comes with their own set of placeholders giving you various ways for customization. (See Available modules for placeholders).

Additionally to specific placeholder, each module also has color placeholders in case you want to create your own colorized markup output (see `-np`):
* {color}
* {color_def}
* {color_good}
* {color_warn}
* {color_crit}
* {color_info}

To sum it up briefly, placeholders have three use-cases:

1. Placeholders can be used in the format argument to format your output.<br/> (e.g.: `-f 'Signal: {percent}%'`)
2. Placeholders can be checked and according to their value the output will differ<br/>(e.g.: `-fe '{status}' '=' 'up' '{iface} {ip} ({ssid} {signal}%)'`)
3. Placeholders can be used to determine the status and thus affect the final output color.<br/>(e.g.: `-tc '{percent}' '<' 50` or `-tc '{date}' '=' '^(Sat|Sun)*'`)


### Threshold and stati

Depending on the status of a module (self-evaluated or custom threshold comparison), the output text will be shown in different colors. There are different ways to determine the final status:

1. **Self evaluation**: Some modules are able to evaluate their status independently. E.g.: `iface` will have a *good status* if it is up and has an IP assigned or it will have a *critical status* if it is down or absent.
2. **Argument thresholds**: You can specify custom command line arguments with which you can compare the value of *placeholders* (less than, greater then or a regex comparison). This can be done for *good*, *info*, *warning* and *critical* states.
3. **Status precedence**: Even though the module is in *good state* it can still show up in a *critical state*. This is evaluated by the precedence. Precedence is evaluated in the following order (later ones always override previous ones):
  - good
  - info
  - warning
  - critical


### Status colors

Every module can set its own set of colors for available stati

* Default
* Good status
* Info status
* Warning status
* Critical status

Stati can be set via the following module arguments:

```
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
```

Instead of setting the color on each module separately, you can also use the `i3blocks-modules` configuration file to set it globally in `~/.config/i3blocks-modules/config`.



## :bulb: Examples

The following examples show command line calls of the modules (each module is simply a bash script that you can execute on the command line) as well as their corresponding configuration settings. In order to get the desired output on the command line, you will need to set the `BLOCK_INSTANCE` variable to a meaningful value. This variable corresponds to the `instance` setting of each module in the configuration file.


### Set *format string*

Use placeholders to specify how the module should output the provided information:

`command line`:
```bash
# Note: set BLOCK_INSTANCE to your wifi interface
$ BLOCK_INSTANCE=wlp3s0 ~/.local/share/i3blocks-modules/wifi -f 'WIFI: {ip} {ssid} ({signal}%)'
```

`~/.config/i3blocks/config`:
```ini
# Note: Set instance to your wifi interface
# Note: interval specifies how often the module should be updated (in seconds)
#       So in this example, it will be updated every 2 seconds.
[wifi]
command=~/.local/share/i3blocks-modules/wifi -f 'WIFI: {ip} {ssid} ({signal}%)'
instance=wlp3s0
interval=2
```


### Set *conditional format string*

Imagine you want the output to be dynamic in case the module reports a different state and/or the placeholders will not have any values. In the above case, if your wifi interface is not connected or not present, the module would output something like this: `WIFI:  (%)`.

So in order to still give a meaningful output for this case, you will need to set a conditional format.

The following example will output your wifi information if it is available, but if the `{status}` does not equal `up`, the it changes the format to `WIFI: down`

`command line`:
```bash
# Note: set BLOCK_INSTANCE to your wifi interface
$ BLOCK_INSTANCE=wlp3s0 ~/.local/share/i3blocks-modules/wifi \
  -f 'WIFI: {ip} {ssid} ({signal}%)' \
  -fe '{status}' '!=' 'up' 'WIFI: down'
```

`~/.config/i3blocks/config`:
```ini
# Note: Set instance to your wifi interface
# Note: interval specifies how often the module should be updated (in seconds)
#       So in this example, it will be updated every 2 seconds.
[wifi]
command=~/.local/share/i3blocks-modules/wifi -f 'WIFI: {ip} {ssid} ({signal}%)' -fe '{status}' '!=' 'up' 'WIFI: down'
instance=wlp3s0
interval=2
```

In the above example you will have different outputs based on whether the Wifi interface is up or not up.


### Set *thresholds*

Thresholds allow you to colorize your output depending on the module state (`default`, `good`, `warning`, `critical` or `info`).
You will need to tell each module (based on your specified conditions) when it reaches a certain state.
The normal behaviour of each module is to run in `default` state.


**1\. Colorize date with 'good status' during weekends:**

`command line`:
```bash
$ ~/.local/share/i3blocks-modules/date -f " {time}" -t "%a, %d.%m.%Y" -tg '{time}' '=' '^(Sat|Sun).*'
```

`~/.config/i3blocks/config`:
```ini
[date]
command=~/.local/share/i3blocks-modules/date -f " {time}" -t "%a, %d.%m.%Y" -tg '{time}' '=' '^(Sat|Sun).*'
interval=60
```

**2\. Colorize time with warning state after 23 o'clock and between 0 and 3 with critical state:**

`command line`:
```bash
$ ~/.local/share/i3blocks-modules/date -f " {time}" -t "%H:%M" -tw '{time}' '=' '^23.*' -tc '{time}' '=' '^0(0|1|2|3).*'
```

`~/.config/i3blocks/config`:
```ini
[time]
command=~/.local/share/i3blocks-modules/date -f " {time}" -t "%H:%M" -tw '{time}' '=' '^23.*' -tc '{time}' '=' '^0(0|1|2|3).*'
interval=1
```



## :wrench:  Configuration file

### i3blocks configuration

Configuration is done as you would normally do it with [i3blocks](https://github.com/vivien/i3blocks). The only customization would be to setting the `command` accordingly.
The configuration file is available in `~/.config/i3blocks/config`.


### i3blocks-modules configuration

The here provided `i3blocks-modules` also come with their own configuration file, which sets status colors globally.

`~/config/i3blocks-modules/config`:
```ini
# i3blocks-modules configuration

# Set your default colors
color_def="#666666"
color_good="#88b090"
color_warn="#ccdc90"
color_crit="#e89393"
color_info="#FCE94F"
```
If the above file is present, those colors are used as the defaults.


### Example configuration

`~/.config/i3blocks/config`
```ini
# output:  51°C
# shows 'good color' at temperatures below 71 degrees
# shows 'warn color' at temperatures above 70 degrees
# shows 'crit color' at temperatures above 90 degrees
[cputemp]
command=~/.local/share/i3blocks-modules/cputemp -tg '{temp}' '<' 71 -tw '{temp}' '>' 70 -tc '{temp}' '>' 90
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
command=~/.local/share/i3blocks-modules/battery -fe '{percent}' '<' 90 ' {percent}% ({time})' -fe '{percent}' '<' 75 ' {percent}% ({time})' -fe '{percent}' '<' 60 ' {percent}% ({time})' -fe '{percent}' '<' 35 ' {percent}% ({time})' -fe '{percent}' '<' 5 ' {percent}% ({time})' -fe '{status}' '=' '^charging' '⚡ {percent}% ({time})' -fe '{status}' '=' 'full' ' {percent}%' -tg '{status}' '=' 'full' -tg '{percent}' '=' 100 -ti '{status}' '=' '^charging' -tw '{percent}' '<' 30 -tc '{percent}' '<' 5
instance=Battery 0
interval=1

# output:  375 GiB / 435 GiB (10%)
# show 'warn color' when disk space is less than 20%
# show 'crit color' when disk space is less than 10%
[disk]
command=~/.local/share/i3blocks-modules/disk -f " {free} {funit}iB / {total} {tunit}iB ({pused}%)" -tc '{pfree}' '<' 20 -tc '{pfree}' '<' 10
instance=/
interval=30

# output: ☼ 100%
[backlight]
command=~/.local/share/i3blocks-modules/backlight
instance=intel_backlight
interval=2

# output:  Sun, 05.03.2017
[date]
command=~/.local/share/i3blocks-modules/date -f " {time}" -t "%a, %d.%m.%Y"
interval=60

# output:  14:36
[time]
command=~/.local/share/i3blocks-modules/date -f " {time}" -t "%H:%M"
interval=5
```



## :computer: General module usage

Each module provides an extensive help output which gives you information about available placeholder, thresholds, colors and custom module arguments. Help screens can be shown via `-h`.
```bash
# Generic
/path/to/module -h

# Specific for the 'wifi' module
~/.local/share/i3blocks-modules/wifi -h
```

All modules are designed to work in the same way. The only difference are their custom specific options `Optional variables`.

Have a look at the [doc/](doc/) folder for usage.



## :page_facing_up: License

**[MIT License](LICENSE)**

Copyright (c) 2017 [cytopia](https://github.com/cytopia)
