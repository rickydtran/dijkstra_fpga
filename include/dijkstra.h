#ifndef _DIJKSTRA_H_
#define _DIJKSTRA_H_

#include "Graph.h"
#include "dijkstra.h"

int min_distance(int dist[], bool done[], int size);
void print_path(int parent[], int dst);
void print_solution(int dist[], int parent[], int src, int size);
void dijkstra_sw_adj_list(const Graph *g, int src, int *dist, int *parent);
void dijkstra_sw_matrix(unsigned **graph, int src, int size, int *dist,
                        int *parent);
// void dijkstra_hw(int **graph, int src);

#endif