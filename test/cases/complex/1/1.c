#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#define STRING_SIZE 1000
int x, y;
double z, w;
char* str = (char *)malloc(sizeof(char) * STRING_SIZE);
char c;
int main(){
    scanf("%d%d%lf%lf", &x, &y, &z, &w);
    str="12345$#@&";
    c='c';
    x=!!!(-(-(-(-(-(-(5)))))));
    /*multiple not and multiple minus*/y=(x&(-(123)));
    z=-(-(-(-(-(3.23344)))));
    if (x<0.3*0.4-(2*(2+3-2.3))*0.3){
        w=(0.2-x)*2+(x%10)/2+0.4*((2+3-24.3123)*((31.324-234.12)/(23.1-23.4)));
    }
    printf("%f\n", (x-y)/z*w/2.0+1.334-3.231);
    printf("%d%s%d%lf%lf%s\n", x, "temp", y, w, z, "temp");
    printf("%s\n", "hello world!");
    printf("%s\n", "for test 123 $%*&*@#!");
    free(str);
    return 0;
}
