/**
  RICKY TRAN
  UNIVERSITY OF FLORIDA
  DIJKSTRA HEADER
**/

#ifndef _DIJKSTRA_H_
#define _DIJKSTRA_H_

#include "Graph.h"
#include "dijkstra.h"

void print_path(int prev[], int dst);
void print_solution(int dist[], int prev[], int src, int size);
int min_distance(int dist[], bool done[], int size);
void print_path(int parent[], int dst);
void print_solution(int dist[], int parent[], int src, int size);
void dijkstra_sw_base(int **graph, int src, int size, int *dist, int *prev);
void dijkstra_sw_bin(const Graph *g, int src, int *dist, int *prev);
void dijkstra_sw_fib(const Graph *g, int src, int *dist, int *prev);
// void dijkstra_hw(int **graph, int src);

#endif