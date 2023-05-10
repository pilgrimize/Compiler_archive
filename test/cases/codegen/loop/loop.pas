program main;
const a1=5;
var a:array [2..100, 3..4, 0..9] of integer;
	i, j, k:integer;
begin
	for i:=2 to 100 do begin
		for j:=3 to 3 do begin
			for k:=2 downto 0 do begin
				a[i,j,k] := i*j*k;
			end
		end
	end;
	write(a[0, 3, 1])
end.
