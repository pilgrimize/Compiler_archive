program test(input,output);
var
  i, j: double;
  k: integer;
  a: array [1..10, 2..7] of integer;
begin
  a[1] := 1;
  a[1, 2] := 2;
  a[1, 2, 3] := 3;
  a[i, j] := 2;
  a[k, k] := 3;
  a[a[k, k], a[k, 2]] := 4;
  a := 1;
end.