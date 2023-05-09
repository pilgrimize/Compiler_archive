program finaltest6(input,output);
var 
    x,y,i,j:integer;
    z,w:double;
    str:string;
    c:char;
begin
    {here is test for readln read write writeln}
    writeln('begin to test');
    read(x,y,z,w);
    readln(str);
    readln(c);
    write(x,y,'test for write',z);
    writeln('123');
    {here is test for if else}
    if x>y then
        writeln(x)
    else if x >z then 
        writeln(y)
    else if x> w then
        writeln(z)
    else begin 
        writeln(w);
        writeln(x)
    end;
    
    {here is test for for ... to do and for... downto ... do}
    for i:=1 to 10 do begin 
        writeln(i);
        z := z+i*x;
        if x> w then
            writeln(z)
        else begin 
            writeln(w);
            writeln(x)
        end
    end;
    for i:=(x*y-2)div 3 downto -(x*y) do begin 
        writeln(j);
        z:=z*i-x
    end;

    repeat
        for i:=x mod y to x*y do begin
            z:=z+8*i;
            writeln(i)
        end;
        writeln(i)
    until (i<>(j-8)div 2)
end.