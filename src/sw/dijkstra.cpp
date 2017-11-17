#include "dijkstra.h"
#include <limits.h>
#include <vector>
#include "Graph.h"
#include "MinHeap.h"
#include "fiboqueue.hpp"

int min_distance(int dist[], bool done[], int size) {
  int min = INT_MAX;
  int min_index = -1;
  for (int i = 0; i < size; i++) {
    if (done[i] == false && dist[i] < min) {
      min = dist[i], min_index = i;
    }
  }
  return min_index;
}

void dijkstra_sw_base(int **graph, int src, int size, int *dist) {
  bool done[size];
  for (int i = 0; i < size; i++) {
    dist[i] = INT_MAX;
    done[i] = false;
  }
  dist[src] = 0;
  for (int i = 1; i < size; i++) {
    int u = min_distance(dist, done, size);
    done[u] = true;
    for (int v = 0; v < size; v++) {
      if ((!done[v]) && (graph[u][v]) && (dist[v] > dist[u] + graph[u][v])) {
        dist[v] = dist[u] + graph[u][v];
      }
    }
  }
}

void dijkstra_sw_bin(const Graph *g, int src, int *dist) {
  MinHeap h((*g).size());
  dist[src] = 0;
  h.insertKey(src, dist[src]);
  for (int i = 1; i < (*g).size(); i++) {
    dist[i] = INT_MAX;
    h.insertKey(i, dist[i]);
  }
  while (!h.isEmpty()) {
    std::pair<int, int> p = h.extractMin();
    int u = p.first;
    std::vector<std::pair<int, int>> adj = (*g).get_adj_list(u);
    for (auto it = adj.begin(); it != adj.end(); it++) {
      int v = it->first;
      int w = it->second;
      if (h.isInMinHeap(v) && dist[u] != INT_MAX && dist[v] > dist[u] + w) {
        dist[v] = dist[u] + w;
        h.decreaseKey(v, dist[v]);
      }
    }
  }
}

void dijkstra_sw_fib(const Graph *g, int src, int *dist) {
  FibQueue<int, int> fq;
  dist[src] = 0;
  fq.push(dist[src], src);
  for (int i = 1; i < (*g).size(); i++) {
    dist[i] = INT_MAX;
    fq.push(dist[i], i);
  }
  while (!fq.isEmpty()) {
    auto n = fq.pop();
    int u = n.data();
    std::vector<std::pair<int, int>> adj = (*g).get_adj_list(u);
    for (auto it = adj.begin(); it != adj.end(); it++) {
      int v = it->first;
      int w = it->second;
      if (dist[u] != INT_MAX && dist[v] > dist[u] + w) {
        dist[v] = dist[u] + w;
        auto temp = fq.findNode(v);
        fq.decrease_key(temp, dist[v]);
      }
    }
  }
}

// void dijkstra_hw(int graph[][], int src) {}
