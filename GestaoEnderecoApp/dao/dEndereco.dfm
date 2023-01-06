object dmEndereco: TdmEndereco
  Height = 119
  Width = 159
  object SQLConnection: TSQLConnection
    DriverName = 'DataSnap'
    LoginPrompt = False
    Params.Strings = (
      'DriverUnit=Data.DBXDataSnap'
      'HostName=localhost'
      'Port=8080'
      'CommunicationProtocol=http'
      'DatasnapContext=datasnap/'
      
        'DriverAssemblyLoader=Borland.Data.TDBXClientDriverLoader,Borland' +
        '.Data.DbxClientDriver,Version=24.0.0.0,Culture=neutral,PublicKey' +
        'Token=91d62ebb5b0d1b1b'
      'Filters={}'
      'DSProxyPort=8888')
    AfterConnect = SQLConnectionAfterConnect
    BeforeDisconnect = SQLConnectionBeforeDisconnect
    Left = 40
    Top = 24
  end
end
