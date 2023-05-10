#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#define STRING_SIZE 1000
int arr[3][3];
int i, j;
int main(){
    for (i=1; i<=3; ++i){
        for (j=1; j<=3; ++j){
            arr[i-(1)][j-(1)]=i*j;
        }
    }
    return 0;
}
