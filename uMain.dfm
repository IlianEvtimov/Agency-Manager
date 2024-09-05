object Main_Form: TMain_Form
  Left = 0
  Top = 0
  Caption = #1057#1086#1092#1090#1091#1077#1088' '#1079#1072' '#1040#1075#1077#1085#1094#1080#1103
  ClientHeight = 431
  ClientWidth = 584
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 169
    Height = 431
    Align = alLeft
    TabOrder = 0
    ExplicitHeight = 428
    object Label_Agency: TLabel
      Left = 24
      Top = 32
      Width = 118
      Height = 21
      Caption = #1044#1086#1073#1072#1074#1080' '#1040#1075#1077#1085#1094#1080#1103
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      OnClick = Label_AgencyClick
      OnMouseEnter = Label_AgencyMouseEnter
      OnMouseLeave = Label_AgencyMouseLeave
    end
    object Label_Agents: TLabel
      Left = 24
      Top = 55
      Width = 98
      Height = 21
      Caption = #1044#1086#1073#1072#1074#1080' '#1040#1075#1077#1085#1090
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      OnClick = Label_AgentsClick
      OnMouseEnter = Label_AgencyMouseEnter
      OnMouseLeave = Label_AgencyMouseLeave
    end
    object Label_Seller: TLabel
      Left = 24
      Top = 107
      Width = 108
      Height = 21
      Caption = #1044#1086#1073#1072#1074#1080' '#1050#1083#1080#1077#1085#1090
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      OnClick = Label_SellerClick
      OnMouseEnter = Label_AgencyMouseEnter
      OnMouseLeave = Label_AgencyMouseLeave
    end
    object Label_Properties: TLabel
      Left = 24
      Top = 81
      Width = 97
      Height = 21
      Caption = #1044#1086#1073#1072#1074#1080' '#1048#1084#1086#1090
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      OnClick = Label_PropertiesClick
      OnMouseEnter = Label_AgencyMouseEnter
      OnMouseLeave = Label_AgencyMouseLeave
    end
    object Label1: TLabel
      Left = 24
      Top = 133
      Width = 108
      Height = 21
      Caption = #1044#1086#1073#1072#1074#1080' '#1050#1083#1080#1077#1085#1090
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      OnClick = Label1Click
      OnMouseEnter = Label_AgencyMouseEnter
      OnMouseLeave = Label_AgencyMouseLeave
    end
  end
end
