
Program ej1;

Const 
  valoralto = 9999;

Type 
  partido = Record
    codPartido: integer;
    tipoVivienda: integer;
  End;

  partido_comp = Record
    codPartido: integer;
    tipoVivienda: integer;
    cant: integer;
  End;

  f_partido = file Of partido;
  f_partido_comp = file Of partido_comp;

Procedure leer(Var archivo: f_partido; Var dato: partido);
Begin
  If (Not eof(archivo)) Then
    read(archivo, dato)
  Else
    dato.codPartido := valoralto;
End;
Procedure compactar(Var archivo: f_partido; Var output: f_partido_comp);

Var 
  dato: partido;
  aux_p: partido_comp;
  partMax, max, acum: integer;
Begin
  reset(archivo);
  rewrite(output);

  max := -1;
  leer(archivo,dato);
  While (dato.codPartido <> valoralto) Do
    Begin
      aux_p.codPartido := dato.codPartido; 
      acum := 0;
      While (dato.codPartido = aux_p.codPartido) Do
        Begin
          aux_p.tipoVivienda := dato.tipoVivienda;
          aux_p.cant := 0;
          While (dato.codPartido = aux_p.codPartido) and (dato.tipoVivienda = aux_p.tipoVivienda) Do
            Begin
              aux_p.cant := aux_p.cant + 1;
              leer(archivo,dato);
            End;
          
          write(output,aux_p);
          acum := acum + aux_p.cant;
        End;
      If (acum > max) Then
        Begin
          max := acum;
          partMax := aux_p.codPartido;
        End;
    End;

  writeln(partMax,', ',max);
  close(output);
  close(archivo);
End;

Var 
  archivo: f_partido;
  output: f_partido_comp;
  filename: string;
Begin
  writeln('Ingrese el nombre del archivo: ');
  read(filename);
  assign(archivo, filename);

  assign(output,'output.txt');

  compactar(archivo,output);
End.
