object frmTela_Cadastro_Atributo: TfrmTela_Cadastro_Atributo
  Left = 0
  Top = 0
  Caption = 'frmTela_Cadastro_Atributo'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = OnCreateForm
  OnResize = OnResizeForm
  TextHeight = 15
  object labelNomeAtributo: TLabel
    Left = 192
    Top = 43
    Width = 97
    Height = 15
    Caption = 'Nome do Atributo'
  end
  object editNomeAtributo: TEdit
    Left = 192
    Top = 64
    Width = 233
    Height = 23
    TabOrder = 0
  end
  object btnEnviarAtributo: TButton
    Left = 230
    Top = 344
    Width = 155
    Height = 33
    Caption = 'Enviar'
    TabOrder = 1
    OnClick = btnEnviarAtributoClick
  end
  object memoTermosAtributo: TMemo
    Left = 192
    Top = 157
    Width = 233
    Height = 89
    Lines.Strings = (
      '')
    TabOrder = 2
  end
  object btnAdicionarTermos: TButton
    Left = 192
    Top = 118
    Width = 233
    Height = 33
    Caption = 'Adicionar Termos'
    TabOrder = 3
    OnClick = btnAdicionarTermosClick
  end
end
