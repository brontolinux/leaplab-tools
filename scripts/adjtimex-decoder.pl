#!/usr/bin/perl

use strict ;
use warnings ;

use constant DEBUG => 0 ;

my $adjtimex = q{/usr/local/sbin/adjtimex} ;

open my $cmdpipe, "$adjtimex --print |" ;

if (not defined $cmdpipe) {
  die "Hell, cannot read from $adjtimex pipe" ;
}

my $status ;
while (my $line = <$cmdpipe>) {
  my ($keyword,$value) = ($line =~ m/^\s*(.+): (.+)$/) ;

  next if not defined $keyword ;
  next unless $keyword eq q{status} ;

  $status = $value ;
}

if (not defined $status) {
  die "Cannot read status from $adjtimex" ;
}

print "Status is $status, which means:\n" ;

my %description =
  (
        1 => q{PLL updates enabled},
        2 => q{PPS freq discipline enabled},
        4 => q{PPS time discipline enabled},
        8 => q{frequency-lock mode enabled},
       16 => q{inserting leap second},
       32 => q{deleting leap second},
       64 => q{clock unsynchronized},
      128 => q{holding frequency},
      256 => q{PPS signal present},
      512 => q{PPS signal jitter exceeded},
     1024 => q{PPS signal wander exceeded},
     2048 => q{PPS signal calibration error},
     4096 => q{clock hardware fault},
     8192 => q{nanosec resolution enabled}, # by John Stultz
    16384 => q{FLL mode enabled},           # by John Stultz
  ) ;

my @vals = reverse sort { $a <=> $b } keys %description ;

foreach my $value (@vals) {
  if (DEBUG) {
    print STDERR "Comparing $value with $status\n" ;
  }

  next if $value > $status ;
  print $description{$value}, "\n" ;
  $status -= $value ;
  if (DEBUG) {
    print STDERR "Residual status: $status\n" ;
  }
}
