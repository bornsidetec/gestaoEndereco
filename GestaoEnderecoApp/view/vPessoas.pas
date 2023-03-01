unit vPessoas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, vCadastro, Data.DB, System.ImageList,
  Vcl.ImgList, System.Actions, Vcl.ActnList, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  cPessoa, mPessoa, dPessoa, hEdit, Vcl.Mask, System.JSON, REST.Types,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, System.UITypes;

type
  TfPessoas = class(TfCadastro)
    edtNatureza: TLabeledEdit;
    edtDocumento: TLabeledEdit;
    edtPrimeiro: TLabeledEdit;
    edtSegundo: TLabeledEdit;
    edtCep: TLabeledEdit;
    Label2: TLabel;
    edtLogradouro: TLabeledEdit;
    edtComplemento: TLabeledEdit;
    edtBairro: TLabeledEdit;
    edtCidade: TLabeledEdit;
    cboEstado: TComboBox;
    RESTRequest: TRESTRequest;
    RESTClient: TRESTClient;
    procedure actPesquisarExecute(Sender: TObject);
    procedure actInserirExecute(Sender: TObject);
    procedure actDetalharExecute(Sender: TObject);
    procedure actExcluirExecute(Sender: TObject);
    procedure actAlterarExecute(Sender: TObject);
    procedure actSalvarExecute(Sender: TObject);
    procedure actCancelarExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtNaturezaKeyPress(Sender: TObject; var Key: Char);
    procedure edtCepExit(Sender: TObject);
  private
    { Private declarations }
    procedure Pesquisar;
    procedure Carregar;
    procedure Alterar;
    procedure Excluir;
    procedure Inserir;
    procedure Salvar;
    procedure Limpar;
    procedure HabilitarEdits(aAcao: TAcao);
    function buscarViaCEP(sCep: string): TJSONObject;
    procedure preecherCEP(jsonEndereco: TJSONObject);
  public
    { Public declarations }
  end;

var
  fPessoas: TfPessoas;

implementation

{$R *.dfm}

{ TfPessoas }

procedure TfPessoas.actAlterarExecute(Sender: TObject);
begin
  inherited;
  HabilitarEdits(acAltera);
end;

procedure TfPessoas.actCancelarExecute(Sender: TObject);
begin
  HabilitarEdits(acLista);
  inherited;
end;

procedure TfPessoas.actDetalharExecute(Sender: TObject);
begin
  if not dsPesquisa.DataSet.IsEmpty then
  begin
    Carregar;
    HabilitarEdits(acLista);
    inherited;
  end;
end;

procedure TfPessoas.actExcluirExecute(Sender: TObject);
begin
  Excluir;
end;

procedure TfPessoas.actInserirExecute(Sender: TObject);
begin
  inherited;
  Limpar;
  HabilitarEdits(acInsere);
end;

procedure TfPessoas.actPesquisarExecute(Sender: TObject);
begin
  Pesquisar;
end;

procedure TfPessoas.actSalvarExecute(Sender: TObject);
begin
  Salvar;
  HabilitarEdits(acLista);
  inherited;
end;

procedure TfPessoas.Alterar;
var
  oPessoa: TPessoa;
  oPessoaController: TPessoaController;
  sErro: string;
begin

  oPessoa := TPessoa.Create;
  oPessoaController := TPessoaController.Create;

  try
    oPessoa.Id := StrToIntDef(edtId.Text, 0);
    oPessoa.FlNatureza := StrToIntDef(edtNatureza.Text, 0);
    oPessoa.DsDocumento := edtDocumento.Text;
    oPessoa.NmPrimeiro := edtPrimeiro.Text;
    oPessoa.NmSegundo := edtSegundo.Text;
    oPessoa.DsCep := edtCep.Text;
    oPessoa.DsUf := cboEstado.Text;
    oPessoa.NmCidade := edtCidade.Text;
    oPessoa.NmBairro := edtBairro.Text;
    oPessoa.NmLogradouro := edtLogradouro.Text;
    oPessoa.DsComplemento := edtComplemento.Text;

    if not oPessoaController.Alterar(oPessoa, sErro) then
      raise Exception.Create(sErro);

  finally
    FreeAndNil(oPessoaController);
    FreeAndNil(oPessoa);
  end;

end;

function TfPessoas.buscarViaCEP(sCep: string): TJSONObject;
const
  sUrl: string = 'https://viacep.com.br/ws/';
  sType: string = '/json';
begin

  RESTClient.BaseURL := sUrl + sCep + sType;
  RESTRequest.Execute;
  Result := RESTRequest.Response.JSONValue AS TJSONObject;

end;

procedure TfPessoas.Carregar;
var
  oPessoa: TPessoa;
  oPessoaController: TPessoaController;
begin

  oPessoa := TPessoa.Create;
  oPessoaController := TPessoaController.Create;
  try
    oPessoaController.CarregarPessoa(oPessoa,
      dsPesquisa.DataSet.FieldByName('IdPessoa').AsInteger);
    edtId.Text := IntToStr(oPessoa.Id);
    edtPrimeiro.Text := oPessoa.NmPrimeiro;
    edtSegundo.Text := oPessoa.NmSegundo;
    edtNatureza.Text := IntToStr(oPessoa.FlNatureza);
    edtDocumento.Text := oPessoa.DsDocumento;
    edtCEP.Text := oPessoa.DsCep;
    edtLogradouro.Text := oPessoa.NmLogradouro;
    edtComplemento.Text := oPessoa.DsComplemento;
    edtBairro.Text := oPessoa.NmBairro;
    edtCidade.Text := oPessoa.NmCidade;
    cboEstado.Text := oPessoa.DsUf;

  finally
    FreeAndNil(oPessoaController);
    FreeAndNil(oPessoa);
  end;

