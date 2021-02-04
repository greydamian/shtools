#! /usr/bin/env bash

#
# Copyright (c) 2021 Damian Jason Lapidge
#
# Licensing information regarding the contents of this file can be found within 
# the file LICENSE.txt, which is located within this project's root directory.
#

readonly CMDUSAGE="usage: $0 [<ipaddr>[/<subnet>] ...]";

appendtopath () {
    [ -n "$1" ] && PATH="$PATH:$1";

    return 0; # success
}

getmacaddr () {
    [ $# -lt 1 ] && return 1; # failure

    local result="$(ip n show | \
                    egrep -v 'FAILED|INCOMPLETE' | \
                    egrep "^$1 " | \
                    cut -d' ' -f5 | \
                    sort -u | \
                    tr '\n' ' ')";

    echo "$result" | sed -E 's/ +$//g';
    return 0; # success
}

main () {
    appendtopath "$(dirname $0)";

    local l="$@";
    [ -z "$l" ] && read l;

    while [ -n "$l" ]; do
        for ipaddr in $(ip4subnet.sh $l); do
            echo -ne "$ipaddr\r";
            ping -c1 $ipaddr >/dev/null 2>&1;
            local macaddr="$(getmacaddr $ipaddr)";
            if [ -n "$macaddr" ]; then
                printf '%-15s @ %s\n' "$ipaddr" "$macaddr";
            else
                printf '%15s\r' "";
            fi;
        done;

        [ $# -gt 0 ] && break;
        read l;
    done;

    return 0; # success
}

trap "exit 1" SIGINT; # handle sigint

main $@;

