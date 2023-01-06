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
    procedure StartServer;
    procedure CaminhoBD(bStart: Boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fGuiServer: TfGuiServer;

implementation

{$R *.dfm}

uses
{$IFDEF MSWINDOWS}
  WinApi.Windows, Winapi.ShellApi,
{$ENDIF}
  Datasnap.DSSession,
  System.Generics.Collections, dConexao;

procedure TfGuiServer.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  ButtonStart.Enabled := not FServer.Active;
  ButtonStop.Enabled := FServer.Active;
  EditPort.Enabled := not FServer.Active;
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
  if not dmConexao.Conexao.Connected then
    Application.Terminate;

  StartServer;
  CaminhoBD(True);
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

procedure TfGuiServer.FormCreate(Sender: TObject);
begin
  FServer := TIdHTTPWebBrokerBridge.Create(Self);
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

end.
