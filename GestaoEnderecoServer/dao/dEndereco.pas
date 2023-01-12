unit dEndereco;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.JSON, REST.Types,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope,
  System.Generics.Collections, dConexao;

type
  TdmEndereco = class(TDataModule)
    updEndereco: TFDQuery;
    qryEndereco: TFDQuery;
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    delEndereco: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    dmConexao: TdmConexao;
  public
    { Public declarations }
    procedure AtualizarEndereco(iId: Integer; sCep: string; out sMsg: string);
    procedure CarregarEnderecos;
    procedure CarregarEnderecosSemIntegracao;
    procedure SetaConexao;
    function Inserir(jsonEndereco: TJSONObject; iId: integer; out sMsg: string): Boolean;
    function buscarViaCEP(sCep: string): TJSONObject;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmEndereco }

procedure TdmEndereco.AtualizarEndereco(iId: Integer; sCep: string; out sMsg: string);
var
  dmEndereco: TdmEndereco;
begin

  dmEndereco := TdmEndereco.Create(nil);

  try
    dmEndereco.Inserir(buscarViaCEP(sCep), iId, sMsg);
  finally
    FreeAndNil(dmEndereco);
  end;

end;

function TdmEndereco.buscarViaCEP(sCep: string): TJSONObject;
const
  sUrl: string = 'https://viacep.com.br/ws/';
  sType: string = '/json';
begin

  RESTClient.BaseURL := sUrl + sCep + sType;
  RESTRequest.Execute;
  Result := RESTRequest.Response.JSONValue AS TJSONObject;

end;

procedure TdmEndereco.CarregarEnderecos;
begin

  qryEndereco.SQL.Clear;
  qryEndereco.SQL.Text :=
    ' SELECT idendereco, dscep ' +
    ' FROM Endereco ' +
    ' ORDER BY idendereco ';
  qryEndereco.Open;

end;

procedure TdmEndereco.CarregarEnderecosSemIntegracao;
begin

  qryEndereco.SQL.Clear;
  qryEndereco.SQL.Text :=
    ' SELECT e.idendereco, e.dscep ' +
    ' FROM Endereco e ' +
    ' WHERE NOT EXISTS ' +
    '   ( ' +
    '   SELECT 1 ' +
    '   FROM endereco_integracao ei ' +
    '   WHERE ei.idendereco = e.idendereco ' +
    '   ) ';
  qryEndereco.Open;

end;

procedure TdmEndereco.DataModuleCreate(Sender: TObject);
begin
  dmConexao := TdmConexao.Create(nil);
end;

procedure TdmEndereco.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(dmConexao);
end;

function TdmEndereco.Inserir(jsonEndereco: TJSONObject; iId: integer;
  out sMsg: string): Boolean;
begin

  if (jsonEndereco.Get(0).JsonString.Value = 'erro') and
    (jsonEndereco.Get(0).JsonValue.Value = 'true') then
    begin
      sMsg := 'Cep não localizado.';
      Result := False;
      Exit;
    end;

  updEndereco.SQL.Clear;
  updEndereco.SQL.Text :=
    ' INSERT INTO Endereco_Integracao ' +
    ' (idendereco, dsuf, nmcidade, nmbairro, nmlogradouro, dscomplemento) ' +
    ' VALUES (:id, :dsuf, :nmcidade, :nmbairro, :nmlogradouro, :dscomplemento) ';

  updEndereco.ParamByName('id').AsInteger := iId;
  updEndereco.ParamByName('dsuf').AsString := jsonEndereco.getValue<string>('uf');
  updEndereco.ParamByName('nmcidade').AsString := jsonEndereco.getValue<string>('localidade');
  updEndereco.ParamByName('nmbairro').AsString := jsonEndereco.getValue<string>('bairro');
  updEndereco.ParamByName('nmlogradouro').AsString := jsonEndereco.getValue<string>('logradouro');
  updEndereco.ParamByName('dscomplemento').AsString := jsonEndereco.getValue<string>('complemento');

  dmConexao.Conexao.StartTransaction;

  try
    updEndereco.ExecSQL;
    dmConexao.Conexao.Commit;
    sMsg := 'Endereço inserido com sucesso!';
    Result := True;
  except
    on E: Exception do
    begin
      dmConexao.Conexao.Rollback;
      sMsg := 'Erro ao inserir Endereço: ' + E.Message;
      Result := False;
    end;

  end;

end;

procedure TdmEndereco.SetaConexao;
begin
  qryEndereco.Connection := dmConexao.Conexao;
  updEndereco.Connection := dmConexao.Conexao;
  delEndereco.Connection := dmConexao.Conexao;
end;

end.
