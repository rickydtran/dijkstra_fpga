#include <iostream>
#include "Graph.h"
#include "catch.hpp"

TEST_CASE("Instantiation of Graph", "[graph_create]") {
  Graph g(10);
  REQUIRE(g.size() == 10);
  REQUIRE(g.num_of_edges() == 0);
}

TEST_CASE("Adding an Edge to Graph", "[add_edge]") {
  Graph g(10);
  REQUIRE(g.size() == 10);
  REQUIRE(g.num_of_edges() == 0);

  SECTION("Adding Edge should Increase Number of Edges by 2 (bi-directional)") {
    g.add_edge(0, 1, 10);
    REQUIRE(g.num_of_edges() == 2);
    g.add_edge(0, 4, 20);
    REQUIRE(g.num_of_edges() == 4);
    g.add_edge(1, 2, 30);
    REQUIRE(g.num_of_edges() == 6);
    g.add_edge(1, 3, 40);
    REQUIRE(g.num_of_edges() == 8);
    g.add_edge(1, 4, 50);
    REQUIRE(g.num_of_edges() == 10);
    g.add_edge(2, 3, 60);
    REQUIRE(g.num_of_edges() == 12);
    g.add_edge(3, 4, 70);
    REQUIRE(g.num_of_edges() == 14);
  }
}

TEST_CASE("Random Graph Generation", "[random_graph]") {
  unsigned size = 500;

  Graph a(size);
  Graph b(size);
  Graph c(size);
  Graph d(size);
  unsigned seed = 100;
  double p;

  p = 0.1;
  a.create_random_graph(seed, p);
  REQUIRE(a.num_of_edges() == size * size * p);
  p = 0.3;
  b.create_random_graph(seed, p);
  REQUIRE(b.num_of_edges() == size * size * p);
  p = 0.5;
  c.create_random_graph(seed, p);
  REQUIRE(c.num_of_edges() == size * size * p);
  p = 0.9;
  d.create_random_graph(seed, p);
  REQUIRE(d.num_of_edges() == size * size * p);

  // d.print_graph();
  // std::cout << d.num_of_edges() << std::endl;
}