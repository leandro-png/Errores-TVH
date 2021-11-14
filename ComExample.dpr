program ComExample;

uses
  Forms,
  ComMainForm in 'ComMainForm.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'CALCULO DE ERROR';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
