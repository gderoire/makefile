#include <iostream>
using namespace std;

#include "app_foo.h"
//#include "../lib_bar/libbar.h"
#include "lib_bar/libbar.h"

int main() 
{
    cout << "Hello, Foo!\n";
    hello_bar();
    return 0;
}
