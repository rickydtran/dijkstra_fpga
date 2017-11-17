#include <iostream>
#include "Graph.h"
#include "MinHeap.h"
#include "catch.hpp"

TEST_CASE("MinHeap Test", "[MinHeap]") {
  int key_one[6] = {0, 3, 2, 1, 5, 4};
  int key_two[6] = {0, 1, 2, 3, 4, 5};

  MinHeap h(6);

  h.insertKey(0, 45);
  h.insertKey(1, 3);
  h.insertKey(2, 2);
  h.insertKey(3, 15);
  h.insertKey(4, 5);
  h.insertKey(5, 4);
  h.decreaseKey(0, 0);
  h.decreaseKey(3, 1);

  // h.printPos();
  int count = 0;
  while (!h.isEmpty()) {
    std::pair<int, int> p = h.extractMin();
    REQUIRE(p.first == key_one[count]);
    REQUIRE(p.second == key_two[count]);
    // std::cout << p.first << ' ' << p.second << std::endl;
    count++;
  }
}