object FormMain: TFormMain
  Left = 202
  Top = 127
  Width = 808
  Height = 429
  Caption = #1061#1091#1076#1086#1078#1085#1080#1082
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter
    Left = 200
    Top = 0
    Width = 5
    Height = 230
    MinSize = 50
  end
  object Tree: TTreeView
    Left = 0
    Top = 0
    Width = 200
    Height = 230
    Align = alLeft
    Indent = 19
    ParentShowHint = False
    ReadOnly = True
    ShowHint = False
    TabOrder = 0
    OnChange = TreeChange
  end
  object Params: TPanel
    Left = 0
    Top = 230
    Width = 800
    Height = 150
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = True
    ParentColor = True
    TabOrder = 1
    DesignSize = (
      800
      150)
    object X1Label: TLabel
      Left = 10
      Top = 10
      Width = 50
      Height = 20
      AutoSize = False
      Caption = #1083#1077#1074#1072#1103
      FocusControl = X1
      Transparent = True
      Layout = tlBottom
    end
    object Y1Label: TLabel
      Left = 60
      Top = 0
      Width = 50
      Height = 20
      Alignment = taCenter
      AutoSize = False
      Caption = #1074#1077#1088#1093#1085#1103#1103
      FocusControl = Y1
      Transparent = True
      Layout = tlBottom
    end
    object X2Label: TLabel
      Left = 110
      Top = 10
      Width = 50
      Height = 20
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1087#1088#1072#1074#1072#1103
      FocusControl = X2
      Transparent = True
      Layout = tlBottom
    end
    object Y2Label: TLabel
      Left = 60
      Top = 60
      Width = 50
      Height = 20
      Alignment = taCenter
      AutoSize = False
      Caption = #1085#1080#1078#1085#1103#1103
      FocusControl = Y2
      Transparent = True
    end
    object XSLabel: TLabel
      Left = 170
      Top = 20
      Width = 50
      Height = 20
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1064#1080#1088#1080#1085#1072
      FocusControl = XS
      Transparent = True
    end
    object YSLabel: TLabel
      Left = 170
      Top = 40
      Width = 50
      Height = 20
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1042#1099#1089#1086#1090#1072
      FocusControl = YS
      Transparent = True
    end
    object X1: TEdit
      Left = 10
      Top = 30
      Width = 50
      Height = 21
      TabOrder = 0
      Text = '-1'
      OnChange = ParamChange
    end
    object Y1: TEdit
      Left = 60
      Top = 20
      Width = 50
      Height = 21
      TabOrder = 1
      Text = '-1'
      OnChange = ParamChange
    end
    object X2: TEdit
      Left = 110
      Top = 30
      Width = 50
      Height = 21
      TabOrder = 2
      Text = '1'
      OnChange = ParamChange
    end
    object Y2: TEdit
      Left = 60
      Top = 40
      Width = 50
      Height = 21
      TabOrder = 3
      Text = '1'
      OnChange = ParamChange
    end
    object XS: TEdit
      Left = 230
      Top = 20
      Width = 50
      Height = 21
      TabOrder = 4
      Text = '500'
      OnChange = ParamChange
    end
    object YS: TEdit
      Left = 230
      Top = 40
      Width = 50
      Height = 21
      TabOrder = 5
      Text = '500'
      OnChange = ParamChange
    end
    object ButtonSize: TButton
      Left = 10
      Top = 120
      Width = 271
      Height = 25
      Action = ActionSetup
      Anchors = [akLeft, akBottom]
      Default = True
      TabOrder = 6
    end
    object ButtonSave: TButton
      Left = 470
      Top = 120
      Width = 100
      Height = 25
      Action = ActionSave
      Anchors = [akTop, akRight]
      TabOrder = 7
    end
    object ButtonClipboard: TButton
      Left = 580
      Top = 120
      Width = 100
      Height = 25
      Action = ActionClip
      Anchors = [akTop, akRight]
      TabOrder = 8
    end
    object ButtonAbout: TButton
      Left = 690
      Top = 120
      Width = 100
      Height = 25
      Action = ActionAbout
      Anchors = [akTop, akRight]
      TabOrder = 9
    end
    object Proportion: TRadioGroup
      Left = 590
      Top = 0
      Width = 200
      Height = 110
      Anchors = [akTop, akRight]
      Caption = #1055#1088#1086#1087#1086#1088#1094#1080#1080
      ItemIndex = 0
      Items.Strings = (
        #1053#1077' '#1089#1086#1073#1083#1102#1076#1072#1090#1100
        #1042#1099#1095#1080#1089#1083#1103#1090#1100' '#1075#1088#1072#1085#1080#1094#1091' '#1083#1077#1074#1091#1102
        #1042#1099#1095#1080#1089#1083#1103#1090#1100' '#1075#1088#1072#1085#1080#1094#1091' '#1087#1088#1072#1074#1091#1102
        #1042#1099#1095#1080#1089#1083#1103#1090#1100' '#1075#1088#1072#1085#1080#1094#1091' '#1074#1077#1088#1093#1085#1102#1102
        #1042#1099#1095#1080#1089#1083#1103#1090#1100' '#1075#1088#1072#1085#1080#1094#1091' '#1085#1080#1078#1085#1102#1102
        #1042#1099#1095#1080#1089#1083#1103#1090#1100' '#1096#1080#1088#1080#1085#1091
        #1042#1099#1095#1080#1089#1083#1103#1090#1100' '#1074#1099#1089#1086#1090#1091)
      TabOrder = 10
      OnClick = ProportionClick
    end
  end
  object ScrollBox: TScrollBox
    Left = 205
    Top = 0
    Width = 595
    Height = 230
    Align = alClient
    BorderStyle = bsNone
    ParentBackground = True
    TabOrder = 2
    object Paint: TPaintBox
      Left = 0
      Top = 0
      Width = 100
      Height = 100
      PopupMenu = PopupMenu
      OnPaint = PaintPaint
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 380
    Width = 800
    Height = 20
    Panels = <
      item
        Alignment = taRightJustify
        Width = 50
      end
      item
        Width = 50
      end>
    ParentColor = True
  end
  object PopupMenu: TPopupMenu
    Left = 70
    Top = 50
    object N1: TMenuItem
      Action = ActionSave
    end
    object N2: TMenuItem
      Action = ActionClip
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object N4: TMenuItem
      Action = ActionAbout
    end
  end
  object SaveDialog: TSavePictureDialog
    DefaultExt = 'bmp'
    Filter = 'Bitmaps (*.bmp)|*.bmp|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofExtensionDifferent, ofPathMustExist]
    Title = #1047#1072#1087#1080#1089#1072#1090#1100
    Left = 100
    Top = 50
  end
  object XPManifest: TXPManifest
    Left = 10
    Top = 50
  end
  object ActionList: TActionList
    Left = 40
    Top = 50
    object ActionSave: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' '#1092#1072#1081#1083
      ShortCut = 16467
      OnExecute = ActionSaveExecute
    end
    object ActionClip: TAction
      Caption = #1042' '#1073#1091#1092#1077#1088' '#1086#1073#1084#1077#1085#1072
      ShortCut = 16451
      OnExecute = ActionClipExecute
    end
    object ActionSetup: TAction
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1080' '#1085#1072#1088#1080#1089#1086#1074#1072#1090#1100
      OnExecute = ActionSetupExecute
    end
    object ActionAbout: TAction
      Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
      OnExecute = ActionAboutExecute
    end
  end
end
