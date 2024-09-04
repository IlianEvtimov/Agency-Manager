unit uPropertyManager;

interface
   uses
    System.SysUtils, System.Classes, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Graphics, Vcl.ExtCtrls, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage,
    FireDAC.Comp.Client, FireDAC.Stan.Param, Data.DB, uDB, uPropertyClass;

    function InsertProperty(var AProperty: TProperty): Boolean;
    function UpdateProperty(const AProperty: TProperty): Boolean;
    function DeleteProperty(const AProperty: TProperty): Boolean;
    function DeleteViewingByPropertyID(const APropertyID: LongInt): Boolean;
    function SetClientPropertyIDToNil(const APropertyID: LongInt): Boolean;
    procedure LoadAllProperties(AListView: TListView);
    procedure LoadAllPropertiesWithNoClients(AListView: TListView);
    function GetPropertyByID(const AProperty: LongInt): TProperty;
    procedure AddImageToDatabase(APropertyID: Integer; AImagePath: string);
    function GetLastGeneratedPropertyID: Integer;
//    procedure LoadImageFromDatabase(APropertyID: Integer; AImage: TImage);
    function GetImagesFromDatabase(const APropertyID: Integer): TFDQuery;
    procedure LoadImagesFDQuery(const AFDQuery : TFDQuery; AImage: TImage);
    function DetectImageFormat(Stream: TStream): string;
    procedure DeleteImageByID(AImageID: Integer);


implementation

function InsertProperty(var AProperty: TProperty): Boolean;
begin
  try
    with DM do
    begin
      if not FDConnection1.Connected then
        FDConnection1.Connected := True;
      FDQuery_Work.SQL.Clear;
      FDQuery_Work.SQL.Text := 'INSERT INTO PROPERTIES (DESCRIPTION, ADDRESS, PRICE, PROPERTYTYPE, AREA, AGENTID) ' +
                               'VALUES (:Description, :Address, :Price, :PropertyType, :Area, :AgentID) ' +
                               'RETURNING PROPERTYID'; // 'PROPERTYID' е името на ID полето
      FDQuery_Work.ParamByName('Description').AsString  := AProperty.Description;
      FDQuery_Work.ParamByName('Address').AsString      := AProperty.Address;
      FDQuery_Work.ParamByName('Price').AsFloat         := AProperty.Price;
      FDQuery_Work.ParamByName('PropertyType').AsString := AProperty.PropertyType;
      FDQuery_Work.ParamByName('Area').AsFloat          := AProperty.Area;
      FDQuery_Work.ParamByName('AgentID').AsInteger     := AProperty.AgentID;

      FDQuery_Work.Open; // Изпълняваме заявката с 'RETURNING'
      AProperty.PropertyID := FDQuery_Work.FieldByName('PROPERTYID').AsInteger; // Запазваме новото ID в AProperty
      FDConnection1.Commit;
    end;
    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
      ShowMessage('Error inserting PROPERTIES: ' + E.Message);
      DM.FDConnection1.Rollback;
    end;
  end;
end;

procedure LoadAllProperties(AListView: TListView);
var
  ListItem: TListItem;
  LProperty: TProperty;
begin

  // Уверете се, че връзката е активна
  if not DM.FDConnection1.Connected then
    DM.FDConnection1.Connected := True;

  // Настройка и изпълнение на заявка за извличане на данни
  DM.FDQuery_Agency.SQL.Clear;
  DM.FDQuery_Agency.SQL.Add('SELECT * FROM PROPERTIES');
  DM.FDQuery_Agency.Open;

  // Итерация през всички записи в FDQuery1
  DM.FDQuery_Agency.First;
  while not DM.FDQuery_Agency.Eof do
  begin
    // Създаване на обект TAgencyRecord с данните от текущия запис
    LProperty := TProperty.Create(
      DM.FDQuery_Agency.FieldByName('PROPERTYID').AsInteger,
      DM.FDQuery_Agency.FieldByName('PropertyType').AsString,
      DM.FDQuery_Agency.FieldByName('Address').AsString,
      DM.FDQuery_Agency.FieldByName('Price').AsFloat,
      DM.FDQuery_Agency.FieldByName('Area').AsFloat,
      DM.FDQuery_Agency.FieldByName('Description').AsString,
      DM.FDQuery_Agency.FieldByName('AgentID').AsInteger
    );

    // Създаване на нов ListItem и задаване на данни
    ListItem := AListView.Items.Add;

    ListItem.Caption := IntToStr(LProperty.PropertyID);
    ListItem.SubItems.Add(LProperty.PropertyType);
    ListItem.SubItems.Add(LProperty.Address);

    // Форматиране на Price и Area с две цифри след десетичната запетая
    ListItem.SubItems.Add(FormatFloat('0.00', LProperty.Price));
    ListItem.SubItems.Add(FormatFloat('0.00', LProperty.Area));

    ListItem.SubItems.Add(LProperty.Description);
    ListItem.SubItems.Add(IntToStr(LProperty.AgentID));

    // Съхраняване на указателя към обекта в Data свойството
    ListItem.Data := LProperty;

    // Преминаване към следващия запис
    DM.FDQuery_Agency.Next;
  end;

  if AListView.Items.Count > 0 then
    AListView.ItemIndex := 0;

  // Затваряне на заявката
  DM.FDQuery_Agency.Close;
