#! /usr/bin/env sh

#
# Copyright (c) 2020 Damian Jason Lapidge
#
# Licensing information regarding the contents of this file can be found within 
# the file LICENSE.txt, which is located within this project's root directory.
#

readonly CMDUSAGE="usage: $0 [<count>]";

# command arguments, initialised with default values
CMDARGS_COUNT=0;

parseargs() {
    readonly CMDARGS_COUNT=${1-$CMDARGS_COUNT};

    return 0; # success
}

main() {
    parseargs $@ || { echo "$CMDUSAGE" >&2; return 1; };

    local n=${#CMDARGS_COUNT};
    local i=${CMDARGS_COUNT};

    while (( i > 0 )); do
        printf "%${n}i\r" "$i";
        (( i-- ));
        sleep 1;
    done;

    return 0; # success
}

main $@;

