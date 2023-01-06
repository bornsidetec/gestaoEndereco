unit vEnderecos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, System.ImageList,
  Vcl.ImgList, System.Actions, Vcl.ActnList, Vcl.StdCtrls, Vcl.Buttons,
  Data.DBXJSON, System.JSON;

type

  TfEnderecos = class(TForm)
    pnlTop: TPanel;
    ActionList: TActionList;
    actFechar: TAction;
    actConfirmar: TAction;
    ImageList: TImageList;
    pnlBotom: TPanel;
    btnFechar: TBitBtn;
    BitBtn1: TBitBtn;
    pnlDados: TPanel;
    MemoRetorno: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actFecharExecute(Sender: TObject);
    procedure actConfirmarExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AtualizarEnderecos(out sMsg: string);
    procedure threadRetorno(const sStatus: string);
    procedure Retorno(const sMsg: string);
  end;

  TStatus = class(TDBXCallBack)
    function Execute(const Arg: TJSONValue): TJSONValue; override;
  end;

var
  fEnderecos: TfEnderecos;

implementation

{$R *.dfm}

uses dEndereco;

procedure TfEnderecos.actConfirmarExecute(Sender: TObject);
var
  sRetorno: string;
begin

  MemoRetorno.Lines.Clear;

  AtualizarEnderecos(sRetorno);
  MemoRetorno.Lines.Add(sRetorno);

end;

procedure TfEnderecos.actFecharExecute(Sender: TObject);
begin
  Close;
end;

procedure TfEnderecos.AtualizarEnderecos(out sMsg: string);
begin
  {
  dmEndereco.SQLConnection.Connected := True;

  if not dmEndereco.SQLConnection.Connected then
  begin
    MessageDlg('Sem conexão com o servidor', mtConfirmation, [mbOK], 0);
    Exit;
  end;

  sMsg := dmEndereco.Proxy.updateEndereco(TStatus.Create);

  dmEndereco.SQLConnection.Connected := False;
  }
end;

procedure TfEnderecos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Self := nil;
end;

procedure TfEnderecos.FormCreate(Sender: TObject);
begin
  //dmEndereco := TdmEndereco.Create(nil);
end;

procedure TfEnderecos.FormDestroy(Sender: TObject);
begin
  //FreeAndNil(dmEndereco);
end;

procedure TfEnderecos.Retorno(const sMsg: string);
begin
  MemoRetorno.Lines.Add(sMsg);
end;

procedure TfEnderecos.threadRetorno(const sStatus: string);
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

  fEnderecos.threadRetorno(sPair1 + ': ' + sPair2);

  Result := TJSONTrue.Create;
end;

end.
