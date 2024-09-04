unit uPropertyUpdate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uPropertyClass, uAgentClass, uPropertyImageClass,
  Vcl.ExtCtrls, FireDAC.Comp.Client, FireDAC.Stan.Param;

type
  TProperty_Update_Form = class(TForm)
    Btn_Cansel: TButton;
    Btn_Create: TButton;
    Memo_Description: TMemo;
    Edt_Agent: TEdit;
    Btn_Agent: TButton;
    Edt_Area: TEdit;
    Edt_Price: TEdit;
    Edt_Address: TEdit;
    Edt_Propery_Type: TEdit;
    Lbl_Description: TLabel;
    Label1: TLabel;
    Lbl_Area: TLabel;
    Lbl_Price: TLabel;
    Lbl_Address: TLabel;
    Lbl_Type: TLabel;
    Image1: TImage;
    Btn_Back: TButton;
    Lbl_Image_Count: TLabel;
    Btn_Next: TButton;
    Btn_Add_Image: TButton;
    Btn_Delete: TButton;
    OpenDialog1: TOpenDialog;
    procedure FormShow(Sender: TObject);
    procedure Btn_AgentClick(Sender: TObject);
    procedure Btn_CreateClick(Sender: TObject);
    procedure Btn_CanselClick(Sender: TObject);
    procedure Edt_AreaKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Btn_BackClick(Sender: TObject);
    procedure Btn_NextClick(Sender: TObject);
    procedure Btn_DeleteClick(Sender: TObject);
    procedure Btn_Add_ImageClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    { Private declarations }
    FProperty : TProperty;
    FAgent : TAgent;
    FPropertyImageLoader : TPropertyImageLoader;
    procedure DisplayData;
    function ValidatePropertyFields: Boolean;
    procedure GetData(var AProperty: TProperty);
  public
    { Public declarations }
  end;
  function CreateUpdateForm(var AProperty: TProperty): Boolean;

var
  Property_Update_Form: TProperty_Update_Form;

implementation

{$R *.dfm}
  uses
    uAgentManager, uAgentList, uPropertyManager;

function CreateUpdateForm(var AProperty: TProperty): Boolean;
begin
  Application.CreateForm(TProperty_Update_Form, Property_Update_Form);
  Property_Update_Form.FProperty := AProperty;
  Property_Update_Form.FAgent    := GetAgentByID(AProperty.AgentID);
  Result := Property_Update_Form.ShowModal = mrOk;

  if Result then
  begin
    Property_Update_Form.GetData(AProperty);
    UpdateProperty(AProperty);
  end;

  Property_Update_Form.Release;
end;

procedure TProperty_Update_Form.Btn_AgentClick(Sender: TObject);
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

procedure TProperty_Update_Form.Btn_BackClick(Sender: TObject);
begin
  FPropertyImageLoader.Previous;
end;

procedure TProperty_Update_Form.Btn_CanselClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TProperty_Update_Form.Btn_CreateClick(Sender: TObject);
begin
  if ValidatePropertyFields then
  begin
    ModalResult := mrOk;
  end;
end;

procedure TProperty_Update_Form.Btn_NextClick(Sender: TObject);
begin
  FPropertyImageLoader.Next;
end;

procedure TProperty_Update_Form.Btn_DeleteClick(Sender: TObject);
begin
  FPropertyImageLoader.Delete;
end;

procedure TProperty_Update_Form.Btn_Add_ImageClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    FPropertyImageLoader.AddImage := OpenDialog1.FileName;
  end;

end;

procedure TProperty_Update_Form.DisplayData;
begin
  Edt_Propery_Type.Text := FProperty.PropertyType;
  Edt_Address.Text      := FProperty.Address;
  Edt_Price.Text        := FormatFloat('0.00', FProperty.Price);
  Edt_Area.Text         := FormatFloat('0.00', FProperty.Area);
  Memo_Description.Text := FProperty.Description;
  Edt_Agent.Text        := FAgent.Name;

  FPropertyImageLoader := TPropertyImageLoader.Create(FProperty.PropertyID, Image1, Lbl_Image_Count);
  FPropertyImageLoader.LoadImage;
