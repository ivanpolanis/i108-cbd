
Program ej1;

Type 
  str20 = string[20];
  tPlant = Record
    code: integer;
    name: str20;
    s_name: str20;
    height: real;
    description: string[200];
    zone: str20;
  End;

  fPlant = file Of tPlant;

Procedure compact(Var master: fPlant);

Var 
  plant: tPlant;
  compacted: fPlant;
Begin
  Assign(compacted, 'data/1/compacted.dat');
  Rewrite(compacted);
  While ( Not eof(master)) Do
    Begin
      Read(master, plant);
      If (plant.code <> 0) Then Write(compacted,plant);
    End;
End;

Procedure soft_delete(Var master: fPlant; code: integer);

Var plant: tPlant;
Begin
  Reset(master);
  plant.code := 0;
  While ( Not eof(master) And (code <> plant.code)) Do
    read(master, plant);

  If (code = plant.code) Then
    Begin
      plant.code := 0;
      Seek(master, FilePos(master) - 1);
      Write(master, plant);
    End;

End;

Procedure hard_delete(Var master: fPlant; code: integer);

Var plant: tPlant;
  pos: integer;
Begin
  Reset(master);
  plant.code := 0;

  While ( Not eof(master) And (code <> plant.code)) Do
    read(master, plant);

  If (code = plant.code) Then
    Begin
      pos := FilePos(master) - 1;
      Seek(master, FileSize(master) - 1);
      Read(master, plant);
      Seek(master, pos);
      Write(master, plant);
      Seek(master, FileSize(master) - 1);
      Truncate(master);
    End;
End;

Var 
  master: fPlant;
  aux, code: integer;

Begin
  Assign(master, 'data/1/master.dat');

  WriteLn('Ingrese el codigo del registro a borrar:');
  ReadLn(code);
  While (code <> 100000) Do
    Begin
      soft_delete(master, code);
      WriteLn('Ingrese el codigo del registro a borrar:');
      ReadLn(code);
    End;
  compact(master);

  // WriteLn('Ingrese el codigo del registro a borrar:');
  // ReadLn(code);
  // While (code <> 100000) Do
  //   Begin
  //     hard_delete(master, code);
  //     WriteLn('Ingrese el codigo del registro a borrar:');
  //     ReadLn(code);
  //   End;

End.
