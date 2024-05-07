program ej3;
const
  eof_value = 9999;
  N = 20;
type
  detalle = record
    id: integer;
    numero: integer;
    cantidad: integer;
  end;
  calzado = record
    id: integer;
    numero: integer;
    stock: integer;
    descripcion: string;
    precio: integer;
    color: string;
  end;
  fCalzado = file of calzado;
  fDetalle = file of detalle;
  array_file_detalle = array [1..N] of fDetalle;
  array_detalle = array [1..N] of detalle;

procedure read_file(var detalle_f: fDetalle; var deta: detalle);
begin
  if not eof(detalle_f) then read(detalle_f,deta)
  else deta.id := eof_value;
end;

function determinarMinimo(detalles: array_detalle): integer;
var i: integer; aux_min, aux_ind: integer;
begin
  aux_min := detalles[1].id; aux_ind:= 1;
  for i:=2 to N do begin
    if(detalles[i].id < aux_min) then begin
      aux_min:= detalles[i].id; aux_ind:=i;
    end;
  end;
  determinarMinimo:=aux_ind;
end;

procedure minimo(var detalle_f:array_file_detalle; var min: detalle; var detalles: array_detalle);
var indice: integer;
begin
  indice := determinarMinimo(detalles);

  min := detalles[indice];

  read_file(detalle_f[indice],detalles[indice]);
end;

var 
  master_file: fCalzado;
  detalles_f: array_file_detalle;
  calz: calzado;
  detalles:array_detalle;
  min: detalle;
  i, aux: integer;
  filename: string;
begin


  for i:=1 to N do begin
    Str(i,filename);
    filename:=Concat('data/3/detalle',filename,'.dat');
    Assign(detalles_f[i], filename); Reset(detalles_f[i]);
    read_file(detalles_f[i],detalles[i]);
  end;

  Assign(master_file,'data/3/master.dat'); Reset(master_file);

  minimo(detalles_f,min,detalles);

  if not eof(master_file) then read(master_file,calz);
  
  while min.id <> eof_value do begin
    aux := min.id;
    while min.id <> calz.id do read(master_file,calz);
    while aux = min.id do begin
      calz.stock := calz.stock - min.cantidad;
      minimo(detalles_f, min, detalles);
    end;
    seek(master_file,FilePos(master_file)-1);
    write(master_file,calz);
  end;
  close(master_file);
  for i := 1 to N do begin
    close(detalles_f[i]);
  end;

end.