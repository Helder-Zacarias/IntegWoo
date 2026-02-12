object frmTela_Envio: TfrmTela_Envio
  Left = 0
  Top = 0
  Anchors = []
  Caption = 'frmTela_Envio'
  ClientHeight = 422
  ClientWidth = 596
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = onFormCreate
  OnResize = FormResize
  OnShow = FormShow
  TextHeight = 15
  object labelDescricao: TLabel
    Left = 168
    Top = 58
    Width = 51
    Height = 15
    Caption = 'Descri'#231#227'o'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object labelDescricaoCurta: TLabel
    Left = 168
    Top = 108
    Width = 83
    Height = 15
    Caption = 'Descri'#231#227'o Curta'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object labelPreco: TLabel
    Left = 168
    Top = 158
    Width = 30
    Height = 15
    Caption = 'Pre'#231'o'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object labelNome: TLabel
    Left = 168
    Top = 8
    Width = 33
    Height = 15
    Caption = 'Nome'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object labelPathImagem: TLabel
    Left = 168
    Top = 258
    Width = 112
    Height = 15
    Caption = 'Caminho da Imagem'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object labelCategoria: TLabel
    Left = 168
    Top = 208
    Width = 51
    Height = 15
    Caption = 'Categoria'
  end
  object editNome: TEdit
    Left = 168
    Top = 29
    Width = 297
    Height = 23
    TabOrder = 0
  end
  object editDescricao: TEdit
    Left = 168
    Top = 79
    Width = 297
    Height = 23
    TabOrder = 1
  end
  object editDescricaoCurta: TEdit
    Left = 168
    Top = 129
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
    Top = 179
    Width = 297
    Height = 23
    Mode = nbmCurrency
    MinValue = 1.000000000000000000
    MaxValue = 1000000.000000000000000000
    TabOrder = 4
    Value = 1.000000000000000000
  end
  object editPathImagem: TEdit
    Left = 168
    Top = 279
    Width = 297
    Height = 23
    TabOrder = 5
    OnClick = editClickOpenImageExplorer
  end
  object comboCategoria: TComboBox
    Left = 168
    Top = 229
    Width = 297
    Height = 23
    TabOrder = 6
  end
  object dialogPathImagem: TOpenPictureDialog
    Left = 504
    Top = 280
  end
end
