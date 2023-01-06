unit vMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, System.Actions, Vcl.ActnList,
  Vcl.ComCtrls, Vcl.ExtCtrls, System.ImageList, Vcl.ImgList, Vcl.StdCtrls,
  Vcl.Buttons, Data.DBXJSON, System.JSON;

type
  TfMain = class(TForm)
    MainMenu: TMainMenu;
    Cadastros1: TMenuItem;
    Movimentao1: TMenuItem;
    ActionList: TActionList;
    StatusBar: TStatusBar;
    actSobre: TAction;
    Ajuda1: TMenuItem;
    Sobre1: TMenuItem;
    actPessoas: TAction;
    actEnderecos: TAction;
    Pessoas1: TMenuItem;
    Enderecos1: TMenuItem;
    PessoasporLote1: TMenuItem;
    pnlEnderecos: TPanel;
    pnlDados: TPanel;
    MemoRetorno: TMemo;
    pnlTop: TPanel;
    pnlBotom: TPanel;
    btnFechar: TBitBtn;
    BitBtn1: TBitBtn;
    ImageList: TImageList;
    actFechar: TAction;
    actConfirmar: TAction;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actSobreExecute(Sender: TObject);
    procedure actPessoasExecute(Sender: TObject);
    procedure actEnderecosExecute(Sender: TObject);
    procedure PessoasporLote1Click(Sender: TObject);
    procedure actFecharExecute(Sender: TObject);
    procedure actConfirmarExecute(Sender: TObject);
  private
    { Private declarations }
    procedure AbrirForm(T: TFormClass; F: TForm);
  public
    { Public declarations }
    procedure AtualizarEnderecos(out sMsg: string);
    procedure threadRetorno(const sStatus: string);
  end;

  TStatus = class(TDBXCallBack)
    function Execute(const Arg: TJSONValue): TJSONValue; override;
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}

uses vSobre, vPessoas, vPesoasLote, dEndereco;

procedure TfMain.AbrirForm(T: TFormClass; F: TForm);
begin
  if not Assigned(F) then
    Application.CreateForm(T, F);
  F.Show;
end;

procedure TfMain.actPessoasExecute(Sender: TObject);
begin
  AbrirForm(TfPessoas, fPessoas);
end;

procedure TfMain.actConfirmarExecute(Sender: TObject);
var
  sRetorno: string;
begin

  MemoRetorno.Lines.Clear;
  Application.ProcessMessages;

  AtualizarEnderecos(sRetorno);
  MemoRetorno.Lines.Add(sRetorno);

end;

procedure TfMain.actEnderecosExecute(Sender: TObject);
begin
  pnlEnderecos.Visible := True;
end;

procedure TfMain.actFecharExecute(Sender: TObject);
begin
  MemoRetorno.Lines.Clear;
  pnlEnderecos.Visible := False;
end;

procedure TfMain.actSobreExecute(Sender: TObject);
begin
  AbrirForm(TfSobre, fSobre);
end;

procedure TfMain.AtualizarEnderecos(out sMsg: string);
var
  dmEndereco: TdmEndereco;
begin

  dmEndereco := TdmEndereco.Create(Self);

  try

    dmEndereco.SQLConnection.Connected := True;

    if not dmEndereco.SQLConnection.Connected then
    begin
      MessageDlg('Sem conexão com o servidor', mtConfirmation, [mbOK], 0);
      Exit;
    end;

    sMsg := dmEndereco.Proxy.updateEndereco(TStatus.Create);

    dmEndereco.SQLConnection.Connected := False;

  finally
    FreeAndNil(dmEndereco);
  end;

end;

procedure TfMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: Integer;
begin
  for i := 0 to MDIChildCount - 1 do
    MDIChildren[i].close;
end;

procedure TfMain.PessoasporLote1Click(Sender: TObject);
begin
  AbrirForm(TfPessoasLote, fPessoasLote);
end;

procedure TfMain.threadRetorno(const sStatus: string);
begin
  TThread.Synchronize(TThread.CurrentThread,
  procedure begin
    MemoRetorno.Lines.Add(sStatus);
  end);
end;

{ TStatus }

function TStatus.Execute(const Arg: TJSONValue): TJSONValue;
var
  sPair1, sPair2: string;
begin
  sPair1 := TJSONObject(Arg).GetValue('cep').Value;
  sPair2 := TJSONObject(Arg).GetValue('status').Value;

  fMain.threadRetorno(sPair1 + ': ' + sPair2);

  Result := TJSONTrue.Create;

end;

end.
