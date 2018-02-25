#include "jstring.h"

namespace stdj {

string::string() {}

string::string(const string& other) : stdj::Array<char>(other) {}

string& string::operator=(const string& other) {
  stdj::Array<char>::operator=(other);
  return *this;
}

string::string(char* other_string) {
  while (*other_string) {
    Add(*other_string++);
  }
}

}  // namespace stdj
