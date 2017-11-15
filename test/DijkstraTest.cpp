#include <iostream>
#include "Graph.h"
#include "catch.hpp"
#include "dijkstra.h"

TEST_CASE("dijkstra matrix test", "[adj_matrix]") {
  unsigned size = 9;

  int dist_key[size] = {0, 4, 12, 19, 21, 11, 9, 8, 14};
  int path_key[size] = {-1, 0, 1, 2, 5, 6, 7, 0, 2};

  Graph g(size);
  g.add_edge(0, 1, 4);
  g.add_edge(0, 7, 8);
  g.add_edge(1, 2, 8);
  g.add_edge(1, 7, 11);
  g.add_edge(2, 3, 7);
  g.add_edge(2, 8, 2);
  g.add_edge(2, 5, 4);
  g.add_edge(3, 4, 9);
  g.add_edge(3, 5, 14);
  g.add_edge(4, 5, 10);
  g.add_edge(5, 6, 2);
  g.add_edge(6, 7, 1);
  g.add_edge(6, 8, 6);
  g.add_edge(7, 8, 7);

  unsigned **input = g.get_matrix();
  int *dist = new int[size];
  int *parent = new int[size];

  dijkstra_sw_matrix(input, 0, size, dist, parent);

  for (int i = 0; i < size; i++) {
    REQUIRE(dist[i] == dist_key[i]);
  }

  for (int i = 0; i < size; i++) {
    REQUIRE(parent[i] == path_key[i]);
  }
}
