program main;
var a, b, c, x, y:longint;
procedure exgcd(a, b, c:longint; var x, y:longint);
var x1, y1:longint;
begin
  if b=0 then
  begin
    if c mod a <> 0	then
    begin
      x:=0;
      y:=0;
    end
    else begin
      x:=c div a;
      y:=0;
    end;
  end
  else begin
    exgcd(b, a mod b, c, x, y);
    if (x<>0) or (y<>0) then
    begin
      x1:=x;
      y1:=y;
      x:=y1;
      y:=x1-(a div b)*y1;
    end;
  end;
end;
begin
  {please enter a,b,c which are all non-zero and not too big.}
  read(a, b, c);
  exgcd(a, b, c, x, y);
  if (x=0) and (y=0) then begin
    writeln('No solution');
  end
  else
  begin
    writeln('x=', x, ', y=', y);
    writeln(a,' * ',x,' + ',b,' * ',y,' = ',c);
  end
end.