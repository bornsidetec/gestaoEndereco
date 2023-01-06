//
// Created by the DataSnap proxy generator.
// 05/01/2023 13:21:21
// 

unit cEndereco;

interface

uses System.JSON, Data.DBXCommon, Data.DBXClient, Data.DBXDataSnap, Data.DBXJSON, Datasnap.DSProxy, System.Classes, System.SysUtils, Data.DB, Data.SqlExpr, Data.DBXDBReaders, Data.DBXCDSReaders, Data.DBXJSONReflect;

type

  TenderecoClient = class(TDSAdminClient)
  private
    FupdateEnderecoCommand: TDBXCommand;
  public
    constructor Create(ADBXConnection: TDBXConnection); overload;
    constructor Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    function updateEndereco(aCallBack: TDBXCallback): string;
  end;

implementation

function TenderecoClient.updateEndereco(aCallBack: TDBXCallback): string;
begin
  if FupdateEnderecoCommand = nil then
  begin
    FupdateEnderecoCommand := FDBXConnection.CreateCommand;
    FupdateEnderecoCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FupdateEnderecoCommand.Text := 'Tendereco.updateEndereco';
    FupdateEnderecoCommand.Prepare;
  end;
  FupdateEnderecoCommand.Parameters[0].Value.SetCallbackValue(aCallBack);
  FupdateEnderecoCommand.ExecuteUpdate;
  Result := FupdateEnderecoCommand.Parameters[1].Value.GetWideString;
end;

constructor TenderecoClient.Create(ADBXConnection: TDBXConnection);
begin
  inherited Create(ADBXConnection);
end;

constructor TenderecoClient.Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean);
begin
  inherited Create(ADBXConnection, AInstanceOwner);
end;

destructor TenderecoClient.Destroy;
begin
  FupdateEnderecoCommand.DisposeOf;
  inherited;
end;

end.
