/**
  RICKY TRAN
  UNIVERSITY OF FLORIDA
  TIMER IMPLEMENTATION
**/

#include "Timer.h"
#include <chrono>

Timer::Timer() {}

Timer::~Timer() {}

std::chrono::steady_clock::time_point Timer::currentTime() const {
  auto curr = std::chrono::steady_clock::now();
  return curr;
}

void Timer::start() { startTime = currentTime(); }

void Timer::stop() { stopTime = currentTime(); }

double Timer::elapsedTime() const {
  return std::chrono::duration<double, std::nano>(stopTime - startTime).count();
}
