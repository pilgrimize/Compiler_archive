#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#define STRING_SIZE 1000
int x, y, z;
int main(){
    x=1;
    y=3;
    z=x+y;
    printf("%d%d%d%d", x, y, z, x+y+z);
    return 0;
}
