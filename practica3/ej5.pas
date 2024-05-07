
Program ej5;

Type 
  tArticle = Record
    code: integer;
    description: string[200];
    color: string[20];
    size: integer;
    stock: integer;
    price: real;
  End;

  fArticle = file Of tArticle;

Procedure soft_delete(Var a_file: fArticle; code: integer; var text_file: text);

Var art: tArticle;
Begin
  If (eof(a_file)) Then reset(a_file)
  Else
    Begin
      read(a_file, art);
      If (art.code > code) Then
        Reset(a_file);
    End;

  While ( Not eof(a_file) And (code <> art.code)) Do
    read(a_file, art);

  If (art.code = code) Then
    Begin
      WriteLn(text_file, art.code, ',',art.description,',',art.color,',',art.size,',',art.stock,',',art.price);
      art.code := -1;
      Seek(a_file, FilePos(a_file) - 1);
      write(a_file,art);
    End;

End;

Var 
  a_file: fArticle;
  text_file: text;
  del_article: integer;
Begin

  Assign(a_file,'data/5/data.dat');
  Assign(text_file, 'data/5/deleted.txt');
  Reset(a_file);
  Rewrite(text_file);

  Write('Enter article code to delete(-1 to finish): ');
  read(del_article);

  While (del_article <> -1) Do
    Begin
      soft_delete(a_file,del_article,text_file);
    End;

  close(a_file);
  close(text_file);

End.
