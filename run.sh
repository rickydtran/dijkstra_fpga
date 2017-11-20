#!/bin/bash

for i in 16 32 64 128 256 512 1024 2048
do
  for j in 0.1 0.3 0.5 0.7 0.9
  do
    zed_schedule.py ${PWD}/bin/dijkstra 25 ${i} ${j} 255
  done
done