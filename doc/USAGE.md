# Usage example


```shell
$ disk -h
Usage: disk [-f <format>] [-fe <p> <s> <int|str> <f>] [-d <disk>] [-tg|-ti|-tw|-tc <p> <s> <int|str>] [-np] [-cd|-cg|-cw|-cc|-ci <code>]
       disk -h
       disk -v

Optional variables:
--------------------------------------------------------------------------------
  -d <disk>    Specify the disk being used. This can also be set via i3blocks 'instance=' value. If neither is set, it will default to '/'.

Optional threshold arguments:
--------------------------------------------------------------------------------
You can optionally enable threshold checking against any placeholder value.
This enables the colorizing of the final output depending on any met
conditions specified.
Default is not to use any threshold
You can use unlimited number of threshold for each type.

  -tg <p> <s> <int|str>   Enable threshold for 'good status'
  -ti <p> <s> <int|str>   Enable threshold for 'info status'
  -tw <p> <s> <int|str>   Enable threshold for 'warn status'
  -tc <p> <s> <int|str>   Enable threshold for 'crit status'

   Explanation:
     <p>   is the placeholder value you want to check against.
           valid placeholders: {total} {used} {free} {pused} {pfree} {uunit} {funit} {tunit}
           Note 1: placeholder values will be converted to integers
                   Any decimal places will simply be cut off.
           Note 2: In equal mode (<s> '=') is a string regex comparison and
                   no placeholder will be converted.
           Note 3: In unequal mode (<s> '!=') is a string comparison and
                   no placeholder will be converted.
           Note 3: In equal mode (<s> '=') regex is allowed :-)
     <s>   must either be '<', '>', '=' or '!='  depending on what direction
           you want to check the threshold placeholder against.
     <int> The integer number you want to check against the placeholder.
     <str> The string you want to check against the placeholder.
           You can only use a string when in equal mode '='.
           You can also use regex here.

   Examples:
     1. Check if value of {total} < 50, then format using the good color
     -tg '{total}' '<' 50

     2. Check if value of {total} > 90, then format using the warn color
     -tw '{total}' '>' 90

     3. Check if value of {total} equals the string 'foo', then format using the info color
     -ti '{total}' '=' 'foo'

     4. Check if value of {total} equals the regex '^[0-9]+$', then format using the info color
     -ti '{total}' '=' '^[0-9]+$'

Optional markup (pango):
--------------------------------------------------------------------------------
  -np          Disable pango markup

Optional color arguments:
--------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------
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
     -f " {free} {funit}iB free"

Optional extended Format output:
--------------------------------------------------------------------------------
You can conditionally set your output text depending on the value of any placeholder.
For example, If you have a placeholder {status} that either is 'up' or 'down', you
can specify different outputs for 'up' and for 'down'.
Usage
  -fe <p> <s> <v> <f>

   Format example:
     -fe '{status}' '=' 'up' 'It works ;-)' -fe '{status}' '!=' 'up' 'status is: {status}'
   Explanation:
     <p>   is the placeholder value you want to check against.
           valid placeholders: {total} {used} {free} {pused} {pfree} {uunit} {funit} {tunit}
           Note 1: placeholder values will be converted to integers
                   Any decimal places will simply be cut off.
           Note 2: In equal mode (<s> '=') is a string regex comparison and
                   no placeholder will be converted.
           Note 3: In unequal mode (<s> '!=') is a string comparison and
                   no placeholder will be converted.
           Note 3: In equal mode (<s> '=') regex is allowed :-)
     <s>   must either be '<', '>', '=' or '!='  depending on what direction
           you want to check the threshold placeholder against.
     <int> The integer number you want to check against the placeholder.
     <str> The string you want to check against the placeholder.
           You can only use a string when in equal mode '='.
           You can also use regex here.
     <f>   Is the format string that should be displayed under the above condition.
           Of course you can also use placeholders here ;-).
```
