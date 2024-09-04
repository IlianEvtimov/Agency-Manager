object Agency_Update_Form: TAgency_Update_Form
  Left = 0
  Top = 0
  Caption = 'Agency_Update_Form'
  ClientHeight = 195
  ClientWidth = 345
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
    345
    195)
  TextHeight = 15
  object Label3: TLabel
    Left = 16
    Top = 108
    Width = 100
    Height = 15
    Caption = #1058#1077#1083#1077#1092#1086#1085#1077#1085' '#1085#1086#1084#1077#1088
  end
  object Label2: TLabel
    Left = 16
    Top = 58
    Width = 33
    Height = 15
    Caption = #1040#1076#1088#1077#1089
  end
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 89
    Height = 15
    Caption = #1048#1084#1077' '#1085#1072' '#1040#1075#1077#1085#1094#1080#1103
  end
  object Btn_Update: TButton
    Left = 158
    Top = 159
    Width = 88
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = #1040#1082#1090#1091#1072#1083#1080#1079#1072#1094#1080#1103
    TabOrder = 3
    OnClick = Btn_UpdateClick
    ExplicitLeft = 156
    ExplicitTop = 156
  end
  object Btn_Cansel: TButton
    Left = 253
    Top = 159
    Width = 74
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = #1053#1072#1079#1072#1076
    TabOrder = 4
    OnClick = Btn_CanselClick
    ExplicitLeft = 251
    ExplicitTop = 156
  end
  object Edt_Phone: TEdit
    Left = 16
    Top = 128
    Width = 315
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    ExplicitWidth = 313
  end
  object Edt_Address: TEdit
    Left = 16
    Top = 79
    Width = 315
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    ExplicitWidth = 313
  end
  object Edt_Name: TEdit
    Left = 16
    Top = 29
    Width = 315
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    ExplicitWidth = 313
  end
end
