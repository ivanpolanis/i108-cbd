program ej1;

const
	valoralto=9999;
type
	excursion=record
		codigo: integer;
		nombre: string;
		descripcion: string;
		cant_vendida: integer;
	end;

	t_excursion= file of excursion;

procedure leer(var archivo: text; var exc: excursion);
begin
	if (not eof(archivo)) then
		begin
		readln(archivo,exc.codigo);
		readln(archivo,exc.nombre);
		readln(archivo,exc.descripcion);
		readln(archivo,exc.cant_vendida);
		end
	else
		exc.codigo := valoralto;
end;

procedure CrearBinario(var archivo: t_excursion; var texto: text);
var
	exc, aux: excursion;
begin
	reset(texto);
	rewrite(archivo);

	leer(texto,exc);

	while(exc.codigo <> valoralto) do
		begin
			aux := exc;
			leer(texto,exc);
			while (exc.codigo <> valoralto) and (aux.codigo = exc.codigo) do
				begin
					aux.cant_vendida := aux.cant_vendida + exc.cant_vendida;
					leer(texto,exc);
				end;

			write(archivo,aux);

		end;

end;

var
	archivo: t_excursion;
	texto: text;
begin

	assign(archivo,'data.bin');
	assign(texto,'data.txt');

	CrearBinario(archivo,texto);

	close(archivo);
	close(texto);
end.
