unit uPropertyCreate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uAgentClass, uPropertyClass,
  Vcl.ExtCtrls, FireDAC.Comp.Client, FireDAC.Stan.Param;

type
  TProperty_Create_Form = class(TForm)
    Edt_Propery_Type: TEdit;
    Lbl_Type: TLabel;
    Edt_Address: TEdit;
    Lbl_Address: TLabel;
    Edt_Price: TEdit;
    Lbl_Price: TLabel;
    Edt_Area: TEdit;
    Lbl_Area: TLabel;
    Lbl_Description: TLabel;
    Memo_Description: TMemo;
    Btn_Cansel: TButton;
    Btn_Create: TButton;
    Edt_Agent: TEdit;
    Label1: TLabel;
    Btn_Agent: TButton;
    Btn_All_Properties: TButton;
    Image1: TImage;
    Btn_Back: TButton;
    Btn_Next: TButton;
    Lbl_Image_Count: TLabel;
    OpenDialog1: TOpenDialog;
    Btn_Add_Image: TButton;
    Btn_Delete_Image: TButton;
    procedure Btn_AgentClick(Sender: TObject);
    procedure Btn_CreateClick(Sender: TObject);
    procedure Edt_PriceKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Btn_All_PropertiesClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Btn_BackClick(Sender: TObject);
    procedure Btn_NextClick(Sender: TObject);
    procedure Btn_Add_ImageClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_Delete_ImageClick(Sender: TObject);
    procedure Btn_CanselClick(Sender: TObject);
  private
    { Private declarations }
    FAgent : TAgent;
    FImageList : TStringList;
    FCurrentImageIndex : Integer;
    function ValidatePropertyFields: Boolean;
    procedure ClearForm;
  public
    { Public declarations }
  end;
  function CreatePropertyForm: Boolean;
var
  Property_Create_Form: TProperty_Create_Form;

implementation

{$R *.dfm}
   uses
    uAgentManager, uPropertyManager, uPropertyList, uAgentList;
function CreatePropertyForm: Boolean;
begin
  Application.CreateForm(TProperty_Create_Form, Property_Create_Form);
  Result := Property_Create_Form.ShowModal = mrOk;
  Property_Create_Form.Release;
end;

procedure TProperty_Create_Form.Btn_Add_ImageClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    FImageList.Add(OpenDialog1.FileName);
    Image1.Picture.LoadFromFile(OpenDialog1.FileName);
    Lbl_Image_Count.Caption := FImageList.Count.ToString + ' от ' + FImageList.Count.ToString;
    FCurrentImageIndex := FImageList.Count - 1;
  end;
end;

procedure TProperty_Create_Form.Btn_AgentClick(Sender: TObject);
var
  LAgentID : LongInt;
begin
  if CreateGetAgent(LAgentID) then begin
    if Assigned(FAgent) then
      FreeAndNil(FAgent);
    FAgent := GetAgentByID(LAgentID);
    Edt_Agent.Text := FAgent.Name;
  end;
end;

procedure TProperty_Create_Form.Btn_BackClick(Sender: TObject);
begin
  if FCurrentImageIndex <= 0 then
    Exit;

  Dec(FCurrentImageIndex);

  Image1.Picture.LoadFromFile(FImageList[FCurrentImageIndex]);

  Lbl_Image_Count.Caption := Format('%d от %d', [FCurrentImageIndex + 1, FImageList.Count]);
end;

procedure TProperty_Create_Form.Btn_CanselClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TProperty_Create_Form.Btn_CreateClick(Sender: TObject);
var
  LDescription, LAddress, LProperyPype : string;
  LPrice, LArea : Double;
  LProperty : TProperty;
  I: Integer;
begin

  if ValidatePropertyFields then begin
    LProperyPype := Trim(Edt_Propery_Type.Text);
    LAddress     := Trim(Edt_Address.Text);
    LPrice       := StrToFloat(Edt_Price.Text);
    LArea        := StrToFloat(Edt_Area.Text);
    LDescription := Trim(Memo_Description.Text);

    LProperty := TProperty.Create(LProperyPype, LAddress, LPrice, LArea, LDescription, FAgent.AgentID);

    if InsertProperty(LProperty) then
    begin

      for I := 0 to FImageList.Count - 1 do
        AddImageToDatabase(LProperty.PropertyID, FImageList[I]);

      ShowMessage('Имота е добавен успешно!');
      ClearForm;
    end
    else
    begin
      ShowMessage('Нещо се обърка при добавяне на имот!');
    end;

  end;

