#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#define STRING_SIZE 1000
int x, y, i, j;
double z, w;
char* str = (char *)malloc(sizeof(char) * STRING_SIZE);
char c;
int main(){
    /*here is test for readln read write writeln*/printf("%s\n", "begin to test");
    scanf("%d%d%lf%lf", &x, &y, &z, &w);
    scanf("%s", str);
    scanf("%c", &c);
    printf("%d%d%s%lf", x, y, "test for write", z);
    printf("%s\n", "123");
    /*here is test for if else*/if (x>y){
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
            else {
                printf("%lf\n", w);
                printf("%d\n", x);
            }
        }
    }
    /*here is test for for ... to do and for... downto ... do*/for (i=1; i<=10; ++i){
        printf("%d\n", i);
        z=z+i*x;
        if (x>w){
            printf("%lf\n", z);
        }
        else {
            printf("%lf\n", w);
            printf("%d\n", x);
        }
    }
    for(i=(x*y-2)/3; i>=-((x*y)); --i){
        printf("%d\n", j);
        z=z*i-x;}
    do{
        for (i=x%y; i<=x*y; ++i){
            z=z+8*i;
            printf("%d\n", i);
        }
        printf("%d\n", i);
    }while(!((i!=(j-8)/2)));
    free(str);
    return 0;
}
