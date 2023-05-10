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
char* str;
/*here is simple test for function*/char  MySmallFunction(){
    char  _MySmallFunction;
    const char ch='a';
    _MySmallFunction=ch;
    return _MySmallFunction;
}
/*here is complex test for function*/t = (char *)malloc(sizeof(char) * STRING_SIZE)
int MyFunction(int i, int j,char  *a, char  *b,char * *s,double  *d){
    int _MyFunction;
    const float pi=3.1415926;
    const float phi=2.718281828;
    int p, q;
    char r, g;
    char* t;
    double temp_d;
    printf("%s\n", "This is a function");
    printf("%d%d%c%c\n", i, j, *a, *b);
    /*here is test for global variable*/printf("%lf%ld\n", *d, c[1-(1)][3-(2)][34-(34)]);
    *a='a';
    *b=*a;
    if ((*b=='c')){
        i=(p-q)*(i+j);
        *d=*d*i/23-1.1415926;
        printf("%c%c%d%d\n", *a, *b, i, j);
        /*here is test for seting of return value */_MyFunction=(q-p*2)*(i-j*p/q);
    }
    /*here is test for internal function call*/_MyFunction=i+j+MyFunction(i, j, &*a, &*b, &*s, &*d);
    *s="This is a string";
    m='m';
    k=3924525;
    for (i=1; i<=10; ++i){
        k=k*i+MyFunction(i, j, &r, &g, &t, &temp_d);
        printf("%ld\n", k);
    }
    i=2;
    /*here is the test for const*/printf("%f%f\n", pi, phi);
    temp_d=pi*phi/3;
    free(t);
    return _MyFunction;
}
int main(){
    str = (char *)malloc(sizeof(char) * STRING_SIZE)
    /*here is the basical test for array*/printf("%s\n", "begin to test");
    i=a[1-(1)];
    scanf("%d%d%d", &x, &y, &z);
    if (a[(x+y)%z+x*y-z/x-(1)]<10.2){
        a[(x-y)/2-i+k*k*k/k%i-(1)]=214748;
        printf("%d\n", a[(x*y-2)/2+k*i%(i*2-3)-(1)]);
    }
    printf("%c\n", b[3-(3)]);
    scanf("%ld", &c[3-(1)][4-(2)][5-(34)]);
    /*below are the test for function*/i=(MyFunction(x, y, &b[4-(3)], &b[5-(3)], &str, &d[28-(10)])+a[0-(1)])/10;
    if ((MyFunction(x, z, &b[2-(3)], &b[8-(3)], &str, &s)==1+(a[129-(1)]*a[a[3-(1)]-(1)]))){
        printf("%d\n", MyFunction(y, z, &b[8-(3)], &b[6-(3)], &str, &l));
        b[3-(3)]=MySmallFunction();
        b[4-(3)]=MySmallFunction();
        b[9-(3)]=MySmallFunction();
        if (MySmallFunction()=='a'){
            printf("%s\n", "correct");
        }
    }
    free(str);
    return 0;
}