end;

procedure TProperty_Update_Form.Edt_AreaKeyPress(Sender: TObject;
  var Key: Char);
begin
  // Проверка дали въведеното е число, десетична запетая или клавиша Backspace
  if not CharInSet(Key, ['0'..'9', ',', #8]) then
  begin
    Key := #0; // Отхвърли клавиша
  end
  // Проверка дали десетичната запетая вече съществува или се опитва да бъде първият символ
  else if (Key = ',') and ((Pos(',', TEdit(Sender).Text) > 0) or (TEdit(Sender).SelStart = 0)) then
  begin
    Key := #0; // Отхвърли клавиша, ако вече има запетая или е първи символ
  end;
end;

procedure TProperty_Update_Form.FormDestroy(Sender: TObject);
begin
  if Assigned(FPropertyImageLoader) then
    FreeAndNil(FPropertyImageLoader);

//  if Assigned(FProperty) then  // Освобождава се в UpropertyList формата
//    FreeAndNil(FProperty);

  if Assigned(FAgent) then
    FreeAndNil(FAgent);
end;

procedure TProperty_Update_Form.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    ModalResult := mrCancel;  // Затваря формата със стойност mrCancel
  end;
end;

procedure TProperty_Update_Form.FormShow(Sender: TObject);
begin
  //
  DisplayData;
  Btn_Add_Image.Caption := #$1F4F7 + ' Add Photo';  // Използване на символ за камера
  OpenDialog1.Filter := 'Image Files|*.jpg;*.jpeg;*.png;*.bmp|JPEG Files|*.jpg;*.jpeg|PNG Files|*.png|Bitmap Files|*.bmp';
  OpenDialog1.FilterIndex := 3;
end;

procedure TProperty_Update_Form.GetData(var AProperty: TProperty);
begin
  AProperty.PropertyType := Edt_Propery_Type.Text;
  AProperty.Address      := Edt_Address.Text;
  AProperty.Price        := StrToFloat(Edt_Price.Text);
  AProperty.Area         := StrToFloat(Edt_Area.Text);
  AProperty.Description  := Memo_Description.Text;
  AProperty.AgentID      := Property_Update_Form.FAgent.AgentID;
end;

function TProperty_Update_Form.ValidatePropertyFields: Boolean;
var
  LPropertyType, LAddress, LDescription: string;
  PriceValue, AreaValue: Double;
begin
  Result := True; // Предполагаме, че всички полета са валидни, докато не се докаже противното

  // Проверка на Property Type
  LPropertyType := Trim(Edt_Propery_Type.Text);
  if LPropertyType = EmptyStr then
  begin
    ShowMessage('Please enter a Property Type.');
    Result := False;
    Edt_Propery_Type.SetFocus;
    Exit;
  end;

  // Проверка на Address
  LAddress := Trim(Edt_Address.Text);
  if LAddress = EmptyStr then
  begin
    ShowMessage('Please enter an Address.');
    Result := False;
    Edt_Address.SetFocus;
    Exit;
  end;

  // Проверка за валидност на Price
  if not TryStrToFloat(Edt_Price.Text, PriceValue) or (PriceValue <= 0) then
  begin
    ShowMessage('Please enter a valid Price greater than zero.');
    Result := False;
    Edt_Price.SetFocus;
    Exit;
  end;

  // Проверка за валидност на Area
  if not TryStrToFloat(Edt_Area.Text, AreaValue) or (AreaValue <= 0) then
  begin
    ShowMessage('Please enter a valid Area greater than zero.');
    Result := False;
    Edt_Area.SetFocus;
    Exit;
  end;

  // Проверка на Description
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

end.


