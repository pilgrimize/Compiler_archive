program main;
	var x, y:longint;
	procedure exgcd(a, b, c:longint;var x, y:longint);
	var x1, y1:longint;
	begin
		if b=0 then
		begin
			if c mod a <> 0	then
			begin
				x:=-1;
				y:=-1;
			end
			else begin
				x:=c div a;
				y:=0;
			end;
		end
		else begin
			exgcd(b, a mod b, c, x, y);
			if x<>-1 then
			begin
				x1:=x;
                y1:=y;	{b*x1 + (a-(a/b)*b)*y1 = c}
				x:=y1;
				y:=x1-(a div b)*y1;
			end;
		end;
	end;
	begin
		exgcd(23, 74-37, 17+2, x, y);
		writeln(x, ' ', y);
	end.