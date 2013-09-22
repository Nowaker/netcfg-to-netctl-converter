#!/usr/bin/bash

# Convert netcfg to netctl profiles.
# License: 2-clause BSD. Copyright (c) 2013, StratusHost Damian Nowak.

set -e

# http://www.linuxquestions.org/questions/programming-9/bash-cidr-calculator-646701/
mask2cidr() {
  nbits=0
  IFS=.
  for dec in $1 ; do
    case $dec in
      255) let nbits+=8;;
      254) let nbits+=7;;
      252) let nbits+=6;;
      248) let nbits+=5;;
      240) let nbits+=4;;
      224) let nbits+=3;;
      192) let nbits+=2;;
      128) let nbits+=1;;
      0);;
      *) echo "Error: $dec is not recognised"; exit 1
    esac
  done
  echo "$nbits"
}

array() {
  if [ -n "$2" ]; then
    echo -n "$1=("
    list=''
    for item in ${@:2}; do
      list="$list '$item'"
    done
    list=`echo "$list" | sed -e 's/^ *//g' -e 's/ *$//g'` # trim
    echo -n "$list"
    echo ")"
  fi
}

while getopts ":f" opt; do
  case $opt in
    f)
      force=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# http://stackoverflow.com/a/2924755/504845
bold=`tput bold`
normal=`tput sgr0`

for cfg in /etc/network.d/*; do
  source $cfg
  name=`basename "$cfg"`

  ctl="/etc/netctl/$name"
  if [ -f "$ctl" -a -z "$force" ]; then
    echo "$ctl already exists. Add -f to overwrite."
    break
  fi
  
  rm -f "$ctl"

  if [ -n "$DESCRIPTION" ]; then
    echo "Description=$DESCRIPTION" >> "$ctl"
  fi

  if [ -n "$INTERFACE" ]; then
    echo "Interface=$INTERFACE" >> "$ctl"
  fi

  if [ -n "$CONNECTION" ]; then
    echo "Connection=$CONNECTION" >> "$ctl"
  fi

  if [ -n "$BRIDGE_INTERFACES" ]; then
    array 'BindsToInterfaces' "${BRIDGE_INTERFACES[@]}" >> "$ctl"
  fi

  if [ -n "$IP" ]; then
    echo "IP=$IP" >> "$ctl"
  fi

  if [ -n "$IP6" ]; then
    echo "IP6=$IP6" >> "$ctl"
  fi

  if [ -n "$ADDR" -a -n "$NETMASK" ]; then
    CIDR=$(mask2cidr "$NETMASK")
    echo "Address=('$ADDR/$CIDR')" >> "$ctl"
  fi

  if [ -n "$GATEWAY" ]; then
    array 'Gateway' "${GATEWAY[@]}" >> "$ctl" 
  fi

  if [ -n "$DNS" ]; then
    array 'DNS' "${DNS[@]}" >> "$ctl" 
  fi

  echo "$bold$name$normal"
  echo "  $bold$cfg (existing)$normal"
  grep . "$cfg" | sed 's/^/    /' # indent by four spaces: http://stackoverflow.com/a/17484859/504845
  echo "  $bold$ctl (generated)$normal"
  grep . "$ctl" | sed 's/^/    /'
done

echo
echo "Don't forget to \`netctl enable/reenable profile\`"
