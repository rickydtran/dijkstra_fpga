#include "Graph.h"
#include <math.h>
#include <stdlib.h>
#include <iostream>
#include <set>

Graph::Graph(unsigned V) {
  this->V = V;
  this->adj = new std::vector<std::pair<int, int>>[this->V];
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

void Graph::create_random_graph(unsigned seed, double p) {
  std::set<std::pair<int, int>> container;
  srand(seed);

  create_spanning_tree(container,
                       seed);  // Guaranteeds every node to be connected

  int e = round(V * V * p) / 2 - (V - 1);

  for (int i = 0; i < e; i++) {  // Fill in till Connectivity is met
    int u = rand() % V;
    int v = rand() % V;
    std::pair<int, int> p = std::make_pair(u, v);
    std::pair<int, int> p_r = std::make_pair(v, u);
    if (container.find(p) != container.end() ||
        container.find(p_r) != container.end() || u == v) {
      i--;
    } else {
      container.insert(p);
    }
  }

  for (auto it = container.begin(); it != container.end(); it++) {
    add_edge(it->first, it->second, rand() % 99);
  }
}

void Graph::create_spanning_tree(std::set<std::pair<int, int>> &c,
                                 unsigned seed) {
  srand(seed);
  bool check[V];
  for (unsigned i = 0; i < V; i++) {
    check[i] = false;
  }
  int nodeNum = V;
  bool firstIteration = true;
  while (nodeNum != 0) {
    int u = rand() % V;
    int v = rand() % V;
    if (u == v) {
      continue;
    }
    if (firstIteration) {
      firstIteration = false;
    } else if ((check[u] && check[v]) || (!check[u] && !check[v])) {
      continue;
    }
    std::pair<int, int> p = std::make_pair(u, v);
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

int Graph::get_weight(unsigned i, unsigned j) const {
  for (auto it = adj[i].begin(); it != adj[i].end(); it++) {
    if (it->first == j) {
      return it->second;
    }
  }
  return 0;
}

void Graph::print_graph() {
  int v, w;
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
  for (int i = 0; i < V; i++) {
    matrix[i] = new unsigned[V];
  }

  for (int i = 0; i < V; i++) {
    for (int j = 0; j < V; j++) {
      matrix[i][j] = 0;
    }
  }

  for (int u = 0; u < V; u++) {
    for (auto it = adj[u].begin(); it != adj[u].end(); it++) {
      matrix[u][it->first] = it->second;
    }
  }
  return matrix;
}

std::vector<std::pair<int, int>> Graph::get_adj_list(int i) const {
  return adj[i];
}