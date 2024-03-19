program ej2;
var
  filename : string;
  voters, min, max : integer;
  myfile : File of integer;
begin
  Write('Ingrese el nombre de archivos a leer: '); ReadLn(filename);

	filename := Concat('data/',filename);

  Assign(myfile, filename);
  reset(myfile);

  min:= 32767; max:= 0;

  while not Eof(myfile) do begin
    read(myfile, voters);
    if voters > max then
      max:= voters
    else if voters < min then
      min:= voters
  end;

  WriteLn(max);
  WriteLn(min);

  close(myfile);
end.