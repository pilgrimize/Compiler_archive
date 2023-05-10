program test(input,output);
var
  i, j: integer;
  k: double;
function F(i, j: integer): integer;
const F = 'K';
var a: array [1..10] of integer;
begin
  F := F * F(1);
  F := F(1.0, 2);
  F := F(1, 2);
  a[F] := F(F, F(F, F));
  F := F(k, 1);
end;
procedure G();
begin
end;
begin
  G();
  G;
  F;
end.