#!/bin/bash

for i in 16 32 64 128 256 512
do
  for j in 0.1 0.3 0.5 0.7 0.9
  do
    ./testdat ${i} 0 ${j} 255 > ${i}_${j}.txt
  done
done
