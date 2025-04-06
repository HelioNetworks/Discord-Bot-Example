#!/usr/bin/python3.12

import os
import signal
import subprocess

print("Content-Type: text/html\n\n")

counter = 0
p = subprocess.Popen(['ps', '-u', 'username'], stdout=subprocess.PIPE)
# Must match your username --------^^^^^^^^

out, err = p.communicate()
for line in out.splitlines():
    if 'bot.py'.encode('utf-8') in line:
        # ^--- This has to match the filename of your loop

        counter += 1
        pid = int(line.split(None, 1)[0])
        print("Stopping bot.")
        os.kill(pid, signal.SIGTERM)

if counter == 0:
    print("Already stopped.")
