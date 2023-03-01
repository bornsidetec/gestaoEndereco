unit vPesoasLote;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList,
  System.Actions, Vcl.ActnList, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.ComCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls, Vcl.Mask,
  Vcl.Menus, System.JSON, System.UITypes;

type
  TfPessoasLote = class(TForm)
    ActionList: TActionList;
    actFechar: TAction;
    actCancelar: TAction;
    ImageList: TImageList;
    pnlTop: TPanel;
    pnlBotom: TPanel;
    btnFechar: TBitBtn;
    actConfirmar: TAction;
    pnlDados: TPanel;
    actBuscar: TAction;
    btnBuscar: TBitBtn;
    edtArquivo: TLabeledEdit;
    OpenDialog: TOpenDialog;
    BitBtn1: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actFecharExecute(Sender: TObject);
    procedure actBuscarExecute(Sender: TObject);
    procedure actConfirmarExecute(Sender: TObject);
  private
    { Private declarations }
    procedure InserirLote(out sMsg: string);
    function StringListToJSONsl(sArquivo: string): TStringList;

  public
    { Public declarations }
  end;

var
  fPessoasLote: TfPessoasLote;

implementation

{$R *.dfm}

uses dPessoa;

procedure TfPessoasLote.actBuscarExecute(Sender: TObject);
begin
  if OpenDialog.Execute then
    edtArquivo.Text := OpenDialog.FileName;
end;

procedure TfPessoasLote.actConfirmarExecute(Sender: TObject);
var
  sMsg: string;
begin

  if edtArquivo.Text = EmptyStr then
  begin
    MessageDlg('Nenhum arquivo selecionado.', mtConfirmation, [mbOK], 0);
    btnBuscar.SetFocus;
    Exit;
  end;

  InserirLote(sMsg);
  MessageDlg(sMsg, mtConfirmation, [mbOK], 0);

  edtArquivo.Text := EmptyStr;
end;

procedure TfPessoasLote.actFecharExecute(Sender: TObject);
begin
  Close;
end;

procedure TfPessoasLote.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Self := nil;
end;

procedure TfPessoasLote.InserirLote(out sMsg: string);
var
  sl: TStringList;
begin

  sl := TStringList.Create;

  try
    sl := StringListToJSONsl(edtArquivo.Text);
    dmPessoa.InserirLote(sl, sMsg);
  finally
    sl.Free;
  end;

end;

function TfPessoasLote.StringListToJSONsl(sArquivo: string): TStringList;
var
  slArquivo, slColunas, slJson: TStringList;
  jsonObj: TJSONObject;
  i: integer;
begin

  slArquivo := TStringList.Create;
  slColunas := TStringList.Create;
  slJson := TStringList.Create;
  try
    slArquivo.LoadFromFile(sArquivo);

    for i := 0 to Pred(slArquivo.Count) do
    begin

      jsonObj := TJSONObject.Create;

      try

        slColunas.Text := StringReplace(slArquivo.Strings[i], ';', #13, [rfReplaceAll]);

        jsonObj.AddPair('flnatureza', slColunas.Strings[0]);
        jsonObj.AddPair('dsdocumento', slColunas.Strings[1]);
        jsonObj.AddPair('nmprimeiro', slColunas.Strings[2]);
        jsonObj.AddPair('nmsegundo', slColunas.Strings[3]);
        jsonObj.AddPair('dscep', slColunas.Strings[4]);

        if i < Pred(slArquivo.Count) then
          slJson.Add(jsonObj.ToString + ', ')
        else
          slJson.Add(jsonObj.ToString);

      finally
        FreeAndNil(jsonObj);
      end;

    end;

    slJson.Text := '[' + slJson.Text + ']';

    Result := TSTringList.Create;
    Result.Text := slJson.Text;

  finally
    FreeAndNil(slArquivo);
    FreeAndNil(slColunas);
    FreeAndNil(slJson);
  end;

end;

end.
