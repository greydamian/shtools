#! /usr/bin/env bash

#
# Copyright (c) 2021 Damian Jason Lapidge
#
# Licensing information regarding the contents of this file can be found within 
# the file LICENSE.txt, which is located within this project's root directory.
#

# N.B. My intuition would have been to use bitwise operators for the conversion 
# of IP addresses, particularly. However, as an intellectual exercise, I have 
# intentionally attempted to avoid the use of bitwise operators in favour of 
# more traditional mathematical operators.

readonly CMDUSAGE="usage: $0 <ipaddr>[/<subnet>]";

CMDARGS_IPADDR="";
CMDARGS_SUBNET="";

parseargs () {
    [ $# -lt 1 ] && return 1; # failure

    CMDARGS_IPADDR="$(echo "$1/" | cut -d/ -f1)";
    CMDARGS_SUBNET="$(echo "$1/" | cut -d/ -f2)";

    CMDARGS_IPADDR="${CMDARGS_IPADDR:-127.0.0.1}";
    CMDARGS_SUBNET="${CMDARGS_SUBNET:-32}";

    readonly CMDARGS_IPADDR;
    readonly CMDARGS_SUBNET;

    return 0; # success
}

iptoint () {
    local x=${1##*.};
    local y=${1%.*};

    [ "$x" == "$y" ] && { echo "$x"; return 0; }; # success

    echo "$(( x + 256 * $(iptoint $y) ))";
    return 0; # success
}

inttoip () {
    local x="$1";
    local n="$(( ${2:-1} - 1 ))";

    (( x < 256 && n < 1 )) && { echo "$x"; return 0; }; # success

    echo "$(inttoip $(( x / 256 )) $n).$(( x % 256 ))";
    return 0; # success
}

getmacaddr () {
    [ $# -lt 1 ] && return 1; # failure

    local result="$(ip n show | \
                    egrep -v 'FAILED|INCOMPLETE' | \
                    egrep "^$1 " | \
                    cut -d' ' -f5 | \
                    sort -u | \
                    tr '\n' ,)";

    echo "${result%,*}";
    return 0; # success
}

main () {
    parseargs $@ || { echo "$CMDUSAGE" >&2; return 1; }; # failure

    local x="$(iptoint $CMDARGS_IPADDR)";
    local n="$(( 2 ** (32 - CMDARGS_SUBNET) ))";
    (( n -= x % n ));

    while (( n > 0 )); do
        local ipaddr="$(inttoip $x 4)";
        echo -ne "$ipaddr\r";
        ping -c1 $ipaddr >/dev/null 2>&1;
        local macaddr="$(getmacaddr $ipaddr)";
        [ "$macaddr" != "" ] && printf '%-15s @ %s\n' "$ipaddr" "$macaddr";
        (( x++ && n-- ));
    done;

    return 0; # success
}

trap "exit 1" SIGINT; # handle sigint

main $@;

