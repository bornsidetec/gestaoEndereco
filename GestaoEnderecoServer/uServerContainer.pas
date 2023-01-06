unit uServerContainer;

interface

uses System.SysUtils, System.Classes,
  Datasnap.DSServer, Datasnap.DSCommonServer,
  IPPeerServer, IPPeerAPI, Datasnap.DSAuth;

type
  TdsServerContainer = class(TDataModule)
    DSServer: TDSServer;
    DSServerClassPadrao: TDSServerClass;
    DSServerClassPessoa: TDSServerClass;
    DSServerClassEndereco: TDSServerClass;
    procedure DSServerClassPadraoGetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
    procedure DSServerClassPessoaGetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
    procedure DSServerClassEnderecoGetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

function DSServer: TDSServer;

implementation


{$R *.dfm}

uses
  sPadrao, sPessoa, sEndereco;

var
  FModule: TComponent;
  FDSServer: TDSServer;

function DSServer: TDSServer;
begin
  Result := FDSServer;
end;

constructor TdsServerContainer.Create(AOwner: TComponent);
begin
  inherited;
  FDSServer := DSServer;
end;

destructor TdsServerContainer.Destroy;
begin
  inherited;
  FDSServer := nil;
end;

procedure TdsServerContainer.DSServerClassEnderecoGetClass(
  DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
begin
  PersistentClass := sEndereco.Tendereco;
end;

procedure TdsServerContainer.DSServerClassPadraoGetClass(
  DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
begin
  PersistentClass := sPadrao.Tpadrao;
end;

procedure TdsServerContainer.DSServerClassPessoaGetClass(
  DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
begin
  PersistentClass := sPessoa.Tpessoa;
end;

initialization
  FModule := TdsServerContainer.Create(nil);
finalization
  FModule.Free;
end.

