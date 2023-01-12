unit sPessoa;

interface

uses System.SysUtils, System.Classes, Datasnap.DSServer, Datasnap.DSAuth,
  System.JSON;

type
{$METHODINFO ON}
  Tpessoa = class(TComponent)
  private
    { Private declarations }
  public
    { Public declarations }
    function Pessoa(const Key: string): TJSONArray;
    function acceptPessoa(jObject: TJSONObject): string;
    function updatePessoa(const Key: string; jObject: TJSONObject): string;
    function cancelPessoa(const Key: string): string;
    function acceptPessoasLote(jArray: TJSONArray): string;
  end;
{$METHODINFO OFF}

implementation


uses dPessoa;

function Tpessoa.acceptPessoa(jObject: TJSONObject): string;
var
  dmPessoa: TdmPessoa;
  sMsg: string;
begin


  dmPessoa := TdmPessoa.Create(nil);

  try
    dmPessoa.Inserir(jObject, sMsg);
    Result := sMsg;
  finally
    FreeAndNil(dmPessoa);
  end;

end;

function Tpessoa.acceptPessoasLote(jArray: TJSONArray): string;
var
  dmPessoa: TdmPessoa;
  sMsg: string;
begin

  dmPessoa := TdmPessoa.Create(nil);

  try
    dmPessoa.InserirLote(jArray, sMsg);
    Result := sMsg;
  finally
    FreeAndNil(dmPessoa);
  end;

end;

function Tpessoa.cancelPessoa(const Key: string): string;
var
  dmPessoa: TdmPessoa;
  sMsg: string;
begin

  dmPessoa := TdmPessoa.Create(nil);

  try
    dmPessoa.Excluir(Key, sMsg);
    Result := sMsg;
  finally
    FreeAndNil(dmPessoa);
  end;

end;

function Tpessoa.Pessoa(const Key: string): TJSONArray;
var
  dmPessoa: TdmPessoa;
begin

  dmPessoa := TdmPessoa.Create(nil);

  try
    Result := dmPessoa.CarregarPessoa(Key);
  finally
    FreeAndNil(dmPessoa);
  end;

end;

function Tpessoa.updatePessoa(const Key: string; jObject: TJSONObject): string;
var
  dmPessoa: TdmPessoa;
  sMsg: string;
begin

  dmPessoa := TdmPessoa.Create(nil);

  try
    dmPessoa.Alterar(Key, jObject, sMsg);
    Result := sMsg;
  finally
    FreeAndNil(dmPessoa);
  end;

end;

end.
