unit vPessoas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, vCadastro, Data.DB, System.ImageList,
  Vcl.ImgList, System.Actions, Vcl.ActnList, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  cPessoa, mPessoa, dPessoa, hEdit;

type
  TfPessoas = class(TfCadastro)
    Label2: TLabel;
    edtNome: TEdit;
    Label3: TLabel;
    edtCidade: TEdit;
    Label4: TLabel;
    cboUF: TComboBox;
    procedure actPesquisarExecute(Sender: TObject);
    procedure actExcluirExecute(Sender: TObject);
    procedure actSalvarExecute(Sender: TObject);
    procedure actDetalharExecute(Sender: TObject);
    procedure actInserirExecute(Sender: TObject);
    procedure actAlterarExecute(Sender: TObject);
    procedure actCancelarExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
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

    function RetornaItem(sLista: TStrings; sParam: string): Integer;
  public
    { Public declarations }
  end;

var
  fPessoas: TfPessoas;

implementation

{$R *.dfm}

{ TfPessoas }

procedure TfClientes.actAlterarExecute(Sender: TObject);
begin
  inherited;
  HabilitarEdits(acAltera);
end;

procedure TfClientes.actCancelarExecute(Sender: TObject);
begin
  HabilitarEdits(acLista);
  inherited;
end;

procedure TfClientes.actDetalharExecute(Sender: TObject);
begin
  Carregar;
  HabilitarEdits(acLista);
  inherited;
end;

procedure TfClientes.actExcluirExecute(Sender: TObject);
begin
  Excluir;
end;

procedure TfClientes.actInserirExecute(Sender: TObject);
begin
  inherited;
  Limpar;
  HabilitarEdits(acInsere);
end;

procedure TfClientes.actPesquisarExecute(Sender: TObject);
begin
  Pesquisar;
end;

procedure TfClientes.actSalvarExecute(Sender: TObject);
begin
  Salvar;
  HabilitarEdits(acLista);
  inherited;
end;

procedure TfClientes.Alterar;
var
  oCliente: TCliente;
  oClienteController: TClienteController;
  sErro: string;
begin

  oCliente := TCliente.Create;
  oClienteController := TClienteController.Create;

  try

    oCliente.Id := StrToInt(edtId.Text);
    oCliente.Nome := edtNome.Text;
    oCliente.Cidade := edtCidade.Text;
    oCliente.UF := cboUF.Text;

    if not oClienteController.Alterar(oCliente, sErro) then
      raise Exception.Create(sErro);

  finally
    FreeAndNil(oClienteController);
    FreeAndNil(oCliente);
  end;

end;

procedure TfClientes.Carregar;
var
  oCliente: TCliente;
  oClienteController: TClienteController;
begin

  oCliente := TCliente.Create;
  oClienteController := TClienteController.Create;
  try
    oClienteController.CarregarCliente(oCliente,
      dsPesquisa.DataSet.FieldByName('Id').AsInteger);
    edtId.Text := IntToStr(oCliente.Id);
    edtNome.Text := oCliente.Nome;
    edtCidade.Text := oCliente.Cidade;
    cboUF.ItemIndex := RetornaItem(cboUF.Items, oCliente.UF);
  finally
    FreeAndNil(oClienteController);
    FreeAndNil(oCliente);
  end;


end;

procedure TfClientes.Excluir;
var
  oClienteController: TClienteController;
  sErro: string;
begin

  oClienteController := TClienteController.Create;
  try
    if (dmCliente.cdsCliente.Active) and (dmCliente.cdsCliente.RecordCount > 0)
    then
    begin
      if MessageDlg('Confirma a exclusão?', mtConfirmation, [mbYes, mbNo], 0) = IDYES
      then
      begin
        if oClienteController.Excluir(dmCliente.cdsClienteId.AsInteger, sErro) = False
        then
          raise Exception.Create(sErro);
        Pesquisar;
      end;
    end
    else
      raise Exception.Create('Nenhum registro selecionado');

  finally
    FreeAndNil(oClienteController);
  end;


end;

procedure TfClientes.FormCreate(Sender: TObject);
begin
  inherited;
  dmCliente := TdmCliente.Create(nil);
end;

procedure TfClientes.FormDestroy(Sender: TObject);
begin
  FreeAndNil(dmCliente);
  inherited;
end;

procedure TfClientes.FormShow(Sender: TObject);
begin
  inherited;
  Pesquisar;
end;

procedure TfClientes.HabilitarEdits(aAcao: TAcao);
begin

  case aAcao of
    acInsere, acAltera:
      begin
        edtNome.ReadOnly := False;
        edtCidade.ReadOnly := False;
        cboUF.Enabled := True;
      end;
    acLista:
      begin
        edtNome.ReadOnly := True;
        edtCidade.ReadOnly := True;
        cboUF.Enabled := False;
      end;
  end;

end;

procedure TfClientes.Inserir;
var
  oCliente: TCliente;
  oClienteController: TClienteController;
  sErro: string;
begin

  oCliente := TCliente.Create;
  oClienteController := TClienteController.Create;

  try
    oCliente.Nome := edtNome.Text;
    oCliente.Cidade := edtCidade.Text;
    oCliente.UF := cboUF.Text;

    if not oClienteController.Inserir(oCliente, sErro) then
      raise Exception.Create(sErro);

  finally
    FreeAndNil(oClienteController);
    FreeAndNil(oCliente);
  end;


end;

procedure TfClientes.Limpar;
begin

  case FAcao of
    acInsere:
      begin
        edtId.Clear;
        edtNome.Clear;
        edtCidade.Clear;
        cboUF.ItemIndex := -1;
        edtNome.SetFocus;
      end;
  end;

end;

procedure TfClientes.Pesquisar;
var
  oClienteController: TClienteController;
begin
  oClienteController := TClienteController.Create;
  try
    oClienteController.Pesquisar(edtPesquisar.Text);
  finally
    FreeAndNil(oClienteController);
  end;


end;

function TfClientes.RetornaItem(sLista: TStrings; sParam: string): Integer;
var
  i: Integer;
begin

  for i := 0 to sLista.Count - 1 do
  begin
    if pos(sParam, sLista[i]) > 0 then
      Result := i;
  end;

end;

procedure TfClientes.Salvar;
var
  oClienteController: TClienteController;
begin
  oClienteController := TClienteController.Create;

  try
    case FAcao of
      acInsere:
        Inserir;
      acAltera:
        Alterar;
    end;
    oClienteController.Pesquisar(edtPesquisar.Text);
  finally
    FreeAndNil(oClienteController);
  end;


end;

end.
