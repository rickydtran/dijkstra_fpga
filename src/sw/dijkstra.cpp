/**
  RICKY TRAN
  UNIVERSITY OF FLORIDA
  DIJKSTRA IMPLEMENTATION
**/

#include "dijkstra.h"
#include <limits.h>
#include <iostream>
#include <vector>
#include "Graph.h"
#include "MinHeap.h"
#include "fiboqueue.hpp"

void print_path(unsigned prev[], unsigned dst, unsigned src) {
  if (dst == src) {
    std::cout << dst << " ";
    return;
  }
  print_path(prev, prev[dst], src);
  std::cout << dst << " ";
}

void print_solution(unsigned dist[], unsigned prev[], unsigned src, unsigned size) {
  std::cout << "Vertex      Distance      Path" << std::endl;
  for (unsigned i = 0; i < size; i++) {
    std::cout << src << " -> " << i << "\t\t" << dist[i] << "\t  ";
    print_path(prev, i, src);
    std::cout << std::endl;
  }
}

unsigned min_distance(unsigned dist[], bool done[], unsigned size) {
  unsigned min = UINT_MAX;
  unsigned min_index = -1;
  for (unsigned i = 0; i < size; i++) {
    if (done[i] == false && dist[i] < min) {
      min = dist[i], min_index = i;
    }
  }
  return min_index;
}

void dijkstra_sw_base(unsigned **graph, unsigned src, unsigned size, unsigned *dist, unsigned *prev) {
  bool done[size];
  for (unsigned i = 0; i < size; i++) {
    dist[i] = UINT_MAX;
    prev[i] = 0;
    done[i] = false;
  }
  dist[src] = 0;
  for (unsigned i = 0; i < size; i++) {
    unsigned u = min_distance(dist, done, size);
    // std::cout << u << std::endl;
    done[u] = true;
    for (unsigned v = 0; v < size; v++) {
      if ((graph[u][v]) && (dist[v] > dist[u] + graph[u][v])) {
        prev[v] = u;
        dist[v] = dist[u] + graph[u][v];
      }
    }
  }
}

void dijkstra_sw_bin(const Graph *g, unsigned src, unsigned *dist, unsigned *prev) {
  MinHeap h((*g).size());
  for (unsigned i = 0; i < (*g).size(); i++) {
    dist[i] = UINT_MAX;
    prev[i] = 0;
    h.insertKey(i, dist[i]);
  }
  dist[src] = 0;
  h.decreaseKey(src, dist[src]);
  while (!h.isEmpty()) {
    std::pair<unsigned, unsigned> p = h.extractMin();
    unsigned u = p.first;
    std::vector<std::pair<unsigned, unsigned>> adj = (*g).get_adj_list(u);
    for (auto it = adj.begin(); it != adj.end(); it++) {
      unsigned v = it->first;
      unsigned w = it->second;
      if (dist[v] > dist[u] + w) {
        prev[v] = u;
        dist[v] = dist[u] + w;
        h.decreaseKey(v, dist[v]);
      }
    }
  }
}

void dijkstra_sw_fib(const Graph *g, unsigned src, unsigned *dist, unsigned *prev) {
  FibQueue<unsigned, unsigned> fq;
  for (unsigned i = 0; i < (*g).size(); i++) {
    dist[i] = UINT_MAX;
    prev[i] = 0;
    fq.push(dist[i], i);
  }
  dist[src] = 0;
  auto src_node = fq.findNode(src);
  fq.decrease_key(src_node, dist[src]);
  while (!fq.isEmpty()) {
    auto n = fq.pop();
    unsigned u = n.data();
    std::vector<std::pair<unsigned, unsigned>> adj = (*g).get_adj_list(u);
    for (auto it = adj.begin(); it != adj.end(); it++) {
      unsigned v = it->first;
      unsigned w = it->second;
      if (dist[v] > dist[u] + w) {
        prev[v] = u;
        dist[v] = dist[u] + w;
        auto temp = fq.findNode(v);
        fq.decrease_key(temp, dist[v]);
      }
    }
  }
}
