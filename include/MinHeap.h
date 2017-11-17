/**
  RICKY TRAN
  UNIVERSITY OF FLORIDA
  MINHEAP HEADER
**/

#ifndef _MINHEAP_H_
#define _MINHEAP_H_

#include <utility>

class MinHeap {
 private:
  int cap;
  int size;
  std::pair<int, int> *heap;
  int *pos;

 public:
  MinHeap(unsigned V);
  ~MinHeap();
  int parent(int v) const;
  int left(int v) const;
  int right(int v) const;
  bool isEmpty();
  bool isInMinHeap(int v);
  void insertKey(int v, int w);
  void decreaseKey(int v, int new_val);
  void MinHeapify(int v);
  std::pair<int, int> extractMin();
  void printPos();
};

void swap(std::pair<int, int> &x, std::pair<int, int> &y);

#endif