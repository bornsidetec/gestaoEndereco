unit vCadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls,
  System.Actions, Vcl.ActnList, Vcl.StdCtrls, Vcl.Buttons, System.ImageList,
  Vcl.ImgList, Data.DB, Vcl.Grids, Vcl.DBGrids;

type
  TAcao = (acInsere, acAltera, acLista);

  TfCadastro = class(TForm)
    pnlBotom: TPanel;
    btnFechar: TBitBtn;
    ActionList: TActionList;
    actFechar: TAction;
    pnlClient: TPanel;
    PageControl: TPageControl;
    tsListagem: TTabSheet;
    tsDetalhes: TTabSheet;
    pnlFind: TPanel;
    actPesquisar: TAction;
    ImageList: TImageList;
    btnPesquisar: TBitBtn;
    edtPesquisar: TEdit;
    Label1: TLabel;
    DBGrid1: TDBGrid;
    dsPesquisa: TDataSource;
    pnlActionsList: TPanel;
    btnInserir: TBitBtn;
    actInserir: TAction;
    btnDetalhar: TBitBtn;
    actDetalhar: TAction;
    btnExcluir: TBitBtn;
    actExcluir: TAction;
    pnlActionsDetail: TPanel;
    btnAlterar: TBitBtn;
    btnSalvar: TBitBtn;
    btnCancelar: TBitBtn;
    btnVoltar: TBitBtn;
    actVoltar: TAction;
    actAlterar: TAction;
    actSalvar: TAction;
    actCancelar: TAction;
    lblCodigo: TLabel;
    edtId: TEdit;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actFecharExecute(Sender: TObject);
    procedure actInserirExecute(Sender: TObject);
    procedure actAlterarExecute(Sender: TObject);
    procedure actSalvarExecute(Sender: TObject);
    procedure actCancelarExecute(Sender: TObject);
    procedure actDetalharExecute(Sender: TObject);
    procedure actVoltarExecute(Sender: TObject);
  private
    { Private declarations }
    procedure Mostrar;
    procedure Insere;
    procedure Altera;
    procedure Detalha;
    procedure HabilitarAcoes(aAcao: TAcao);
    procedure Listar;

  public
    FAcao: TAcao;
    { Public declarations }

  end;

var
  fCadastro: TfCadastro;

implementation

{$R *.dfm}
{ TfCadastro }

procedure TfCadastro.Mostrar;
begin

  tsDetalhes.tabVisible := False;
  tsListagem.TabVisible := False;

  PageControl.ActivePage := tsListagem;
  FAcao := acLista;
  HabilitarAcoes(acLista);

end;

procedure TfCadastro.actAlterarExecute(Sender: TObject);
begin
  FAcao := acAltera;
  HabilitarAcoes(acAltera);
end;

procedure TfCadastro.actCancelarExecute(Sender: TObject);
begin
  HabilitarAcoes(acLista);
end;

procedure TfCadastro.actDetalharExecute(Sender: TObject);
begin
  Detalha;
end;

procedure TfCadastro.actFecharExecute(Sender: TObject);
begin
  Close;
end;

procedure TfCadastro.actInserirExecute(Sender: TObject);
begin
  FAcao := acInsere;
  PageControl.ActivePage := tsDetalhes;
  HabilitarAcoes(acInsere);
end;

procedure TfCadastro.actSalvarExecute(Sender: TObject);
begin
  HabilitarAcoes(acLista)
end;

procedure TfCadastro.actVoltarExecute(Sender: TObject);
begin
  Listar;
end;

procedure TfCadastro.Altera;
begin
  FAcao := acAltera;
  PageControl.ActivePage := tsDetalhes;
end;

procedure TfCadastro.Detalha;
begin
  FAcao := acLista;
  PageControl.ActivePage := tsDetalhes;
  HabilitarAcoes(acLista);
end;

procedure TfCadastro.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Self := nil;
end;

procedure TfCadastro.FormShow(Sender: TObject);
begin
  Mostrar;
end;

procedure TfCadastro.HabilitarAcoes(aAcao: TAcao);
begin
  case aAcao of
    acInsere, acAltera:
      begin
        btnVoltar.Enabled := false;
        btnFechar.Enabled := false;
        btnAlterar.Enabled := false;
        btnSalvar.Enabled := True;
        btnCancelar.Enabled := True;
      end;
    acLista:
      begin
        btnVoltar.Enabled := True;
        btnFechar.Enabled := True;
        btnAlterar.Enabled := True;
        btnSalvar.Enabled := false;
        btnCancelar.Enabled := false;
      end;
  end;
end;

procedure TfCadastro.Insere;
begin
  FAcao := acInsere;
  PageControl.ActivePage := tsDetalhes;
end;

procedure TfCadastro.Listar;
begin
  PageControl.ActivePage := tsListagem;
end;

end.
