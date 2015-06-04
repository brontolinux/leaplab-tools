#!/usr/bin/perl

use strict ;
use warnings ;

my $adjtimex = q{/usr/local/sbin/adjtimex} ;

open my $cmdpipe, "$adjtimex --print |" ;

if (not defined $cmdpipe) {
  die "Hell, cannot read from $adjtimex pipe" ;
}

my $status ;
while (my $line = <$cmdpipe>) {
  my ($keyword,$value) = ($line =~ m/^\s*(.+): (.+)$/) ;

  next unless $keyword eq q{status} ;

  $status = $value ;
  last ;
}

if (not defined $status) {
  die "Cannot read status from $adjtimex" ;
}

# We try to detect if a leap second is inserted (16) or deleted (32)
# We AND the status string with 48 (32+16) and we expect $leap to be
# either 0 (those bits are down), or 16 (leap second inserted), or
# 32 (leap second removed). Theoretically, we could also get 48, but
# that would mean that we are both inserting and removing a leap second
# at the same time, which is illogical.
my $leap = $status & 48 ; 

if ($leap == 0) {
  # No leap set, we "fail" out
  exit 1 ;
}

if ($leap == 16 or $leap == 32) {
  # Leap second inserted (16) or deleted (32): we must reset that bit
  $status -= $leap ;
  system($adjtimex,'--status',$status) ;
  exit 0 ;
}

die "Leap bits are set to $leap, which is illogical" ;
