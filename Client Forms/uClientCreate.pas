unit uClientCreate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uPropertyClass;

type
  TCreate_Clietn_Form = class(TForm)
    Edt_PhoneNumber: TEdit;
    Label3: TLabel;
    Label2: TLabel;
    Edt_ClientName: TEdit;
    Label1: TLabel;
    Btn_Add: TButton;
    Btn_Cancel: TButton;
    Button3: TButton;
    Cmb_ClientType: TComboBox;
    Edt_Budget: TEdit;
    Label4: TLabel;
    Edt_PropertyID: TEdit;
    Lbl_Owner: TLabel;
    Btn_Agent: TButton;
    procedure Btn_AgentClick(Sender: TObject);
    procedure Edt_BudgetKeyPress(Sender: TObject; var Key: Char);
    procedure Btn_AddClick(Sender: TObject);
    procedure Cmb_ClientTypeChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    FProperty: TProperty;
    function ValidatePropertyFields: Boolean;
    procedure ClearForm;
  public
    { Public declarations }
  end;
  function CreateClientForm: Boolean;
var
  Create_Clietn_Form: TCreate_Clietn_Form;

implementation

{$R *.dfm}
  uses
    uPropertyList, uPropertyManager, uClientClass, uClientManager, uClientList;

function CreateClientForm: Boolean;
begin
  Application.CreateForm(TCreate_Clietn_Form, Create_Clietn_Form);
  Result := Create_Clietn_Form.ShowModal = mrOk;
  Create_Clietn_Form.Release;
end;

procedure TCreate_Clietn_Form.Btn_AddClick(Sender: TObject);
var
  LClient: TClient;
begin
  if ValidatePropertyFields then
  begin


    LClient := TClient.Create(
      Edt_ClientName.Text,
      Edt_PhoneNumber.Text,
      Cmb_ClientType.ItemIndex,
      StrToFloat(Edt_Budget.Text),
      FProperty.PropertyID
    );


    if InsertClient(LClient) then
     ShowMessage('Клиента е добавен успешно!');

    ClearForm;
  end;

end;

procedure TCreate_Clietn_Form.Btn_AgentClick(Sender: TObject);
var
  LPorpertyID: LongInt;
begin
  if CreateGetPropertyListForm(LPorpertyID) then
  begin
    if Assigned(FProperty) then
      FreeAndNil(FProperty);

    FProperty := GetPropertyByID(LPorpertyID);
    Edt_PropertyID.Text := FProperty.Address;
  end;
end;

procedure TCreate_Clietn_Form.Button3Click(Sender: TObject);
begin
  CreateClientListForm;
end;

procedure TCreate_Clietn_Form.ClearForm;
begin
  Edt_ClientName.Text  := '';
  Edt_Budget.Text      := '';
  Edt_PropertyID.Text  := '';
  Edt_PhoneNumber.Text := '';
  Cmb_ClientType.ItemIndex := -1;
  Cmb_ClientTypeChange(nil);
end;

procedure TCreate_Clietn_Form.Cmb_ClientTypeChange(Sender: TObject);
begin
  if Cmb_ClientType.ItemIndex = 0 then
  begin
    Edt_PropertyID.Visible := True;
    Btn_Agent.Visible      := True;
    Lbl_Owner.Visible      := True;
  end
  else
  begin
    Edt_PropertyID.Visible := False;
    Btn_Agent.Visible      := False;
    Lbl_Owner.Visible      := False;
  end;
end;

procedure TCreate_Clietn_Form.Edt_BudgetKeyPress(Sender: TObject;
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

procedure TCreate_Clietn_Form.FormDestroy(Sender: TObject);
begin
  if Assigned(FProperty) then
    FreeAndNil(FProperty);
end;

procedure TCreate_Clietn_Form.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    ModalResult := mrCancel;  // Затваря формата със стойност mrCancel
  end;
end;

procedure TCreate_Clietn_Form.FormShow(Sender: TObject);
begin
  FProperty := TProperty.Create;
end;

function TCreate_Clietn_Form.ValidatePropertyFields: Boolean;
var
  BudgetValue: Double;
begin
  Result := False;  // По подразбиране е неуспешно

  // Проверка за Име на Клиента
  if Trim(Edt_ClientName.Text) = '' then
  begin
    ShowMessage('Please enter a valid Client Name.');
    Edt_ClientName.SetFocus;
    Exit;
  end;

  // Проверка за Телефонен номер
  if Trim(Edt_PhoneNumber.Text) = '' then
  begin
    ShowMessage('Please enter a valid Phone Number.');
    Edt_PhoneNumber.SetFocus;
    Exit;
  end;

  // Проверка за Тип (предполага се, че трябва да бъде избран елемент)
  if Cmb_ClientType.Text = '' then
  begin
    ShowMessage('Please select a valid Client Type.');
    Cmb_ClientType.SetFocus;
    Exit;
  end;

  // Проверка за валидност на Бюджет
  if not TryStrToFloat(Edt_Budget.Text, BudgetValue) or (BudgetValue <= 0) then
  begin
    ShowMessage('Please enter a valid Budget greater than zero.');
    Edt_Budget.SetFocus;
    Exit;
  end;

  if Cmb_ClientType.ItemIndex = 0 then
  begin
    // Проверка за Собственост (Property ID)
    if Trim(Edt_PropertyID.Text) = '' then
    begin
      ShowMessage('Please enter a valid Property ID.');
      Btn_Agent.SetFocus;
      Exit;
    end;
  end
  else
  begin
    FProperty.PropertyID := 0;
  end;

  // Ако всички проверки са преминали
  Result := True;
end;

end.
