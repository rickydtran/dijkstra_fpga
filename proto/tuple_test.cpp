#include <tuple>
#include <iostream>
// #include <string>
// #include <stdexcept>
 
std::tuple<int, int , int> get_student(int id)
{
    if (id == 0) return std::make_tuple(1, 2, 3);
    if (id == 0) return std::make_tuple(1, 2, 3);
    if (id == 0) return std::make_tuple(1, 2, 3);
    // throw std::invalid_argument("id");
}
 
int main()
{
    auto student0 = get_student(0);
    std::cout << "ID: 0, "
              << "GPA: " << std::get<0>(student0) << ", "
              << "grade: " << std::get<1>(student0) << ", "
              << "name: " << std::get<2>(student0) << '\n';
 
    // double gpa1;
    // char grade1;
    // std::string name1;
    // std::tie(gpa1, grade1, name1) = get_student(1);
    // std::cout << "ID: 1, "
    //           << "GPA: " << gpa1 << ", "
    //           << "grade: " << grade1 << ", "
    //           << "name: " << name1 << '\n';
}