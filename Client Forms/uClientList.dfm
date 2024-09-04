inherited Client_List_Form: TClient_List_Form
  Caption = 'Client_List_Form'
  ClientWidth = 601
  ExplicitWidth = 617
  TextHeight = 15
  inherited ListView1: TListView
    Width = 601
    Columns = <
      item
        Caption = 'ID'
        Width = 40
      end
      item
        AutoSize = True
        Caption = 'Name'
      end
      item
        AutoSize = True
        Caption = 'Phonenumber'
      end
      item
        Caption = 'ClientType'
      end
      item
        Caption = 'Budget'
      end
      item
        Caption = 'PropertyId'
      end>
    ExplicitWidth = 601
  end
end