end;

procedure LoadAllPropertiesWithNoClients(AListView: TListView);
var
  ListItem: TListItem;
  LProperty: TProperty;
begin
  // Уверете се, че връзката е активна
  if not DM.FDConnection1.Connected then
    DM.FDConnection1.Connected := True;

  // Настройка и изпълнение на заявка за извличане на свойства, които не са свързани с клиенти
  DM.FDQuery_Agency.SQL.Clear;
  DM.FDQuery_Agency.SQL.Add('SELECT p.PROPERTYID, p.PropertyType, p.Address, p.Price, p.Area, ' +
                            'p.Description, p.AgentID ' +
                            'FROM PROPERTIES p ' +
                            'LEFT JOIN CLIENTS c ON p.PROPERTYID = c.PROPERTYID ' +
                            'WHERE c.PROPERTYID IS NULL');
  DM.FDQuery_Agency.Open;

  // Итерация през всички записи в FDQuery_Agency
  DM.FDQuery_Agency.First;
  while not DM.FDQuery_Agency.Eof do
  begin
    // Създаване на обект TProperty с данните от текущия запис
    LProperty := TProperty.Create(
      DM.FDQuery_Agency.FieldByName('PROPERTYID').AsInteger,
      DM.FDQuery_Agency.FieldByName('PropertyType').AsString,
      DM.FDQuery_Agency.FieldByName('Address').AsString,
      DM.FDQuery_Agency.FieldByName('Price').AsFloat,
      DM.FDQuery_Agency.FieldByName('Area').AsFloat,
      DM.FDQuery_Agency.FieldByName('Description').AsString,
      DM.FDQuery_Agency.FieldByName('AgentID').AsInteger
    );

    // Създаване на нов ListItem и задаване на данни
    ListItem := AListView.Items.Add;

    ListItem.Caption := IntToStr(LProperty.PropertyID);
    ListItem.SubItems.Add(LProperty.PropertyType);
    ListItem.SubItems.Add(LProperty.Address);

    // Форматиране на Price и Area с две цифри след десетичната запетая
    ListItem.SubItems.Add(FormatFloat('0.00', LProperty.Price));
    ListItem.SubItems.Add(FormatFloat('0.00', LProperty.Area));

    ListItem.SubItems.Add(LProperty.Description);
    ListItem.SubItems.Add(IntToStr(LProperty.AgentID));

    // Съхраняване на указателя към обекта в Data свойството
    ListItem.Data := LProperty;

    // Преминаване към следващия запис
    DM.FDQuery_Agency.Next;
  end;

  if AListView.Items.Count > 0 then
    AListView.ItemIndex := 0;

  // Затваряне на заявката
  DM.FDQuery_Agency.Close;
end;

