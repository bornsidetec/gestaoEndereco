inherited fPessoas: TfPessoas
  Caption = 'Cadastro de Pessoas'
  ClientHeight = 386
  ClientWidth = 645
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitHeight = 424
  TextHeight = 13
  inherited pnlBotom: TPanel
    Top = 341
    Width = 645
    ExplicitTop = 316
    ExplicitWidth = 645
    inherited btnFechar: TBitBtn
      Left = 552
      ExplicitLeft = 548
    end
  end
  inherited pnlClient: TPanel
    Width = 645
    Height = 341
    inherited PageControl: TPageControl
      Width = 645
      Height = 341
      ActivePage = tsDetalhes
      inherited tsListagem: TTabSheet
        ExplicitWidth = 637
        ExplicitHeight = 313
        inherited pnlFind: TPanel
          Width = 637
          inherited btnPesquisar: TBitBtn
            Left = 548
          end
          inherited edtPesquisar: TEdit
            Width = 418
            OnKeyPress = edtNaturezaKeyPress
          end
        end
        inherited DBGrid1: TDBGrid
          Width = 637
          Height = 223
        end
        inherited pnlActionsList: TPanel
          Top = 268
          Width = 637
          inherited btnInserir: TBitBtn
            Left = 392
          end
          inherited btnDetalhar: TBitBtn
            Left = 473
          end
          inherited btnExcluir: TBitBtn
            Left = 554
          end
        end
      end
      inherited tsDetalhes: TTabSheet
        ExplicitWidth = 637
        ExplicitHeight = 313
        object Label2: TLabel [1]
          Left = 527
          Top = 212
          Width = 33
          Height = 13
          Caption = 'Estado'
        end
        inherited pnlActionsDetail: TPanel
          Top = 268
          Width = 637
          ExplicitTop = 243
          ExplicitWidth = 637
          inherited btnAlterar: TBitBtn
            Left = 396
            ExplicitLeft = 396
          end
          inherited btnSalvar: TBitBtn
            Left = 477
            ExplicitLeft = 477
          end
          inherited btnCancelar: TBitBtn
            Left = 558
            ExplicitLeft = 558
          end
          inherited btnVoltar: TBitBtn
            Left = 315
            ExplicitLeft = 315
          end
        end
        object edtNatureza: TLabeledEdit
          Left = 16
          Top = 135
          Width = 121
          Height = 21
          EditLabel.Width = 44
          EditLabel.Height = 13
          EditLabel.Caption = 'Natureza'
          MaxLength = 5
          TabOrder = 4
          Text = ''
          OnKeyPress = edtNaturezaKeyPress
        end
        object edtDocumento: TLabeledEdit
          Left = 143
          Top = 135
          Width = 337
          Height = 21
          EditLabel.Width = 54
          EditLabel.Height = 13
          EditLabel.Caption = 'Documento'
          MaxLength = 20
          TabOrder = 5
          Text = ''
        end
        object edtPrimeiro: TLabeledEdit
          Left = 16
          Top = 84
          Width = 297
          Height = 21
          EditLabel.Width = 68
          EditLabel.Height = 13
          EditLabel.Caption = 'Primeiro Nome'
          MaxLength = 100
          TabOrder = 2
          Text = ''
        end
        object edtSegundo: TLabeledEdit
          Left = 319
          Top = 84
          Width = 305
          Height = 21
          EditLabel.Width = 72
          EditLabel.Height = 13
          EditLabel.Caption = 'Segundo Nome'
          MaxLength = 100
          TabOrder = 3
          Text = ''
        end
        object edtCep: TLabeledEdit
          Left = 486
          Top = 135
          Width = 138
          Height = 21
          EditLabel.Width = 19
          EditLabel.Height = 13
          EditLabel.Caption = 'CEP'
          MaxLength = 8
          TabOrder = 6
          Text = ''
          OnExit = edtCepExit
          OnKeyPress = edtNaturezaKeyPress
        end
        object edtLogradouro: TLabeledEdit
          Left = 16
          Top = 183
          Width = 297
          Height = 21
          EditLabel.Width = 55
          EditLabel.Height = 13
          EditLabel.Caption = 'Logradouro'
          MaxLength = 100
          TabOrder = 7
          Text = ''
        end
        object edtComplemento: TLabeledEdit
          Left = 319
          Top = 183
          Width = 305
          Height = 21
          EditLabel.Width = 65
          EditLabel.Height = 13
          EditLabel.Caption = 'Complemento'
          MaxLength = 100
          TabOrder = 8
          Text = ''
        end
        object edtBairro: TLabeledEdit
          Left = 16
          Top = 231
          Width = 185
          Height = 21
          EditLabel.Width = 28
          EditLabel.Height = 13
          EditLabel.Caption = 'Bairro'
          MaxLength = 50
          TabOrder = 9
          Text = ''
        end
        object edtCidade: TLabeledEdit
          Left = 207
          Top = 231
          Width = 314
          Height = 21
          EditLabel.Width = 33
          EditLabel.Height = 13
          EditLabel.Caption = 'Cidade'
          MaxLength = 100
          TabOrder = 10
          Text = ''
        end
        object cboEstado: TComboBox
          Left = 527
          Top = 231
          Width = 97
          Height = 21
          ItemIndex = 0
          TabOrder = 11
          Text = 'AC'
          Items.Strings = (
            'AC'
            'AL'
            'AP'
            'AM'
            'BA'
            'CE'
            'DF'
            'ES'
            'GO'
            'MA'
            'MT'
            'MS'
            'MG'
            'PA'
            'PB'
            'PR'
            'PE'
            'PI'
            'RJ'
            'RN'
            'RS'
            'RO'
            'RR'
            'SC'
            'SP'
            'SE'
            'TO')
        end
      end
    end
  end
  inherited ActionList: TActionList
    Top = 184
    inherited actPesquisar: TAction
      OnExecute = actPesquisarExecute
    end
    inherited actExcluir: TAction
      OnExecute = actExcluirExecute
    end
  end
  inherited ImageList: TImageList
    Top = 184
  end
  inherited dsPesquisa: TDataSource
    DataSet = dmPessoa.cdsPessoa
    Top = 184
  end
  object RESTRequest: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient
    Params = <>
    SynchronizedEvents = False
    Left = 584
    Top = 64
  end
  object RESTClient: TRESTClient
    Params = <>
    SynchronizedEvents = False
    Left = 584
    Top = 8
  end
end
