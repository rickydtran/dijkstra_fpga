/**
  RICKY TRAN
  UNIVERSITY OF FLORIDA
  MINHEAP IMPLEMENTATION
**/

#include "MinHeap.h"
#include <limits.h>
#include <iostream>

MinHeap::MinHeap(unsigned V) {
  this->cap = V;
  this->size = 0;
  this->heap = new std::pair<unsigned, unsigned>[V];
  this->pos = new unsigned[V];
}

MinHeap::~MinHeap() {
  delete[] this->heap;
  delete[] this->pos;
}

bool MinHeap::isInMinHeap(unsigned v) {
  if (pos[v] < size) return true;
  return false;
}

unsigned MinHeap::parent(unsigned v) const { return (v - 1) / 2; }
unsigned MinHeap::left(unsigned v) const { return (2 * v + 1); }
unsigned MinHeap::right(unsigned v) const { return (2 * v + 2); }

bool MinHeap::isEmpty() {
  if (size == 0) return true;
  return false;
}

void MinHeap::insertKey(unsigned v, unsigned w) {
  std::pair<unsigned, unsigned> p = std::make_pair(v, w);
  if (size == cap) {
    return;
  }
  unsigned i = size;
  heap[i] = p;
  pos[v] = i;
  size++;
  while (i && heap[parent(i)].second > heap[i].second) {
    pos[heap[i].first] = parent(i);
    pos[heap[parent(i)].first] = i;
    swap(heap[i], heap[parent(i)]);
    i = parent(i);
  }
}

void MinHeap::decreaseKey(unsigned v, unsigned new_val) {
  heap[pos[v]].second = new_val;
  unsigned i = pos[v];
  while (i && heap[parent(i)].second > heap[i].second) {
    pos[heap[i].first] = parent(i);
    pos[heap[parent(i)].first] = i;
    swap(heap[i], heap[parent(i)]);
    i = parent(i);
  }
}

void MinHeap::MinHeapify(unsigned v) {
  unsigned l = left(v);
  unsigned r = right(v);
  unsigned min = v;
  if (l < size && heap[l].second < heap[min].second) {
    min = l;
  }
  if (r < size && heap[r].second < heap[min].second) {
    min = r;
  }
  if (min != v) {
    pos[heap[v].first] = min;
    pos[heap[min].first] = v;
    swap(heap[v], heap[min]);
    MinHeapify(min);
  }
}

std::pair<unsigned, unsigned> MinHeap::extractMin() {
  if (isEmpty()) {
    return std::make_pair(UINT_MAX, UINT_MAX);
  }
  if (size == 1) {
    size--;
    return heap[0];
  }
  std::pair<unsigned, unsigned> root = heap[0];
  heap[0] = heap[size - 1];
  pos[heap[0].first] = 0;
  size--;
  MinHeapify(0);
  return root;
}

void MinHeap::printPos() {
  for (unsigned i = 0; i < size; i++) {
    std::cout << pos[i] << ' ' << std::endl;
  }
}

void swap(std::pair<unsigned, unsigned> &x, std::pair<unsigned, unsigned> &y) {
  std::pair<unsigned, unsigned> temp = x;
  x = y;
  y = temp;
}