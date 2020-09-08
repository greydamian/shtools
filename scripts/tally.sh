#! /usr/bin/env sh

#
# Copyright (c) 2020 Damian Jason Lapidge
#
# Licensing information regarding the contents of this file can be found within 
# the file LICENSE.txt, which is located within this project's root directory.
#

# set shell options
set -o pipefail;

readonly CMDUSAGE="usage: $0 [<file>]";

# command arguments, initialised with default values
CMDARGS_INPUT="/dev/stdin";

parseargs() {
    readonly CMDARGS_INPUT=${1-$CMDARGS_INPUT};

    return 0; # success
}

main() {
    parseargs $@ || { echo "$CMDUSAGE" >&2; return 1; };

    cat "${CMDARGS_INPUT}" | sort | uniq -c | sort -nr;

    return $?;
}

main $@;

