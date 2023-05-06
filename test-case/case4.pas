program test(a,b);
var
	a:array[0..10] of integer;
	procedure quick (first, last, counter: integer);
	var i, k, x : integer;
	begin
	   i := first;
	   k := last;
	   x := a[(i+k) div 2];
	   counter := counter + 1;
	   while i<=k do begin
			while a[i] < x do
			   i:= i+1;
			while a[k] > x do
			   k:= k-1;
			if i<=k then begin
				prohod(i,k);
				i:=i+1;
				k:=k-1
			end
		end;
		repeat 
			a := a + 1;
			port(aa,aa,b)
		until a = 10;
		for 
	   if first<k then quick(first,k, counter);
	   if i<last then quick(i,last, counter);
	   P:= P + counter
	end;
begin
	quick(1,2,b)
end.