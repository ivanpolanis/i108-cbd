
Program ej1;

Const
  valoralto = 9999;
  N = 20;

Type
  detalle = Record
    anio: integer;
    mes: integer;
    dia: integer;
    c_marca: integer;
    c_modelo: integer;
    nombre_marca: string;
    nombre_modelo: string;
    color: string;
    dni: integer;
    monto: real;
  End;

  informe = Record
    anio: integer;
    mes: integer;
    dia: integer;
    monto: real;
    cant: integer;
  End;

  reg = Record
    c_marca: integer;
    c_modelo: integer;
    nombre_marca: string;
    nombre_modelo: string;
    nombre_modelo_max: string;
    max: integer;
    nombre_modelo_min: string;
    min: integer;
  End;

  f_detalle = file Of detalle;
  f_informe = file Of informe;

  a_f_detalle = array[1..N] Of f_detalle;
  a_detalle = array[1..N] Of detalle;

Procedure leer(Var arch: f_detalle; Var det: detalle);
Begin
  If (Not eof(arch)) Then
    read(arch,det)
  Else
    det.anio := valoralto;
End;

Procedure minimo(Var archivos: a_f_detalle; Var minimos: a_detalle; Var min: detalle);

Var
  i, pos_min: integer;
Begin
  min := minimos[1];
  pos_min := 1;

  For i:=2 To N Do
    Begin
      If (minimos[i].anio < min.anio) Or ((minimos[i].anio = min.anio) And (minimos[i].mes < min.mes)) Or ((minimos[i].anio = min.anio) And (minimos[i].mes = min.mes) And (minimos[i].dia < min.dia))
         Or ((minimos[i].anio = min.anio) And (minimos[i].mes = min.mes) And (minimos[i].dia = min.dia) And (minimos[i].c_marca < min.c_marca)) Or ((minimos[i].anio = min.anio) And (minimos[i].mes =
         min.mes) And (minimos[i].dia = min.dia) And (minimos[i].c_marca = min.c_marca) And (minimos[i].c_modelo < min.c_modelo)) Then
        Begin
          min := minimos[i];
          pos_min := i;
        End;
    End;

  leer(archivos[pos_min],minimos[pos_min]);
End;

Procedure crear(Var maestro: f_informe; Var detalles: a_f_detalle);

Var
  minimos : a_detalle;
  min: detalle;
  inf: informe;
  i, ventas: integer;
  monto: real;
  registro: reg;
  arch_reg: text;

Begin
  rewrite(maestro);
  rewrite(arch_reg);
  assign(arch_reg,'output.txt');
  For i:=1 To N Do
    Begin
      reset(detalles[i]);
      leer(detalles[i],minimos[i]);
    End;

  minimo(detalles,minimos,min);

  While (min.anio <> valoralto) Do
    Begin
      inf.anio := min.anio;
      While (min.anio = inf.anio) Do
        Begin
          inf.mes := min.mes;
          inf.monto := 0;
          inf.cant := 0;
          While (min.anio = inf.anio) And (min.mes = inf.mes) Do
            Begin
              inf.dia := min.dia;

              While (min.anio = inf.anio) And (min.mes = inf.mes) And (min.dia = inf.dia) Do
                Begin
                  registro.c_marca := min.c_marca;
                  registro.nombre_marca := min.nombre_marca;
                  registro.min := 9999;
                  registro.max := 0;

                  While (min.anio = inf.anio) And (min.mes = inf.mes) And (min.dia = inf.dia) And (min.c_marca = registro.c_marca) Do
                    Begin
                      ventas := 0;
                      registro.c_modelo := min.c_modelo;
                      registro.nombre_modelo := min.nombre_modelo;

                      While (min.anio = inf.anio) And (min.mes = inf.mes) And (min.dia = inf.dia) And (min.c_marca = registro.c_marca) And (min.c_modelo = registro.c_modelo) Do
                        Begin
                          ventas := ventas + 1;
                          inf.monto := inf.monto + min.monto;
                          minimo(detalles,minimos,min);
                        End;

                      If (ventas < registro.min) Then
                        Begin
                          registro.min := ventas;
                          registro.nombre_modelo_min := registro.nombre_modelo;
                        End;
                      If (ventas > registro.max) Then
                        Begin
                          registro.max := ventas;
                          registro.nombre_modelo_max := registro.nombre_modelo;
                        End;

                      inf.cant := inf.cant + ventas;
                    End;
                  writeln(arch_reg, registro.nombre_marca, ':');
                  writeln(arch_reg,'Modelo más vendido: ', registro.nombre_modelo_max, ', unidades: ', registro.max);
                  writeln(arch_reg,'Modelo menos vendido: ', registro.nombre_modelo_min, ', unidades: ', registro.min);

                End;


            End;

          write(maestro, inf);
        End;
    End;

  close(maestro);
  For i:=1 To N Do
    close(detalles[i]);
  close(arch_reg);
End;

Var
  master: f_informe;
  detalles: a_f_detalle;
  filename: string;
  i: integer;
Begin
  assign(master,'data.bin');
  For i:=1 To N Do
    Begin
      writeln('Ingrese el nombre del archivo: ');
      readln(filename);
      assign(detalles[i],filename);
    End;

  crear(master,detalles);
End.
