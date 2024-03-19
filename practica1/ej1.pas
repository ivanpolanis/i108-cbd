program ej1;
var
  filename, material : string;
	myfile : text;
begin
	write('Ingrese el nombre del archivo: '); readln(filename);
	filename := Concat('data/',filename);
	assign(myfile,filename);
	rewrite(myfile);

	material:= '';

	while (material <> 'cemento') do begin
		write('Ingrese el material: '); readln(material);
		writeln(myfile, material);
	end;

	close(myfile);
end.