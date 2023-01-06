unit dPessoa;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient, Datasnap.Provider,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, mPessoa, System.JSON,
  REST.Types;

const
  sMetodos: string = 'tpessoa/pessoa';
  sMetodoLote: string = 'tpessoa/pessoaslote';

type
  TdmPessoa = class(TDataModule)
    dspPessoa: TDataSetProvider;
    cdsPessoa: TClientDataSet;
    cdsPessoadsdocumento: TWideStringField;
    cdsPessoanmprimeiro: TWideStringField;
    cdsPessoanmsegundo: TWideStringField;
    memPessoa: TFDMemTable;
    cdsPessoaidpessoa: TFloatField;
    cdsPessoaflnatureza: TFloatField;
    cdsPessoadtregistro: TWideStringField;
    cdsPessoadscep: TWideStringField;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Pesquisar(sId: string);
    procedure CarregarPessoa(oPessoa: TPessoa; iId: Integer);
    function Inserir(oPessoa: TPessoa; out sErro: string): Boolean;
    function Alterar(oPessoa: TPessoa; out sErro: string): Boolean;
    function Excluir(iId: Integer; out sErro: string): Boolean;

    function InserirLote(jsonLote: TStringList; out sMsg: string): Boolean;
  end;

var
  dmPessoa: TdmPessoa;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses dRest;

{$R *.dfm}

{ TdmPessoa }

function TdmPessoa.Alterar(oPessoa: TPessoa; out sErro: string): Boolean;
var
  jsonObj: TJSONObject;
  dmRest: TdmRest;
begin

  jsonObj := TJSONObject.Create;
  dmRest := TdmRest.Create(nil);

  try
    jsonObj.AddPair('flnatureza', IntToStr(oPessoa.FlNatureza));
    jsonObj.AddPair('dsdocumento', oPessoa.DsDocumento);
    jsonObj.AddPair('nmprimeiro', oPessoa.NmPrimeiro);
    jsonObj.AddPair('nmsegundo', oPessoa.NmSegundo);
    jsonObj.AddPair('dscep', oPessoa.DsCep);

    Result := dmRest.Requisicao(sMetodos, '/' + IntToStr(oPessoa.Id), sErro, jsonObj, rmPOST);
  finally
    FreeAndNil(jsonObj);
    FreeAndNil(dmRest);
  end;

end;

procedure TdmPessoa.CarregarPessoa(oPessoa: TPessoa; iId: Integer);
var
  sMsg: string;
  jsonObj: TJSONObject;
  dmRest: TdmRest;
begin

  jsonObj := TJSONObject.Create;
  dmRest := TDmRest.Create(nil);
  try

    if dmRest.Requisicao(sMetodos, '/' + IntToStr(iId), sMsg, jsonObj) then
    begin
      oPessoa.Id := dmRest.FDMemTable.FieldByName('idpessoa').AsInteger;
      oPessoa.FlNatureza := dmRest.FDMemTable.FieldByName('flnatureza').AsInteger;
      oPessoa.DsDocumento := dmRest.FDMemTable.FieldByName('dsdocumento').AsString;
      oPessoa.NmPrimeiro := dmRest.FDMemTable.FieldByName('nmprimeiro').AsString;
      oPessoa.NmSegundo := dmRest.FDMemTable.FieldByName('nmsegundo').AsString;
      oPessoa.DsCep := dmRest.FDMemTable.FieldByName('dscep').AsString;
    end;

  finally
    FreeAndNil(jsonObj);
    FreeAndNil(dmRest);
  end;
end;

function TdmPessoa.Excluir(iId: Integer; out sErro: string): Boolean;
var
  dmRest: TdmRest;
begin

  dmRest := TdmRest.Create(nil);

  try
    Result := dmRest.Requisicao(sMetodos, '/' + IntToStr(iId), sErro, nil, rmDELETE);
  finally
    FreeAndNil(dmRest);
  end;
end;

function TdmPessoa.Inserir(oPessoa: TPessoa; out sErro: string): Boolean;
var
  jsonObj: TJSONObject;
  dmRest: TdmRest;
begin

  jsonObj := TJSONObject.Create;
  dmRest := TdmRest.Create(nil);

  try
    jsonObj.AddPair('flnatureza', IntToStr(oPessoa.FlNatureza));
    jsonObj.AddPair('dsdocumento', oPessoa.DsDocumento);
    jsonObj.AddPair('nmprimeiro', oPessoa.NmPrimeiro);
    jsonObj.AddPair('nmsegundo', oPessoa.NmSegundo);
    jsonObj.AddPair('dscep', oPessoa.DsCep);

    Result := dmRest.Requisicao(sMetodos, EmptyStr, sErro, jsonObj, rmPUT);
  finally
    FreeAndNil(jsonObj);
    FreeAndNil(dmRest);
  end;

end;

function TdmPessoa.InserirLote(jsonLote: TStringList;
  out sMsg: string): Boolean;
var
  dmRest: TdmRest;
begin

  dmRest := TdmRest.Create(nil);

  try
    Result := dmRest.Requisicao(sMetodoLote, sMsg, jsonLote);
  finally
    FreeAndNil(dmRest);
  end;

end;

procedure TdmPessoa.Pesquisar(sId: string);
var
  dmRest: TdmRest;
  sMsg: string;
begin

  dmRest := TdmRest.Create(nil);

  try

    if sId <> EmptyStr then
      sId := '/' + sId;

    if dmRest.Requisicao(sMetodos, sId, sMsg) then
    begin

      if sMsg <> 'null' then
      begin
        cdsPessoa.Close;
        memPessoa.Close;
        memPessoa.CloneCursor(dmRest.FDMemTable);
        memPessoa.CopyDataSet(dmRest.FDMemTable, [coStructure, coRestart, coAppend]);
        cdsPessoa.Active := True;
      end
      else
      begin
        cdsPessoa.Close;
        raise Exception.Create('Nenhum registro encontrado');
      end;
    end;
  finally
    FreeAndNil(dmRest);
  end;

end;

end.
