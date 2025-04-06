#!/usr/bin/python3.12

import subprocess

print("Content-Type: text/html\n\n")

counter = 0
p = subprocess.Popen(['ps', '-u', 'username'], stdout=subprocess.PIPE)
# must match your username --------^^^^^^^^

out, err = p.communicate()
for line in out.splitlines():
    if 'bot.py'.encode('utf-8') in line:
        #     ^^^^^^^^^^^----- this has to match the filename of your bot script

        counter += 1
        print("Bot already running.")

if counter == 0:
    subprocess.Popen("/home/username/bot.py")
    #                       ^^^^^^^^-- be sure to update it to your username

    print("Bot started!")
