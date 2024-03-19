program ej6;
Type
  BookRecord = Record 
    b_ISBN: string;
    b_title: string;
    b_year: integer;
    b_publisher: string;
    b_gender: string;
    end;
  book_file = file of BookRecord;
procedure create_bin_from(var bin: book_file; text_filename : string);
var
  book: BookRecord;
  text_file: text;
  str: string;
begin
  Assign(text_file, text_filename); Rewrite(bin); Reset(text_file);

  while (not eof(text_file)) do begin
    ReadLn(text_file,str);
    book.b_ISBN:= Copy(str,1,13);
    book.b_title:= Copy(str,14,Length(str));

    ReadLn(text_file,str);
    val(copy(str,1,4),book.b_year);
    book.b_publisher:= Copy(str,4,Length(str));

    WriteLn(book.b_year);
    ReadLn(text_file,str);
    book.b_gender:=Copy(str,1,Length(str));

    Write(bin,book);
  end;


  close(text_file);
end;

var 
  bin_file: book_file;
begin
  Assign(bin_file,'data/libros.dat');
  create_bin_from(bin_file, 'libros.txt');
end.