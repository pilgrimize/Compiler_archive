#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#define STRING_SIZE 1000
char a[10];
char b[10];
long int c[12][29][317];
double d[20];
char i;
int j, x, y, z;
long int k;
double l;
char m;
double s;
char* str = (char *)malloc(sizeof(char) * STRING_SIZE);
char char_array[11];
void MySmallProcedure(){
    const char ch='a';
    /*here is test for global variable*/printf("%lf%c%lf%s\n", l, m, s, str);
}
void MyProcedure(int i, int j,char  *a, char  *b,char * *s,double  *d){
    const float pi=3.1415926;
    const float phi=2.718281828;
    int p, q;
    char r, g;
    char* t = (char *)malloc(sizeof(char) * STRING_SIZE);
    double temp_d;
    printf("%s\n", "This is a function");
    printf("%d%d%c%c\n", i, j, *a, *b);
    /*here is test for global variable*/printf("%lf%ld\n", *d, c[-(1)-(1)][3-(2)][34-(34)]);
    *a='a';
    *b=*a;
    if ((*b=='c')){
        i=(p-q+2)*(i+j);
        *d=*d*i/23-1.1415926;
        printf("%c%c%d%d\n", *a, *b, i, j);
        MyProcedure(i, j, &*a, &*b, &*s, &*d);
    }
    /*here is test for procedure call*/MyProcedure(p, q, &char_array[0-(0)], &char_array[1-(0)], &t, &temp_d);
    /*here is test for setting for the var parameter*/*s="This is a string";
    m='m';
    k=3924525;
    /*here is test for procedure call*/for (i=1; i<=10; ++i){
        MyProcedure(i, j, &r, &g, &t, &temp_d);
    }
    i=2;
    /*here is the test for const*/printf("%f%f\n", pi, phi);
    temp_d=pi*phi/3;free(t);
    
}
int main(){
    /*below are the test for function*/printf("%s\n", "begin to test");
    MySmallProcedure();
    MyProcedure(i, j, &m, &b[3-(3)], &str, &s);
    MySmallProcedure();
    free(str);
    return 0;
}
