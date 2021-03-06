

unit ComMainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, CPort, CPortCtl, jpeg,mmsystem,inifiles;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Rango_de_tension: TEdit;
    Label2: TLabel;
    Label1: TLabel;
    rango_de_corriente: TEdit;
    Label4: TLabel;
    constante_patron: TLabel;
    constante_medidor: TEdit;
    Label7: TLabel;
    Impulsos_teoricos: TEdit;
    Label6: TLabel;
    vueltas: TEdit;
    Label5: TLabel;
    Panel4: TPanel;
    codigo_recibido: TEdit;
    configuracion_puerto_serie: TButton;
    Panel5: TPanel;
    Panel2: TPanel;
    lbl_error: TLabel;
    btn_iniciar: TButton;
    ComPort: TComPort;
    chk_modo_continuo: TCheckBox;
    Timer1: TTimer;
    edt_pulsos_teoricos: TEdit;
    edt_error_1: TEdit;
    edt_error_2: TEdit;
    edt_error_3: TEdit;
    edt_error_4: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Panel3: TPanel;
    Label3: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel6: TPanel;
    Panel7: TPanel;
    rg_tension: TRadioGroup;
    rg_corriente: TRadioGroup;
    Image1: TImage;
    Label10: TLabel;
    pnl1: TPanel;
    rg_constantes: TRadioGroup;
    procedure configuracion_puerto_serieClick(Sender: TObject);
    procedure ComPortRxChar(Sender: TObject; Count: Integer);
    procedure Bt_LoadClick(Sender: TObject);
    procedure Bt_StoreClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure alpha1000Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
