program test(input,output);
var
  i, j: integer;
function F(i, j: integer): integer;
const F = 'K';
var a: array [1..10] of integer;
begin
  F := i;
  i := F(i, j);
  F := a[j];
  i := F(a[k]);
end;
begin
end.