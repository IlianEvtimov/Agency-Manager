inherited Viewing_Clients_Form: TViewing_Clients_Form
  Caption = 'Viewing_Clients_Form'
  TextHeight = 15
  inherited ListView1: TListView
    MultiSelect = False
  end
  inherited PopupMenu1: TPopupMenu
    inherited Update: TMenuItem
      Visible = False
    end
    inherited Delete: TMenuItem
      Visible = False
    end
  end
end
