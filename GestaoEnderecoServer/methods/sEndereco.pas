unit sEndereco;

interface

uses System.SysUtils, System.Classes, Datasnap.DSServer, Datasnap.DSAuth,
  System.JSON, Data.DBXJSON;

type
{$METHODINFO ON}
  Tendereco = class(TComponent)
  private
    { Private declarations }
  public
    { Public declarations }
    function updateEndereco(aCallBack: TDBXCallback): string;
  end;
{$METHODINFO OFF}

implementation

{ Tendereco }

uses dEndereco;

function Tendereco.updateEndereco(aCallBack: TDBXCallback): string;
var
  sMsg: string;
  iId: integer;
  sCep: string;
  jsonStatus: TJSONObject;
begin

  try
    if not Assigned(dmEndereco) then
      dmEndereco := TdmEndereco.Create(nil);

    dmEndereco.CarregarEnderecos;

    while not dmEndereco.qryEndereco.Eof do
    begin

      iId := dmEndereco.qryEndereco.FieldByName('idendereco').AsInteger;
      sCep := dmEndereco.qryEndereco.FieldByName('dscep').AsString;

      dmEndereco.AtualizarEndereco(iId, sCep, sMsg);

      jsonStatus := TJSONObject.Create;
      jsonStatus.AddPair('cep', sCep);
      jsonStatus.AddPair('status', sMsg);
      aCallBack.Execute(jsonStatus).Free;

      dmEndereco.qryEndereco.Next;
    end;

    Result := 'Finalizado com sucesso';
  finally
    FreeAndNil(dmEndereco);
  end;

end;

end.
