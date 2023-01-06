unit hComboBox;

interface

uses
  Vcl.StdCtrls, System.SysUtils, System.Classes;

type
  TComboBoxHelper = class helper for TComboBox

  public
    class function Id(sTexto, sSeparador: string): Integer;
    class function IdOf(sCombo: TComboBox; iId: Integer; sSeparador: string): Integer;

  end;

implementation

{ TComboBoxHelper }

class function TComboBoxHelper.Id(sTexto, sSeparador: string): Integer;
var
  iPosicao, iId: Integer;
begin

  Result := 0;

  iPosicao := Pos(sSeparador, sTexto);
  if iPosicao > 0 then
  begin
    try
      iId := StrToInt(Trim(Copy(sTexto, 1, iPosicao - 1)));
      Result := iId;
    except

    end;
  end;

end;

class function TComboBoxHelper.IdOf(sCombo: TComboBox; iId: Integer; sSeparador: string): Integer;
var
  cbo: TStringList;
  i, iPosicao: Integer;
begin
  cbo := TStringList.Create;

  try
    cbo.Clear;
    for i := 0 to sCombo.Items.Count - 1 do
    begin
      iPosicao := Pos(sSeparador, sCombo.Items[i]);
      cbo.Add(Trim(Copy(sCombo.Items[i], 1, iPosicao - 1)));
    end;
    Result := cbo.IndexOf(IntToStr(iId));
  finally
    FreeAndNil(cbo);
  end;
end;


end.
