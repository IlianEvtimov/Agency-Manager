object Client_Update_Form: TClient_Update_Form
  Left = 0
  Top = 0
  Caption = 'Client_Update_Form'
  ClientHeight = 289
  ClientWidth = 335
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
    335
    289)
  TextHeight = 15
  object Label3: TLabel
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
  object Label2: TLabel
    Left = 16
    Top = 107
    Width = 23
    Height = 17
    Caption = #1058#1080#1087
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
    Caption = #1048#1084#1077' '#1085#1072' '#1050#1083#1080#1077#1085#1090#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 16
    Top = 162
    Width = 51
    Height = 17
    Caption = #1041#1102#1076#1078#1077#1090
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Lbl_Owner: TLabel
    Left = 16
    Top = 210
    Width = 79
    Height = 17
    Caption = #1057#1086#1073#1089#1090#1074#1077#1085#1086#1089#1090
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object Edt_PhoneNumber: TEdit
    Left = 16
    Top = 78
    Width = 279
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    ExplicitWidth = 281
  end
  object Edt_ClientName: TEdit
    Left = 16
    Top = 29
    Width = 279
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    ExplicitWidth = 281
  end
  object Btn_Add: TButton
    Left = 139
    Top = 255
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1044#1086#1073#1072#1074#1080
    TabOrder = 2
    OnClick = Btn_AddClick
    ExplicitLeft = 141
  end
  object Btn_Cancel: TButton
    Left = 220
    Top = 255
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1053#1072#1079#1072#1076
    TabOrder = 3
    OnClick = Btn_CancelClick
    ExplicitLeft = 222
  end
  object Cmb_ClientType: TComboBox
    Left = 16
    Top = 130
    Width = 145
    Height = 23
    TabOrder = 4
    OnChange = Cmb_ClientTypeChange
    Items.Strings = (
      #1055#1088#1086#1076#1072#1074#1072#1095
      #1050#1091#1087#1086#1074#1072#1095)
  end
  object Edt_Budget: TEdit
    Left = 16
    Top = 181
    Width = 279
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 5
    ExplicitWidth = 281
  end
  object Edt_PropertyID: TEdit
    Left = 16
    Top = 230
    Width = 254
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    Enabled = False
    TabOrder = 6
    Visible = False
    ExplicitWidth = 256
  end
  object Btn_Agent: TButton
    Left = 274
    Top = 230
    Width = 25
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 7
    Visible = False
    OnClick = Btn_AgentClick
    ExplicitLeft = 276
  end
end
