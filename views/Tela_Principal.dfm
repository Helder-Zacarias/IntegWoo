object frmTela_Principal: TfrmTela_Principal
  Left = 0
  Top = 0
  Caption = 'frmTela_Principal'
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
      OnClick = btnOpenModalClick
    end
    object btnTestConexao: TButton
      Left = 0
      Top = 384
      Width = 155
      Height = 33
      Caption = 'Teste Conex'#227'o'
      TabOrder = 3
      OnClick = btnTestarConexãoClick
    end
    object btnBuscarCategorias: TButton
      Left = 0
      Top = 169
      Width = 155
      Height = 33
      Caption = 'Buscar Categorias'
      TabOrder = 4
      OnClick = btnBuscarCategoriasClick
    end
    object btnCriarAtributos: TButton
      Left = 0
      Top = 247
      Width = 155
      Height = 33
      Caption = 'Criar Atributos'
      TabOrder = 5
      OnClick = btnCriarAtributosClick
    end
    object btnBuscarAtributos: TButton
      Left = 0
      Top = 208
      Width = 155
      Height = 33
      Caption = 'Buscar Atributos'
      TabOrder = 6
      OnClick = btnBuscarAtributosClick
    end
  end
  object MySQL: TMySQLUniProvider
    Left = 392
    Top = 24
  end
  object Database: TUniConnection
    ProviderName = 'MySQL'
    Port = 33063
    Database = 'information_schema'
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
