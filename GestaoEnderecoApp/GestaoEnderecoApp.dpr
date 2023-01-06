program GestaoEnderecoApp;

uses
  Vcl.Forms,
  vMain in 'view\vMain.pas' {Form1},
  vSobre in 'view\vSobre.pas' {fSobre},
  vCadastro in 'view\vCadastro.pas' {fCadastro},
  mPessoa in 'model\mPessoa.pas',
  dRest in 'dao\dRest.pas' {dmRest: TDataModule},
  dPessoa in 'dao\dPessoa.pas' {dmPessoa: TDataModule},
  cPessoa in 'controller\cPessoa.pas',
  hComboBox in 'helper\hComboBox.pas',
  hEdit in 'helper\hEdit.pas' {$R *.res},
  vPessoas in 'view\vPessoas.pas' {fPessoas},
  vPesoasLote in 'view\vPesoasLote.pas' {fPessoasLote},
  dEndereco in 'dao\dEndereco.pas' {dmEndereco: TDataModule},
  cEndereco in 'methods\cEndereco.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
