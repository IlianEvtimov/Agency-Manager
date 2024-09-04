object Agency_Create_Form: TAgency_Create_Form
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1103#1085#1077' '#1085#1072' '#1040#1075#1077#1085#1080#1103
  ClientHeight = 197
  ClientWidth = 377
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poDesktopCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    377
    197)
  TextHeight = 15
  object Label3: TLabel
    Left = 16
    Top = 108
    Width = 115
    Height = 17
    Caption = #1058#1077#1083#1077#1092#1086#1085#1077#1085' '#1085#1086#1084#1077#1088
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 58
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
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 102
    Height = 17
    Caption = #1048#1084#1077' '#1085#1072' '#1040#1075#1077#1085#1094#1080#1103
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button3: TButton
    Left = 6
    Top = 164
    Width = 99
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1042#1089#1080#1095#1082#1080' '#1040#1075#1077#1085#1094#1080#1080
    TabOrder = 5
    OnClick = Button3Click
    ExplicitTop = 161
  end
  object Button1: TButton
    Left = 113
    Top = 164
    Width = 71
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1044#1086#1073#1072#1074#1080' 1000'
    TabOrder = 6
    OnClick = Button1Click
    ExplicitLeft = 111
    ExplicitTop = 161
  end
  object Btn_Add: TButton
    Left = 190
    Top = 164
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1044#1086#1073#1072#1074#1080
    TabOrder = 3
    OnClick = Btn_AddClick
    ExplicitLeft = 188
    ExplicitTop = 161
  end
  object Btn_Cancel: TButton
    Left = 276
    Top = 164
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1053#1072#1079#1072#1076
    TabOrder = 4
    OnClick = Btn_CancelClick
    ExplicitLeft = 274
    ExplicitTop = 161
  end
  object Edt_Phone: TEdit
    Left = 16
    Top = 128
    Width = 327
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    ExplicitWidth = 325
  end
  object Edt_Address: TEdit
    Left = 16
    Top = 79
    Width = 327
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    ExplicitWidth = 325
  end
  object Edt_Name: TEdit
    Left = 16
    Top = 29
    Width = 327
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    ExplicitWidth = 325
  end
end
