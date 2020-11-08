# shtools
A selection of shell scripts which I find useful.

## Scripts

### interval.sh
`interval.sh` outputs the number of seconds between 2 points in time. Arguments 
must be provided in a format accepted by the `date` command's `-d` option.

### tally.sh
`tally.sh` sums the number of times that unique lines are repeated in a file 
and displays the results in descending order.

N.B. `tally.sh`, rather than a shell script, could be implemented as an alias 
(`alias tally='sort | uniq -c | sort -nr'`). However, the alias would only 
accept input as standard input. Whereas, the script will accept input as either 
standard input or as a filename argument.

### snore.sh
`snore.sh` is a more verbose alternative to the `sleep` command.

