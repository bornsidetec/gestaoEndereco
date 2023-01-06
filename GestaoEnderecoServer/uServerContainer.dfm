object dsServerContainer: TdsServerContainer
  Height = 271
  Width = 415
  object DSServer: TDSServer
    Left = 96
    Top = 11
  end
  object DSServerClassPadrao: TDSServerClass
    OnGetClass = DSServerClassPadraoGetClass
    Server = DSServer
    Left = 200
    Top = 11
  end
  object DSServerClassPessoa: TDSServerClass
    OnGetClass = DSServerClassPessoaGetClass
    Server = DSServer
    Left = 200
    Top = 75
  end
  object DSServerClassEndereco: TDSServerClass
    OnGetClass = DSServerClassEnderecoGetClass
    Server = DSServer
    Left = 200
    Top = 147
  end
end