function UpdateProperty(const AProperty: TProperty): Boolean;
begin
  try
    with DM do
    begin
      if not FDConnection1.Connected then
        FDConnection1.Connected := True;
      FDQuery_Work.SQL.Clear;
      FDQuery_Work.SQL.Text := 'UPDATE PROPERTIES SET ' +
                               'DESCRIPTION = :Description, ' +
                               'ADDRESS = :Address, ' +
                               'PRICE = :Price, ' +
                               'PROPERTYTYPE = :PropertyType, ' +
                               'AREA = :Area, ' +
                               'AGENTID = :AgentID ' +
                               'WHERE PROPERTYID = :PropertyID';  // ID е идентификаторът на записа, който ще се актуализира

      FDQuery_Work.ParamByName('Description').AsString  := AProperty.Description;
      FDQuery_Work.ParamByName('Address').AsString      := AProperty.Address;
      FDQuery_Work.ParamByName('Price').AsFloat         := AProperty.Price;  // Използвай AsFloat за Double стойности
      FDQuery_Work.ParamByName('PropertyType').AsString := AProperty.PropertyType;
      FDQuery_Work.ParamByName('Area').AsFloat          := AProperty.Area;    // Използвай AsFloat за Double стойности
      FDQuery_Work.ParamByName('AgentID').AsInteger     := AProperty.AgentID;
      FDQuery_Work.ParamByName('PropertyID').AsInteger  := AProperty.PropertyID;      // ID на записа, който ще се актуализира
      FDQuery_Work.ExecSQL;
      FDConnection1.Commit;
    end;
    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
      // Логиране или показване на съобщение за грешка може да бъде добавено тук
       ShowMessage('Error updating PROPERTIES: ' + E.Message);
      DM.FDConnection1.Rollback;  // Връщане на транзакцията при грешка
    end;
  end;
end;

function DeleteProperty(const AProperty: TProperty): Boolean;
begin
  try
    with DM do
    begin
      if not FDConnection1.Connected then
        FDConnection1.Connected := True;

      if not DeleteViewingByPropertyID(AProperty.PropertyID) then
        ShowMessage('Грешка при изтриване на VIEWINGS!');

      if not SetClientPropertyIDToNil(AProperty.PropertyID) then
        ShowMessage('Грешка при задаване на Client таблицата PropertyID to nil!');


      FDQuery_Work.SQL.Clear;
      FDQuery_Work.SQL.Text := 'DELETE FROM PROPERTIES WHERE PROPERTYID = :PropertyID';  // Изтриване на записа с даден PropertyID
      FDQuery_Work.ParamByName('PropertyID').AsInteger := AProperty.PropertyID;  // PropertyID на записа, който ще бъде изтрит
      FDQuery_Work.ExecSQL;
      FDConnection1.Commit;
    end;
    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
      // Логиране или показване на съобщение за грешка може да бъде добавено тук
      // ShowMessage('Error deleting property: ' + E.Message);
      DM.FDConnection1.Rollback;  // Връщане на транзакцията при грешка
    end;
  end;
end;

function DeleteViewingByPropertyID(const APropertyID: LongInt): Boolean;
begin
  try
    with DM do
    begin
      if not FDConnection1.Connected then
        FDConnection1.Connected := True;


      FDQuery_Work.SQL.Clear;
      FDQuery_Work.SQL.Text := 'DELETE FROM VIEWINGS WHERE PROPERTYID = :PropertyID';  // Изтриване на записа с даден PropertyID

      FDQuery_Work.ParamByName('PropertyID').AsInteger := APropertyID;  // PropertyID на записа, който ще бъде изтрит
      FDQuery_Work.ExecSQL;
      FDConnection1.Commit;
    end;
    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
      // Логиране или показване на съобщение за грешка може да бъде добавено тук
      // ShowMessage('Error deleting property: ' + E.Message);
      DM.FDConnection1.Rollback;  // Връщане на транзакцията при грешка
    end;
  end;
end;

function SetClientPropertyIDToNil(const APropertyID: LongInt): Boolean;
begin
  try
    with DM do
    begin
      if not FDConnection1.Connected then
        FDConnection1.Connected := True;
      FDQuery_Work.SQL.Clear;
      FDQuery_Work.SQL.Text := 'UPDATE CLIENTS SET PROPERTYID = NULL WHERE PROPERTYID = :PropertyID';  // Задаване на PROPERTYID на NULL

      FDQuery_Work.ParamByName('PropertyID').AsInteger := APropertyID;  // Задаване на стойността на CLIENTID, която идентифицира клиента
      FDQuery_Work.ExecSQL;
      FDConnection1.Commit;
    end;
    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
      // Логиране или показване на съобщение за грешка може да бъде добавено тук
      // ShowMessage('Error updating property ID to NULL: ' + E.Message);
      DM.FDConnection1.Rollback;  // Връщане на транзакцията при грешка
    end;
  end;
end;

