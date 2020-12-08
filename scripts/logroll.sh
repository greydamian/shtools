#! /usr/bin/env sh

#
# Copyright (c) 2020 Damian Jason Lapidge
#
# Licensing information regarding the contents of this file can be found within 
# the file LICENSE.txt, which is located within this project's root directory.
#

readonly CMDUSAGE="usage: $0 <filename> [<interval> [<start> [<datefmt>]]]";

# command arguments, initialised with default values
CMDARGS_OUTFILE="";
CMDARGS_INTERVAL="86400"; # 24h
CMDARGS_START="now";
CMDARGS_DATEFMT="%Y%m%d";

parseargs() {
    [ $# -lt 1 ] && return 1; # failure

    readonly CMDARGS_OUTFILE="$1";
    readonly CMDARGS_INTERVAL="${2-$CMDARGS_INTERVAL}";
    readonly CMDARGS_START="${3-$CMDARGS_START}";
    readonly CMDARGS_DATEFMT="${4-$CMDARGS_DATEFMT}";

    return 0; # success
}

appendtopath() {
    local suffix="$1";
    [ -n "$suffix" ] && suffix=":$suffix";

    PATH="$PATH$suffix";

    return 0; # success
}

dates() {
    date +%s $@;
}

getnextrolltime() {
    [ $# -lt 2 ] && return 1; # failure

    local rolltime="$1";
    local interval="$2";

    while [ "$(interval.sh @"$rolltime")" -lt 1 ]; do
        : $(( rolltime += interval ));
    done;

    echo "$rolltime";
    return 0; # success
}

createlogfile() {
    [ $# -lt 1 ] && return 1; # failure

    local lnkfile="$1";
    local datefmt="${2:-"%Y%m%d"}";

    local datestr="$(date +"${datefmt}")";
    local logfile="${lnkfile}.${datestr}";

    touch "$logfile";
    [ -f "$lnkfile" ] && rm "$lnkfile";
    ln -s "$logfile" "$lnkfile";

    return 0; # success
}

main() {
    parseargs $@ || { echo "${CMDUSAGE}" >&2; return 1; };

    appendtopath "$(dirname $0)";

    local rolltime="$(dates -d "${CMDARGS_START}")";

    createlogfile "${CMDARGS_OUTFILE}" "${CMDARGS_DATEFMT}";
    while [ 1 ]; do
        cat "/proc/$$/fd/0" >"${CMDARGS_OUTFILE}"&
        rolltime="$(getnextrolltime "${rolltime}" "${CMDARGS_INTERVAL}")";
        sleep $(interval.sh @"${rolltime}");
        kill -0 "$!" >/dev/null 2>&1 || break;
        createlogfile "${CMDARGS_OUTFILE}" "${CMDARGS_DATEFMT}";
        kill $!;
        wait $! 2>/dev/null;
    done;

    return 0; # success
}

main $@;

