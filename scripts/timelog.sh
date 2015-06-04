#!/bin/sh

while true
do
  DATE=`date "+%Y/%m/%d %H:%M:%S.%N"`
  #LEAP=`ntpdc -c sysinfo | awk '/^leap indicator/ { print $3 }'`
  LEAP=`ntpq -c rv | perl -ne 'm{leap=(\d\d)} && print $1'`
  echo "$DATE $LEAP"
done
