object dmEndereco: TdmEndereco
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 188
  Width = 263
  object updEndereco: TFDQuery
    Connection = dmConexao.Conexao
    SQL.Strings = (
      '')
    Left = 112
    Top = 16
  end
  object qryEndereco: TFDQuery
    Connection = dmConexao.Conexao
    SQL.Strings = (
      '')
    Left = 24
    Top = 16
  end
  object RESTClient: TRESTClient
    Params = <>
    SynchronizedEvents = False
    Left = 192
    Top = 16
  end
  object RESTRequest: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient
    Params = <>
    Response = RESTResponse
    SynchronizedEvents = False
    Left = 192
    Top = 72
  end
  object RESTResponse: TRESTResponse
    Left = 192
    Top = 128
  end
  object delEndereco: TFDQuery
    Connection = dmConexao.Conexao
    SQL.Strings = (
      '')
    Left = 112
    Top = 72
  end
end
