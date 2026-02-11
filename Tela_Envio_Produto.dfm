object Form1: TForm1
  Left = 0
  Top = 0
  Anchors = []
  Caption = 'Form1'
  ClientHeight = 422
  ClientWidth = 596
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnResize = FormResize
  OnShow = FormShow
  TextHeight = 15
  object labelDescricao: TLabel
    Left = 168
    Top = 110
    Width = 67
    Height = 21
    Caption = 'Descri'#231#227'o'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object labelDescricaoCurta: TLabel
    Left = 168
    Top = 166
    Width = 109
    Height = 21
    Caption = 'Descri'#231#227'o Curta'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object labelPreco: TLabel
    Left = 168
    Top = 222
    Width = 39
    Height = 21
    Caption = 'Pre'#231'o'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object labelNome: TLabel
    Left = 168
    Top = 54
    Width = 43
    Height = 21
    Caption = 'Nome'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object labelPathImagem: TLabel
    Left = 168
    Top = 278
    Width = 145
    Height = 21
    Caption = 'Caminho da Imagem'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object editNome: TEdit
    Left = 168
    Top = 81
    Width = 297
    Height = 23
    TabOrder = 0
  end
  object editDescricao: TEdit
    Left = 168
    Top = 137
    Width = 297
    Height = 23
    TabOrder = 1
  end
  object editDescricaoCurta: TEdit
    Left = 168
    Top = 193
    Width = 297
    Height = 23
    TabOrder = 2
  end
  object btnEnviarProduto: TButton
    Left = 224
    Top = 368
    Width = 155
    Height = 33
    Caption = 'Enviar Produto'
    TabOrder = 3
    OnClick = btnRetornarInformacoes
  end
  object boxPreco: TNumberBox
    Left = 168
    Top = 249
    Width = 297
    Height = 23
    Mode = nbmCurrency
    MinValue = 1.000000000000000000
    MaxValue = 1000000.000000000000000000
    TabOrder = 4
  end
  object editPathImagem: TEdit
    Left = 168
    Top = 299
    Width = 297
    Height = 23
    TabOrder = 5
    OnClick = editClickOpenImageExplorer
  end
  object dialogPathImagem: TOpenPictureDialog
    Left = 480
    Top = 296
  end
end
