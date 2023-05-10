program main;
var
  n,i:longint;
  a:array[0..10000] of longint;
procedure quick_sort(l,r:longint);
var
  i,j,mid:longint;
begin
  if l<r then begin
    i:=l;j:=r;mid:=a[(l+r) div 2];
    repeat
      while a[i]<mid do i:=i+1;
      while a[j]>mid do j:=j-1;
      if i<=j then
      begin
        a[0]:=a[i];
        a[i]:=a[j];
        a[j]:=a[0];
        i:=i+1;
        j:=j-1;
      end;
    until i>j;
    quick_sort(l,j);
    quick_sort(i,r);
  end;
end;
begin
  readln(n);
  for i:=1 to n do
    read(a[i]);
  quick_sort(1,n);
  for i:=1 to n do
    write(a[i], ' ');
end.