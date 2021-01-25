# shtools
A selection of shell scripts which I find useful.

## Scripts

### macscan.sh

#### Description
`macscan.sh` outputs the hardware/MAC (Media Access Control) address(es) for a 
given LAN IP address/subnet.

#### Examples
```sh
# output MAC address of the device with IP address 192.168.0.1, if available
./macscan.sh 192.168.0.1
# scan subnet 192.168.0.0/24 (A.K.A. 192.168.0.0/255.255.255.0)
./macscan.sh 192.168.0.0/24
# scan subnet 192.168.0.0/24, beginning at IP address 192.168.0.1
./macscan.sh 192.168.0.1/24
```

### logroll.sh

#### Description
`logroll.sh` is a simple/immature log rotation tool. It outputs its standard 
input to a series of log files. The naming and interval of these log files is 
defined by the user supplied arguments.

N.B. `logroll.sh` is a immature/hacky solution and is only intended to be used 
in situations where a more robust solution such as `logrotate` may be 
considered excessive. `logroll.sh` is only intended to be used temporarily and 
only for unimportant/non-critical data.

N.B. The default date format is only accurate to 1 day, therefore it is the 
user's responsibility to specify an appropriate date format for rotation 
intervals of less than 86400 seconds.

#### Examples
```sh
# log incoming traffic to tcp port 80, then "roll" log every 24 hours at 0400
tcpdump -Qin 'tcp and dst port 80' | ./logroll.sh httpd.log 86400 0400
```

### interval.sh

#### Description
`interval.sh` outputs the number of seconds between 2 points in time. Arguments 
must be provided in a format accepted by the `date` command's `-d` option.

#### Examples
```sh
# output number of seconds since midnight
./interval.sh 0000
# output number of seconds until midnight
./interval.sh 'tomorrow 0000'
```

### tally.sh

#### Description
`tally.sh` sums the number of times that unique lines are repeated in a file 
and displays the results in descending order.

N.B. `tally.sh`, rather than a shell script, could be implemented as an alias 
(`alias tally='sort | uniq -c | sort -nr'`). However, the alias would only 
accept input as standard input. Whereas, the script will accept input as either 
standard input or as a filename argument.

#### Examples
```sh
# tally lines from the file "mydata.txt"
./tally.sh mydata.txt
./tally.sh < mydata.txt
cat mydata.txt | ./tally.sh
```

### snore.sh

#### Description
`snore.sh` is a more verbose alternative to the `sleep` command.

#### Examples
```sh
# sleep for 60 seconds
./snore.sh 60
# sleep for 24 hours
./snore.sh $(( 24 * 60 ** 2 ))
```

