unit uPropertyImageClass;

interface
  uses
     System.Classes, System.SysUtils, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Graphics, Data.DB, Vcl.Imaging.pngimage, Vcl.Imaging.jpeg, FireDAC.Comp.Client, FireDAC.Stan.Param;

  type


  TPropertyImageLoader  = class
  private
    FPropertyID: Integer;
    FImage: TImage;
    FLabel: TLabel;
    FDQuery: TFDQuery;
    procedure GetImagesFromDatabase;
    procedure LoadImagesFDQuery;
    function DetectImageFormat(Stream: TStream): string;
    function GetNext: Boolean;
    function GetPrevious: Boolean;
    function SetDelete: Boolean;
    procedure DeleteImageByID(AImageID: Integer);
    
    function InsertImage(AImagePath: string): Boolean;
    procedure SetAddImage(const AImagePath: string);
  public
    constructor Create(APropertyID: Integer; AImage: TImage; ALabel: TLabel);
    procedure LoadImage;
    property Next: Boolean read GetNext;
    property Previous: Boolean read GetPrevious;
    property Delete: Boolean read SetDelete;
    property AddImage: string write SetAddImage;
    destructor Destroy; override;      
  end;

implementation
   uses
    uDB;

constructor TPropertyImageLoader.Create(APropertyID: Integer; AImage: TImage; ALabel: TLabel);
begin
  inherited Create;

  // Задаване на PropertyID
  FPropertyID := APropertyID;

  // Свързване със съществуващите компоненти
  FImage := AImage;
  FLabel := ALabel;

  // Инициализация на стойности по подразбиране
  FLabel.Caption := 'Property ID: ' + IntToStr(FPropertyID);
end;

procedure TPropertyImageLoader.LoadImage;
begin
  GetImagesFromDatabase;
  if Assigned(FDQuery) then begin
    LoadImagesFDQuery;
    FLabel.Caption := Format('%d от %d', [FDQuery.RecNo, FDQuery.RecordCount]);
  end 
  else 
  begin
    FLabel.Caption := '0 от 0';
  end;
end;

procedure TPropertyImageLoader.SetAddImage(const AImagePath: string);
begin
  if InsertImage(AImagePath) then
  begin
//    GetImagesFromDatabase;
    if Assigned(FDQuery) then
    begin
      FDQuery.Close;
      FDQuery.Open;
      
      FDQuery.Last;
      LoadImagesFDQuery;
      FLabel.Caption := Format('%d от %d', [FDQuery.RecNo, FDQuery.RecordCount]);
    end;
  end;
end;

function TPropertyImageLoader.SetDelete: Boolean;
var
  LCurrentImageID, LCurrentIndex: Integer;
begin
  Result := False;
  if Assigned(FDQuery) then
  begin
    // Запазване на текущия индекс
    LCurrentIndex := FDQuery.RecNo;

    // Извличане на текущото IMAGEID и изтриване
    LCurrentImageID := FDQuery.FieldByName('IMAGEID').AsInteger;
    DeleteImageByID(LCurrentImageID);

    // Презареждане на данните след изтриване
//    GetImagesFromDatabase;
    Result := True;
    if Assigned(FDQuery) then begin
      FDQuery.Close;
      FDQuery.Open;
      
      // Настройка на курсора към предишния запис (или първия, ако текущият е изтрит)
      if FDQuery.RecordCount > 0 then
      begin
        if LCurrentIndex > 1 then
          FDQuery.RecNo := LCurrentIndex - 1  // Преминаване към предишния запис
        else
          FDQuery.First;  // Ако текущият запис е първи, преминете към първия след презареждането

        // Визуализиране на текущото изображение
        LoadImagesFDQuery;
        FLabel.Caption := Format('%d от %d', [FDQuery.RecNo, FDQuery.RecordCount]);
      end;
    end
    else
    begin
      // Ако няма останали записи, изчистване на изображението
      FImage.Picture.Assign(nil);
      FLabel.Caption := '0 от 0';
    end;
  end;
end;

