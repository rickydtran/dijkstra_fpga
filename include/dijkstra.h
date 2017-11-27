/**
  RICKY TRAN
  UNIVERSITY OF FLORIDA
  DIJKSTRA HEADER
**/

#ifndef _DIJKSTRA_H_
#define _DIJKSTRA_H_

#include "Graph.h"
#include "dijkstra.h"

void print_path(unsigned prev[], unsigned dst, unsigned src);
void print_solution(unsigned dist[], unsigned prev[], unsigned src, unsigned size);
unsigned min_distance(unsigned dist[], bool done[], unsigned size);
void dijkstra_sw_base(unsigned **graph, unsigned src, unsigned size, unsigned *dist, unsigned *prev);
void dijkstra_sw_bin(const Graph *g, unsigned src, unsigned *dist, unsigned *prev);
void dijkstra_sw_fib(const Graph *g, unsigned src, unsigned *dist, unsigned *prev);

#endif