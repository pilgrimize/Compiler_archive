program main;
var a, b, c:longint;
function fpow(x, y, m:longint):longint;
var tmp:integer;
begin
  if y=0 then
  begin
    fpow:=1;
  end
  else begin
    tmp:=fpow(x, y div 2, m);
    fpow:=(tmp*tmp) mod m;
    if y mod 2=1 then
      fpow:=fpow*x mod m;
  end;
end;
begin
  read(a,b,c);
  writeln(a,' ^ ',b,' mod ',c,' = ',fpow(a,b,c));
end.