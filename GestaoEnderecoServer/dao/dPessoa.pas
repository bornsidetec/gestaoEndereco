unit dPessoa;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  Datasnap.DBClient, Datasnap.Provider, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, System.JSON, hDataSetJSON, System.Generics.Collections,
  dConexao;

type
  TPessoa = class
  private
    Fid: Integer;
    FFlNatureza: Integer;
    FNmPrimeiro: string;
    FNmSegundo: string;
    FDsDocumento: string;
    FDsCep: string;
    procedure SetDsDocumento(const Value: string);
    procedure SetNmPrimeiro(const Value: string);
    procedure SetNmSegundo(const Value: string);
    procedure SetDsCep(const Value: string);
  public
    property Id: Integer read Fid write Fid;
    property FlNatureza: Integer read FFlNatureza write FFlNatureza;
    property DsDocumento: string read FDsDocumento write SetDsDocumento;
    property NmPrimeiro: string read FNmPrimeiro write SetNmPrimeiro;
    property NmSegundo: string read FNmSegundo write SetNmSegundo;
    property DsCep: string read FDsCep write SetDsCep;
  end;

  TPessoaEndereco = class
  private
    Fid: Integer;
    FDsCep: string;
    procedure SetDsCep(const Value: string);
  public
    property Id: Integer read Fid write Fid;
    property DsCep: string read FDsCep write SetDsCep;
  end;

  TdmPessoa = class(TDataModule)
    qryPessoa: TFDQuery;
    updPessoa: TFDQuery;
    updEndereco: TFDQuery;
    updEnderecoIntegracao: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    dmConexao: TdmConexao;
  public
    { Public declarations }
    function CarregarPessoa(sId: String = ''): TJSONArray;
    function Inserir(jsonPessoa: TJSONObject; out sMsg: string): Boolean;
    function Alterar(sId: String; jsonPessoa: TJSONObject; out sMsg: string): Boolean;
    function Excluir(sId: String; out sMsg: string): Boolean;
    function InserirLote(jsonPessoa: TJSONArray; out sMsg: string): Boolean;
    function InserirPessoa(lPessoa: TObjectList<TPessoa>; out sMsg: string; var lPessoaEndereco: TObjectList<TPessoaEndereco>): Boolean;
    function InserirPessoaEndereco(lPessoaEndereco: TObjectList<TPessoaEndereco>; out sMsg: string): Boolean;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

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
      ' WHERE IdPessoa = :id ' +
      ' RETURNING idendereco ';
    updEndereco.ParamByName('id').AsInteger := iId;
    updEndereco.ParamByName('dscep').AsString := jsonPessoa.GetValue<string>('dscep');
    updEndereco.Open;

    if jsonPessoa.GetValue<string>('nmlogradouro') <> EmptyStr then
    begin
      updEnderecoIntegracao.SQL.Text :=
        ' UPDATE Endereco_Integracao ' +
        ' SET dsuf = :dsuf, ' +
        '   nmcidade = :nmcidade, ' +
        '   nmbairro = :nmbairro, ' +
        '   nmlogradouro = :nmlogradouro, ' +
        '   dscomplemento = :dscomplemento ' +
        ' WHERE IdEndereco = :idendereco ';
      updEnderecoIntegracao.ParamByName('idendereco').AsInteger := updEndereco.FieldByName('idendereco').AsInteger;
      updEnderecoIntegracao.ParamByName('dsuf').AsString := jsonPessoa.GetValue<string>('dsuf');
      updEnderecoIntegracao.ParamByName('nmcidade').AsString := jsonPessoa.GetValue<string>('nmcidade');
      updEnderecoIntegracao.ParamByName('nmbairro').AsString := jsonPessoa.GetValue<string>('nmbairro');
      updEnderecoIntegracao.ParamByName('nmlogradouro').AsString := jsonPessoa.GetValue<string>('nmlogradouro');
      updEnderecoIntegracao.ParamByName('dscomplemento').AsString := jsonPessoa.GetValue<string>('dscomplemento');
      updEnderecoIntegracao.ExecSQL;
    end;

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
  qryPessoa.SQL.Add('SELECT Pessoa.*, ');
  qryPessoa.SQL.Add('Endereco.dscep, ');
  qryPessoa.SQL.Add('Endereco_Integracao.*');
  qryPessoa.SQL.Add('FROM Pessoa');
  qryPessoa.SQL.Add('INNER JOIN Endereco ON Endereco.idpessoa = Pessoa.idpessoa');
  qryPessoa.SQL.Add('INNER JOIN Endereco_Integracao ON Endereco_Integracao.idendereco = Endereco.idendereco');

  if not sId.IsEmpty then
  begin
    qryPessoa.SQL.Add('WHERE Pessoa.idpessoa = :id');
    qryPessoa.ParamByName('id').AsInteger := strToIntDef(sId,0);
  end;

  qryPessoa.SQL.Add('ORDER BY Pessoa.nmprimeiro, Pessoa.nmsegundo');
  qryPessoa.Open;

  Result := qryPessoa.DataSetToJSON;

end;

procedure TdmPessoa.DataModuleCreate(Sender: TObject);
begin
  dmConexao := TdmConexao.Create(nil);
end;

