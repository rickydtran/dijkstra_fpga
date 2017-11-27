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
  unsigned cap;
  unsigned size;
  std::pair<unsigned, unsigned> *heap;
  unsigned *pos;

 public:
  MinHeap(unsigned V);
  ~MinHeap();
  unsigned parent(unsigned v) const;
  unsigned left(unsigned v) const;
  unsigned right(unsigned v) const;
  bool isEmpty();
  bool isInMinHeap(unsigned v);
  void insertKey(unsigned v, unsigned w);
  void decreaseKey(unsigned v, unsigned new_val);
  void MinHeapify(unsigned v);
  std::pair<unsigned, unsigned> extractMin();
  void printPos();
};

void swap(std::pair<unsigned, unsigned> &x, std::pair<unsigned, unsigned> &y);

#endif