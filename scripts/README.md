# Scripts

* adjtimex-decoder.pl: runs adjtimex and prints the meaning of the status string
* leap-adjust.pl: runs adjtimex, checks if the leap second bits are set and resets them
* timelog.sh: writes the date and the leap bits from ntpd repeatedly, until you stop it; the output is more useful if you write it into a file;
* scan_timelog.sh: scans a timelog created by timelog.sh and tells you if the clock has stepped back and where
