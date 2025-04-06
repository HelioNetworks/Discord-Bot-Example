#!/bin/bash

# Latest copy of this file is available here: https://wiki.helionet.org/Discord_Bot#Starting_and_Stopping_Your_Bot
# edit this to match your bot filename
bot_name="bot.py"

###################################################################

printf 'Content-Type: text/html\n\n'
username=`whoami`
pwd=`printenv|grep '^PWD'|cut -f2 -d'='`
main_domain=`echo "$pwd"|cut -f3 -d'/'`
control=`echo "$pwd"|cut -f5 -d'/'`
temp=`ps axo user:16,pid,pcpu,pmem,vsz,rss,tty,stat,start,time,command|grep -v grep|grep "^$username "`
running=`echo "$temp"|grep -c "$bot_name"`
file_base=`echo $bot_name|tr -cd "a-zA-Z0-9"`
log_name="$file_base.txt"
if [ "$QUERY_STRING" == "" ]; then
    if [ $running -ne 0 ]; then
        mem_kb=`echo "$temp"|grep "$bot_name"|awk '{print $6}'`
        mem_mb=$( echo "scale=2;$mem_kb/1024"|bc )
        mem_24=$( echo "scale=2;$mem_kb*1440/1048576"|bc )
        echo "$bot_name is running. <a href='?action=stop'>Stop</a><br>Current memory usage: $mem_mb MB<br>Estimated 24 hour usage: $mem_24 GB - "
    else
        echo "$bot_name is not running. <a href='?action=start'>Start</a> - "
    fi
    echo "<a href='https://heliohost.org/dashboard/load/' target='_blank'>Check Load</a><br><br>Logs: <a href='?action=clear'>Clear Logs</a> - <a href='/$control/$log_name'>Full Logs</a><pre>"
    tail -30 $pwd/$log_name
    echo "</pre><script>reloading = setTimeout('window.location.reload();', 10000);</script>"
fi
ts=`date +"%Y-%m-%d %H:%M:%S"`
if [ "$QUERY_STRING" == "action=stop" ]; then
    echo "[$ts] Stopping $bot_name." >> $pwd/$log_name
    pid=`echo "$temp"|grep "$bot_name"|tail -1|awk '{print $2}'`
    if [ ${#pid} -ne 0 ]; then
        kill $pid
    fi
    echo "Stopping $bot_name...<script>setInterval(\"window.location.replace('/$control/');\", 2000);</script>"
fi
if [ "$QUERY_STRING" == "action=start" ]; then
    if [ $running -ne 0 ]; then
        echo "$bot_name is already running..."
    else
        echo "[$ts] Starting $bot_name." >> $pwd/$log_name
        /usr/bin/python3.12 -u /home/$main_domain/$bot_name >> $pwd/$log_name 2>&1 &
        echo "Starting $bot_name...<script>window.location.replace('/$control/');</script>"
    fi
fi
if [ "$QUERY_STRING" == "action=clear" ]; then
    cat /dev/null > $pwd/$log_name
    echo "Clearing logs...<script>window.location.replace('/$control/');</script>"
fi
exit 0