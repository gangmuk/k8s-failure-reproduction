#!/bin/bash

echo "lol" > lol.txt

python3 app.py

echo "sleep start" > shell_done.txt
sleep 600
echo "shell_done" >> shell_done.txt
