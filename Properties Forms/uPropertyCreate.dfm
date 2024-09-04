object Property_Create_Form: TProperty_Create_Form
  Left = 0
  Top = 0
  Caption = 'Property_Create_Form'
  ClientHeight = 452
  ClientWidth = 680
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
    680
    452)
  TextHeight = 15
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
  object Image1: TImage
    Left = 415
    Top = 8
    Width = 259
    Height = 215
    Stretch = True
  end
  object Lbl_Image_Count: TLabel
    Left = 566
    Top = 246
    Width = 16
    Height = 15
    Caption = 'Lbl'
  end
  object Edt_Propery_Type: TEdit
    Left = 16
    Top = 30
    Width = 342
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    ExplicitWidth = 344
  end
  object Edt_Address: TEdit
    Left = 16
    Top = 78
    Width = 342
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    ExplicitWidth = 344
  end
  object Edt_Price: TEdit
    Left = 16
    Top = 126
    Width = 342
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Text = '0'
    OnKeyPress = Edt_PriceKeyPress
    ExplicitWidth = 344
  end
  object Edt_Area: TEdit
    Left = 16
    Top = 174
    Width = 342
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    OnKeyPress = Edt_PriceKeyPress
    ExplicitWidth = 344
  end
  object Memo_Description: TMemo
    Left = 16
    Top = 273
    Width = 640
    Height = 139
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 5
    ExplicitWidth = 642
  end
  object Btn_Cansel: TButton
    Left = 581
    Top = 419
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1053#1072#1079#1072#1076
    TabOrder = 7
    ExplicitLeft = 583
  end
  object Btn_Create: TButton
    Left = 493
    Top = 419
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1044#1086#1073#1072#1074#1080
    TabOrder = 6
    OnClick = Btn_CreateClick
    ExplicitLeft = 495
  end
  object Edt_Agent: TEdit
    Left = 16
    Top = 222
    Width = 342
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    Enabled = False
    TabOrder = 8
    ExplicitWidth = 344
  end
  object Btn_Agent: TButton
    Left = 364
    Top = 221
    Width = 25
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 4
    OnClick = Btn_AgentClick
    ExplicitLeft = 366
  end
  object Btn_All_Properties: TButton
    Left = 16
    Top = 419
    Width = 113
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1042#1080#1078' '#1074#1089#1080#1095#1082#1080' '#1080#1084#1086#1090#1080
    TabOrder = 9
    OnClick = Btn_All_PropertiesClick
  end
  object Btn_Back: TButton
    Left = 505
    Top = 242
    Width = 25
    Height = 25
    Caption = '<'
    TabOrder = 10
    OnClick = Btn_BackClick
  end
  object Btn_Next: TButton
    Left = 625
    Top = 242
    Width = 24
    Height = 25
    Caption = '>'
    TabOrder = 11
    OnClick = Btn_NextClick
  end
  object Btn_Add_Image: TButton
    Left = 415
    Top = 242
    Width = 84
    Height = 25
    Caption = '9'
    TabOrder = 12
    OnClick = Btn_Add_ImageClick
  end
  object Btn_Delete_Image: TButton
    Left = 650
    Top = 8
    Width = 24
    Height = 25
    Caption = 'Del'
    TabOrder = 13
    OnClick = Btn_Delete_ImageClick
  end
  object OpenDialog1: TOpenDialog
    Left = 344
    Top = 152
  end
end
