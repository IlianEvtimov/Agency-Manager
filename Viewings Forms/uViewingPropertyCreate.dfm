object Viewing_Crete_Form: TViewing_Crete_Form
  Left = 0
  Top = 0
  Caption = 'Viewing_Crete_Form'
  ClientHeight = 482
  ClientWidth = 549
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
  TextHeight = 15
  object ListView1: TListView
    Left = 0
    Top = 0
    Width = 549
    Height = 309
    Align = alClient
    Columns = <
      item
        Caption = 'ID'
        Width = 40
      end
      item
        AutoSize = True
        Caption = 'Property Type'
      end
      item
        AutoSize = True
        Caption = 'Address'
      end
      item
        AutoSize = True
        Caption = 'Price'
      end
      item
        Caption = 'Area'
      end
      item
        Caption = 'Description'
      end
      item
        Caption = 'AgentID'
      end>
    GridLines = True
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = ListView1DblClick
    ExplicitWidth = 551
    ExplicitHeight = 321
  end
  object Panel1: TPanel
    Left = 0
    Top = 309
    Width = 549
    Height = 173
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 312
    ExplicitWidth = 551
    DesignSize = (
      549
      173)
    object Lbl_Owner: TLabel
      Left = 280
      Top = 58
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
    object Label4: TLabel
      Left = 280
      Top = 8
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
      Visible = False
    end
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
    object Edt_PropertyID: TEdit
      Left = 280
      Top = 78
      Width = 245
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      TabOrder = 0
      ExplicitWidth = 249
    end
    object Edt_Budget: TEdit
      Left = 280
      Top = 29
      Width = 150
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      TabOrder = 1
      ExplicitWidth = 154
    end
    object Cmb_ClientType: TComboBox
      Left = 16
      Top = 130
      Width = 145
      Height = 23
      Enabled = False
      TabOrder = 2
      Visible = False
      OnChange = Cmb_ClientTypeChange
      Items.Strings = (
        #1055#1088#1086#1076#1072#1074#1072#1095
        #1050#1091#1087#1086#1074#1072#1095)
    end
    object Edt_PhoneNumber: TEdit
      Left = 16
      Top = 78
      Width = 237
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      TabOrder = 3
      ExplicitWidth = 241
    end
    object Edt_ClientName: TEdit
      Left = 16
      Top = 29
      Width = 237
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      TabOrder = 4
      ExplicitWidth = 241
    end
    object Btn_Client_Choose: TButton
      Left = 440
      Top = 128
      Width = 89
      Height = 25
      Caption = #1048#1079#1073#1077#1088#1080' '#1050#1083#1080#1077#1085#1090
      TabOrder = 5
      OnClick = Btn_Client_ChooseClick
    end
  end
end
