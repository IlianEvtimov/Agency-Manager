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
    procedure Btn_CancelClick(Sender: TObject);
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

procedure TCreate_Clietn_Form.Btn_CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
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
  if not CharInSet(Key, ['0'..'9', ',', #8]) then
  begin
    Key := #0;
  end
  else if (Key = ',') and ((Pos(',', TEdit(Sender).Text) > 0) or (TEdit(Sender).SelStart = 0)) then
  begin
    Key := #0;
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
    ModalResult := mrCancel;
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
  Result := False;

  if Trim(Edt_ClientName.Text) = '' then
  begin
    ShowMessage('Моля, въведете валидно име на клиент.');
    Edt_ClientName.SetFocus;
    Exit;
  end;

  if Trim(Edt_PhoneNumber.Text) = '' then
  begin
    ShowMessage('Моля, въведете валиден телефонен номер.');
    Edt_PhoneNumber.SetFocus;
    Exit;
  end;

  if Cmb_ClientType.Text = '' then
  begin
    ShowMessage('Моля, изберете валиден тип клиент.');
    Cmb_ClientType.SetFocus;
    Exit;
  end;

  if not TryStrToFloat(Edt_Budget.Text, BudgetValue) or (BudgetValue <= 0) then
  begin
    ShowMessage('Моля, въведете валиден бюджет по-голям от нула.');
    Edt_Budget.SetFocus;
    Exit;
  end;

  if Cmb_ClientType.ItemIndex = 0 then
  begin
    if Trim(Edt_PropertyID.Text) = '' then
    begin
      ShowMessage('Моля, въведете валиден идентификатор на имот.');
      Btn_Agent.SetFocus;
      Exit;
    end;
  end
  else
  begin
    FProperty.PropertyID := 0;
  end;

  Result := True;
end;

end.
