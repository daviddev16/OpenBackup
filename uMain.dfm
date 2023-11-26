object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'OpenBackup'
  ClientHeight = 510
  ClientWidth = 554
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object LblOrigin: TLabel
    Left = 8
    Top = 56
    Width = 43
    Height = 15
    Caption = 'Origem:'
  end
  object LblPercent: TLabel
    Left = 8
    Top = 368
    Width = 538
    Height = 15
    AutoSize = False
    Caption = '0/0'
  end
  object LstOrigins: TListBox
    Left = 8
    Top = 72
    Width = 426
    Height = 241
    ItemHeight = 15
    Items.Strings = (
      'C:\Users\David\IdeaProjects')
    TabOrder = 0
  end
  object ProgressBar: TProgressBar
    Left = 8
    Top = 319
    Width = 538
    Height = 43
    ParentShowHint = False
    ShowHint = False
    TabOrder = 1
  end
  object BtnStart: TButton
    Left = 440
    Top = 288
    Width = 106
    Height = 25
    Caption = 'Iniciar'
    TabOrder = 2
    OnClick = BtnStartClick
  end
  object EdtDestination: TLabeledEdit
    Left = 8
    Top = 27
    Width = 426
    Height = 23
    EditLabel.Width = 43
    EditLabel.Height = 15
    EditLabel.Caption = 'Destino:'
    TabOrder = 3
    Text = 'Y:\'
  end
  object MmStatus: TMemo
    Left = 8
    Top = 389
    Width = 538
    Height = 108
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -10
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 4
  end
  object BtnRemove: TButton
    Left = 440
    Top = 103
    Width = 106
    Height = 25
    Caption = 'Remover Pasta'
    TabOrder = 5
    OnClick = BtnRemoveClick
  end
  object BtnAdd: TButton
    Left = 440
    Top = 72
    Width = 106
    Height = 25
    Caption = 'Adicionar Pasta'
    TabOrder = 6
    OnClick = BtnAddClick
  end
  object LblIdentifier: TLabeledEdit
    Left = 440
    Top = 27
    Width = 106
    Height = 23
    EditLabel.Width = 70
    EditLabel.Height = 15
    EditLabel.Caption = 'Identificador:'
    TabOrder = 7
    Text = 'DESKTOP'
  end
  object OpenFolderDialog: TOpenDialog
    Left = 200
    Top = 168
  end
end
