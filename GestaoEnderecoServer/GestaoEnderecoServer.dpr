program GestaoEnderecoServer;
{$APPTYPE GUI}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  vGuiServer in 'view\vGuiServer.pas' {fGuiServer},
  uServerContainer in 'uServerContainer.pas' {dsServerContainer: TDataModule},
  uWebModule in 'uWebModule.pas' {dsWebModule: TWebModule},
  sPadrao in 'methods\sPadrao.pas',
  sPessoa in 'methods\sPessoa.pas',
  dConexao in 'dao\dConexao.pas' {dmConexao: TDataModule},
  dPessoa in 'dao\dPessoa.pas' {dmPessoa: TDataModule},
  dEndereco in 'dao\dEndereco.pas' {dmEndereco: TDataModule},
  hDataSetJSON in 'helper\hDataSetJSON.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TfGuiServer, fGuiServer);
  Application.Run;
end.
