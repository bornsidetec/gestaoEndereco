object fGuiServer: TfGuiServer
  Left = 271
  Top = 114
  BorderStyle = bsToolWindow
  Caption = 'Interface Gr'#225'fica do Usu'#225'rio - Server'
  ClientHeight = 100
  ClientWidth = 311
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 20
    Height = 13
    Caption = 'Port'
  end
  object ButtonStart: TButton
    Left = 144
    Top = 25
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = ButtonStartClick
  end
  object ButtonStop: TButton
    Left = 225
    Top = 25
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 1
    OnClick = ButtonStopClick
  end
  object EditPort: TEdit
    Left = 8
    Top = 27
    Width = 121
    Height = 21
    TabOrder = 2
    Text = '8080'
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 81
    Width = 311
    Height = 19
    Panels = <
      item
        Width = 150
      end
      item
        Width = 200
      end>
    ExplicitTop = 69
    ExplicitWidth = 303
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 88
    Top = 24
  end
end
