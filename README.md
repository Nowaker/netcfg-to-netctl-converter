# About netcfg-to-netctl-converter

A simple script that converts `/etc/network.d` to `/etc/netctl` profiles and displays both for convenience.

Only a subset of netcfg/netctl directives is supported. Generally, all ethernets and bridges should work. Wireless won't. Check the source for details.

## Available parameters

`-f` - force overwrite profile in /etc/netctl if already exists

## Example output

```text
# netcfg-to-netctl-converter.sh -f
br0
  /etc/network.d/br0 (existing)
    INTERFACE="br0"
    CONNECTION="bridge"
    DESCRIPTION="Example Bridge connection"
    BRIDGE_INTERFACES="eth0"
    IP="static"
    ADDR="188.116.38.67"
    NETMASK="255.255.255.224"
    GATEWAY="188.116.38.65"
    ## sets forward delay time
    #FWD_DELAY=0
    ## sets max age of hello message
    #MAX_AGE=10
    DNS=("91.203.134.60" "193.143.121.3")
  /etc/netctl/br0 (generated)
    Description=Example Bridge connection
    Interface=br0
    Connection=bridge
    BindsToInterfaces=('eth0')
    IP=static
    Address=('188.116.38.67/27')
    Gateway=('188.116.38.65')
    DNS=('91.203.134.60' '193.143.121.3')
```

# Licensed under 2-clause BSD. 

Copyright (c) 2013, StratusHost Damian Nowak
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
