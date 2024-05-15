program ej1;
const
	N = 50;
	valoralto = 9999;
type
	producto = record
		codigo: integer;
		nombre: string;
		descripcion: string;
		stock: integer;
	end;

	detalle = record
		codigo: integer;
		vendido: integer;
	end;

	t_detalle = file of detalle;
	t_producto = file of producto;

	a_fdetalle = array[N] of t_detalle;
	a_detalle = array[N] of detalle;

procedure leer(var detalle: t_detalle; var det: detalle);
begin
	if (not eof(detalle)) then
		read(detalle,det)
	else
		det.codigo := valoralto;
end;

procedure minimo(var detalles: a_fdetalle; var minimos: a_detalle; var min: detalle);
var
	pos_min: integer;
begin
	min := minimos[1];
	pos_min := 1;

	for i:=2 to N do
		begin
			if (minimos[i].codigo < min.codigo) then
				begin
					min := minimos[i];
					pos_min:= i;
				end;
		end;

	Leer(detalles[pos_min],minimos[pos_min])
end;

procedure actualizar(var master: t_producto; var detalles: a_fdetalle);
var
	minimos: a_detalle;
	min: detalle;
	prod: producto;
begin
	reset(master);

	for i:=1 to N do
		begin
			reset(detalles[i]);
			read(detalles[i], minimos[i]);
		end;

  read(master,prod);
	minimo(detalles,minimos,min);
	while (min.codigo <> valoralto) do
	begin

		while(min.codigo <> prod.codigo) do
		begin
			read(master,prod);
		end;

		while (min.codigo <> valoralto) and (min.codigo = prod.codigo) do
			begin
				prod.stock := prod.stock - min.vendido;
				minimo(detalles,minimos,min);
			end;

		seek(master,filepos(master)-1),
		write(master,prod);
	end;

	close(master);
	for i:=1 to N do
		begin
			close(detalles[i]);
		end;
end;

var
	master: t_producto;
	detalles: a_fdetalle;
begin
	assign(master,'data.bin');
	for i:=1 to N do
	begin
		writeln('Ingrese el nombre del archivo: ');
		readln(nombre);
		assign(detalles[i],nombre);
	end;

	actualizar(master, detalles);
end.
