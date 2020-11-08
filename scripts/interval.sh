#! /usr/bin/env sh

#
# Copyright (c) 2020 Damian Jason Lapidge
#
# Licensing information regarding the contents of this file can be found within 
# the file LICENSE.txt, which is located within this project's root directory.
#

readonly CMDUSAGE="usage: $0 <stop> [<start>]";

# command arguments, initialised with default values
CMDARGS_STOP="";
CMDARGS_START="now";

parseargs() {
    [ $# -lt 1 ] && return 1; # failure

    readonly CMDARGS_STOP="$1";
    readonly CMDARGS_START="${2-$CMDARGS_START}";

    return 0; # success
}

interval() {
    [ $# -lt 1 ] && return 1; # failure

    local stop="$1";
    local start="${2-'now'}";

    stop="$(date -d "$stop" +%s)";
    [ -z "$stop" ] && return 2; # failure

    start="$(date -d "$start" +%s)";
    [ -z "$start" ] && return 2; # failure

    echo "$(( $stop - $start ))";

    return 0; # success
}

main() {
    parseargs "$@" || { echo "${CMDUSAGE}" >&2; return 1; };

    interval "${CMDARGS_STOP}" "${CMDARGS_START}";

    return $?;
}

main "$@";

