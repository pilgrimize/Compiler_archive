program finaltest2(input,output);
var 
    a : array[1..10] of byte;
    b : array[3..12] of char;
    c : array[1..12,2..30,34..35] of longint;
    d : array[10..29] of double;
    i : byte;
    j, x, y, z: integer;
    k : longint;
    l : double;
    m : char;
    s : double;
begin
    i := a[1];
    writeln('hello world!');
    read(x,y,z);
    if a[(x+y)+x*y-z div x] < 10.2 then begin
        a[(x-y)div 2-i+k*k*k div k mod i] := 214748;
        writeln(a[(x*y-2)div 2+k*i mod (i*2-3)])
    end;
    writeln(b[3]);
    read(c[3,4,5]);
    {test for assign operator for array}
    a[a[0]] := a[1];
    b[3]:='c';
    d[a[1]+1] := l+s*3/3.145;
    c[-2,4,34] := (12345 and 23 or 15 )*(34-23*71) and (231 or 4895);
    writeln((319-78*7)and 2 or (3-2+17*8*z-x*y) or (x-y+z));
    if a[c[-10,15,35]*10] <> 10 then begin
        i:= a[c[-10,15,35]*10];
        m := b[10];
        s:=d[23]
    end
end.