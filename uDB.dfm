object DM: TDM
  Height = 352
  Width = 453
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=D:\Firebird Project\Database\AGENTURDB.FDB'
      'User_Name=sysdba'
      'Password=masterkey'
      'DriverID=FB')
    Connected = True
    LoginPrompt = False
    Left = 40
    Top = 32
  end
  object FDQuery_Agency: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT r.AGENCYID, r."NAME", r.ADDRESS, r.CONTACTPHONE'
      'FROM AGENCY r')
    Left = 144
    Top = 40
  end
  object FDQuery_Work: TFDQuery
    Connection = FDConnection1
    Left = 144
    Top = 96
  end
  object FDQuery2: TFDQuery
    Connection = FDConnection1
    Left = 144
    Top = 160
  end
  object FDQuery3: TFDQuery
    Connection = FDConnection1
    Left = 144
    Top = 216
  end
  object FDQuery4: TFDQuery
    Connection = FDConnection1
    Left = 144
    Top = 272
  end
end
