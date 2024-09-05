object Agent_Create_Form: TAgent_Create_Form
  Left = 0
  Top = 0
  Caption = 'Agent_Create_Form'
  ClientHeight = 201
  ClientWidth = 416
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  DesignSize = (
    416
    201)
  TextHeight = 15
  object Label3: TLabel
    Left = 16
    Top = 108
    Width = 52
    Height = 17
    Caption = #1040#1075#1077#1085#1094#1080#1103
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
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 92
    Height = 17
    Caption = #1048#1084#1077' '#1085#1072' '#1040#1075#1077#1085#1090#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Edt_Agency: TEdit
    Left = 16
    Top = 128
    Width = 327
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    Enabled = False
    ReadOnly = True
    TabOrder = 2
    ExplicitWidth = 325
  end
  object Edt_Phone: TEdit
    Left = 16
    Top = 79
    Width = 327
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    ExplicitWidth = 325
  end
  object Edt_Agent_Name: TEdit
    Left = 16
    Top = 29
    Width = 327
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    ExplicitWidth = 325
  end
  object Btn_Add: TButton
    Left = 238
    Top = 168
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1044#1086#1073#1072#1074#1080
    TabOrder = 4
    OnClick = Btn_AddClick
    ExplicitLeft = 236
    ExplicitTop = 165
  end
  object Btn_Cancel: TButton
    Left = 319
    Top = 168
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1053#1072#1079#1072#1076
    TabOrder = 5
    OnClick = Btn_CancelClick
  end
  object Button3: TButton
    Left = 15
    Top = 168
    Width = 99
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1042#1089#1080#1095#1082#1080' '#1040#1075#1077#1085#1090#1080
    TabOrder = 6
    OnClick = Button3Click
    ExplicitTop = 165
  end
  object Btn_Choose_Agency: TButton
    Left = 351
    Top = 127
    Width = 30
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 3
    OnClick = Btn_Choose_AgencyClick
    ExplicitLeft = 349
  end
end
