#!/usr/bin/perl

use strict ;
use warnings ;
use v5.10 ;

my ($previous_sample,$current_sample) ;

while (my $record = <>) {
    my ($yyyy,$mth,$dd,$hh,$mm,$ss) = 
	( $record =~ m{^(\d\d\d\d)/(\d\d)/(\d\d) (\d\d):(\d\d):(\d\d\.\d{9})} ) ;

    # Skip if the line doesn't match the pattern (can happen with corrupted
    # entries)
    next if not defined $yyyy ;

    my $current_date = "$yyyy$mth$dd" ;
    my $current_time = "$hh$mm$ss" ;
    
    $previous_sample = $current_sample if defined $current_sample ;
    $current_sample  = [$current_date,$current_time] ;

    # If $previous_sample is undefined, we have nothing to compare
    # so we go for another loop
    next if not defined $previous_sample ;

    # $previous_sample is defined, that's good.
    my ($previous_date,$previous_time) = @$previous_sample ;

    my $delta_t = $current_time - $previous_time ;
    next if $delta_t > 0 and $delta_t < 1;

    # $delta_t is negative or is bigger than one, has the date changed?
    my $delta_d = $current_date - $previous_date ;
    if ( $delta_d <= 0 ) {
	# No, the date hasn't changed, this is a step back
	report_step_back($previous_sample,$current_sample,$.) ;
    }
}


sub report_step_back {
    my ($previous_sample,$current_sample,$line_number) = @_ ;

    my ($pdate,$ptime,$cdate,$ctime) = (@$previous_sample,@$current_sample) ;
    say "STEP $pdate-$ptime => $cdate-$ctime at line $line_number" ;
}