function GetPropertyByID(const AProperty: LongInt): TProperty;
begin
  // Инициализиране на резултата с nil
  Result := nil;
  try
    with DM do
    begin
      if not FDConnection1.Connected then
        FDConnection1.Connected := True;

      FDQuery_Work.SQL.Clear;
      FDQuery_Work.SQL.Text := 'SELECT * FROM PROPERTIES WHERE PROPERTYID = :PropertyID';
      FDQuery_Work.ParamByName('PropertyID').AsInteger := AProperty;
      FDQuery_Work.Open;

      // Проверка дали заявката е върнала резултат
      if not FDQuery_Work.IsEmpty then
      begin
        // Създаване на обект TAgency с данните от заявката
        Result := TProperty.Create(
          FDQuery_Work.FieldByName('PROPERTYID').AsInteger,
          FDQuery_Work.FieldByName('PROPERTYTYPE').AsString,
          FDQuery_Work.FieldByName('ADDRESS').AsString,
          FDQuery_Work.FieldByName('PRICE').AsFloat,
          FDQuery_Work.FieldByName('AREA').AsFloat,
          FDQuery_Work.FieldByName('DESCRIPTION').AsString,
          FDQuery_Work.FieldByName('AGENTID').AsInteger
        );
      end;
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Грешка при взимане на AGENTS по ИД: ' + E.Message);
    end;
  end;

end;

procedure AddImageToDatabase(APropertyID: Integer; AImagePath: string);
var
  FileStream: TFileStream;
begin
  try
    with DM do
    begin
      if not FDConnection1.Connected then
       FDConnection1.Connected := True;
      // Подгответе SQL заявката за вмъкване
      FDQuery_Work.SQL.Text := 'INSERT INTO PROPERTY_IMAGES (PROPERTYID, IMAGE) ' +
                        'VALUES (:PropertyID, :Image)';

      // Задайте параметрите на заявката
      FDQuery_Work.ParamByName('PropertyID').AsInteger := APropertyID;

      // Заредете изображението в потока
      FileStream := TFileStream.Create(AImagePath, fmOpenRead or fmShareDenyWrite);
      try
        FDQuery_Work.ParamByName('Image').LoadFromStream(FileStream, ftBlob);
      finally
        FileStream.Free;
      end;

      // Изпълнете SQL заявката
      FDQuery_Work.ExecSQL;

      // Потвърдете транзакцията
      DM.FDConnection1.Commit;
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Error adding image to the database: ' + E.Message);
      DM.FDConnection1.Rollback;  // Връщане на транзакцията при грешка
    end;
  end;
end;

function GetLastGeneratedPropertyID: Integer;
var
  LastID: Integer;
begin
  LastID := 0;  // Начална стойност
   with DM do
   begin
      try
        if not FDConnection1.Connected then
        FDConnection1.Connected := True;
        FDQuery_Work.SQL.Text := 'SELECT GEN_ID(GEN_PROPERTYID, 0) FROM RDB$DATABASE;';
        FDQuery_Work.Open;
        if not FDQuery_Work.IsEmpty then
        begin
          LastID := FDQuery_Work.Fields[0].AsInteger;
        end;

      finally
        Result := LastID;

      end;
   end;
end;

procedure LoadImagesFDQuery(const AFDQuery : TFDQuery; AImage: TImage);
var
  BlobStream: TStream;
  ImageFormat: string;
  Graphic: TGraphic;
begin
  if not AFDQuery.IsEmpty then
  begin
    BlobStream := AFDQuery.CreateBlobStream(AFDQuery.FieldByName('IMAGE'), bmRead);
    try
      BlobStream.Position := 0;  // Уверете се, че началната позиция на потока е нула

      // Определете формата на изображението
      ImageFormat := DetectImageFormat(BlobStream);

      // Създайте графичен обект според формата на изображението
      if ImageFormat = 'PNG' then
        Graphic := TPngImage.Create
      else if ImageFormat = 'JPEG' then
        Graphic := TJPEGImage.Create
      else if ImageFormat = 'BMP' then
        Graphic := TBitmap.Create
      else
        raise Exception.Create('Unsupported image format');

      try
        // Зареждане на графиката от потока
        BlobStream.Position := 0;  // Отново се уверете, че позицията е нула преди четене
        Graphic.LoadFromStream(BlobStream);
        AImage.Picture.Assign(Graphic);
      finally
        Graphic.Free;
      end;

    finally
      BlobStream.Free;
    end;
  end
  else
  begin
    ShowMessage('No image found for this PropertyID.');
  end;
end;

