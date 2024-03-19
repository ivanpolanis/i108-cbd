program ej4;
var 
  filename : string;
  int: Integer;
  int_file: file of Integer;
  myfile: text;
begin
  WriteLn('Ingrese el nombre del archivo a generar: '); ReadLn(filename);

  Assign(int_file, 'data/voters.dat'); Assign(myfile, filename);
  Reset(int_file); Rewrite(myfile);

  while (not eof(int_file)) do begin
    read(int_file, int);
    WriteLn(myfile, int);
  end;

  close(int_file); close(myfile);
end.