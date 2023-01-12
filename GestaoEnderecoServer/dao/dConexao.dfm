object dmConexao: TdmConexao
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 185
  Width = 332
  object Conexao: TFDConnection
    Params.Strings = (
      'Database=rest'
      'User_Name=postgres'
      'Password=bs101100'
      'DriverID=PG')
    LoginPrompt = False
    Left = 56
    Top = 40
  end
  object FDPhysPgDriverLink: TFDPhysPgDriverLink
    VendorHome = 
      'C:\Users\borns\Google Drive\bornside\_WK\desbravador\gestaoEnder' +
      'eco\GestaoEnderecoServer\bd'
    Left = 152
    Top = 40
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 152
    Top = 104
  end
end
