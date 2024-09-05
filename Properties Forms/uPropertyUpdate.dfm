object Property_Update_Form: TProperty_Update_Form
  Left = 0
  Top = 0
  Caption = 'Property_Update_Form'
  ClientHeight = 459
  ClientWidth = 658
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    658
    459)
  TextHeight = 15
  object Lbl_Description: TLabel
    Left = 16
    Top = 250
    Width = 62
    Height = 17
    Caption = #1054#1087#1080#1089#1072#1085#1080#1077
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 16
    Top = 201
    Width = 35
    Height = 17
    Caption = #1040#1075#1077#1085#1090
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Lbl_Area: TLabel
    Left = 16
    Top = 153
    Width = 38
    Height = 17
    Caption = #1055#1083#1086#1097
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Lbl_Price: TLabel
    Left = 16
    Top = 105
    Width = 33
    Height = 17
    Caption = #1062#1077#1085#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Lbl_Address: TLabel
    Left = 16
    Top = 57
    Width = 38
    Height = 17
    Caption = #1040#1076#1088#1077#1089
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Lbl_Type: TLabel
    Left = 16
    Top = 9
    Width = 85
    Height = 17
    Caption = #1058#1080#1087' '#1085#1072' '#1080#1084#1086#1090#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Image1: TImage
    Left = 378
    Top = 8
    Width = 259
    Height = 215
    Stretch = True
  end
  object Lbl_Image_Count: TLabel
    Left = 545
    Top = 246
    Width = 16
    Height = 15
    Caption = 'Lbl'
  end
  object Btn_Cansel: TButton
    Left = 541
    Top = 419
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1053#1072#1079#1072#1076
    TabOrder = 0
    OnClick = Btn_CanselClick
    ExplicitLeft = 539
    ExplicitTop = 416
  end
  object Btn_Create: TButton
    Left = 438
    Top = 419
    Width = 97
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1040#1082#1090#1091#1072#1083#1080#1079#1072#1094#1080#1103
    TabOrder = 1
    OnClick = Btn_CreateClick
    ExplicitLeft = 436
    ExplicitTop = 416
  end
  object Memo_Description: TMemo
    Left = 16
    Top = 273
    Width = 612
    Height = 140
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
    ExplicitWidth = 610
    ExplicitHeight = 137
  end
  object Edt_Agent: TEdit
    Left = 16
    Top = 222
    Width = 304
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    Enabled = False
    TabOrder = 3
    ExplicitWidth = 302
  end
  object Btn_Agent: TButton
    Left = 326
    Top = 221
    Width = 25
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '...'
    TabOrder = 4
    OnClick = Btn_AgentClick
    ExplicitLeft = 324
    ExplicitTop = 218
  end
  object Edt_Area: TEdit
    Left = 16
    Top = 174
    Width = 335
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 5
    OnKeyPress = Edt_AreaKeyPress
    ExplicitWidth = 333
  end
  object Edt_Price: TEdit
    Left = 16
    Top = 126
    Width = 335
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 6
    Text = '0'
    OnKeyPress = Edt_AreaKeyPress
    ExplicitWidth = 333
  end
  object Edt_Address: TEdit
    Left = 16
    Top = 78
    Width = 335
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 7
    ExplicitWidth = 333
  end
  object Edt_Propery_Type: TEdit
    Left = 16
    Top = 30
    Width = 335
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 8
    ExplicitWidth = 333
  end
  object Btn_Back: TButton
    Left = 488
    Top = 242
    Width = 25
    Height = 25
    Caption = '<'
    TabOrder = 9
    OnClick = Btn_BackClick
  end
  object Btn_Next: TButton
    Left = 608
    Top = 242
    Width = 24
    Height = 25
    Caption = '>'
    TabOrder = 10
    OnClick = Btn_NextClick
  end
  object Btn_Add_Image: TButton
    Left = 385
    Top = 242
    Width = 97
    Height = 25
    Caption = '#$1F4F7 + Add Photo'
    TabOrder = 11
    OnClick = Btn_Add_ImageClick
  end
  object Btn_Delete: TButton
    Left = 614
    Top = 8
    Width = 24
    Height = 25
    Caption = 'Del'
    TabOrder = 12
    OnClick = Btn_DeleteClick
  end
  object OpenDialog1: TOpenDialog
    Left = 352
    Top = 104
  end
end
