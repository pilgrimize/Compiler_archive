program finaltest4(input,output);
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
{here is simple test for function}
function MySmallFunction:char;
const ch = 'a';
begin
    MySmallFunction := ch
end;
{here is complex test for function}
function MyFunction(i,j:integer;var a,b:char;var s:string;var d:double):integer;
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
    writeln(d,c[1,3,34]);
    a := 'a';
    b := a;
    if (b='c') then begin
        i := (p-q)*(i+j);
        d := d*i/23-1.1415926;
        writeln(a,b,i,j);
        {here is test for seting of return value }
        MyFunction := (q-p*2)*(i-j*p div q)
    end;
    {here is test for internal function call}
    MyFunction := i+j + MyFunction(i,j,a,b,s,d);
    s := 'This is a string';
    m := 'm';
    k := 3924525;
    for i := 1 to 10 do begin
        k := k*i + MyFunction(i,j,r,g,t,temp_d);
        writeln(k)
    end;
    i := 2;
    {here is the test for const}
    writeln(pi, phi);
    temp_d := pi*phi/3
end;
begin
    {here is the basical test for array}
	writeln('begin to test');
    i := a[1];
    read(x,y,z);
    if a[(x+y)mod z+x*y-z div x] < 10.2 then begin
        a[(x-y)div 2-i+k*k*k div k mod i] := 214748;
        writeln(a[(x*y-2)div 2+k*i mod (i*2-3)])
    end;
    writeln(b[3]);
    read(c[3,4,5]);
    
    {below are the test for function}
    i := (MyFunction(x,y,b[4],b[5],str,d[28])+a[0]) div 10;
    if (MyFunction(x,z,b[2],b[8],str,s) = 1+(a[129]*a[a[3]])) then begin
        writeln(MyFunction(y,z,b[8],b[6],str,l));
        b[3] := MySmallFunction();
        b[4] := MySmallFunction();
        b[9] := MySmallFunction();
        if MySmallFunction = 'a' then writeln('correct')
    end
end.