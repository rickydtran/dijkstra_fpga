#include "dijkstra.h"
#include <limits.h>
#include <iostream>
#include <queue>
#include <vector>
#include "Graph.h"
#include "MinHeap.h"

int min_distance(int dist[], bool done[], int size) {
  int min = INT_MAX, min_index;
  for (int i = 0; i < size; i++) {
    if (done[i] == false && dist[i] < min) {
      min = dist[i], min_index = i;
    }
  }
  return min_index;
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
    std::cout << src << " -> " << i << "\t\t" << dist[i] << "\t  ";
    print_path(parent, i);
    std::cout << std::endl;
  }
}

void dijkstra_sw_fib(const Graph *g, int src, int *dist, int *parent) {}

void dijkstra_sw_adj_list(const Graph *g, int src, int *dist, int *parent) {
  // std::priority_queue<std::pair<int, int>, std::vector<std::pair<int, int>>,
  //                     std::greater<std::pair<int, int>>>
  //     pq;
  // for (int i = 0; i < (*g).size(); i++) {
  //   dist[i] = INT_MAX;
  //   parent[i] = 0;
  // }
  // dist[src] = 0;
  // parent[src] = -1;
  // pq.push(std::make_pair(0, src));
  // while(!pq.empty()) {
  //   int u = pq.top().second;
  //   pq.pop();
  //   std::vector<std::pair<int, int>> adj = (*g).get_adj_list(u);
  //   for (auto it = adj.begin(); it != adj.end(); ++it) {
  //     int v = it->first;
  //     int w = it->second;
  //     if (dist[u] != INT_MAX && dist[v] > dist[u] + w) {
  //       parent[v] = u;
  //       dist[v] = dist[u] + w;
  //       pq.push(std::make_pair(dist[v], v));
  //     }
  //   }
  // }
  MinHeap h((*g).size());
  dist[src] = 0;
  parent[src] = -1;
  h.insertKey(src, dist[src]);
  for (int i = 1; i < (*g).size(); i++) {
    dist[i] = INT_MAX;
    parent[i] = 0;
    h.insertKey(i, dist[i]);
    // h.printPos();
  }

  while (!h.isEmpty()) {
    std::pair<int, int> p = h.extractMin();
    int u = p.first;
    std::vector<std::pair<int, int>> adj = (*g).get_adj_list(u);
    for (auto it = adj.begin(); it != adj.end(); it++) {
      int v = it->first;
      int w = it->second;
      if(h.isInMinHeap(v) && dist[u] != INT_MAX && dist[v] > dist[u] + w) {
        parent[v] = u;
        dist[v] = dist[u] + w;
        // std::cout << dist[u] << " + " << w << " = " << dist[v] << std::endl;
        h.decreaseKey(v, dist[v]);
        // h.insertKey(v, dist[v]);
      }
    }
  }
}

void dijkstra_sw_matrix(unsigned **graph, int src, int size, int *dist,
                        int *parent) {
  bool done[size];
  for (int i = 0; i < size; i++) {
    dist[i] = INT_MAX;
    done[i] = false;
  }
  dist[src] = 0;
  parent[src] = -1;
  for (int i = 1; i < size; i++) {
    int u = min_distance(dist, done, size);
    done[u] = true;
    for (int v = 0; v < size; v++) {
      if ((!done[v]) && (graph[u][v]) && (dist[v] > dist[u] + graph[u][v])) {
        parent[v] = u;
        dist[v] = dist[u] + graph[u][v];
        // std::cout << dist[u] << " + " << graph[u][v] << " = " << dist[v] << std::endl;
      }
    }
  }
}

// void dijkstra_hw(int graph[][], int src) {}
