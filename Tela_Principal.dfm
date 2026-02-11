object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object butEnviarProdutos: TBitBtn
    Left = 24
    Top = 144
    Width = 153
    Height = 50
    Caption = 'Enviar Produtos'#13#10'do Banco'
    TabOrder = 0
    OnClick = butEnviarProdutosClick
  end
  object butReceberProdutos: TBitBtn
    Left = 24
    Top = 216
    Width = 153
    Height = 25
    Caption = 'Buscar Produtos'
    TabOrder = 1
    OnClick = butReceberProdutosClick
  end
  object BitBtn1: TBitBtn
    Left = 216
    Top = 156
    Width = 153
    Height = 25
    Caption = 'Enviar 1 Produto'
    TabOrder = 2
    OnClick = btnEnviarProduto
  end
  object BitBtn2: TBitBtn
    Left = 216
    Top = 216
    Width = 153
    Height = 25
    Caption = 'Upload Imagem'
    TabOrder = 3
    OnClick = btnEnviarImagemTestClick
  end
  object btnEnviarFull: TBitBtn
    Left = 144
    Top = 288
    Width = 153
    Height = 41
    Caption = 'Enviar Imagem'#13#10'e Produto'
    TabOrder = 4
    OnClick = btnEnviarFullClick
  end
  object MySQL: TMySQLUniProvider
    Left = 96
    Top = 16
  end
  object Database: TUniConnection
    ProviderName = 'MySQL'
    Port = 33063
    Database = 'db_sgci'
    SpecificOptions.Strings = (
      'MySQL.Protocol=mpTCP'
      'MySQL.ConnectionTimeout=30'
      'MySQL.Compress=True')
    Options.DisconnectedMode = True
    Options.LocalFailover = True
    Username = 'helder'
    Server = 'datastore.redesoftware.com.br'
    LoginPrompt = False
    OnConnectionLost = DatabaseConnectionLost
    Left = 40
    Top = 16
    EncryptedPassword = 'B7FFCCFFCEFF9BFFBAFFBFFF8DFFBFFFCCFFDCFF'
  end
  object sqlProdutos: TUniQuery
    Connection = Database
    SQL.Strings = (
      'SELECT'
      '   *'
      'FROM'
      '   db_sgci.produtos'
      'WHERE'
      '   COD_ID_EMPRESA = 2433 AND'
      '   COD_ID_LOJA    = 90')
    Left = 40
    Top = 80
  end
  object sqlImagens: TUniQuery
    Connection = Database
    SQL.Strings = (
      'SELECT'
      '   *'
      'FROM'
      '   db_sgci.produtos_imagens'
      'WHERE'
      '   COD_ID_EMPRESA = 2433')
    Left = 120
    Top = 80
  end
end
