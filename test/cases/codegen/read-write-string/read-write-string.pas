program main;
var 
    x,y,i,j:integer;
    z,w:double;
    str:string;
    c:char;
begin
    read(x,y,z,w);
    readln(str);
    readln(c);
    if x>y then
        writeln(x)
    else if x >z then 
        writeln(y)
    else if x> w then
        writeln(z);
    repeat
        for i:=x mod y to x*y do begin
            z:=z+8*i;
            writeln(i)
        end;
        writeln(i)
    until (i<>(j-8)div 2);
    write(x,y,'test for write',z);
end.