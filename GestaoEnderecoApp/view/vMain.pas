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
    PessoasporLote1: TMenuItem;
    ImageList: TImageList;
    actFechar: TAction;
    actConfirmar: TAction;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actSobreExecute(Sender: TObject);
    procedure actPessoasExecute(Sender: TObject);
    procedure PessoasporLote1Click(Sender: TObject);
  private
    { Private declarations }
    procedure AbrirForm(T: TFormClass; F: TForm);
  public
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}

uses vSobre, vPessoas, vPesoasLote;

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

procedure TfMain.actSobreExecute(Sender: TObject);
begin
  AbrirForm(TfSobre, fSobre);
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

end.
