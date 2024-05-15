
Program ej1;

Const 
  valoralto = 9999;

Type 
  product = Record
    id: integer;
    name: string;
    description: string;
    stock: integer;
  End;

  tProduct = file Of product;

Procedure CrearArchivo(Var master: tProduct; Var carga: text);

Var 
  producto: product;
  nombre_archivo: string;
Begin
  Writeln('Ingrese el nombre del archivo con los datos: ');
  Readln(nombre_archivo);
  Assign(carga,nombre_archivo);
  Reset(carga);
  Rewrite(master);

  producto.id := -1;
  producto.name := '';
  producto.description := '';
  producto.stock := 0;

  Write(master,producto);

  While (Not eof(carga)) Do
    Begin
      ReadLn(carga,producto.id);
      ReadLn(carga,producto.name);
      ReadLn(carga,producto.description);
      ReadLn(carga,producto.stock);
      Write(master,producto);
    End;

  close(carga);

End;

Procedure Leer(Var master: tProduct; Var producto: product);
Begin
  If (Not eof(master)) Then
    read(master,producto)
  Else
    producto.id := valoralto;
End;

Procedure Borrar(Var master: tProduct; id: integer);

Var 
  producto, aux: product;
  pos: integer;
Begin
  Reset(master);
  Leer(master,producto);
  While (producto.id <> valoralto) And (producto.id <> id) Do
    Begin
      Leer(master,producto);
    End;

  If (producto.id <> valoralto) Then
    Begin
      pos := Filepos(master)-1;
      seek(master,0);
      Read(master,aux);
      producto.id := aux.id;
      producto.name := '###';
      aux.id := pos;
      seek(master,0);
      write(master,aux);
      seek(master,pos);
      write(master,producto);
    End;
End;

Var 
  master: tProduct;
  carga: text;
  cod: integer;
  producto: product;
Begin
  Assign(master,'data.bin');
  CrearArchivo(master,carga);

  reset(master);
  While (Not eof(master)) Do
    Begin
      read(master,producto);
      WriteLn(producto.id,',',producto.name,',');
    End;

  writeln('Ingrese el número del producto a borrar: ');
  read(cod);
  While (cod <> 0) Do
    Begin
      borrar(master,cod);
      writeln('Ingrese el número del producto a borrar: ');
      read(cod);
    End;

  reset(master);
  While (Not eof(master)) Do
    Begin
      read(master,producto);
      WriteLn(producto.id,',',producto.name,',');
    End;
End.
