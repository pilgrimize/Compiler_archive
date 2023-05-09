program finaltest5(input,output);
var 
    a : array[1..10] of byte;
    b : array[3..12] of char;
    c : array[1..12,2..30,34..350] of longint;
    d : array[10..29] of double;
    i : byte;
    j, x, y, z: integer;
    k : longint;
    l : double;
    m : char;
    s : double;
    str : string;
	char_array : array[0..10] of char;
{here is simple test for function}
procedure MySmallProcedure();
const ch = 'a';
begin
    {here is test for global variable}
    writeln(l,m,s,str)
end;
{here is complex test for function}
procedure MyProcedure(i,j:integer;var a,b:char;var s:string;var d:double);
const 
    pi = 3.1415926;
    phi = 2.718281828;
var p,q:integer;
    r,g:char;
    t:string;
    temp_d:double;
begin
    writeln('This is a function');
    writeln(i,j,a,b);
    {here is test for global variable}
    writeln(d,c[-1,3,34]);
    a := 'a';
	b := a;
    if (b='c') then begin
        i := (p-q+2)*(i+j);
        d := d*i/23-1.1415926;
        writeln(a,b,i,j);
        MyProcedure(i,j,a,b,s,d)
    end;
    {here is test for procedure call}
    MyProcedure(p,q,char_array[0],char_array[1],t,temp_d);
    {here is test for setting for the var parameter}
    s := 'This is a string';
    m := 'm';
    k := 3924525;
    {here is test for procedure call}
    for i := 1 to 10 do begin
        MyProcedure(i,j,r,g,t,temp_d)
    end;
    i := 2;
    {here is the test for const}
    writeln(pi, phi);
    temp_d := pi*phi/3
end;
begin
    {below are the test for function}
    writeln('begin to test');
    MySmallProcedure();
    MyProcedure(i,j,m,b[3],str,s);
    MySmallProcedure()
end.