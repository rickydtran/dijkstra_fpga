/**
  RICKY TRAN
  UNIVERSITY OF FLORIDA
  GRAPH AND DATA GEN IMPL
**/

#include "Graph.h"
#include <cmath>
#include <iostream>
#include <random>
#include <set>

Graph::Graph(unsigned V) {
  this->V = V;
  this->adj = new std::vector<std::pair<unsigned, unsigned>>[this->V];
}

Graph::~Graph() { delete[] this->adj; }

unsigned Graph::size() const { return this->V; }

unsigned Graph::num_of_edges() {
  unsigned no_e = 0;
  for (unsigned i = 0; i < V; i++) {
    no_e += adj[i].size();
  }
  return no_e;
}

void Graph::add_edge(unsigned u, unsigned v, unsigned wt) {
  adj[u].push_back(std::make_pair(v, wt));
  adj[v].push_back(std::make_pair(u, wt));
}

void Graph::create_random_graph(unsigned seed, double p, unsigned max_wt) {
  std::set<std::pair<unsigned, unsigned>> container;
  std::mt19937 mt(seed);
  std::uniform_int_distribution<unsigned> dist(0, V - 1);
  std::uniform_int_distribution<unsigned> dist_wt(1, max_wt);

  create_spanning_tree(container,
                       seed);  // Guaranteeds every node to be connected

  int e = round(V * V * p) / 2 - (V - 1);

  for (int i = 0; i < e; i++) {  // Fill in till Connectivity is met
    unsigned u = dist(mt);
    unsigned v = dist(mt);
    std::pair<unsigned, unsigned> p = std::make_pair(u, v);
    std::pair<unsigned, unsigned> p_r = std::make_pair(v, u);
    if (container.find(p) != container.end() ||
        container.find(p_r) != container.end() || u == v) {
      i--;
    } else {
      container.insert(p);
    }
  }

  for (auto it = container.begin(); it != container.end(); it++) {
    add_edge(it->first, it->second, dist_wt(mt));
  }
}

void Graph::create_spanning_tree(std::set<std::pair<unsigned, unsigned>> &c,
                                 unsigned seed) {
  std::mt19937 mt(seed);
  std::uniform_int_distribution<unsigned> dist(0, V - 1);
  bool check[V];
  for (unsigned i = 0; i < V; i++) {
    check[i] = false;
  }
  unsigned nodeNum = V;
  bool firstIteration = true;
  while (nodeNum != 0) {
    unsigned u = dist(mt);
    unsigned v = dist(mt);
    if (u == v) {
      continue;
    }
    if (firstIteration) {
      firstIteration = false;
    } else if ((check[u] && check[v]) || (!check[u] && !check[v])) {
      continue;
    }
    std::pair<unsigned, unsigned> p = std::make_pair(u, v);
    c.insert(p);
    if (!check[u]) {
      check[u] = true;
      nodeNum--;
    }
    if (!check[v]) {
      check[v] = true;
      nodeNum--;
    }
  }
}

unsigned Graph::get_weight(unsigned i, unsigned j) const {
  for (auto it = adj[i].begin(); it != adj[i].end(); it++) {
    if (it->first == j) {
      return it->second;
    }
  }
  return 0;
}

void Graph::print_graph() {
  unsigned v, w;
  for (unsigned u = 0; u < V; u++) {
    std::cout << "Node " << u << " has an edge with" << std::endl;
    for (auto it = adj[u].begin(); it != adj[u].end(); it++) {
      v = it->first;
      w = it->second;
      std::cout << "\tNode " << v << " with edge weight of " << w << std::endl;
    }
  }
}

unsigned **Graph::get_matrix() {
  unsigned **matrix = new unsigned *[V];
  for (unsigned i = 0; i < V; i++) {
    matrix[i] = new unsigned[V];
  }

  for (unsigned i = 0; i < V; i++) {
    for (unsigned j = 0; j < V; j++) {
      matrix[i][j] = 0;
    }
  }

  for (unsigned u = 0; u < V; u++) {
    for (auto it = adj[u].begin(); it != adj[u].end(); it++) {
      matrix[u][it->first] = it->second;
    }
  }
  return matrix;
}

unsigned **Graph::create_hw_matrix(unsigned **matrix) {
  unsigned **hmatrix = new unsigned *[V / 4];
  for (unsigned i = 0; i < V / 4; i++) {
    hmatrix[i] = new unsigned[V];
  }

  for (unsigned i = 0; i < V / 4; i++) {
    for (unsigned j = 0; j < V; j++) {
      hmatrix[i][j] = 0;
    }
  }

  for (unsigned i = 0; i < V / 4; i++) {
    for (unsigned j = 0; j < V; j++) {
      hmatrix[i][j] = (matrix[4 * i][j] & 0xFF) << 24 |
                      (matrix[4 * i + 1][j] & 0xFF) << 16 |
                      (matrix[4 * i + 2][j] & 0xFF) << 8 |
                      (matrix[4 * i + 3][j] & 0xFF);
    }
  }
  return hmatrix;
}

std::vector<std::pair<unsigned, unsigned>> Graph::get_adj_list(
    unsigned i) const {
  return adj[i];
}