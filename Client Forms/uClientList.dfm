inherited Client_List_Form: TClient_List_Form
  Caption = 'Client_List_Form'
  ClientHeight = 444
  ClientWidth = 601
  TextHeight = 15
  inherited ListView1: TListView
    Width = 601
    Height = 444
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
  end
end
