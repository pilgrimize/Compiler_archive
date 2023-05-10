program finaltest1(input,output);
var 
    x,y:integer;
    z,w:double;
    str:string;
    c:char;
begin
    read(x,y,z,w);
    str := '12345$#@&';
    c := 'c';
    x :=  not not not(------5); {multiple not and multiple minus}
    y := x and (-123);
    z := -----3.23344;
    if x < 0.3*0.4-(2*(2+3-2.3))*0.3 then begin
        w := (0.2-x)*2+(x mod 10)div 2+0.4*((2+3-24.3123)*((31.324-234.12)/(23.1-23.4)))
    end;
    writeln((x-y)/z*w/2.0+1.334-3.231);
    writeln(x,'temp',y,w,z,'temp');
    writeln('hello world!');
    writeln('for test 123 $%*&*@#!');
end.