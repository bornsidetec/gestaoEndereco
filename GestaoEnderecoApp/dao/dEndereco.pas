unit dEndereco;

interface

uses
  System.SysUtils, System.Classes, REST.Types,
  Data.DBXDataSnap, Data.DBXCommon, IPPeerClient, Data.DB, Data.SqlExpr,
  Data.DbxHTTPLayer, Datasnap.DSCommon, cEndereco;

const
  sMetodos: string = 'tendereco/endereco';

type

  TdmEndereco = class(TDataModule)
    SQLConnection: TSQLConnection;
    procedure SQLConnectionAfterConnect(Sender: TObject);
    procedure SQLConnectionBeforeDisconnect(Sender: TObject);
  private
    FInstanceOwner: Boolean;
    FenderecoClient: TenderecoClient;
    function GetenderecoClient: TenderecoClient;
    { Private declarations }
  public
    { Public declarations }

    Proxy: TenderecoClient;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property InstanceOwner: Boolean read FInstanceOwner write FInstanceOwner;
    property enderecoClient: TenderecoClient read GetenderecoClient write FenderecoClient;

  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses dRest;

{$R *.dfm}

{ TdmEndereco }

constructor TdmEndereco.Create(AOwner: TComponent);
begin
  inherited;
  FInstanceOwner := True;
end;

destructor TdmEndereco.Destroy;
begin
  FenderecoClient.Free;
  inherited;
end;

function TdmEndereco.GetenderecoClient: TenderecoClient;
begin
  if FenderecoClient = nil then
  begin
    SQLConnection.Open;
    FenderecoClient:= TenderecoClient.Create(SQLConnection.DBXConnection, FInstanceOwner);
  end;
  Result := FenderecoClient;
end;

procedure TdmEndereco.SQLConnectionAfterConnect(Sender: TObject);
begin
  Proxy := TenderecoClient.Create(SQLConnection.DBXConnection);
end;

procedure TdmEndereco.SQLConnectionBeforeDisconnect(Sender: TObject);
begin
  FreeAndNil(Proxy)
end;

end.
