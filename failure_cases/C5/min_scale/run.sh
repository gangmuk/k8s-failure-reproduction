#!/bin/bash

echo "before executing fifty-cpu-util-app.py" > lol.txt

python3 fifty-cpu-util-app.py

echo "sleep start" > shell_done.txt
sleep 600
echo "shell_done" >> shell_done.txt