function GetImagesFromDatabase(const APropertyID: Integer): TFDQuery;
begin
  Result := TFDQuery.Create(nil); // Инициализация на Result
  try
    with DM do
    begin
      if not FDConnection1.Connected then
        FDConnection1.Connected := True;

      Result.Connection := FDConnection1;
      // Подгответе SQL заявката за извличане на изображението
      Result.SQL.Text := 'SELECT IMAGEID, IMAGE FROM PROPERTY_IMAGES WHERE PROPERTYID = :PropertyID';
      Result.ParamByName('PropertyID').AsInteger := APropertyID;

      // Изпълнете заявката
      Result.Open;

      if Result.IsEmpty then
        FreeAndNil(Result);
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Error loading image from the database: ' + E.Message);
      Result := nil; // В случай на грешка, върнете nil
    end;
  end;
end;

//procedure LoadImageFromDatabase(APropertyID: Integer; AImage: TImage);
//var
//  BlobStream: TStream;
//  ImageFormat: string;
//  Graphic: TGraphic;
//begin
//  try
//    with DM do
//    begin
//      if not FDConnection1.Connected then
//        FDConnection1.Connected := True;
//
//      // Подгответе SQL заявката за извличане на изображението
//      FDQuery_Work.SQL.Text := 'SELECT IMAGE FROM PROPERTY_IMAGES WHERE PROPERTYID = :PropertyID';
//      FDQuery_Work.ParamByName('PropertyID').AsInteger := APropertyID;
//
//      // Изпълнете заявката
//      FDQuery_Work.Open;
//
//      // Проверете дали има резултат и извлечете изображението
//      if not FDQuery_Work.IsEmpty then
//      begin
//        BlobStream := FDQuery_Work.CreateBlobStream(FDQuery_Work.FieldByName('IMAGE'), bmRead);
//        try
//          BlobStream.Position := 0;  // Уверете се, че началната позиция на потока е нула
//
//          // Определете формата на изображението
//          ImageFormat := DetectImageFormat(BlobStream);
//
//          // Създайте графичен обект според формата на изображението
//          if ImageFormat = 'PNG' then
//            Graphic := TPngImage.Create
//          else if ImageFormat = 'JPEG' then
//            Graphic := TJPEGImage.Create
//          else if ImageFormat = 'BMP' then
//            Graphic := TBitmap.Create
//          else
//            raise Exception.Create('Unsupported image format');
//
//          try
//            // Зареждане на графиката от потока
//            BlobStream.Position := 0;  // Отново се уверете, че позицията е нула преди четене
//            Graphic.LoadFromStream(BlobStream);
//            AImage.Picture.Assign(Graphic);
////            ShowMessage('Image loaded successfully.');
//          finally
//            Graphic.Free;
//          end;
//        finally
//          BlobStream.Free;
//        end;
//      end
//      else
//      begin
//        ShowMessage('No image found for this PropertyID.');
//      end;
//    end;
//
//  except
//    on E: Exception do
//    begin
//      ShowMessage('Error loading image from the database: ' + E.Message);
//    end;
//  end;
//end;

function DetectImageFormat(Stream: TStream): string;
var
  Signature: array[0..7] of Byte;
begin
  Result := '';
  Stream.Position := 0;
  Stream.Read(Signature, SizeOf(Signature));

  // Проверка за PNG формат
  if (Signature[0] = $89) and (Signature[1] = $50) and (Signature[2] = $4E) and (Signature[3] = $47) then
    Result := 'PNG'
  // Проверка за JPEG формат
  else if (Signature[0] = $FF) and (Signature[1] = $D8) and (Signature[2] = $FF) then
    Result := 'JPEG'
  // Проверка за BMP формат
  else if (Signature[0] = $42) and (Signature[1] = $4D) then
    Result := 'BMP'
  // Можете да добавите и други формати, ако е необходимо
  else
    Result := 'UNKNOWN';
end;

procedure DeleteImageByID(AImageID: Integer);
begin
  try
    with DM do
    begin
      if not FDConnection1.Connected then
        FDConnection1.Connected := True;

      FDQuery_Work.SQL.Clear;
      FDQuery_Work.SQL.Text := 'DELETE FROM PROPERTY_IMAGES WHERE IMAGEID = :ImageID';
      FDQuery_Work.ParamByName('ImageID').AsInteger := AImageID;
      FDQuery_Work.ExecSQL;

      FDConnection1.Commit;
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Error deleting image record: ' + E.Message);
      DM.FDConnection1.Rollback;  // Връщане на транзакцията при грешка
    end;
  end;
end;

end.
