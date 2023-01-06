unit sPadrao;

interface

uses System.SysUtils, System.Classes, Datasnap.DSServer, Datasnap.DSAuth;

type
{$METHODINFO ON}
  Tpadrao = class(TComponent)
  private
    { Private declarations }
  public
    { Public declarations }
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;
  end;
{$METHODINFO OFF}

implementation


uses System.StrUtils;

function Tpadrao.EchoString(Value: string): string;
begin
  Result := Value;
end;

function Tpadrao.ReverseString(Value: string): string;
begin
  Result := System.StrUtils.ReverseString(Value);
end;

end.
