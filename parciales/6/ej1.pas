program ej1;
const
	valoralto = 9999;
type
	profesional = record
		DNI: integer;
		nombre: string;
		apellido: string;
	end;

	tArchivo = file of profesional;

procedure leer(var info: text; var prof: profesional);
begin
	if (not eof(info)) then
		begin
			readln(info,prof.DNI);
			readln(info,prof.nombre);
			readln(info,prof.apellido);
		end
		else
			prof.DNI := valoralto;
end;

procedure crear(var arch: tArchivo; var info: text);
var
	prof: profesional;
begin
	rewrite(arch);
	reset(info);
	prof.DNI := 0;
	prof.nombre := '';
	prof.apellido := '';

	write(arch,prof);

	leer(info,prof);
	while (prof.DNI <> valoralto) do
		begin
			write(arch,prof);
			leer(info,prof);
		end;

		close(arch);
		close(info);
end;

procedure agregar(var arch: tArchivo; p:profesional);
var
	prof, aux: profesional;
begin
	reset(arch);
	read(arch, prof);

	aux.DNI := filesize(arch);
	if (prof.DNI <> 0) then
		begin
			seek(arch, -1*prof.DNI);
			read(arch, aux);
			seek(arch, 0);
			prof.DNI := aux.DNI;
			write(arch, prof);
		end;

	seek(arch,aux.DNI);
	write(arch,p);
end;

procedure eliminar(var arch: tArchivo; DNI: integer; var bajas: text);
var
	root, aux: profesional;
begin
	reset(arch);
	read(arch,root);

	read(arch,aux);
	while (not eof(arch)) and (aux.DNI <> DNI) do
		read(arch,aux);

	if(aux.DNI = DNI) then
		begin
			seek(arch,filepos(arch)-1);
			write(arch,root);
			root.DNI := -1*(filepos(arch)-1);
			seek(arch,0);
			write(arch,root);
			append(bajas);
			writeln(bajas,aux.DNI);
			writeln(bajas,aux.nombre);
			writeln(bajas,aux.apellido);
		end;

end;

begin
	writeln('Compilo');
end.
