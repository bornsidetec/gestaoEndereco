unit dConexao;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef,
  FireDAC.Comp.UI;

type
  TdmConexao = class(TDataModule)
    Conexao: TFDConnection;
    FDPhysPgDriverLink: TFDPhysPgDriverLink;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Conectar;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmConexao }

procedure TdmConexao.Conectar;
var
  slAcesso: TStringList;
begin

  slAcesso := TStringList.Create;

  if FileExists('acesso.config') then
    slAcesso.LoadFromFile('acesso.config')
  else
  begin
    slAcesso.Add('DriverID=PG');
    slAcesso.Add('Port=5432');
    slAcesso.Add('Database=rest');
    slAcesso.Add('Password=bs101100');
    slAcesso.Add('Server=localhost');
    slAcesso.Add('User_Name=postgres');

    slAcesso.SaveToFile('acesso.config');
  end;

  try

    Conexao.Params.Clear;
    Conexao.Params.Add(slAcesso[0]); //Driver
    Conexao.Params.Add(slAcesso[1]); //Port
    Conexao.Params.Add(slAcesso[2]); //Database
    Conexao.Params.Add(slAcesso[3]); //Password
    Conexao.Params.Add(slAcesso[4]); //Server
    Conexao.Params.Add(slAcesso[5]); //User_Name

    try
      Conexao.Connected := True;
    except
      on E: Exception do
      begin
        raise Exception.Create(sLineBreak + 'Falha ao conectar' +
          sLineBreak +
          sLineBreak + E.Message);
      end;

    end;

  finally
    FreeAndNil(slAcesso);
  end;

end;

procedure TdmConexao.DataModuleCreate(Sender: TObject);
begin
  FDPhysPgDriverLink.VendorHome := '.\';
  Conexao.Connected := False;
  Conectar;
end;

procedure TdmConexao.DataModuleDestroy(Sender: TObject);
begin
  Conexao.Connected := False;
end;

end.


