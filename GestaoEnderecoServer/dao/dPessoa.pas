unit dPessoa;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  Datasnap.DBClient, Datasnap.Provider, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, System.JSON, hDataSetJSON, System.Generics.Collections;

type
  TdmPessoa = class(TDataModule)
    qryPessoa: TFDQuery;
    updPessoa: TFDQuery;
    updEndereco: TFDQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    function CarregarPessoa(sId: String = ''): TJSONArray;
    function Inserir(jsonPessoa: TJSONObject; out sMsg: string): Boolean;
    function Alterar(sId: String; jsonPessoa: TJSONObject; out sMsg: string): Boolean;
    function Excluir(sId: String; out sMsg: string): Boolean;
    function InserirLote(jsonPessoa: TJSONArray; out sMsg: string): Boolean;
  end;


var
  dmPessoa: TdmPessoa;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses dConexao;

{$R *.dfm}

{ TdmPessoa }

function TdmPessoa.Alterar(sId: String; jsonPessoa: TJSONObject; out sMsg: string): Boolean;
var
  iId: Integer;
begin

  iId := StrToIntDef(sId, 0);

  updPessoa.SQL.Clear;
  updEndereco.SQL.Clear;

  dmConexao.Conexao.StartTransaction;

  try
    updPessoa.SQL.Text :=
      ' UPDATE Pessoa ' +
      ' SET flnatureza = :flnatureza, ' +
      '   dsdocumento = :dsdocumento, ' +
      '   nmprimeiro = :nmprimeiro, ' +
      '   nmsegundo = :nmsegundo ' +
      ' WHERE IdPessoa = :id ';
    updPessoa.ParamByName('id').AsInteger := iId;
    updPessoa.ParamByName('flnatureza').AsInteger := jsonPessoa.GetValue<integer>('flnatureza');
    updPessoa.ParamByName('dsdocumento').AsString := jsonPessoa.GetValue<string>('dsdocumento');
    updPessoa.ParamByName('nmprimeiro').AsString := jsonPessoa.GetValue<string>('nmprimeiro');
    updPessoa.ParamByName('nmsegundo').AsString := jsonPessoa.GetValue<string>('nmsegundo');
    updPessoa.ExecSQL;

    updEndereco.SQL.Text :=
      ' UPDATE Endereco ' +
      ' SET dscep = :dscep ' +
      ' WHERE IdPessoa = :id ';
    updEndereco.ParamByName('id').AsInteger := iId;
    updEndereco.ParamByName('dscep').AsString := jsonPessoa.GetValue<string>('dscep');
    updEndereco.ExecSQL;

    dmConexao.Conexao.Commit;
    sMsg := 'Pessoa alterada com sucesso!';
    Result := True;
  except
    on E: Exception do
    begin
      dmConexao.Conexao.Rollback;
      sMsg := 'Erro ao alterar Pessoa: ' + E.Message;
      Result := False;
    end;

  end;

end;

function TdmPessoa.CarregarPessoa(sId: String = ''): TJSONArray;
begin

  qryPessoa.SQL.Clear;
  qryPessoa.SQL.Add('SELECT Pessoa.*, Endereco.dscep');
  qryPessoa.SQL.Add('FROM Pessoa');
  qryPessoa.SQL.Add('INNER JOIN Endereco ON Endereco.idpessoa = Pessoa.idpessoa');

  if not sId.IsEmpty then
  begin
    qryPessoa.SQL.Add('WHERE Pessoa.idpessoa = :id');
    qryPessoa.ParamByName('id').AsInteger := strToIntDef(sId,0);
  end;

  qryPessoa.SQL.Add('ORDER BY Pessoa.nmprimeiro, Pessoa.nmsegundo');
  qryPessoa.Open;

  Result := qryPessoa.DataSetToJSON;

end;

function TdmPessoa.Excluir(sId: string; out sMsg: string): Boolean;
begin

  updPessoa.SQL.Clear;
  updPessoa.SQL.Text :=
    ' DELETE FROM Pessoa ' +
    ' WHERE IdPessoa = :Id ';
  updPessoa.Params[0].AsInteger := StrToIntDef(sId, 0);

  dmConexao.Conexao.StartTransaction;

  try
    updPessoa.ExecSQL;
    dmConexao.Conexao.Commit;
    sMsg := 'Pessoa excluida com sucesso!';
    Result := True;
  except
    on E: Exception do
    begin
      dmConexao.Conexao.Rollback;
      sMsg := 'Erro ao excluir Pessoa: ' + E.Message;
      Result := False;
    end;

  end;

end;

