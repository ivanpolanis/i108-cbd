
Program ej2;

Type 
  tVehiculo = Record
    codigoVehiculo: integer;
    patente: String;
    motor: String;
    cantidadPuertas: integer;
    precio: real;
    descripcion: String
  End;
  tArchivo = File Of tVehiculo;

Procedure agregar(Var master: tArchivo; vehiculo: tVehiculo);

Var aux: vehiculo;
  pos, code: integer;
Begin
  reset(master);
  If (Not eof(master)) Then
    Begin

      read(master,aux);
      Val(aux.descripcion, pos, code);
      If (pos <> 0) Then
        Begin
          Seek(master, pos);
          Read(master, aux);
          Seek(master, 0);
          Write(master, aux);
          Seek(master, pos);
        End
      Else
        Begin
          Seek(master, FileSize(master));
        End;
      Write(master, vehiculo);

    End;

End;

Procedure dar_baja(Var master: tArchivo; codigoVehiculo: integer);

Var aux, vehiculo: tVehiculo;
  pos: integer;
Begin
  Reset(master); read(master, aux);
  vehiculo.codigoVehiculo := 0;
  While (Not eof(master) And codigoVehiculo <> vehiculo.codigoVehiculo)  Do
    read(master, vehiculo);

  If (codigoVehiculo = vehiculo.codigoVehiculo) Then
    Begin
      pos := FilePos(master) - 1;
      Seek(master, pos);
      Write(master, aux);
      Str(pos, vehiculo.descripcion);
      Seek(master, 0); Write(master, vehiculo);
    End;

    close(master);
End;

Var 
Begin

End.
