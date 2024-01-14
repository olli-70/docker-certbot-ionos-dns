#!/bin/sh


echo "Create crontab job to run with sched: $LE_SCHED"
entfernt=$(echo "$variable" | sed 's/"//g')
echo "$LE_SCHED /app/certrun.sh  2>&1" > /tmp/cron
sed 's/"//g' /tmp/cron > /tmp/cron_ready
crontab /tmp/cron_ready
rm /tmp/cro*

echo "Starting crontab"
/usr/sbin/crond -f -l 2