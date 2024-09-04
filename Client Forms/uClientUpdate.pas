unit uClientUpdate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uClientClass, Vcl.StdCtrls, uPropertyClass;

type
  TClient_Update_Form = class(TForm)
    Edt_PhoneNumber: TEdit;
    Label3: TLabel;
    Label2: TLabel;
    Edt_ClientName: TEdit;
    Label1: TLabel;
    Btn_Add: TButton;
    Btn_Cancel: TButton;
    Cmb_ClientType: TComboBox;
    Edt_Budget: TEdit;
    Label4: TLabel;
    Edt_PropertyID: TEdit;
    Lbl_Owner: TLabel;
    Btn_Agent: TButton;
    procedure Cmb_ClientTypeChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Btn_AgentClick(Sender: TObject);
    procedure Btn_AddClick(Sender: TObject);
    procedure Btn_CancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FProperty : TProperty;
    FClient   : TClient;
    procedure DisplayData;
    procedure GetData(var AClient: TClient);
  public
    { Public declarations }
  end;
  function CreateClientUpdateForm(var AClient: TClient): Boolean;
var
  Client_Update_Form: TClient_Update_Form;

implementation

{$R *.dfm}
   uses
    uPropertyManager, uClientManager, uPropertyList;

function CreateClientUpdateForm(var AClient: TClient): Boolean;
begin
  Application.CreateForm(TClient_Update_Form, Client_Update_Form);
  Client_Update_Form.FClient   := AClient;
  Client_Update_Form.FProperty := GetPropertyByID(AClient.PropertyID);
  Result := Client_Update_Form.ShowModal = mrOk;

  if Result then
  begin
    Client_Update_Form.GetData(AClient);
    UpdateClient(AClient);
  end;

  Client_Update_Form.Release;
end;

{ TClient_Update_Form }

procedure TClient_Update_Form.Btn_AddClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TClient_Update_Form.Btn_AgentClick(Sender: TObject);
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

procedure TClient_Update_Form.Btn_CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TClient_Update_Form.Cmb_ClientTypeChange(Sender: TObject);
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

procedure TClient_Update_Form.DisplayData;
begin
  Edt_ClientName.Text  := FClient.Name;
  Edt_Budget.Text      := FormatFloat('0.00', FClient.Budget);
  Edt_PropertyID.Text  := IntToStr(FClient.PropertyID);
  Edt_PhoneNumber.Text := FClient.PhoneNumber;
  Cmb_ClientType.ItemIndex := FClient.ClientType;
  Cmb_ClientTypeChange(nil);
end;

procedure TClient_Update_Form.FormDestroy(Sender: TObject);
begin
  if Assigned(FProperty) then
    FreeAndNil(FProperty);
end;

procedure TClient_Update_Form.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    ModalResult := mrCancel;  // Затваря формата със стойност mrCancel
  end;
end;

procedure TClient_Update_Form.FormShow(Sender: TObject);
begin
  DisplayData;
end;

procedure TClient_Update_Form.GetData(var AClient: TClient);
begin
  AClient.ClientID    := FClient.ClientID;
  AClient.Name        := Edt_ClientName.Text;
  AClient.Budget      := StrToFloat(Edt_Budget.Text);
  AClient.PhoneNumber := Edt_PhoneNumber.Text;
  AClient.ClientType  := Cmb_ClientType.ItemIndex;
  AClient.PropertyID  := FProperty.PropertyID;
end;
end.
