unit uAgencyList;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Menus, System.UITypes, uAgencyClasses;
type
  TAgency_List_Form = class(TForm)
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    Update: TMenuItem;
    Delete: TMenuItem;
    Enter: TMenuItem;
    procedure UpdateClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EnterClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FIsCalledFromAgencyFrom: Boolean;
    function GetAgencyID: LongInt;
  end;
  function CreateAgencyListForm: Boolean;
  function CreateGetAgency(var AAgencyID: LongInt): Boolean;
  procedure SetAgentSettings;
var
  Agency_List_Form: TAgency_List_Form;
implementation
{$R *.dfm}
uses
  uDB, uAgencyUpdate, uAgencyManager;
function CreateAgencyListForm: Boolean;
begin
  Application.CreateForm(TAgency_List_Form, Agency_List_Form);
  Agency_List_Form.FIsCalledFromAgencyFrom := True;
  Result := Agency_List_Form.ShowModal = mrOk;
  Agency_List_Form.Release;
end;
function CreateGetAgency(var AAgencyID: LongInt): Boolean;
begin
  Application.CreateForm(TAgency_List_Form, Agency_List_Form);
  SetAgentSettings;
  Result := Agency_List_Form.ShowModal = mrOk;
  if Result then
    AAgencyID := Agency_List_Form.GetAgencyID;
end;
procedure SetAgentSettings;
begin
  Agency_List_Form.FIsCalledFromAgencyFrom := False;
  Agency_List_Form.ListView1.MultiSelect := False;
end;
procedure TAgency_List_Form.DeleteClick(Sender: TObject);
var
  ListItem: TListItem;
  LAgency: TAgency;
  i: Integer;
  UserResponse: Integer;
begin
  // If no items are selected
  if ListView1.SelCount = 0 then
  begin
    ShowMessage('Няма избрани елементи за изтриване.');
    Exit;
  end;
  // Display confirmation dialog
  UserResponse := MessageDlg('Наистина ли искате да изтриете избрания запис?', mtConfirmation, [mbYes, mbNo], 0);
  if UserResponse = mrNo then
    Exit;
  // Iterate backward through all items
  for i := ListView1.Items.Count - 1 downto 0 do
  begin
    ListItem := ListView1.Items[i];
    // Check if the item is selected
    if ListItem.Selected then
    begin
      // Free the memory for the object associated with this item
      LAgency := TAgency(ListItem.Data);
      if Assigned(LAgency) then
      begin
        DeleteAgency(LAgency); // Delete the record from the database (if needed)
        FreeAndNil(LAgency);
      end;
      // Delete the selected item from ListView
      ListItem.Delete;
    end;
  end;
end;
procedure TAgency_List_Form.EnterClick(Sender: TObject);
begin
  ListView1DblClick(nil);
end;
procedure TAgency_List_Form.FormDestroy(Sender: TObject);
var
  i: Integer;
  LAgency: TAgency;
begin
  for i := 0 to ListView1.Items.Count - 1 do
  begin
    LAgency := TAgency(ListView1.Items[i].Data);
    LAgency.Free; // Free the memory for each object
  end;
end;
procedure TAgency_List_Form.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    ModalResult := mrCancel;  // Closes the form with a mrCancel result
  end;
end;
procedure TAgency_List_Form.FormShow(Sender: TObject);
begin
  LoadAllAgencies(ListView1);
end;
function TAgency_List_Form.GetAgencyID: LongInt;
var
  ListItem: TListItem;
  LAgency: TAgency;
begin
  Result := -1;
  // Get the selected item
  ListItem := ListView1.Selected;
  LAgency := TAgency(ListItem.Data);
  if Assigned(LAgency) then
  begin
    // Opens the update form and updates the object if changes are confirmed
    Result := LAgency.ID;
  end;
end;
procedure TAgency_List_Form.ListView1DblClick(Sender: TObject);
begin
  // If no items are selected
  if ListView1.SelCount = 0 then
  begin
    ShowMessage('Няма избрани елементи за актуализиране.');
    Exit;  // Add Exit here
  end;
  if FIsCalledFromAgencyFrom then
    UpdateClick(Sender)
  else
    ModalResult := mrOk;
end;
procedure TAgency_List_Form.UpdateClick(Sender: TObject);
var
  ListItem: TListItem;
  LAgency: TAgency;
begin
  // Get the selected item
  ListItem := ListView1.Selected;
  LAgency := TAgency(ListItem.Data);
  if Assigned(LAgency) then
  begin
    // Opens the update form and updates the object if changes are confirmed
    if CreateAgencyUpdateForm(LAgency) then
    begin
      // Update ListItem values
      ListItem.Caption := IntToStr(LAgency.ID);
      ListItem.SubItems[0] := LAgency.Name;
      ListItem.SubItems[1] := LAgency.Address;
      ListItem.SubItems[2] := LAgency.PhoneNumber;
      ListItem.Data := LAgency; // Update the data
    end;
  end;
end;
end.

