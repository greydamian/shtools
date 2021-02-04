#! /usr/bin/env bash

#
# Copyright (c) 2021 Damian Jason Lapidge
#
# Licensing information regarding the contents of this file can be found within 
# the file LICENSE.txt, which is located within this project's root directory.
#

readonly CMDUSAGE="usage: $0 [<ipaddr>[/<subnet>] ...]";

readonly REGEX_IPADDR="^((0|[1-9][0-9]{0,2})\.){3}(0|[1-9][0-9]{0,2})$";
readonly REGEX_INTGTZ="^[1-9][0-9]*$";

appendtopath () {
    [ -n "$1" ] && PATH="$PATH:$1";

    return 0; # success
}

main() {
    appendtopath "$(dirname $0)";

    local l="$@";
    [ -z "$l" ] && read l;

    while [ -n "$l" ]; do
        for e in $l; do
            local ipaddr="$(echo "$e/" | cut -d/ -f1)";
            local subnet="$(echo "$e/" | cut -d/ -f2)";

            [[ "$subnet" =~ $REGEX_INTGTZ ]] || subnet="32";
            [ "$subnet" -gt 31 ] && { echo "$ipaddr"; continue; };

            [[ "$ipaddr" =~ $REGEX_IPADDR ]] || continue;

            local i=$(ip4int.sh -i $ipaddr);
            local n=$(( 2 ** (32 - subnet) ));
            n=$(( n - (i % n) ));

            while (( n > 0 )); do
                echo "$(ip4int.sh -a $i)";
                i=$(( ++i ));
                n=$(( --n ));
            done;
        done;

        [ $# -gt 0 ] && break;
        read l;
    done;

    return 0; # success
}

main $@;

