unit dRest;

interface

uses
  System.SysUtils, System.Classes, REST.Types, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, System.JSON;

const
  sWsUrl: string = 'http://localhost:8080/datasnap/rest/';

type
  TdmRest = class(TDataModule)
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    RESTResponseDataSetAdapter: TRESTResponseDataSetAdapter;
    FDMemTable: TFDMemTable;
  private
    { Private declarations }
  public
    { Public declarations }
    function Requisicao(const sMetodo, sParam: string; out sMsg: string;
      json: TJSONObject = nil; requestMetodo: TRESTRequestMethod = rmGET): Boolean; overload;
    function Requisicao(const sMetodo: string; out sMsg: string;
      slJson: TStringList; requestMetodo: TRESTRequestMethod = rmPUT): Boolean; overload;

  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmRest }

function TdmRest.Requisicao(const sMetodo, sParam: string; out sMsg: string;
  json: TJSONObject; requestMetodo: TRESTRequestMethod): Boolean;
begin

  Result := False;

  try
    RESTClient.BaseURL := sWSUrl + sMetodo + sParam;

    RESTRequest.Method := requestMetodo;

    RESTRequest.Body.ClearBody;
    if (json <> nil) and (json.Count > 0) then
      RESTRequest.Body.Add(json.ToString, ContentTypeFromString('application/json'));

    RESTRequest.Execute;
    sMsg := RESTRequest.Response.JSONText;
    Result := True;
  except
    on E: Exception do
    begin
      sMsg := 'Requisição Falhou: ' + sLineBreak + E.Message;
      Result := False;
    end;
  end;

end;

function TdmRest.Requisicao(const sMetodo: string; out sMsg: string;
  slJson: TStringList; requestMetodo: TRESTRequestMethod): Boolean;
begin

  Result := False;

  try
    RESTClient.BaseURL := sWSUrl + sMetodo;
    RESTRequest.Method := requestMetodo;
    RESTRequest.Body.ClearBody;
    RESTRequest.Body.Add(slJson.Text, ContentTypeFromString('application/json'));
    RESTRequest.Execute;
    sMsg := RESTRequest.Response.JSONText;
    Result := True;
  except
    on E: Exception do
    begin
      sMsg := 'Requisição Falhou: ' + sLineBreak + E.Message;
      Result := False;
    end;
  end;

end;

end.
