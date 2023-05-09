#ifndef POSITION_H
#define POSITION_H

typedef struct YYLTYPE
{
    int first_line;
    int first_column;
    int last_line;
    int last_column;
} YYLTYPE;
extern YYLTYPE yylloc; /* 用于定位的，在yacc中提供，需要声明为extern*/
static void update_loc() /* 用于定位的行列的，每次在识别一个成分之前会调用*/
{
    static int curr_line = 1;/*静态变量*/
    static int curr_col  = 1;
    yylloc.first_line   = curr_line;
    yylloc.first_column = curr_col;
    {
        char * s; 
        for(s = yytext; *s != '\0'; s++) /*yytext是取到词的数组的开始地址*/
        {
            if(*s == '\n'){/*是换行符行数+1*/
            curr_line++;
            curr_col = 1;
            }
            else{
            curr_col++;
            }
        }
    }
    yylloc.last_line   = curr_line;
    yylloc.last_column = curr_col-1;
}

#define YY_USER_ACTION update_loc();

#endif