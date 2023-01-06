object dmRest: TdmRest
  Height = 213
  Width = 398
  object RESTClient: TRESTClient
    BaseURL = 'http://localhost:8080/datasnap/rest/tpessoa/pessoa'
    Params = <>
    SynchronizedEvents = False
    Left = 96
    Top = 24
  end
  object RESTRequest: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient
    Params = <
      item
        Kind = pkREQUESTBODY
        Name = 'body5325C56B78354962AED873F5371DC6C6'
        ContentTypeStr = 'application/json'
      end>
    Response = RESTResponse
    SynchronizedEvents = False
    Left = 96
    Top = 80
  end
  object RESTResponse: TRESTResponse
    Left = 96
    Top = 136
  end
  object RESTResponseDataSetAdapter: TRESTResponseDataSetAdapter
    Dataset = FDMemTable
    FieldDefs = <>
    Response = RESTResponse
    TypesMode = JSONOnly
    Left = 272
    Top = 24
  end
  object FDMemTable: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    Left = 272
    Top = 80
  end
end
