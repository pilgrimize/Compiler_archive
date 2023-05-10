#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#define STRING_SIZE 1000
int x, y, i, j;
double z, w;
char* str;
char c;
int main(){
    str = (char *)malloc(sizeof(char) * STRING_SIZE)
    scanf("%d%d%lf%lf", &x, &y, &z, &w);
    scanf("%s", str);
    scanf("%c", &c);
    if (x>y){
        printf("%d\n", x);
    }
    else {
        if (x>z){
            printf("%d\n", y);
        }
        else {
            if (x>w){
                printf("%lf\n", z);
            }
        }
    }
    do{
        for (i=x%y; i<=x*y; ++i){
            z=z+8*i;
            printf("%d\n", i);
        }
        printf("%d\n", i);
    }while(!((i!=(j-8)/2)));
    printf("%d%d%s%lf", x, y, "test for write", z);
    free(str);
    return 0;
}
