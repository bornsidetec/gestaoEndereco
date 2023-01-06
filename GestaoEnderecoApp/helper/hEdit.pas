unit hEdit;

interface

uses
  Vcl.StdCtrls, System.SysUtils, Vcl.Mask;

type
  TEditHelper = class helper for TEdit
  public
    class procedure KeyPress(var Key: Char; sTexto: string;
      iLocal, iTamanho, iCasas: Integer);
  end;
  TMaskEditHelper = class helper for TMaskEdit
  public
    class procedure Agora(var Key: Char; var edt: TMaskEdit);
  end;

implementation

{ TEditHelper }

class procedure TEditHelper.KeyPress(var Key: Char; sTexto: string;
  iLocal, iTamanho, iCasas: Integer);
var
  sInt, sFloat: string;
  iVirgula: Integer;
begin

  if not(Key in ['0' .. '9', ',', #8, #9]) then
    Key := #0;

  if Key in ['0' .. '9', ','] then
  begin

    iVirgula := Pos(',', sTexto);

    if (iVirgula > 0) then
    begin

      if (Key = ',') then
        Key := #0;

      if iLocal < iVirgula then
      begin
        sInt := Copy(sTexto, 1, iVirgula - 1);
        if (Length(sInt) = iTamanho) then
          Key := #0;
      end;

      if iLocal >= iVirgula then
      begin
        sFloat := Copy(sTexto, iVirgula + 1, Length(sTexto) - iVirgula);
        if Length(sFloat) = iCasas then
          Key := #0;
      end;

    end
    else
    begin

      if (Length(sTexto) = iTamanho) and (Key <> ',') then
        Key := #0;

    end;

  end;

end;

{ TMaskEditHelper }

class procedure TMaskEditHelper.Agora(var Key: Char; var edt: TMaskEdit);
begin
  if (Key in ['a','A',#8]) then
    edt.Text := FormatDateTime('DD/MM/YYYY HH:MM', now)
  else
    Key := #0;
end;

end.
