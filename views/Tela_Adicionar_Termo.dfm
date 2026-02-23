object frmTela_Adicionar_Termo: TfrmTela_Adicionar_Termo
  Left = 0
  Top = 0
  Caption = 'frmTela_Adicionar_Termo'
  ClientHeight = 228
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = OnFormCreate
  OnResize = OnFormResize
  TextHeight = 15
  object labelTermo: TLabel
    Left = 216
    Top = 80
    Width = 34
    Height = 15
    Caption = 'Termo'
  end
  object editTermo: TEdit
    Left = 216
    Top = 101
    Width = 217
    Height = 23
    TabOrder = 0
  end
  object btnAdicionarTermo: TButton
    Left = 248
    Top = 152
    Width = 155
    Height = 33
    Caption = 'Adicionar'
    TabOrder = 1
    OnClick = btnAdicionarTermoCLick
  end
end
