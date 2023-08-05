// included above every outputted c++ file.
#include <cmath>
#include <iostream>
#include <random>
#include <string>

void comma_putsnoln_() {}
template <typename A, typename... T> void comma_putsnoln_(A thing, T... rest) {
  std::cout << thing;
  comma_putsnoln_(rest...);
}

void comma_putswithaln_() {}
template <typename A, typename... T>
void comma_putswithaln_(A thing, T... rest) {
  std::cout << thing << '\n';
  comma_putswithaln_(rest...);
}

namespace comma {
float mod(float a, float b) { return std::fmod(a, b); }
double mod(double a, double b) { return std::fmod(a, b); }
long double mod(long double a, long double b) { return std::fmod(a, b); }
// for integers
template <typename T> T mod(T a, T b) { return (a % b + b) % b; }

static std::random_device rd;
static std::mt19937 gen(rd());
static std::uniform_real_distribution<double> dis(0.0, 1.0);
struct Chance {
  double chance;

  constexpr Chance(double chance) : chance(chance) {}
  operator bool() { return dis(gen) < chance; }
  template <typename T> constexpr Chance operator/(T t) {
    return Chance{chance / t};
  }
  template <typename T> constexpr Chance operator*(T t) {
    return Chance{chance * t};
  }
};

// allows for \0 in strings
template <size_t length>
inline std::string string(const char (&literal)[length]) {
  return std::string(&literal[0], length - 1);
}
}
