#! /usr/bin/env bash

#
# Copyright (c) 2021 Damian Jason Lapidge
#
# Licensing information regarding the contents of this file can be found within 
# the file LICENSE.txt, which is located within this project's root directory.
#

readonly CMDUSAGE="usage: $0 [-ai] [<addr|int> ...]"; 

readonly REGEX_IPADDR="^((0|[1-9][0-9]{0,2})\.){3}(0|[1-9][0-9]{0,2})$";
readonly REGEX_INTGTZ="^[1-9][0-9]*$";

readonly OPTSTR=":ai";

readonly CMDOPT_MODE_IPA=$(( 1 << 0 ));
readonly CMDOPT_MODE_INT=$(( 1 << 1 ));
readonly CMDOPT_MODE_ALL=$(( CMDOPT_MODE_IPA | \
                             CMDOPT_MODE_INT ));
CMDOPT_MODE=$CMDOPT_MODE_ALL;

parseopts () {
    while getopts $OPTSTR opt; do
        case "$opt" in
            a)
                CMDOPT_MODE=$(( CMDOPT_MODE ^ CMDOPT_MODE_INT ));
                [ $CMDOPT_MODE -eq 0 ] && CMDOPT_MODE=$CMDOPT_MODE_ALL;
                ;;
            i)
                CMDOPT_MODE=$(( CMDOPT_MODE ^ CMDOPT_MODE_IPA ));
                [ $CMDOPT_MODE -eq 0 ] && CMDOPT_MODE=$CMDOPT_MODE_ALL;
                ;;
            ?)
                # ignore
                ;;
            :)
                # ignore
                ;;
        esac;
    done;

    readonly CMDOPT_MODE;

    return 0; # success
}

appendtopath () {
    [ -n "$1" ] && PATH="$PATH:$1";

    return 0; # success
}

addrtoint () {
    local x="${1%.*}";
    local y="${1##*.}";

    [ "$1" == "$x" ] && { echo "$y"; return 0; };

    echo $(( y + 256 * $(addrtoint $x) ));
    return 0; # success
}

inttoaddr () {
    local n="$(( ${2:-4} - 1 ))";
    local x="$1";

    [ "$n" -lt 1 -a "$x" -lt 256 ] && { echo "$(( x % 256 ))"; return 0; };

    echo "$(inttoaddr $(( x / 256 )) $n).$(( x % 256 ))";
    return 0; # success
}

main () {
    appendtopath "$(dirname $0)";

    parseopts $@;
    shift $(( OPTIND - 1 ));

    local l="$@";
    [ -z "$l" ] && read l;

    while [ -n "$l" ]; do
        for e in $(ip4subnet.sh $l); do
            local a="";
            local i="";

            [[ "$e" =~ $REGEX_IPADDR ]] && a="$e";
            [[ "$e" =~ $REGEX_INTGTZ ]] && i="$e";

            [ -z "$a" -a -z "$i" ] && continue;

            if (( CMDOPT_MODE & CMDOPT_MODE_IPA )); then
                [ -z "$a" ] && a="$(inttoaddr "$i")";
                echo "$a";
            fi;

            if (( CMDOPT_MODE & CMDOPT_MODE_INT )); then
                [ -z "$i" ] && i="$(addrtoint "$a")";
                echo "$i";
            fi;
        done;

        [ $# -gt 0 ] && break;
        read l;
    done;

    return 0; # success
}

main $@;

