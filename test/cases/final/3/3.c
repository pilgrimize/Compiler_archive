#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#define STRING_SIZE 1000
int x, y;
int gcd(int a, int b){
    int _gcd;
    if (b==0){
        _gcd=a;
    }
    else {
        _gcd=gcd(b, a%b);
    }
    return _gcd;
}
int main(){
    scanf("%d%d", &x, &y);
    printf("%d", gcd(x, y));
    return 0;
}
