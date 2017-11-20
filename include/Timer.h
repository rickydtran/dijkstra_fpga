/**
  RICKY TRAN
  UNIVERSITY OF FLORIDA
  TIMER HEADER
**/

#ifndef _TIMER_H_
#define _TIMER_H_

#include <chrono>

class Timer {
 public:
  Timer();
  ~Timer();

  void start();
  void stop();
  double elapsedTime() const;

 protected:
  std::chrono::steady_clock::time_point startTime;
  std::chrono::steady_clock::time_point stopTime;
  std::chrono::steady_clock::time_point currentTime() const;
};

#endif