procedure TdmPessoa.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(dmConexao);
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

    if jsonPessoa.GetValue<string>('nmlogradouro') <> EmptyStr then
    begin
      updEnderecoIntegracao.SQL.Text :=
        ' INSERT INTO Endereco_Integracao ' +
        ' (idendereco, dsuf, nmcidade, nmbairro, nmlogradouro, dscomplemento) ' +
        ' VALUES (currval(''endereco_idendereco_seq''), :dsuf, :nmcidade, :nmbairro, :nmlogradouro, :dscomplemento) ';
      updEnderecoIntegracao.ParamByName('dsuf').AsString := jsonPessoa.GetValue<string>('dsuf');
      updEnderecoIntegracao.ParamByName('nmcidade').AsString := jsonPessoa.GetValue<string>('nmcidade');
      updEnderecoIntegracao.ParamByName('nmbairro').AsString := jsonPessoa.GetValue<string>('nmbairro');
      updEnderecoIntegracao.ParamByName('nmlogradouro').AsString := jsonPessoa.GetValue<string>('nmlogradouro');
      updEnderecoIntegracao.ParamByName('dscomplemento').AsString := jsonPessoa.GetValue<string>('dscomplemento');
      updEnderecoIntegracao.ExecSQL;
    end;

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
  i: integer;
  lPessoa: TObjectList<TPessoa>;
  oPessoa: TPessoa;
  lPessoaEndereco: TObjectList<TPessoaEndereco>;
begin


  oPessoa := TPessoa.Create;
  lPessoa := TObjectList<TPessoa>.Create(False);
  lPessoaEndereco := TObjectList<TPessoaEndereco>.Create(False);

  try

    for i := 0 to Pred(jsonPessoa.Count) do
    begin
      lPessoa.Add(TPessoa.Create);
      lPessoa[i].FlNatureza := jsonPessoa.Get(i).GetValue<integer>('flnatureza');
      lPessoa[i].DsDocumento := jsonPessoa.Get(i).GetValue<string>('dsdocumento');
      lPessoa[i].NmPrimeiro := jsonPessoa.Get(i).GetValue<string>('nmprimeiro');
      lPessoa[i].NmSegundo := jsonPessoa.Get(i).GetValue<string>('nmsegundo');
      lPessoa[i].DsCep := jsonPessoa.Get(i).GetValue<string>('dscep');
    end;

    dmConexao.Conexao.StartTransaction;

    if InserirPessoa(lPessoa, sMsg, lPessoaEndereco) then
    begin
      InserirPessoaEndereco(lPessoaEndereco, sMsg);
      dmConexao.Conexao.Commit;
      Result := True;
    end
    else
    begin
      dmConexao.Conexao.Rollback;
      Result := False;
    end;

  finally
    FreeAndNil(oPessoa);
    lPessoa.Free;
    lPessoaEndereco.Free;
  end;

end;

function Tdmpessoa.InserirPessoa(lPessoa: TObjectList<TPessoa>; out sMsg: string; var lPessoaEndereco: TObjectList<TPessoaEndereco>): Boolean;
var
  i: integer;
begin

  try

    for i := 0 to Pred(lPessoa.Count) do
    begin

      updPessoa.SQL.Clear;
      updPessoa.SQL.Text :=
        ' INSERT INTO Pessoa ' +
        ' (flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro) ' +
        ' VALUES (:flnatureza, :dsdocumento, :nmprimeiro, :nmsegundo, CURRENT_DATE) RETURNING idpessoa; ';

      updPessoa.ParamByName('flnatureza').AsInteger := lPessoa.Items[i].FFlNatureza;
      updPessoa.ParamByName('dsdocumento').AsString := lPessoa.Items[i].DsDocumento;
      updPessoa.ParamByName('nmprimeiro').AsString := lPessoa.Items[i].NmPrimeiro;
      updPessoa.ParamByName('nmsegundo').AsString := lPessoa.Items[i].NmSegundo;

      updPessoa.Open;

      lPessoaEndereco.Add(TPessoaEndereco.Create);
      lPessoaEndereco[i].Id := updPessoa.FieldByName('idpessoa').AsInteger;
      lPessoaEndereco[i].DsCep := lPessoa.Items[i].DsCep;

    end;

    Result := True;
    sMsg := 'Pessoas em lote inseridas com sucesso!';

  except
    on E: Exception do
    begin
      Result := False;
      sMsg := 'Erro ao inserir Pessoas: ' + E.Message;
    end;
  end;

end;

function TdmPessoa.InserirPessoaEndereco(lPessoaEndereco: TObjectList<TPessoaEndereco>;
  out sMsg: string): Boolean;
var
  i: integer;
begin

  updPessoa.SQL.Clear;
  updPessoa.SQL.Text :=
    ' INSERT INTO Endereco ' +
    ' (idpessoa, dscep) ' +
    ' VALUES (:idpessoa, :dscep); ';
  updPessoa.Params.ArraySize := lPessoaEndereco.Count;

  for i := 0 to Pred(lPessoaEndereco.Count) do
  begin
    updPessoa.ParamByName('idpessoa').AsIntegers[i] := lPessoaEndereco.Items[i].Id;
    updPessoa.ParamByName('dscep').AsStrings[i] := lPessoaEndereco.Items[i].DsCep;
  end;

  try
    updPessoa.Execute(updPessoa.Params.ArraySize);

    sMsg := 'Pessoas_Enderecos em lote inseridos com sucesso!';
    Result := True;
  except
    on E: Exception do
    begin
      sMsg := 'Erro ao inserir Pessoa: ' + E.Message;
      Result := False;
    end;

  end;

end;

{ TPessoa }

procedure TPessoa.SetDsCep(const Value: string);
begin
  FDsCep := Value;
end;

procedure TPessoa.SetDsDocumento(const Value: string);
begin
  FDsDocumento := Value;
end;

procedure TPessoa.SetNmPrimeiro(const Value: string);
begin
  FNmPrimeiro := Value;
end;

procedure TPessoa.SetNmSegundo(const Value: string);
begin
  FNmSegundo := Value;
end;

{ TPessoaEndereco }

procedure TPessoaEndereco.SetDsCep(const Value: string);
begin
  FDsCep := Value;
end;

end.
