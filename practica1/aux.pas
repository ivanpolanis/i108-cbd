program aux;
var
  filename: string;
	int : integer;
	myfile : file of integer;
begin
	write('Ingrese el nombre del archivo: '); readln(filename);
	filename := Concat('data/',filename);
	assign(myfile,filename);
	rewrite(myfile);
	int := 0;


	while (int <> 10) do begin
		write('Ingrese el material: '); read(int);
		write(myfile, int);
	end;

	close(myfile);
end.