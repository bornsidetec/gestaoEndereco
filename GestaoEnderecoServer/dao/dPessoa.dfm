object dmPessoa: TdmPessoa
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 87
  Width = 339
  object qryPessoa: TFDQuery
    Connection = dmConexao.Conexao
    SQL.Strings = (
      'SELECT * FROM Pessoa'
      'WHERE Nome like :nome')
    Left = 32
    Top = 16
    ParamData = <
      item
        Position = 1
        Name = 'Nome'
        DataType = ftString
        ParamType = ptInput
      end>
  end
  object updPessoa: TFDQuery
    Connection = dmConexao.Conexao
    SQL.Strings = (
      '')
    Left = 96
    Top = 16
  end
  object updEndereco: TFDQuery
    Connection = dmConexao.Conexao
    SQL.Strings = (
      '')
    Left = 168
    Top = 16
  end
  object updEnderecoIntegracao: TFDQuery
    Connection = dmConexao.Conexao
    SQL.Strings = (
      '')
    Left = 248
    Top = 16
  end
end
