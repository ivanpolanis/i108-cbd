program ej10;
uses sysutils;
const
  eof_value = 9999;
  N = 3;
type
  tProducto = record 
    codigo: integer;
    nombre: string;
    descripcion: string;
    precio: real;
    cant_vendida: integer;
    mayor_cv: integer;
  end;

  tDetalle = record
    codigo: integer;
    cantidad: integer;
  end;

  tMaster = file of tProducto;
  tFDetalle = file of tDetalle;
  tAFDetalle = Array[1..N] of tFDetalle;
  tADetalle = Array[1..N] of tDetalle;

procedure leer(var a_detalle: tFDetalle; var detalle: tDetalle);
begin
  if not eof(a_detalle) then begin
    read(a_detalle, detalle);
    WriteLn('code:',detalle.codigo);
  end
  else 
    detalle.codigo := eof_value;
end;

function determinar_minimo(var minimos: tADetalle): integer;
var min, min_index, i: integer;
begin
  min := minimos[1].cantidad; 
  min_index := 1;
  for i:=2 to N do
    begin
      if min > minimos[i].cantidad then begin
        min := minimos[i].cantidad;
        min_index := i;
      end;
    end;

  determinar_minimo := min_index;
end;

procedure minimo(var detalles: tAFDetalle; var minimos: tADetalle; var min: tDetalle);
var indice: integer;
begin
  indice := determinar_minimo(minimos);

  min :=  minimos[indice];

  leer(detalles[indice], minimos[indice]);
end;

var
  maestro : tMaster;
  archivos_detalle: tAFDetalle;
  detalles: tADetalle;
  prod: tProducto;
  aux, min: tDetalle;
  i: integer;
begin

  Assign(maestro, 'data/10/master.dat');
  Reset(maestro);
  if not eof(maestro) then read(maestro, prod);

  for i:= 1 to N do
    begin
      Assign(archivos_detalle[i], concat('data/10/det',IntToStr(i),'.dat'));
      Reset(archivos_detalle[i]);
      leer(archivos_detalle[i],detalles[i]);
    end;
  
  minimo(archivos_detalle,detalles,min);

  while min.codigo <> eof_value do 
  begin
    aux:= min; 
    WriteLn('Producto:',min.codigo);
    while min.codigo <> prod.codigo do begin
      read(maestro, prod);
    end;
    WriteLn('Producto:',prod.nombre, 'Code:', prod.codigo, 'cant:',prod.cant_vendida);

    while min.codigo = aux.codigo do
      begin
        prod.cant_vendida := prod.cant_vendida + min.cantidad;
        if prod.mayor_cv < min.cantidad then WriteLn('Se vendio caleta.');
        minimo(archivos_detalle,detalles,min);
      end;
    
    Seek(maestro,FilePos(maestro) - 1);
    Write(maestro, prod);
  end;

  close(maestro);
  for i:= 1 to N do
    close(archivos_detalle[i]);
end.