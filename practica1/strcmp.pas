program strcmp;
function strcmp(str1,str2: string): integer;
var len,i,diff: integer;
begin
  if Length(str1) > Length(str2) then
    len := Length(str2)
  else
    len := Length(str1);

  diff := 0;
  i:=1;

  while (diff = 0) and (i<=len) do begin
    diff := integer(str1[i]) - integer(str2[i]);
    i := i + 1;
  end;

  if (diff = 0) and (Length(str1) <> Length(str2)) then
    if Length(str1) > Length(str2) then
      diff := 1
    else
      diff := -1;

  strcmp:=diff;
end;
var
  i: integer;
begin

Write(strcmp('hola','holaaa'));
  
end.