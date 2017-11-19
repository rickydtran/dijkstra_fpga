/**
  RICKY TRAN
  UNIVERSITY OF FLORIDA
  GRAPH HEADER
**/

#ifndef _GRAPH_H_
#define _GRAPH_H_

#include <set>
#include <vector>

class Graph {
 public:
  Graph(int V);
  ~Graph();
  int size() const;
  int num_of_edges();
  void add_edge(int u, int v, int wt);
  void create_random_graph(int seed, double p, int max_wt);
  void create_spanning_tree(std::set<std::pair<int, int>> &c, int seed);
  int get_weight(int i, int j) const;
  void print_graph();
  int **get_matrix();
  std::vector<std::pair<int, int>> get_adj_list(int i) const;

 private:
  int V;
  std::vector<std::pair<int, int>> *adj;
};

#endif