//    procedure Timer1Timer(Sender: TObject);
    procedure btn_iniciarClick(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton5Click(Sender: TObject);
    procedure RadioButton6Click(Sender: TObject);
    procedure RadioButton7Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure rg_constantesClick(Sender: TObject);
    procedure rg_tensionClick(Sender: TObject);
    procedure rg_corrienteClick(Sender: TObject);
    procedure vueltasChange(Sender: TObject);
  private
    { Private declarations }

ini:tinifile;

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
var     lectura_habilitada:boolean;   tension, corriente,constante:integer;   vueltitas:string;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TForm1.configuracion_puerto_serieClick(Sender: TObject);
begin
  ComPort.ShowSetupDialog;
end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function probar(a:char):char;
var temp:char;
begin
     case a of
              '0':temp:='0';
              '1':temp:='1';
              '2':temp:='2';
              '3':temp:='3';
              '4':temp:='4';
              '5':temp:='5';
              '6':temp:='6';
              '7':temp:='7';
              '8':temp:='8';
              '9':temp:='9';
               else temp:='A';
             end;
       Result:=temp;
end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function extraer(a:string):integer;
var b:integer;
begin
   if (a<>'')and(a<>'A') then  b:=strtoint(a[1]+a[2]+a[3]+a[4]+a[5]+a[6]) else b:=0;
   Result:=b;
end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function realtostr(n:real;decimal:byte):string;
var s:string;
begin
          str(n:0:decimal,s);
          result:=s;
end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TForm1.ComPortRxChar(Sender: TObject; Count: Integer);
var  Str: String; a,b:integer;     temp:real;
  begin
  a:=0;
  b:=0;
  sleep(1);
  ComPort.ReadStr(Str, Count);
  codigo_recibido.Text:=Str;
  edit7.Text:=str;

  if (length(codigo_recibido.text)>3)and(length(codigo_recibido.text)<13)and(probar(codigo_recibido.Text[length(codigo_recibido.Text)-2])<>'A')and(probar(codigo_recibido.Text[length(codigo_recibido.Text)-1])<>'A')then
                        begin
                                case rg_tension.ItemIndex of
                                                           0:begin rango_de_tension.Text:= '40-80 V'; a:=1; end;
                                                           1:begin rango_de_tension.Text:= '80-160 V';a:=2; end;
                                                           2:begin rango_de_tension.Text:= '160-320 V';a:=4;end;
                                end;

                                case rg_corriente.ItemIndex of
                                                            0:begin rango_de_corriente.Text:= '1 (2) A';b:=1;     end;
                                                            1:begin rango_de_corriente.Text:= '2 (4) A';b:=2;     end;
                                                            2:begin rango_de_corriente.Text:= '5 (10) A';b:=5;    end;
                                                            3:begin rango_de_corriente.Text:= '10 (20) A';b:=10;   end;
                                                            4:begin rango_de_corriente.Text:= '20 (40) A';b:=20;   end;
                                                            5:begin rango_de_corriente.Text:= '50 (100) A';b:=50;  end;
                                end;

                                if (a*b)<>0 then constante_patron.caption:=inttostr(12000000 div(a*b)) else constante_patron.caption:='1';
                                Impulsos_teoricos.Text:=floattostr(strtoint(constante_patron.Caption)*strtoint(vueltas.Text)/strtofloat(constante_medidor.Text  ) );
                                edt_pulsos_teoricos.Text:=inttostr(round(strtofloat(impulsos_teoricos.Text)));
                        end;

   if ((extraer(str))<>0)and(length((str))>6) then
                                                     begin
                                                            temp:=(strtofloat(impulsos_teoricos.text)-(extraer(str)))*100/(extraer(str));
                                                            edit8.Text:=str;
                                                            if (temp>-200)and(temp<200)then
                                                                                            begin
                                                                                                  lbl_error.Caption:=realtostr(temp,3)+' %';
                                                                                                //  playsound('Open',0,SND_ALIAS or SND_ASYNC);
                                                                                                PlaySound(PChar('c:\windows\media\start.wav'), 0, SND_SYNC);
                                                                                            end
                                                            else lbl_error.Caption:='Inf.';
                                                            lectura_habilitada:=false;

                                                            ComPort.WriteStr('3431');

                                                            if chk_modo_continuo.Checked then btn_iniciar.Click;
                                                     end;
end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TForm1.Bt_LoadClick(Sender: TObject);
begin
  ComPort.LoadSettings(stRegistry, 'HKEY_LOCAL_MACHINE\Software\Dejan');
end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TForm1.Bt_StoreClick(Sender: TObject);
begin
  ComPort.StoreSettings(stRegistry, 'HKEY_LOCAL_MACHINE\Software\Dejan');
end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TForm1.FormCreate(Sender: TObject);
begin
    lectura_habilitada:=false;
    if ComPort.Connected then
                             ComPort.Close else
                                                begin
                                                        ComPort.Open;
                                                        ComPort.WriteStr('3431');
                                                end;

ini:=tinifile.create(changefileext(application.ExeName,'.ini'));
tension  :=ini.ReadInteger('TVH','Tension',0);
corriente:=ini.ReadInteger('TVH','Corriente',0);
constante:=ini.ReadInteger('TVH','Constante',0);
Vueltitas:=ini.Readstring('TVH','Vueltas','1');

    rg_tension.ItemIndex:=tension;
    rg_corriente.ItemIndex:=corriente;
    rg_constantes.ItemIndex:=constante;
    vueltas.Text:=vueltitas;
end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TForm1.alpha1000Click(Sender: TObject);
begin

end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TForm1.RadioButton2Click(Sender: TObject);
begin

end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TForm1.RadioButton3Click(Sender: TObject);
begin

end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TForm1.RadioButton4Click(Sender: TObject);
begin

end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TForm1.btn_iniciarClick(Sender: TObject);
begin
        sleep(1000);
        PlaySound(PChar('c:\windows\media\start.wav'), 0, SND_SYNC);
        if lectura_habilitada=false then begin
                                                  ComPort.WriteStr('34313632');
                                                  lectura_habilitada:=true;

                                                  edt_error_4.Text:=edt_error_3.Text;
                                                  edt_error_3.Text:=Edt_error_2.Text;
                                                  Edt_error_2.Text:=Edt_error_1.Text;
                                                  Edt_error_1.Text:=lbl_error.Caption;
                                         end ;

end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TForm1.RadioButton1Click(Sender: TObject);
begin

end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TForm1.RadioButton5Click(Sender: TObject);
begin

end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TForm1.RadioButton6Click(Sender: TObject);
begin

end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TForm1.RadioButton7Click(Sender: TObject);
begin

end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TForm1.Timer1Timer(Sender: TObject);
var  Str: String;    a,b,count:integer;     temp:real;

begin
if  lectura_habilitada=false then
                                    begin
                                          ComPort.WriteStr('33');

                                          a:=0;
                                          b:=0;
                                          ComPort.ReadStr(Str, Count);
                                          codigo_recibido.Text:=Str;

                                          case rg_tension.ItemIndex of
                                                                     0:begin rango_de_tension.Text:= '40-80 V'; a:=1; end;
                                                                     1:begin rango_de_tension.Text:= '80-160 V';a:=2; end;
                                                                     2:begin rango_de_tension.Text:= '160-320 V';a:=4;end;
                                                        end;
                                          case rg_corriente.ItemIndex of
                                                                      0:begin rango_de_corriente.Text:= '1 (2) A';b:=1;     end;
                                                                      1:begin rango_de_corriente.Text:= '2 (4) A';b:=2;     end;
                                                                      2:begin rango_de_corriente.Text:= '5 (10) A';b:=5;    end;
                                                                      3:begin rango_de_corriente.Text:= '10 (20) A';b:=10;   end;
                                                                      4:begin rango_de_corriente.Text:= '20 (40) A';b:=20;   end;
                                                                      5:begin rango_de_corriente.Text:= '50 (100) A';b:=50;  end;
                                                        end;

                                          if codigo_recibido.text<>''then
                                                                        begin
                                                                              if(probar(codigo_recibido.Text[length(codigo_recibido.Text)-2])<>'A')and(probar(codigo_recibido.Text[length(codigo_recibido.Text)-1])<>'A')then
                                                                                                    begin
                                                                                                          constante_patron.caption:=inttostr(12000000 div(a*b));
                                                                                                          Impulsos_teoricos.Text:=floattostr(strtoint(constante_patron.Caption)*strtoint(vueltas.Text)/strtofloat(constante_medidor.Text  ) );
                                                                                                                                                                           end else begin
                                                                                                                                                                                        rango_de_tension.Text:= '';
                                                                                                                                                                                        rango_de_corriente.Text:= '';
                                                                                                                                                                                        constante_patron.caption:='';
                                                                                                                                                                                        Impulsos_teoricos.Text:='';
                                                                                                                                                                                    end;
                                                                                                    end;
                                                                         end ;

end;

procedure TForm1.rg_constantesClick(Sender: TObject);
begin

case rg_constantes.ItemIndex of
                                0:constante_medidor.Text:='3508.77';
                                1:constante_medidor.Text:='20000';
                                2:constante_medidor.Text:='20000';
                                3:constante_medidor.Text:='10000';
                                4:constante_medidor.Text:='2500';
                                5:constante_medidor.Text:='1000';
                                6:constante_medidor.Text:='769.23';
                                7:constante_medidor.Text:='555.555';
                                8:constante_medidor.Text:='150';
                                9:constante_medidor.Text:='50';
end;
Ini.WriteInteger('TVH','Constante',rg_constantes.ItemIndex);
end;

procedure TForm1.rg_tensionClick(Sender: TObject);
begin
Ini.WriteInteger('TVH','Tension',rg_tension.ItemIndex);


//Ini.WriteInteger('TVH','Vueltas',rg_tension.ItemIndex);
end;

procedure TForm1.rg_corrienteClick(Sender: TObject);
begin
Ini.WriteInteger('TVH','Corriente',rg_corriente.ItemIndex);
end;

procedure TForm1.vueltasChange(Sender: TObject);
begin
Ini.WriteString('TVH','Vueltas',vueltas.Text);
end;

end.
