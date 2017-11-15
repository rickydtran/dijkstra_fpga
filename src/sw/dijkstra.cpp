#include "dijkstra.h"
#include <limits.h>
#include <iostream>
#include "Graph.h"

int min_distance(int dist[], bool done[], int size) {
  int min = INT_MAX, min_idx;
  for (int i = 0; i < size; i++) {
    if (done[i] == false && dist[i] <= min) {
      min = dist[i], min_idx = i;
    }
  }
  return min_idx;
}

void print_path(int parent[], int dst) {
  if (parent[dst] == -1) {
    std::cout << dst << " ";
    return;
  }
  print_path(parent, parent[dst]);
  std::cout << dst << " ";
}

void print_solution(int dist[], int parent[], int src, int size) {
  std::cout << "Vertex      Distance      Path" << std::endl;
  for (int i = 0; i < size; i++) {
    std::cout << src << " -> " << i << "      " << dist[i] << "\t\t  ";
    print_path(parent, i);
    std::cout << std::endl;
  }
}

// void dijkstra_sw_adj_l(Graph g, int src) {}

void dijkstra_sw_matrix(unsigned **graph, int src, int size, int *dist,
                        int *parent) {
  bool done[size];
  for (int i = 0; i < size; i++) {
    parent[src] = -1;
    dist[i] = INT_MAX;
    done[i] = false;
  }
  dist[src] = 0;
  for (int i = 1; i < size; i++) {
    int u = min_distance(dist, done, size);
    done[u] = true;
    for (int v = 0; v < size; v++) {
      if (!done[v] && graph[u][v] && dist[u] + graph[u][v] < dist[v]) {
        parent[v] = u;
        dist[v] = dist[u] + graph[u][v];
      }
    }
  }
  // print_solution(dist, parent, src, size);
}

// void dijkstra_hw(int graph[][], int src) {}
