program Simple2DArrayExample;

var
  arr: array[1..3, 1..3] of integer;
  i, j: integer;

begin
  for i := 1 to 3 do
  begin
    for j := 1 to 3 do
    begin
      arr[i, j] := i * j
    end
  end
end.