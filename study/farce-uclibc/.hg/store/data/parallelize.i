         l   k      ��������P M�T+�6�-N�ZF8�%���            u#!/bin/bash
for i in {1..26}
do
   echo "Launching $i with file list: $1"
   ./analyze.sh x86_64 $1 &
done
