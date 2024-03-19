program ej3;
Type
  DinosaurRecord = Record
    d_name: string;
    d_type: string;
  end;

function get_dinasour_info(var dino:DinosaurRecord): Boolean;
begin
  Write('Ingrese el nombre del dinosaurio: '); ReadLn(dino.d_name);
  if dino.d_name = 'ZZZ' then get_dinasour_info:= False
  else begin
    Write('Ingrese el tipo del dinosaurio: '); ReadLn(dino.d_type);
    get_dinasour_info := True;
  end;
end;

var
  dinosaur : DinosaurRecord;
  filename: string;
  myfile: text;
begin
  Write('Ingrese el nombre del archivo: '); ReadLn(filename);

	filename := Concat('data/',filename);
  Assign(myfile, filename);
  Rewrite(myfile);

  while get_dinasour_info(dinosaur) do begin
    WriteLn(myfile, 'Name: ' , dinosaur.d_name , ' Type: ',  dinosaur.d_type);
  end;

  close(myfile);

end.
