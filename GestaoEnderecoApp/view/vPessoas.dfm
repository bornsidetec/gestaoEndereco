inherited fPessoas: TfPessoas
  Caption = 'Cadastro de Pessoas'
  ClientHeight = 361
  ClientWidth = 645
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 13
  inherited pnlBotom: TPanel
    Top = 316
    Width = 645
    ExplicitTop = 315
    ExplicitWidth = 641
    inherited btnFechar: TBitBtn
      Left = 542
      ExplicitLeft = 538
    end
  end
  inherited pnlClient: TPanel
    Width = 645
    Height = 316
    inherited PageControl: TPageControl
      inherited tsListagem: TTabSheet
        inherited pnlFind: TPanel
          ExplicitWidth = 633
          inherited edtPesquisar: TEdit
            OnKeyPress = edtNaturezaKeyPress
          end
        end
        inherited pnlActionsList: TPanel
          ExplicitTop = 242
          ExplicitWidth = 633
        end
      end
      inherited tsDetalhes: TTabSheet
        inherited pnlActionsDetail: TPanel
          inherited btnAlterar: TBitBtn
            ExplicitLeft = 396
          end
          inherited btnSalvar: TBitBtn
            ExplicitLeft = 477
          end
          inherited btnCancelar: TBitBtn
            ExplicitLeft = 558
          end
          inherited btnVoltar: TBitBtn
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
          OnKeyPress = edtNaturezaKeyPress
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
end
