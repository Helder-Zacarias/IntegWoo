object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 441
  ClientWidth = 645
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object btnHamburguer: TButton
    Left = 0
    Top = 2
    Width = 155
    Height = 33
    Caption = #9776
    TabOrder = 0
    OnClick = btnHamburguerClick
  end
  object panelSide: TPanel
    Left = 0
    Top = 0
    Width = 155
    Height = 441
    Align = alLeft
    TabOrder = 1
    Visible = False
    object butReceberProdutos: TBitBtn
      Left = 0
      Top = 52
      Width = 155
      Height = 33
      Caption = 'Buscar Produtos'
      TabOrder = 0
      OnClick = butBuscarProdutosClick
    end
    object butEnviarProdutos: TBitBtn
      Left = 0
      Top = 130
      Width = 155
      Height = 33
      Caption = 'Enviar Produtos do Banco'
      TabOrder = 1
      OnClick = butEnviarProdutosdoBancoClick
    end
    object btnEnviarFull: TBitBtn
      Left = 0
      Top = 91
      Width = 155
      Height = 33
      Caption = 'Enviar Produto Simples'
      TabOrder = 2
      OnClick = btnEnviarProdutoSimplesClick
    end
    object btnOpen: TButton
      Left = 40
      Top = 264
      Width = 75
      Height = 25
      Caption = 'Teste Modal'
      TabOrder = 3
      OnClick = btnOpenModalClick
    end
  end
  object MySQL: TMySQLUniProvider
    Left = 392
    Top = 24
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
    Left = 480
    Top = 32
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
    Left = 392
    Top = 120
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
    Left = 480
    Top = 120
  end
end
