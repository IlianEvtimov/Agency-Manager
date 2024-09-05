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
  FPropertyID := APropertyID;
  FImage := AImage;
  FLabel := ALabel;
  FDQuery := TFDQuery.Create(nil);
end;

procedure TPropertyImageLoader.LoadImage;
begin
  GetImagesFromDatabase;
  LoadImagesFDQuery;
  FLabel.Caption := Format('%d от %d', [FDQuery.RecNo, FDQuery.RecordCount]);
end;

procedure TPropertyImageLoader.SetAddImage(const AImagePath: string);
begin
  if InsertImage(AImagePath) then
  begin
    FDQuery.Close;
    FDQuery.Open;
    FDQuery.Last;

    LoadImagesFDQuery;
  end;
end;

function TPropertyImageLoader.SetDelete: Boolean;
var
  LCurrentImageID, LCurrentIndex: Integer;
begin
  Result := False;
  if Assigned(FDQuery) then
  begin
    LCurrentIndex := FDQuery.RecNo;

    LCurrentImageID := FDQuery.FieldByName('IMAGEID').AsInteger;
    DeleteImageByID(LCurrentImageID);

    Result := True;

    FDQuery.Close;
    FDQuery.Open;

    if FDQuery.RecordCount > 0 then
    begin
      if LCurrentIndex > 1 then
        FDQuery.RecNo := LCurrentIndex - 1
      else
        FDQuery.First;

      LoadImagesFDQuery;
    end
    else
    begin
      FLabel.Caption := Format('%d от %d', [FDQuery.RecNo, FDQuery.RecordCount]);
      FImage.Picture.Assign(nil);
    end;
  end;
end;

procedure TPropertyImageLoader.GetImagesFromDatabase;
begin

  try
    with DM do
    begin
      if not FDConnection1.Connected then
        FDConnection1.Connected := True;

      FDQuery.Connection := FDConnection1;

      FDQuery.SQL.Text := 'SELECT IMAGEID, IMAGE FROM PROPERTY_IMAGES WHERE PROPERTYID = :PropertyID';
      FDQuery.ParamByName('PropertyID').AsInteger := FPropertyID;

      FDQuery.Open;
    end;
  except
    on E: Exception do
    begin
      raise Exception.Create('Грешка при зареждане на изображенията за имота: ' + E.Message);
    end;
  end;
end;

function TPropertyImageLoader.GetNext: Boolean;
begin
  Result := False;

  FDQuery.Next;
  if not FDQuery.Eof then
  begin
    LoadImagesFDQuery;
    Result := True;
  end;

end;

function TPropertyImageLoader.GetPrevious: Boolean;
begin
  Result := False;

  FDQuery.Prior;
  if not FDQuery.Bof then
  begin
    LoadImagesFDQuery;
    Result := True;
  end;

end;

procedure TPropertyImageLoader.LoadImagesFDQuery;
var
  BlobStream: TStream;
  ImageFormat: string;
  Graphic: TGraphic;
begin

  if not FDQuery.IsEmpty then
  begin
    BlobStream := FDQuery.CreateBlobStream(FDQuery.FieldByName('IMAGE'), bmRead);
    try
      BlobStream.Position := 0;

      ImageFormat := DetectImageFormat(BlobStream);

      if ImageFormat = 'PNG' then
        Graphic := TPngImage.Create
      else if ImageFormat = 'JPEG' then
        Graphic := TJPEGImage.Create
      else if ImageFormat = 'BMP' then
        Graphic := TBitmap.Create
      else
        raise Exception.Create('Unsupported image format');

      try
        BlobStream.Position := 0;
        Graphic.LoadFromStream(BlobStream);
        FImage.Picture.Assign(Graphic);
      finally
        Graphic.Free;
      end;

    finally

      BlobStream.Free;
    end;
  end;
  FLabel.Caption := Format('%d от %d', [FDQuery.RecNo, FDQuery.RecordCount]);
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

  if (Signature[0] = $89) and (Signature[1] = $50) and (Signature[2] = $4E) and (Signature[3] = $47) then
    Result := 'PNG'
  else if (Signature[0] = $FF) and (Signature[1] = $D8) and (Signature[2] = $FF) then
    Result := 'JPEG'
  else if (Signature[0] = $42) and (Signature[1] = $4D) then
    Result := 'BMP'
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
      DM.FDConnection1.Rollback;
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

       LDQuery := TFDQuery.Create(nil);
      try
        LDQuery.Connection := FDConnection1;
        LDQuery.SQL.Text := 'INSERT INTO PROPERTY_IMAGES (PROPERTYID, IMAGE) ' +
                        'VALUES (:PropertyID, :Image)';

        LDQuery.ParamByName('PropertyID').AsInteger := FPropertyID;

        FileStream := TFileStream.Create(AImagePath, fmOpenRead or fmShareDenyWrite);
        try
          LDQuery.ParamByName('Image').LoadFromStream(FileStream, ftBlob);
        finally
          FileStream.Free;
        end;

        LDQuery.ExecSQL;

        DM.FDConnection1.Commit;
      finally
        FreeAndNil(LDQuery);
        Result := True;
      end;

    end;
  except
    on E: Exception do
    begin
      DM.FDConnection1.Rollback;
      Result := False;
    end;
  end;
end;

end.
