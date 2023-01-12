unit vGuiServer;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.AppEvnts, Vcl.StdCtrls, IdHTTPWebBrokerBridge, IdGlobal, Web.HTTPApp,
  Vcl.ComCtrls;

type
  TfGuiServer = class(TForm)
    ButtonStart: TButton;
    ButtonStop: TButton;
    EditPort: TEdit;
    Label1: TLabel;
    ApplicationEvents1: TApplicationEvents;
    StatusBar: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ButtonOpenBrowserClick(Sender: TObject);
  private
    FServer: TIdHTTPWebBrokerBridge;
    threadCep: TThread;
    procedure StartServer;
    procedure CaminhoBD(bStart: Boolean);
    procedure AtualizaCep;
    procedure UpdateCep;
    procedure Executar(iTempo: Integer);
    procedure Parar;
    procedure Excecao(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fGuiServer: TfGuiServer;
  sTempo: string;

implementation

{$R *.dfm}

uses
{$IFDEF MSWINDOWS}
  WinApi.Windows, Winapi.ShellApi,
{$ENDIF}
  Datasnap.DSSession,
  System.Generics.Collections,
  dEndereco;

procedure TfGuiServer.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  ButtonStart.Enabled := not FServer.Active;
  ButtonStop.Enabled := FServer.Active;
  EditPort.Enabled := not FServer.Active;
end;

procedure TfGuiServer.AtualizaCep;
begin
  Executar(StrToIntDef(sTempo, 0));
end;

procedure TfGuiServer.ButtonOpenBrowserClick(Sender: TObject);
{$IFDEF MSWINDOWS}
var
  LURL: string;
{$ENDIF}
begin
  StartServer;
{$IFDEF MSWINDOWS}
  LURL := Format('http://localhost:%s', [EditPort.Text]);
  ShellExecute(0,
        nil,
        PChar(LURL), nil, nil, SW_SHOWNOACTIVATE);
{$ENDIF}
end;

procedure TfGuiServer.ButtonStartClick(Sender: TObject);
begin
  StartServer;
  CaminhoBD(True);
  AtualizaCep;
end;

procedure TerminateThreads;
begin
  if TDSSessionManager.Instance <> nil then
    TDSSessionManager.Instance.TerminateAllSessions;
end;

procedure TfGuiServer.ButtonStopClick(Sender: TObject);
begin
  TerminateThreads;
  FServer.Active := False;
  FServer.Bindings.Clear;
  CaminhoBD(False);
  Parar;
end;

procedure TfGuiServer.CaminhoBD(bStart: Boolean);
var
  slAcesso: TStringList;
begin

  if bStart then
  begin

    slAcesso := TStringList.Create;
    try
      slAcesso.LoadFromFile('acesso.config');
      StatusBar.Panels[0].Text := slAcesso[4];
      StatusBar.Panels[1].Text := slAcesso[2];
      sTempo := slAcesso[6]
    finally
      FreeAndNil(slAcesso);
    end;

  end
  else
  begin
    StatusBar.Panels[0].Text := EmptyStr;
    StatusBar.Panels[1].Text := EmptyStr;
  end;

end;

procedure TfGuiServer.Excecao(Sender: TObject);
begin
  if Assigned(TThread(Sender).FatalException) then
    showmessage(Exception(TThread(Sender).FatalException).Message);
end;

procedure TfGuiServer.Executar(iTempo: Integer);
begin

  threadCep := TThread.CreateAnonymousThread(
    procedure
    begin

      while True do
      begin
        Sleep(iTempo * 1000);
        UpdateCep;

        TThread.Synchronize(nil,
          procedure
          begin
            StatusBar.Panels[2].Text := 'Cep: ' + FormatDateTime('dd/MM/yyyy hh:nn:ss', now);
          end);

      end;
    end
  );

  threadCep.FreeOnTerminate := True;
  threadCep.OnTerminate := Excecao;
  threadCep.Start;

end;

procedure TfGuiServer.FormCreate(Sender: TObject);
begin
  FServer := TIdHTTPWebBrokerBridge.Create(Self);
end;

procedure TfGuiServer.Parar;
begin
  if Assigned(threadCep) then
    threadCep.Terminate;
end;

procedure TfGuiServer.StartServer;
begin
  if not FServer.Active then
  begin
    FServer.Bindings.Clear;
    FServer.DefaultPort := StrToInt(EditPort.Text);
    FServer.Active := True;
  end;
end;

procedure TfGuiServer.UpdateCep;
var
  dmEndereco: TdmEndereco;
  sMsg: string;
  iId: integer;
  sCep: string;
begin

  dmEndereco := TdmEndereco.Create(nil);

  try

    dmEndereco.SetaConexao;
    dmEndereco.CarregarEnderecosSemIntegracao;

    while not dmEndereco.qryEndereco.Eof do
    begin

      iId := dmEndereco.qryEndereco.FieldByName('idendereco').AsInteger;
      sCep := dmEndereco.qryEndereco.FieldByName('dscep').AsString;

      dmEndereco.AtualizarEndereco(iId, sCep, sMsg);
      dmEndereco.qryEndereco.Next;
    end;

  finally
    FreeAndNil(dmEndereco);
  end;

end;

end.
