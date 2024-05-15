
Program ej1;

Const 
  N = 50;
  valoralto = 9999;

Type 
  producto = Record
    codigo: integer;
    nombre: string;
    descripcion: string;
    stock: integer;
  End;

  detalle = Record
    codigo: integer;
    vendido: integer;
  End;

  t_detalle = file Of detalle;
  t_producto = file Of producto;

  a_fdetalle = array[1..N] Of t_detalle;
  a_detalle = array[1..N] Of detalle;

Procedure leer(Var detalle: t_detalle; Var det: detalle);
Begin
  If (Not eof(detalle)) Then
    read(detalle,det)
  Else
    det.codigo := valoralto;
End;

Procedure minimo(Var detalles: a_fdetalle; Var minimos: a_detalle; Var min: detalle);

Var 
  pos_min,i: integer;
Begin
  min := minimos[1];
  pos_min := 1;

  For i:=2 To N Do
    Begin
      If (minimos[i].codigo < min.codigo) Then
        Begin
          min := minimos[i];
          pos_min := i;
        End;
    End;

  Leer(detalles[pos_min],minimos[pos_min])
End;

Procedure actualizar(Var master: t_producto; Var detalles: a_fdetalle);

Var 
  minimos: a_detalle;
  min: detalle;
  prod: producto;
	i:integer;
Begin
  reset(master);

  For i:=1 To N Do
    Begin
      reset(detalles[i]);
      read(detalles[i], minimos[i]);
    End;

  read(master,prod);
  minimo(detalles,minimos,min);
  While (min.codigo <> valoralto) Do
    Begin

      While (min.codigo <> prod.codigo) Do
        Begin
          read(master,prod);
        End;

      While (min.codigo <> valoralto) And (min.codigo = prod.codigo) Do
        Begin
          prod.stock := prod.stock - min.vendido;
          minimo(detalles,minimos,min);
        End;

      seek(master,filepos(master)-1);
      write(master,prod);
    End;

  close(master);
  For i:=1 To N Do
    Begin
      close(detalles[i]);
    End;
End;

Var 
  master: t_producto;
  detalles: a_fdetalle;
	i: integer;
	nombre: string;
Begin
  assign(master,'data.bin');
  For i:=1 To N Do
    Begin
      writeln('Ingrese el nombre del archivo: ');
      readln(nombre);
      assign(detalles[i],nombre);
    End;

  actualizar(master, detalles);
End.
