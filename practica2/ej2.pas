program ej2;
const
  eof_value = 9999;
type
  tCD =  Record 
    author_id: integer;
    author_name: string;
    name: string;
    genre: string;
    qty: integer;
  end;
  fCD = file of tCD;

procedure read_file(var cd_file: fCD; var cd: tCD);
begin
  if not eof(cd_file) then read(cd_file,cd)
  else cd.id:=eof_value;
end;
var
  cd_file = fCD;
  cd_text = text;
  cd = tCD;
  prev_cd = tCD;
  tot_g, tot_a: integer;
begin
  Assign(cd_file, 'data/2/data.dat'); Assign(cd_text, 'data/2/output.txt');

  Reset(cd_file); Rewrite(cd_text);

  read_file(cd_file,cd);

  while(cd.author_id <> eof_value) do begin
    WriteLn('Autor: ', cd.author_name);
    WriteLn(cd_text,'Autor: ', cd.author_name);
    tot_a:=0;
    prev_cd := cd;
    while(cd.author_id = prev_cd.author_id) do begin
      WriteLn('Genero: ', cd.genre);
      WriteLn(cd_text,'Genero: ', cd.genre);
      tot_g:= 0;
      while (cd.genre = prev_cd.genre) and (cd.author_id = prev_cd.author_id) do begin
        tot_g:= tot_g + 1;
        tot_a:= tot_a + 1;
        WriteLn('Nombre de disco: ', cd.name, 'cantidad vendida: ', cd.qty);
        WriteLn(cd_text,'Nombre de disco: ', cd.name, 'cantidad vendida: ', cd.qty);
        read_file(cd_file,cd)
      end;
      WriteLn('Total genero: ', tot_g);
      WriteLn(cd_text,'Total genero: ', tot_g);
    end;
    WriteLn('Total autor: ', tot_a);
    WriteLn(cd_text,'Total autor: ', tot_a);
  end;

  Close(cd_file); Close(cd_text);
end.