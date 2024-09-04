object Agent_Update_Form: TAgent_Update_Form
  Left = 0
  Top = 0
  Caption = 'Agent_Update_Form'
  ClientHeight = 192
  ClientWidth = 352
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poDesktopCenter
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    352
    192)
  TextHeight = 15
  object Label2: TLabel
    Left = 16
    Top = 58
    Width = 55
    Height = 17
    Caption = #1058#1077#1083#1077#1092#1086#1085
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
  object Btn_Update: TButton
    Left = 161
    Top = 156
    Width = 88
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = #1040#1082#1090#1091#1072#1083#1080#1079#1072#1094#1080#1103
    TabOrder = 2
    OnClick = Btn_UpdateClick
    ExplicitLeft = 159
    ExplicitTop = 153
  end
  object Btn_Cansel: TButton
    Left = 256
    Top = 156
    Width = 74
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = #1053#1072#1079#1072#1076
    TabOrder = 3
    OnClick = Btn_CanselClick
    ExplicitLeft = 254
    ExplicitTop = 153
  end
  object Edt_Phone: TEdit
    Left = 16
    Top = 79
    Width = 318
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    ExplicitWidth = 316
  end
  object Edt_Name: TEdit
    Left = 16
    Top = 29
    Width = 318
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    ExplicitWidth = 316
  end
  object Edt_Agency: TEdit
    Left = 16
    Top = 128
    Width = 277
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    Enabled = False
    ReadOnly = True
    TabOrder = 4
    ExplicitWidth = 275
  end
  object Btn_Choose_Agency: TButton
    Left = 299
    Top = 127
    Width = 30
    Height = 25
    Anchors = [akTop]
    Caption = '...'
    TabOrder = 5
    OnClick = Btn_Choose_AgencyClick
    ExplicitLeft = 297
  end
end
