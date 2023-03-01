unit mPessoa;

interface

uses System.SysUtils;

type
  TPessoa = class
  private
    Fid: Integer;
    FFlNatureza: Integer;
    FNmPrimeiro: string;
    FDtRegistro: TDate;
    FNmSegundo: string;
    FDsDocumento: string;
    FDsCep: string;
    FDsUf: string;
    FNmCidade: string;
    FNmLogradouro: string;
    FNmBairro: string;
    FDsComplemento: string;
    procedure SetDsDocumento(const Value: string);
    procedure SetNmPrimeiro(const Value: string);
    procedure SetNmSegundo(const Value: string);
    procedure SetDsCep(const Value: string);
    procedure SetDsUf(const Value: string);
    procedure SetDsComplemento(const Value: string);
    procedure SetNmBairro(const Value: string);
    procedure SetNmCidade(const Value: string);
    procedure SetNmLogradouro(const Value: string);
  public
    property Id: Integer read Fid write Fid;
    property FlNatureza: Integer read FFlNatureza write FFlNatureza;
    property DsDocumento: string read FDsDocumento write SetDsDocumento;
    property NmPrimeiro: string read FNmPrimeiro write SetNmPrimeiro;
    property NmSegundo: string read FNmSegundo write SetNmSegundo;
    property DtRegistro: TDate read FDtRegistro write FDtRegistro;
    property DsCep: string read FDsCep write SetDsCep;
    property DsUf: string read FDsUf write SetDsUf;
    property NmCidade: string read FNmCidade write SetNmCidade;
    property NmBairro: string read FNmBairro write SetNmBairro;
    property NmLogradouro: string read FNmLogradouro write SetNmLogradouro;
    property DsComplemento: string read FDsComplemento write SetDsComplemento;


  end;

implementation

{ TPessoa }

procedure TPessoa.SetDsCep(const Value: string);
begin
  if Value = EmptyStr then
    raise EArgumentException.Create('Cep não informado');

  FDsCep := Value;
end;

procedure TPessoa.SetDsComplemento(const Value: string);
begin
  FDsComplemento := Value;
end;

procedure TPessoa.SetDsDocumento(const Value: string);
begin
  if Value = EmptyStr then
    raise EArgumentException.Create('Documento não informado');

  FDsDocumento := Value;
end;

procedure TPessoa.SetDsUf(const Value: string);
begin
  FDsUf := Value;
end;

procedure TPessoa.SetNmBairro(const Value: string);
begin
  FNmBairro := Value;
end;

procedure TPessoa.SetNmCidade(const Value: string);
begin
  FNmCidade := Value;
end;

procedure TPessoa.SetNmLogradouro(const Value: string);
begin
  FNmLogradouro := Value;
end;

procedure TPessoa.SetNmPrimeiro(const Value: string);
begin
  if Value = EmptyStr then
    raise EArgumentException.Create('Primeiro nome não informado');

  FNmPrimeiro := Value;
end;

procedure TPessoa.SetNmSegundo(const Value: string);
begin
  if Value = EmptyStr then
    raise EArgumentException.Create('Segundo nome não informado');

  FNmSegundo := Value;
end;

end.
