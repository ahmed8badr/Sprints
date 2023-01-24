#!/bin/bash

# Create directories if it doesn't exist
if [ ! -d ~/Reports ]; then
  mkdir ~/Reports
fi

year=`date +%Y`
if [ ! -d ~/Reports/$year ]; then
  mkdir ~/Reports/$year
fi

for month in {01..12}; do
  if [ ! -d ~/Reports/$year/$month ]; then
    mkdir ~/Reports/$year/$month
  fi
done

month=`date +%m`
for day in {01..31}; do
  if [ ! -f ~/Reports/$year/$month/$day.xls ]; then
    touch ~/Reports/$year/$month/$day.xls
  fi
done

# Backup the reports only between 12AM and 5AM daily
hour=`date +%H`
if [ $hour -ge 0 -a $hour -lt 5 ]; then
  if [ ! -d ~/backups ]; then
    mkdir ~/backups
  fi
  cp -r ~/Reports ~/backups/Reports_$(date +%Y%m%d_%H%M%S)
fi
