program ej1;
const
	valoralto = 9999;
	N = 5;
type
	tDetalle = record
		cod: integer;
		vendido: integer;
	end;

	tProducto = record
		cod: integer;
		nombre: string;
		descripcion: string;
		stock: integer;
	end;

	tArchProd = file of tProducto;
	tArchDet = file of tDetalle;

	arrArchDet = array[1..N] of tArchDet;
	arrDet = array[1..N] of tDetalle;

procedure leer(var archivo: tArchDet; var detalle: tDetalle);
begin
	if (not eof(archivo)) then read(archivo,detalle)
	else detalle.cod := valoralto;
end;

procedure minimo(var archivos: arrArchDet; var minimos: arrDet; var min);
var
	pos_min, i : integer;
begin
	min := minimos[1];
	pos_min := 1;
	for i:=2 to N do begin
		if (minimos[i].cod < min.cod) then begin
			min := minimos[i];
			pos_min := i;
		end;
	end;

	leer(archivos[pos_min],minimos[pos_min]);
end;

procedure actualizar(var maestro: tArchProd; var detalles: arrArchDet);
var
	i: integer;
	minimos: arrDet;
	min: detalle;
	producto: tProducto;
begin
	reset(maestro);
	for i:=1 to N do begin
		reset(detalles[i]);
		read(detalles[i],minimos[i]);
	end;

	read(maestro,producto);
	minimo(detalles,minimos,min);
	while (min.cod <> valoralto) do begin
		while (producto.cod <> min.cod) do read(maestro,producto);

		while (min.cod = producto.cod) do begin
			producto.stock := producto.stock - min.vendido;
			minimo(detalles,minimo,min);
		end;

		seek(maestro, filepos(maestro) - 1);
		write(maestro, producto);
	end;

	close(maestro);
	for i:=1 to N do close(detalles[i]);
end;
begin
end.
