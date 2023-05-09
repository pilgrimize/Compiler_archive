program finaltest3(input,output);
var 
    a : array[1..10] of byte;
    b : array[3..12] of char;
    c : array[1..12,2..30,34..55] of longint;
    d : array[10..29] of double;
    i : byte;
    j, x, y, z: integer;
    k : longint;
    m : char;
    s, l: double;
    t : single;
begin
	writeln('begin to test');
    i := a[1];
    read(x,y,z);
    k := c[x,y,z] + a[4]*a[3]-a[2]+i mod a[2]+k*c[10,23,35];
    s := t* c[10,2,a[3]] / d[10] + d[a[c[-2,4,34]]] * c[10,2,39] / t + a[2]/x+a[3]/5*2.3-3.1+2.3*4.5;
    j := (x div 2)*y*z+i-2*32-j*(a[4]-a[3]) mod 2;
    l := s + 2.3*4.5;
    if ((x = c[a[0],a[1],a[3]]) or ((y-x+z*z mod x*(y-x*(y-321) div z)) <> ((12-321)*(y-x+z) div (3-12*z))) and ((y-x*z) < (x div y+z*z div 2))) then begin
        writeln(l,i,j,k)
    end;
    if (((y-x)<>(12*34-34*x+a[a[a[0]]])) and ((x-89+x div 2 mod 4)> a[2]) or (a[i] > a[x]+a[y])) then begin
        if (a[i-j+x]>a[x+y-z]+2) then begin
            if a[i] = a[j] then write(i,j)
        end
    end
end.