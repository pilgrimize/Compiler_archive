#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#define STRING_SIZE 1000
long int x, y;
void exgcd(long  a, long  b, long  c,long  *x, long  *y){
    long int x1, y1;
    if (b==0){
        if (c%a!=0){
            *x=-(1);
            *y=-(1);
        }
        else {
            *x=c/a;
            *y=0;
        }
    }
    else {
        exgcd(b, a%b, c, &*x, &*y);
        if (*x!=-(1)){
            x1=*x;
            y1=*y;
            /*b*x1 + (a-(a/b)*b)*y1 = c*/*x=y1;
            *y=x1-(a/b)*y1;
        }
    }
}
int main(){
    exgcd(23, 74-37, 17+2, &x, &y);
    printf("%ld%c%ld\n", x, ' ', y);
    return 0;
}