end;

procedure TProperty_Create_Form.Btn_Delete_ImageClick(Sender: TObject);
begin
  if FCurrentImageIndex >= 0 then
  begin
    FImageList.Delete(FCurrentImageIndex);
    Dec(FCurrentImageIndex);

    if FCurrentImageIndex >= 0 then
      Image1.Picture.LoadFromFile(FImageList[FCurrentImageIndex])
    else
      Image1.Picture := nil;

    Lbl_Image_Count.Caption := Format('%d от %d', [FCurrentImageIndex + 1, FImageList.Count]);
  end;

end;

procedure TProperty_Create_Form.Btn_NextClick(Sender: TObject);
begin
  if FCurrentImageIndex >= FImageList.Count - 1 then
    Exit;

  Inc(FCurrentImageIndex);

  Image1.Picture.LoadFromFile(FImageList[FCurrentImageIndex]);

  Lbl_Image_Count.Caption := Format('%d от %d', [FCurrentImageIndex + 1, FImageList.Count]);
end;

procedure TProperty_Create_Form.Btn_All_PropertiesClick(Sender: TObject);
begin
  CreatePropertyListForm;
end;

procedure TProperty_Create_Form.ClearForm;
begin
  Edt_Propery_Type.Text := '';
  Edt_Address.Text      := '';
  Edt_Price.Text        := '';
  Edt_Area.Text         := '';
  Memo_Description.Text := '';
  Image1.Picture := nil;

end;

function TProperty_Create_Form.ValidatePropertyFields: Boolean;
var
  LPropertyType, LAddress, LDescription: string;
  PriceValue, AreaValue: Double;
begin
  Result := True;

  LPropertyType := Trim(Edt_Propery_Type.Text);
  if LPropertyType = EmptyStr then
  begin
    ShowMessage('Please enter a Property Type.');
    Result := False;
    Edt_Propery_Type.SetFocus;
    Exit;
  end;

  LAddress := Trim(Edt_Address.Text);
  if LAddress = EmptyStr then
  begin
    ShowMessage('Please enter an Address.');
    Result := False;
    Edt_Address.SetFocus;
    Exit;
  end;

  if not TryStrToFloat(Edt_Price.Text, PriceValue) or (PriceValue <= 0) then
  begin
    ShowMessage('Please enter a valid Price greater than zero.');
    Result := False;
    Edt_Price.SetFocus;
    Exit;
  end;

  if not TryStrToFloat(Edt_Area.Text, AreaValue) or (AreaValue <= 0) then
  begin
    ShowMessage('Please enter a valid Area greater than zero.');
    Result := False;
    Edt_Area.SetFocus;
    Exit;
  end;

  LDescription := Trim(Memo_Description.Text);
  if LDescription = EmptyStr then
  begin
    ShowMessage('Please enter a Description.');
    Result := False;
    Memo_Description.SetFocus;
    Exit;
  end;

  if not Assigned(FAgent) then begin
    ShowMessage('Please choose an Agent.');
    Btn_Agent.SetFocus;
    Result := False;
    Exit;
  end;
end;

procedure TProperty_Create_Form.Edt_PriceKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', ',', #8]) then
  begin
    Key := #0;
  end
  else if (Key = ',') and ((Pos(',', TEdit(Sender).Text) > 0) or (TEdit(Sender).SelStart = 0)) then
  begin
    Key := #0;
  end;
end;

procedure TProperty_Create_Form.FormDestroy(Sender: TObject);
begin

  if Assigned(FImageList) then
    FreeAndNil(FImageList);

  if Assigned(FAgent) then
    FreeAndNil(FAgent);
end;

procedure TProperty_Create_Form.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    ModalResult := mrCancel;
  end;
end;
procedure TProperty_Create_Form.FormShow(Sender: TObject);
begin
  OpenDialog1.Filter := 'Image Files|*.jpg;*.jpeg;*.png;*.bmp|JPEG Files|*.jpg;*.jpeg|PNG Files|*.png|Bitmap Files|*.bmp';
  OpenDialog1.FilterIndex := 3;
  Btn_Add_Image.Caption := #$1F4F7 + ' Add Photo';
  FImageList := TStringList.Create;
  FCurrentImageIndex := -1;
  Lbl_Image_Count.Caption := Format('%d от %d', [FCurrentImageIndex + 1, FImageList.Count]);
end;

end.
