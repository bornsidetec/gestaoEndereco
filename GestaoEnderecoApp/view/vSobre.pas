unit vSobre;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls, ShellApi;

type
  TfSobre = class(TForm)
    pnlInfo: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    lblCaminhoGit: TLabel;
    Image1: TImage;
    Image2: TImage;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lblCaminhoGitMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lblCaminhoGitMouseLeave(Sender: TObject);
    procedure lblCaminhoGitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fSobre: TfSobre;

implementation

{$R *.dfm}

procedure TfSobre.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Self := nil;
end;

procedure TfSobre.lblCaminhoGitClick(Sender: TObject);
var
  sUrl: PWideChar;
begin
  sUrl := pChar(lblCaminhoGit.Caption);
  ShellExecute(Application.Handle, 'open', sUrl,
    nil, nil, 0);
end;

procedure TfSobre.lblCaminhoGitMouseLeave(Sender: TObject);
begin
  TLabel(Sender).Font.Color := clBlack;
  TLabel(Sender).Font.Style := [];
  Cursor := crDefault;
end;

procedure TfSobre.lblCaminhoGitMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  TLabel(Sender).Font.Color := clBlue;
  TLabel(Sender).Font.Style := [fsUnderline];
  Cursor := crHandPoint;
end;

end.

