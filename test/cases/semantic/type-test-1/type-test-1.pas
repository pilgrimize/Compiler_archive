program test;
var a,b:longint;
  c:double;
  s:string;
  p:char;
  d: byte;
begin
  s := '1234';
  p :='a';
  s := p;
  p := s;
  c := a;
  a := c;
  c := s;
  d := a;
  a := b + d;
  d := 1;
  b := 0.1;
  writeln(a,b,s,p)
end.