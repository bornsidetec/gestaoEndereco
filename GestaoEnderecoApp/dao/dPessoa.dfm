object dmPessoa: TdmPessoa
  Height = 86
  Width = 238
  object dspPessoa: TDataSetProvider
    DataSet = memPessoa
    Left = 104
    Top = 8
  end
  object cdsPessoa: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftString
        Name = 'Nome'
        ParamType = ptInput
      end>
    ProviderName = 'dspPessoa'
    Left = 176
    Top = 8
    object cdsPessoaidpessoa: TFloatField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'idpessoa'
      ReadOnly = True
    end
    object cdsPessoaflnatureza: TFloatField
      DisplayLabel = 'Natureza'
      FieldName = 'flnatureza'
    end
    object cdsPessoadsdocumento: TWideStringField
      DisplayLabel = 'Documento'
      FieldName = 'dsdocumento'
    end
    object cdsPessoanmprimeiro: TWideStringField
      DisplayLabel = 'Primeiro Nome'
      FieldName = 'nmprimeiro'
      Size = 100
    end
    object cdsPessoanmsegundo: TWideStringField
      DisplayLabel = 'Segundo Nome'
      FieldName = 'nmsegundo'
      Size = 100
    end
    object cdsPessoadtregistro: TWideStringField
      DisplayLabel = 'Data Registro'
      FieldName = 'dtregistro'
      Size = 50
    end
    object cdsPessoadscep: TWideStringField
      DisplayLabel = 'CEP'
      FieldName = 'dscep'
      Size = 8
    end
  end
  object memPessoa: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    Left = 32
    Top = 8
  end
end
