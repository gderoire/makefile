#include <iostream>
using namespace std;

#include "app.h"
#include "../lib_hello/libhello.h"

int main() 
{
    cout << "Hello, World!\n";
    hello_lib();
    hello_lib2();
    return 0;
}
