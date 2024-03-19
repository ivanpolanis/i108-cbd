program ej5;
Type
  FlowerRecord = record
    f_number: integer;
    f_max_height: integer;
    f_scientific_name: string;
    f_name: string;
    f_color: string;
  end;

  FlowerFile = File of FlowerRecord;

procedure list_species(var data_file: FlowerFile);
var
  qty:integer;
  min, max: FlowerRecord;
  flower: FlowerRecord;
begin
  reset(data_file);

  qty := 0; min.f_max_height:= 32000; max.f_max_height:=0;

  while not eof(data_file) do begin
    read(data_file, flower);
    qty:= qty + 1; 
    if(flower.f_max_height > max.f_max_height) then
      max := flower;
    if(flower.f_max_height < min.f_max_height) then
      min := flower;
  end;

  WriteLn('La cantidad de especies registrada es: ', qty);
  WriteLn('La especie que alcanza mayor altura es: ', max.f_name); 
  WriteLn('La especie que alcanza menor altura es: ', min.f_name); 

end;

procedure list_file(var data_file: FlowerFile);
var
  flower: FlowerRecord;
begin
  Reset(data_file);

  while not eof(data_file) do begin
    read(data_file, flower);
    WriteLn('Numero: ', flower.f_number, ' Nombre: ', flower.f_name, ' Nombre cientifico: ', flower.f_scientific_name, ' Color: ', flower.f_color, ' Altura maxima: ', flower.f_max_height);
  end;
end;

procedure modify_name(var data_file: FlowerFile; name, modified_name: string );
var
  flower: FlowerRecord;
begin
  Reset(data_file);

  while not eof(data_file) do begin
    read(data_file, flower);

    if (flower.f_scientific_name <> name) then continue;

    flower.f_scientific_name:= modified_name;
    seek(data_file, filepos(data_file) - 1);
    write(data_file, flower);

    Break;
  end;
end;

function read_flower(var flower: FlowerRecord): Boolean;
begin
  Write('Ingrese el nombre de la especie: ');ReadLn(flower.f_name);

  if flower.f_name = 'zzz' then read_flower:= False
  else begin
    Write('Ingrese el numero de la especie: ');ReadLn(flower.f_number);
    Write('Ingrese la altura de la especie: ');ReadLn(flower.f_max_height);
    Write('Ingrese el nombre cientifico de la especie: ');ReadLn(flower.f_scientific_name);
    Write('Ingrese el color de la especie: ');ReadLn(flower.f_color);
    read_flower:= True;
  end;
end;

procedure add_species(var data_file: FlowerFile);
var 
  flower: FlowerRecord;
begin
  Reset(data_file);
  Seek(data_file, FileSize(data_file));

  while read_flower(flower) do begin
    Write(data_file, flower);
  end;
  
end;

procedure list_into_txt(var data_file: FlowerFile);
var
  flower: FlowerRecord;
  text_file: text;
begin
  Assign(text_file, 'data/flores.txt');
  Reset(data_file); Rewrite(text_file);

  while not eof(data_file) do begin
    read(data_file, flower);
    WriteLn(text_file, 'Numero: ', flower.f_number, ' Nombre: ', flower.f_name, ' Nombre cientifico: ', flower.f_scientific_name, ' Color: ', flower.f_color, ' Altura maxima: ', flower.f_max_height);
  end;

  Close(text_file);
end;

procedure clear();
var i: integer;
begin
  for i := 0 to 20 do
    WriteLn('');
end;

function menu(var data_file: FlowerFile):integer;
var option: integer;
begin
  clear();

  WriteLn('Seleccione una opción:');
  WriteLn('1 - Reportar en pantalla las especies.');
  WriteLn('2 - Listar el contenido en pantalla.');
  WriteLn('3 - Modificar Victoria amazonia.'); 
  WriteLn('4 - Añadir más especies.');
  WriteLn('5 - Listar el archivo a un txt.');
  WriteLn('0 - Salir');

  readln(option);

  case option of
    1: list_species(data_file);
    2: list_file(data_file);
    3: modify_name(data_file, 'Victoria amazonia', 'Victoria regia');
    4: add_species(data_file);
    5: list_into_txt(data_file);
    0: menu:=0;
  end;

  menu:=option;
end;

var
  data_file: FlowerFile;
  text_file: text;
begin
  Assign(data_file, 'data/flores.dat');
  Rewrite(data_file);

  add_species(data_file);

  while menu(data_file) <> 0 do begin
    WriteLn;
    WriteLn('Presione enter para continuar.');
    ReadLn 
  end;

  Close(data_file); 
end.