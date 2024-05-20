program ej1;
const
	valoralto = 9999;
type
	tVta = record
		codSuc: word;
		idAutor: longword;
		isbn: longword;
		idEj: word;
	end;

	tArchVtas = file of tVta;

procedure leer(var ventas: tArchVtas; var venta: tVta);
begin
	if (not eof(ventas)) then read(ventas,venta)
	else venta.codSuc := valoralto;
end;

procedure totalizar(var ventas: tArchVtas; nombre: string);
var
	act, aux : tVta;
	reporte: text;
	vTotal, vSucursal, vAutor, vLibros : integer;
begin
	reset(ventas);
	assign(reporte, nombre);
	rewrite(reporte);

	vTotal := 0;
	leer(ventas, act);
	while(act.codSuc <> valoralto) do begin
		aux := act;
		vSucursal := 0;
		writeln(reporte,'Codigo de sucursal: ',aux.codSuc);
		while(act.codSuc = aux.codSuc) do begin
			aux.idAutor := act.idAutor;
			writeln(reporte,'Identificación del autor: ',aux.idAutor);
			vAutor := 0;
			while (act.codSuc = aux.codSuc) and (act.idAutor = aux.idAutor) do begin
				aux.isbn := act.isbn;
				vLibros := 0;
				while (act.codSuc = aux.codSuc) and (act.idAutor = aux.idAutor) and (act.isbn = aux.isbn) do begin
					vLibros := vLibros + 1;
					leer(ventas,act);
				end;
				writeln(reporte,'ISBN: ',aux.isbn,'Total de ejemplares vendidos del libro: ', vLibros);
				vAutor := vAutor + vLibros;
			end;
			writeln(reporte,'Total de ejemplares vendidos del autor: ', vAutor);
			vSucursal := vSucursal + vAutor;
		end;
		writeln(reporte,'Total de ejemplares vendidos en la sucursal: ', vSucursal);
		vTotal := vTotal + vSucursal;
	end;
	cloase(ventas); close(reporte);
end;

begin
end.
