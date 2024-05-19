program ej1;
const
	valoralto = 9999;
	N = 8;
type
	producto = record
		codigo: integer;
		nombre: string;
		descripcion: string;
		precio: real;
		cant_vendida: integer;
		max_cant_vendida: integer;
	end;

	detalle = record
		codigo: integer;
		cant_vendida: integer;
	end;

	t_producto = file of producto;
	t_detalle = file of detalle;

	a_fdetalle = array[1..N] of t_detalle;
	a_detalle = array[1..N] of detalle;

procedure leer(var archivo: t_detalle; prod: detalle);
begin
	if (not eof(archivo)) then
		begin
			read(archivo, prod);
		end
		else
			prod.codigo := valoralto;
end;

procedure minimo(var detalles: a_fdetalle; var minimos: a_detalle; var min: detalle);
var
	prod_min, i: integer;
begin
	min := minimos[1];
	prod_min := 1;

	for i:=2 to N do
		begin
			if (minimos[i].codigo < min.codigo) then begin
				min := minimos[i];
				prod_min := i;
			end;
		end;

	leer(detalles[prod_min], minimos[prod_min]);
end;

procedure actualizar(var master: t_producto; var detalles: a_fdetalle);
var
	minimos: a_detalle;
	min: detalle;
	prod: producto;
	aux_max, i: integer;
begin

	reset(master);

	for i:=1 to N do
		begin
			reset(detalles[i]);
			leer(detalles[i],minimos[i]);
		end;


	minimo(detalles, minimos, min);

	read(master,prod);

	while (min.codigo <> valoralto) do
		begin

			while (min.codigo <> prod.codigo) do
				read(master, prod);

			aux_max := 0;

			while (min.codigo = prod.codigo) do
				begin
					prod.cant_vendida := prod.cant_vendida + min.cant_vendida;
					if (aux_max < min.cant_vendida) then
						aux_max := min.cant_vendida;
					minimo(detalles, minimos, min);
				end;

			if (aux_max > prod.max_cant_vendida) then
				begin
					Writeln(prod.codigo,':  ',prod.nombre,' ',prod.max_cant_vendida);
					Writeln(aux_max);
					prod.max_cant_vendida := aux_max;
				end;

			seek(master, filepos(master)-1);
			write(master,prod);
		end;

		close(master);
		for i:=1 to N do
			close(detalles[i]);
end;

var
	master: t_producto;
	detalles: a_fdetalle;
	filename: string;
	i: integer;
begin

	assign(master,'data.bin');
	for i:=1 to N do
		begin
			writeln('Ingrese el nombre del archivo detalle nro (',i,'): ');
			readln(filename);
			assign(detalles[i],filename);
		end;

	actualizar(master,detalles);
end.
