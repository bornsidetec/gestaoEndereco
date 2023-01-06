unit cPessoa;

interface

uses
  mPessoa, dPessoa, System.SysUtils;

type
  TPessoaController = class
  public
    procedure Pesquisar(sId: string);
    procedure CarregarPessoa(oPessoa: TPessoa; iId: Integer);
    function Inserir(oPessoa: TPessoa; var sErro: string): Boolean;
    function Alterar(oPessoa: TPessoa; var sErro: string): Boolean;
    function Excluir(iId: Integer; var sErro: string): Boolean;
  end;

implementation

{ TPessoaController }

function TPessoaController.Alterar(oPessoa: TPessoa;
  var sErro: string): Boolean;
begin
  Result := dmPessoa.Alterar(oPessoa, sErro);
end;

procedure TPessoaController.CarregarPessoa(oPessoa: TPessoa; iId: Integer);
begin
  dmPessoa.CarregarPessoa(oPessoa, iId);
end;

function TPessoaController.Excluir(iId: Integer; var sErro: string): Boolean;
begin
  Result := dmPessoa.Excluir(iId, sErro);
end;

function TPessoaController.Inserir(oPessoa: TPessoa;
  var sErro: string): Boolean;
begin
  Result := dmPessoa.Inserir(oPessoa, sErro);
end;

procedure TPessoaController.Pesquisar(sId: string);
begin
  dmPessoa.Pesquisar(sId);
end;

end.
