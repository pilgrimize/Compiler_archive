#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#define STRING_SIZE 1000
const int a1=5;
int a[99][2][10];
int i, j, k;
int main(){
    for (i=2; i<=100; ++i){
        for (j=3; j<=3; ++j){
            for(k=2; k>=0; --k){
                a[i-(2)][j-(3)][k-(0)]=i*j*k;}
        }
    }
    printf("%d", a[0-(2)][3-(3)][1-(0)]);
    return 0;
}
