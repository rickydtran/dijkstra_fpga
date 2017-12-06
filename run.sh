#!/bin/bash

for i in 16 32 64
do
  for j in 0.02 0.04 0.06 0.08 0.1 0.3 0.5 0.7 0.9
  do
    zed_schedule.py bin/dijkstra 50 ${i} 0 ${j} 255 dijkstra_hw_wrapper.bit | tee metrics2/dijkstra_${i}_${j}.txt
  done
done