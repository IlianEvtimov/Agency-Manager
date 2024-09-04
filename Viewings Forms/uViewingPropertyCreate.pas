unit uViewingPropertyCreate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TViewing_Crete_Form = class(TForm)
    ListView1: TListView;
    Panel1: TPanel;
    Edt_PropertyID: TEdit;
    Lbl_Owner: TLabel;
    Edt_Budget: TEdit;
    Label4: TLabel;
    Cmb_ClientType: TComboBox;
    Label2: TLabel;
    Edt_PhoneNumber: TEdit;
    Label3: TLabel;
    Edt_ClientName: TEdit;
    Label1: TLabel;
    Btn_Client_Choose: TButton;
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Btn_Client_ChooseClick(Sender: TObject);
    procedure Cmb_ClientTypeChange(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
  private
    { Private declarations }
    FClientID: LongInt;
  public
    { Public declarations }
  end;
  function CreateViewingForm: Boolean;
var
  Viewing_Crete_Form: TViewing_Crete_Form;

implementation

{$R *.dfm}
  uses
    uPropertyClass, uPropertyManager, uViewingClients, uClientClass, uClientManager, uViewingsProperty, uViewingsManager;

function CreateViewingForm: Boolean;
begin
  Application.CreateForm(TViewing_Crete_Form, Viewing_Crete_Form);
  Result := Viewing_Crete_Form.ShowModal = mrOk;
  Viewing_Crete_Form.Release;
end;

procedure TViewing_Crete_Form.Btn_Client_ChooseClick(Sender: TObject);
var
  AClient: TClient;
begin
  if CreateClientListForm(FClientID) then
  begin
    AClient := GetClientByID(FClientID);

    Edt_ClientName.Text  := AClient.Name;
    Edt_Budget.Text      := FormatFloat('0.00', AClient.Budget);
    Edt_PropertyID.Text  := IntToStr(AClient.PropertyID);
    Edt_PhoneNumber.Text := AClient.PhoneNumber;
    Cmb_ClientType.ItemIndex := AClient.ClientType;
    Cmb_ClientTypeChange(nil);

    if Assigned(AClient) then
      FreeAndNil(AClient);
  end;
end;

procedure TViewing_Crete_Form.Cmb_ClientTypeChange(Sender: TObject);
begin
  if Cmb_ClientType.ItemIndex = 0 then
  begin
    Edt_PropertyID.Visible := True;
    Lbl_Owner.Visible      := True;
  end
  else
  begin
    Edt_PropertyID.Visible := False;
    Lbl_Owner.Visible      := False;
  end;
end;

procedure TViewing_Crete_Form.FormDestroy(Sender: TObject);
var
  i: Integer;
  LProperty : TProperty;
begin
  for i := 0 to ListView1.Items.Count - 1 do
  begin
    LProperty := TProperty(ListView1.Items[i].Data);
    FreeAndNil(LProperty)
  end;
end;

procedure TViewing_Crete_Form.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    ModalResult := mrCancel;  // Затваря формата със стойност mrCancel
  end;
end;

procedure TViewing_Crete_Form.FormShow(Sender: TObject);
begin
  LoadAllProperties(ListView1);
  FClientID := -1;
end;

procedure TViewing_Crete_Form.ListView1DblClick(Sender: TObject);
var
  ListItem: TListItem;
  LProperty: TProperty;
begin
  if FClientID = -1 then
  begin
    ShowMessage('Не сте избрали клиент!');
    Exit;
  end;

  // Ако няма избрани елементи
  if ListView1.SelCount = 0 then
  begin
    ShowMessage('Няма избрани елементи за актуализиране.');
    Exit;  // Добавяне на Exit тук
  end;

  // Вземи избрания елемент
  ListItem := ListView1.Selected;
  LProperty := TProperty(ListItem.Data);

  if GetViewingCount(FClientID, LProperty.PropertyID) > 3 then
  begin
    ShowMessage('Достигнахте максимален брой прегледи!');
    Exit;
  end;

  if Assigned(LProperty) then
  begin
    CreateViewingsPropertyForm(LProperty);
    InsertViewing(LProperty.PropertyID, LProperty.AgentID, FClientID, now);
  end;
end;

end.
