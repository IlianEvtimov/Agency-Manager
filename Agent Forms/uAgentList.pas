unit uAgentList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Menus, System.UITypes, uAgentClass;

type
  TAgent_List_Form = class(TForm)
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
    FIsCalledFromAgentFrom : Boolean;
    function GetAgency: LongInt;
  end;
  function CreateAgentListForm: Boolean;
  function CreateGetAgent(var AAgencyID: LongInt) : Boolean;
  procedure SetAgentSettings;
var
  Agent_List_Form: TAgent_List_Form;

implementation

{$R *.dfm}
   uses
    uDB, uAgencyUpdate, uAgencyManager, uAgentUpdate, uAgentManager, uAgencyClasses;

function CreateAgentListForm: Boolean;
begin
  Application.CreateForm(TAgent_List_Form, Agent_List_Form);
  Agent_List_Form.FIsCalledFromAgentFrom := True;
  Result := Agent_List_Form.ShowModal = mrOk;
  Agent_List_Form.Release;
end;

function CreateGetAgent(var AAgencyID: LongInt) : Boolean;
begin
  Application.CreateForm(TAgent_List_Form, Agent_List_Form);
  SetAgentSettings;
  Result := Agent_List_Form.ShowModal = mrOk;
  if Result then
    AAgencyID := Agent_List_Form.GetAgency; // Procedure
end;

procedure SetAgentSettings;
begin
  Agent_List_Form.FIsCalledFromAgentFrom := False;
  Agent_List_Form.ListView1.MultiSelect := False;
end;

procedure TAgent_List_Form.DeleteClick(Sender: TObject);
var
  ListItem: TListItem;
  LAgent: TAgent;
  i: Integer;
  UserResponse: Integer;
begin
  // If no items are selected
  if ListView1.SelCount = 0 then
  begin
    ShowMessage('No items selected for deletion.');
    Exit;
  end;

  // Show confirmation dialog
  UserResponse := MessageDlg('Are you sure you want to delete the selected record?', mtConfirmation, [mbYes, mbNo], 0);
  if UserResponse = mrNo then
    Exit;

  // Iterate backwards through all items
  for i := ListView1.Items.Count - 1 downto 0 do
  begin
    ListItem := ListView1.Items[i];

    // Check if the item is selected
    if ListItem.Selected then
    begin
      // Free the memory for the object associated with this item
      LAgent := TAgent(ListItem.Data);
      if Assigned(LAgent) then
      begin
        DeleteAgent(LAgent.AgentID); // Delete record from the database (if needed)
        FreeAndNil(LAgent);          // Free memory
      end;

      // Delete the selected item from ListView
      ListItem.Delete;
    end;
  end;

end;

procedure TAgent_List_Form.EnterClick(Sender: TObject);
begin
  ListView1DblClick(nil); // Procedure
end;

procedure TAgent_List_Form.FormDestroy(Sender: TObject);
var
  i: Integer;
  LAgent : TAgent;
begin
  for i := 0 to ListView1.Items.Count - 1 do
  begin
    LAgent := TAgent(ListView1.Items[i].Data);
    FreeAndNil(LAgent);
  end;
end;

procedure TAgent_List_Form.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    ModalResult := mrCancel;  // Close the form with mrCancel result
  end;
end;

procedure TAgent_List_Form.FormShow(Sender: TObject);
begin
  LoadAllAgents(ListView1); // Procedure
end;

function TAgent_List_Form.GetAgency: LongInt;
var
  ListItem: TListItem;
  LAgent: TAgent;
begin
  Result := -1;
  // Get the selected item
  ListItem := ListView1.Selected;
  LAgent := TAgent(ListItem.Data);

  if Assigned(LAgent) then
  begin
    Result := LAgent.AgentID;
  end;
end;

procedure TAgent_List_Form.ListView1DblClick(Sender: TObject);
begin
  // If no items are selected
  if ListView1.SelCount = 0 then
  begin
    ShowMessage('No items selected for updating.');
    Exit;  // Add Exit here
  end;

  if FIsCalledFromAgentFrom then
    UpdateClick(Sender)
  else begin
    ModalResult := mrOk;
  end;

end;

procedure TAgent_List_Form.UpdateClick(Sender: TObject);
var
  ListItem: TListItem;
  LAgent: TAgent;
  LAgency : TAgency;
begin

  // Get the selected item
  ListItem := ListView1.Selected;

  LAgent := TAgent(ListItem.Data);

  if Assigned(LAgent) then
  begin
    // Open update form and refresh the object if changes are confirmed
    if CreateAgentUpdateForm(LAgent) then
    begin
      // Update ListItem values
      ListItem.Caption := IntToStr(LAgent.AgentID);
      ListItem.SubItems[0] := LAgent.Name;
      ListItem.SubItems[1] := LAgent.PhoneNumber;
      LAgency := GetAgencyByID(LAgent.AgencyID);
      ListItem.SubItems[2] := (LAgency.Name);
      FreeAndNil(LAgency);
      ListItem.Data := LAgent; // Update data
    end;
  end;
end;

end.
