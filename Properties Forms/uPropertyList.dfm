object Property_List_Form: TProperty_List_Form
  Left = 0
  Top = 0
  Caption = 'Property_List_Form'
  ClientHeight = 453
  ClientWidth = 607
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
  TextHeight = 15
  object ListView1: TListView
    Left = 0
    Top = 0
    Width = 607
    Height = 453
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
    PopupMenu = PopupMenu1
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = ListView1DblClick
  end
  object PopupMenu1: TPopupMenu
    Left = 468
    Top = 266
    object Update: TMenuItem
      Caption = 'Update'
      ShortCut = 85
      OnClick = UpdateClick
    end
    object Delete: TMenuItem
      Caption = 'Delete'
      ShortCut = 46
      OnClick = DeleteClick
    end
    object Enter: TMenuItem
      Caption = 'Enter'
      ShortCut = 13
      OnClick = EnterClick
    end
  end
end