function TdmPessoa.Inserir(jsonPessoa: TJSONObject; out sMsg: string): Boolean;
begin

  updPessoa.SQL.Clear;
  updEndereco.SQL.Clear;

  dmConexao.Conexao.StartTransaction;

  try
    updPessoa.SQL.Text :=
      ' INSERT INTO Pessoa ' +
      ' (flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro) ' +
      ' VALUES (:flnatureza, :dsdocumento, :nmprimeiro, :nmsegundo, CURRENT_DATE); ';
    updPessoa.ParamByName('flnatureza').AsInteger := jsonPessoa.getValue<integer>('flnatureza');
    updPessoa.ParamByName('dsdocumento').AsString := jsonPessoa.getValue<string>('dsdocumento');
    updPessoa.ParamByName('nmprimeiro').AsString := jsonPessoa.getValue<string>('nmprimeiro');
    updPessoa.ParamByName('nmsegundo').AsString := jsonPessoa.getValue<string>('nmsegundo');
    updPessoa.ExecSQL;

    updEndereco.SQL.Text :=
      ' INSERT INTO Endereco ' +
      ' (idpessoa, dscep) ' +
      ' VALUES (currval(''pessoa_idpessoa_seq''), :dscep) ';
    updEndereco.ParamByName('dscep').AsString := jsonPessoa.GetValue<string>('dscep');
    updEndereco.ExecSQL;

    dmConexao.Conexao.Commit;
    sMsg := 'Pessoa inserida com sucesso!';
    Result := True;
  except
    on E: Exception do
    begin
      dmConexao.Conexao.Rollback;
      sMsg := 'Erro ao inserir Pessoa: ' + E.Message;
      Result := False;
    end;

  end;

end;

function TdmPessoa.InserirLote(jsonPessoa: TJSONArray;
  out sMsg: string): Boolean;
var
  iIdPessoa, i: integer;
begin

  updPessoa.SQL.Clear;
  updEndereco.SQL.Clear;

  dmConexao.Conexao.StartTransaction;

  try
    qryPessoa.SQL.Text :=
      ' SELECT LAST_VALUE AS idpessoa FROM pessoa_idpessoa_seq ';
    qryPessoa.Open;

    iIdPessoa := qryPessoa.Fields[0].AsInteger;

    updPessoa.SQL.Text :=
      ' INSERT INTO Pessoa ' +
      ' (idpessoa, flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro) ' +
      ' VALUES (:idpessoa, :flnatureza, :dsdocumento, :nmprimeiro, :nmsegundo, CURRENT_DATE); ';
    updPessoa.Params.ArraySize := jsonPessoa.Count;

    updEndereco.SQL.Text :=
      ' INSERT INTO Endereco ' +
      ' (idpessoa, dscep) ' +
      ' VALUES (:idpessoa, :dscep) ';
    updEndereco.Params.ArraySize := jsonPessoa.Count;

    for i := 0 to Pred(jsonPessoa.Count) do
    begin

      inc(iIdPessoa);

      updPessoa.ParamByName('idpessoa').AsIntegers[i] := iIdPessoa;
      updPessoa.ParamByName('flnatureza').AsIntegers[i] := jsonPessoa.Get(i).GetValue<integer>('flnatureza');
      updPessoa.ParamByName('dsdocumento').AsStrings[i] := jsonPessoa.Get(i).GetValue<string>('dsdocumento');
      updPessoa.ParamByName('nmprimeiro').AsStrings[i] := jsonPessoa.Get(i).GetValue<string>('nmprimeiro');
      updPessoa.ParamByName('nmsegundo').AsStrings[i] := jsonPessoa.Get(i).GetValue<string>('nmsegundo');

      updEndereco.ParamByName('idpessoa').AsIntegers[i] := iIdPessoa;
      updEndereco.ParamByName('dscep').AsStrings[i] := jsonPessoa.Get(i).GetValue<string>('dscep');

    end;

    updPessoa.Execute(updPessoa.Params.ArraySize);
    updEndereco.Execute(updEndereco.Params.ArraySize);

    qryPessoa.SQL.Text :=
      ' SELECT SETVAL(''pessoa_idpessoa_seq'', :idpessoa) ';
    qryPessoa.ParamByName('idpessoa').AsInteger := iIdPessoa;
    qryPessoa.Open;

    dmConexao.Conexao.Commit;
    sMsg := 'Pessoas em lote inseridas com sucesso!';
    Result := True;
  except
    on E: Exception do
    begin
      dmConexao.Conexao.Rollback;
      sMsg := 'Erro ao inserir Pessoa: ' + E.Message;
      Result := False;
    end;

  end;

end;

end.
