program ej1;
const
  eof_value = 9999;
type
  request = Record 
    code : integer;
    date : string;
    days_requested: integer;
  end;

  worker = Record
    code: integer;
    full_name: string;
    birthday: string;
    address: string;
    children: integer; 
    days_remaining: integer;
  end;

  fWorker = file of worker;
  fDetail = file of request;

procedure read_file(var detail: fDetail; var req: request);
begin
  if (not eof(detail)) then
  read(detail, req) else req.code:= eof_value;
end;

var
  master_file : fWorker;
  detail_file: fDetail;
  denied_file: text;
  emp: worker;
  req: request;
begin

  Assign(master_file, 'data/1/master.dat'); Assign(detail_file, 'data/1/detail.dat'); Assign(denied_file,'data/1/denied.txt');
  Reset(master_file); Reset(detail_file); Rewrite(denied_file);

  read_file(detail_file, req);
  read(master_file,emp);

  while (req.code <> eof_value) do
  begin
    while(not eof(master_file) and emp.code <> req.code) do 
      read(master_file, emp);
    
    if(emp.days_remaining <= req.days_requested) then begin
      emp.days_remaining:= emp.days_remaining - req.days_requested;
      Seek(master_file, FilePos(master_file) - 1);
      write(master_file, emp);
    end else begin
      WriteLn(denied_file, emp.code,';',emp.full_name,';',emp.days_remaining,';',req.days_requested);
    end;

    read_file(detail_file,req);
  end;

end.