procedure TPropertyImageLoader.GetImagesFromDatabase;
begin
  if Assigned(FDQuery) then
    FreeAndNil(FDQuery);

  FDQuery := TFDQuery.Create(nil); // Инициализация на Result
  try
    with DM do
    begin
      if not FDConnection1.Connected then
        FDConnection1.Connected := True;

      FDQuery.Connection := FDConnection1;
      // Подгответе SQL заявката за извличане на изображението
      FDQuery.SQL.Text := 'SELECT IMAGEID, IMAGE FROM PROPERTY_IMAGES WHERE PROPERTYID = :PropertyID';
      FDQuery.ParamByName('PropertyID').AsInteger := FPropertyID;

      // Изпълнете заявката
      FDQuery.Open;

      if FDQuery.IsEmpty then
        FreeAndNil(FDQuery);
    end;
  except
    on E: Exception do
    begin
      FDQuery := nil; // В случай на грешка, върнете nil
    end;
  end;
end;

function TPropertyImageLoader.GetNext: Boolean;
begin
  Result := False;
  if Assigned(FDQuery) then
  begin
    FDQuery.Next; // Преминава към следващия запис, ако не е в края
    if not FDQuery.Eof then
    begin
      LoadImagesFDQuery;
      FLabel.Caption := Format('%d от %d', [FDQuery.RecNo, FDQuery.RecordCount]);
      Result := True;
    end;
  end;
end;

function TPropertyImageLoader.GetPrevious: Boolean;
begin
  Result := False;
  if Assigned(FDQuery) then
  begin
    // Преминава към предишния запис
    FDQuery.Prior;
    // Проверка дали сме в началото на набора от данни (BOF)
    if not FDQuery.Bof then
    begin
      // Зареждане на изображението от текущия запис
      LoadImagesFDQuery;
      FLabel.Caption := Format('%d от %d', [FDQuery.RecNo, FDQuery.RecordCount]);
      Result := True;
    end;
  end;
end;

procedure TPropertyImageLoader.LoadImagesFDQuery;
var
  BlobStream: TStream;
  ImageFormat: string;
  Graphic: TGraphic;
begin

  if Assigned(FDQuery) then
  begin
    BlobStream := FDQuery.CreateBlobStream(FDQuery.FieldByName('IMAGE'), bmRead);
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
        FImage.Picture.Assign(Graphic);
      finally
        Graphic.Free;
      end;

    finally
      BlobStream.Free;
    end;
  end;
end;

destructor TPropertyImageLoader.Destroy;
begin
  if Assigned(FDQuery) then
  begin
    FreeAndNil(FDQuery);
  end;
  inherited;
end;

function TPropertyImageLoader.DetectImageFormat(Stream: TStream): string;
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

procedure TPropertyImageLoader.DeleteImageByID(AImageID: Integer);
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
      DM.FDConnection1.Rollback;  // Връщане на транзакцията при грешка
    end;
  end;
end;

function TPropertyImageLoader.InsertImage(AImagePath: string): Boolean;
var
  FileStream: TFileStream;
  LDQuery : TFDQuery;
begin

  try
    with DM do
    begin
      if not FDConnection1.Connected then
       FDConnection1.Connected := True;

       LDQuery := TFDQuery.Create(nil); // Инициализация на Result
      // Подгответе SQL заявката за вмъкване
      try
        LDQuery.Connection := FDConnection1;
        LDQuery.SQL.Text := 'INSERT INTO PROPERTY_IMAGES (PROPERTYID, IMAGE) ' +
                        'VALUES (:PropertyID, :Image)';

        // Задайте параметрите на заявката
        LDQuery.ParamByName('PropertyID').AsInteger := FPropertyID;

        // Заредете изображението в потока
        FileStream := TFileStream.Create(AImagePath, fmOpenRead or fmShareDenyWrite);
        try
          LDQuery.ParamByName('Image').LoadFromStream(FileStream, ftBlob);
        finally
          FileStream.Free;
        end;

        // Изпълнете SQL заявката
        LDQuery.ExecSQL;

        // Потвърдете транзакцията
        DM.FDConnection1.Commit;
      finally
        FreeAndNil(LDQuery);
        Result := True;
      end;

    end;
  except
    on E: Exception do
    begin
      DM.FDConnection1.Rollback;  // Връщане на транзакцията при грешка
      Result := False;
    end;
  end;
end;

end.