end;

procedure TfPessoas.edtCepExit(Sender: TObject);
begin
  inherited;

  preecherCEP(buscarViaCEP(edtCep.Text));
end;

procedure TfPessoas.edtNaturezaKeyPress(Sender: TObject; var Key: Char);
begin
  if not(Key in ['0' .. '9', #8, #9]) then
    Key := #0;
end;

procedure TfPessoas.Excluir;
var
  oPessoaController: TPessoaController;
  sErro: string;
begin

  oPessoaController := TPessoaController.Create;
  try
    if (dmPessoa.cdsPessoa.Active) and (dmPessoa.cdsPessoa.RecordCount > 0)
    then
    begin
      if MessageDlg('Confirma a exclusão?', mtConfirmation, [mbYes, mbNo], 0) = IDYES
      then
      begin
        if oPessoaController.Excluir(dmPessoa.cdsPessoaidpessoa.AsInteger, sErro) = False
        then
          raise Exception.Create(sErro);
        Pesquisar;
      end;
    end
    else
      raise Exception.Create('Nenhum registro selecionado');

  finally
    FreeAndNil(oPessoaController);
  end;

end;

procedure TfPessoas.FormCreate(Sender: TObject);
begin
  inherited;
  dmPessoa := TdmPessoa.Create(nil);
end;

procedure TfPessoas.FormDestroy(Sender: TObject);
begin
  FreeAndNil(dmPessoa);
  inherited;
end;

procedure TfPessoas.FormShow(Sender: TObject);
begin
  inherited;
  Pesquisar;
end;

procedure TfPessoas.HabilitarEdits(aAcao: TAcao);
begin

  case aAcao of
    acInsere, acAltera:
      begin
        edtPrimeiro.ReadOnly := False;
        edtSegundo.ReadOnly := False;
        edtNatureza.ReadOnly := False;
        edtDocumento.ReadOnly := False;
        edtCep.ReadOnly := False;
        edtLogradouro.ReadOnly := False;
        edtComplemento.ReadOnly := False;
        edtBairro.ReadOnly := False;
        edtCidade.ReadOnly := False;
        cboEstado.Enabled := True;
      end;
    acLista:
      begin
        edtPrimeiro.ReadOnly := True;
        edtSegundo.ReadOnly := True;
        edtNatureza.ReadOnly := True;
        edtDocumento.ReadOnly := True;
        edtCep.ReadOnly := True;
        edtLogradouro.ReadOnly := True;
        edtComplemento.ReadOnly := True;
        edtBairro.ReadOnly := True;
        edtCidade.ReadOnly := True;
        cboEstado.Enabled := False;
      end;
  end;

end;

procedure TfPessoas.Inserir;
var
  oPessoa: TPessoa;
  oPessoaController: TPessoaController;
  sErro: string;
begin

  oPessoa := TPessoa.Create;
  oPessoaController := TPessoaController.Create;

  try
    oPessoa.NmPrimeiro := edtPrimeiro.Text;
    oPessoa.NmSegundo := edtSegundo.Text;
    oPessoa.FlNatureza := StrToIntDef(edtNatureza.Text, 0);
    oPessoa.DsDocumento := edtDocumento.Text;
    oPessoa.DsCep := edtCep.Text;
    oPessoa.DsUf := cboEstado.Text;
    oPessoa.NmCidade := edtCidade.Text;
    oPessoa.NmBairro := edtBairro.Text;
    oPessoa.NmLogradouro := edtLogradouro.Text;
    oPessoa.DsComplemento := edtComplemento.Text;

    if not oPessoaController.Inserir(oPessoa, sErro) then
      raise Exception.Create(sErro);

  finally
    FreeAndNil(oPessoaController);
    FreeAndNil(oPessoa);
  end;

end;

procedure TfPessoas.Limpar;
begin

  case FAcao of
    acInsere:
      begin
        edtId.Clear;
        edtPrimeiro.Clear;
        edtSegundo.Clear;
        edtNatureza.Clear;
        edtDocumento.Clear;
        edtCep.Clear;
        edtLogradouro.Clear;
        edtComplemento.Clear;
        edtBairro.Clear;
        edtCidade.Clear;
        cboEstado.ItemIndex := -1;
      end;
  end;

end;

procedure TfPessoas.Pesquisar;
var
  oPessoaController: TPessoaController;
begin
  oPessoaController := TPessoaController.Create;
  try
    oPessoaController.Pesquisar(edtPesquisar.Text);
  finally
    FreeAndNil(oPessoaController);
  end;
end;

procedure TfPessoas.preecherCEP(jsonEndereco: TJSONObject);
begin
  try
    cboEstado.Text := jsonEndereco.getValue<string>('uf');
    edtCidade.Text := jsonEndereco.getValue<string>('localidade');
    edtBairro.Text := jsonEndereco.getValue<string>('bairro');
    edtLogradouro.Text := jsonEndereco.getValue<string>('logradouro');
    edtComplemento.Text := jsonEndereco.getValue<string>('complemento');
  except on E: Exception do
    MessageDlg('CEP não encontrado' + #13 + #13 + E.Message, mtInformation, [mbOK], 0);
  end;
end;

procedure TfPessoas.Salvar;
var
  oPessoaController: TPessoaController;
begin

  oPessoaController := TPessoaController.Create;

  try
    case FAcao of
      acInsere:
        Inserir;
      acAltera:
        Alterar;
    end;
    oPessoaController.Pesquisar(edtPesquisar.Text);
  finally
    FreeAndNil(oPessoaController);
  end;

end;

end.
