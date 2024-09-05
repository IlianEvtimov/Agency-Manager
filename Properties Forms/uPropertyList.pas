unit uPropertyList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Menus, System.UITypes, uPropertyClass,
  Vcl.StdCtrls;

type
  TProperty_List_Form = class(TForm)
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
    FIsCalledFromClientFrom : Boolean;
    function GetPropertyID: LongInt;
  end;
  function CreatePropertyListForm: Boolean;
  function CreateGetPropertyListForm(var APropertyID: LongInt) : Boolean;
  procedure SetAgentSettings;
var
  Property_List_Form: TProperty_List_Form;

implementation

{$R *.dfm}
   uses
    uDB, uAgencyManager, uPropertyManager, uPropertyUpdate;

function CreatePropertyListForm: Boolean;
begin
  Application.CreateForm(TProperty_List_Form, Property_List_Form);
  Property_List_Form.FIsCalledFromClientFrom := False;
  Result := Property_List_Form.ShowModal = mrOk;
  Property_List_Form.Release;
end;

function CreateGetPropertyListForm(var APropertyID: LongInt) : Boolean;
begin
  Application.CreateForm(TProperty_List_Form, Property_List_Form);
  SetAgentSettings;
  Result := Property_List_Form.ShowModal = mrOk;
  if Result then
    APropertyID := Property_List_Form.GetPropertyID;
end;

procedure SetAgentSettings;
begin
  Property_List_Form.FIsCalledFromClientFrom := True;
  Property_List_Form.ListView1.MultiSelect := False;
end;

procedure TProperty_List_Form.DeleteClick(Sender: TObject);
var
  ListItem: TListItem;
  LProperty: TProperty;
  i: Integer;
  UserResponse: Integer;
begin
  if ListView1.SelCount = 0 then
  begin
    ShowMessage('Няма избрани елементи за изтриване.');
    Exit;
  end;

  UserResponse := MessageDlg('Наистина ли искате да изтриете избрания запис?', mtConfirmation, [mbYes, mbNo], 0);
  if UserResponse = mrNo then
    Exit;

  for i := ListView1.Items.Count - 1 downto 0 do
  begin
    ListItem := ListView1.Items[i];

    if ListItem.Selected then
    begin
      LProperty := TProperty(ListItem.Data);
      if Assigned(LProperty) then
      begin
        DeleteProperty(LProperty);
        LProperty.Free;
        ListItem.Data := nil;
      end;

      ListItem.Delete;
    end;
  end;
end;

procedure TProperty_List_Form.EnterClick(Sender: TObject);
begin
  ListView1DblClick(nil);
end;

procedure TProperty_List_Form.FormDestroy(Sender: TObject);
var
  i: Integer;
  LProperty : TProperty;
begin
  for i := 0 to ListView1.Items.Count - 1 do
  begin
    LProperty := TProperty(ListView1.Items[i].Data);
    LProperty.Free;
  end;
end;

procedure TProperty_List_Form.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    ModalResult := mrCancel;
  end;
end;

procedure TProperty_List_Form.FormShow(Sender: TObject);
begin
  if FIsCalledFromClientFrom then
    LoadAllPropertiesWithNoClients(ListView1)
  else
    LoadAllProperties(ListView1);
end;

function TProperty_List_Form.GetPropertyID: LongInt;
var
  ListItem: TListItem;
  LProperty: TProperty;
begin
  Result := -1;

  ListItem := ListView1.Selected;
  LProperty := TProperty(ListItem.Data);

  if Assigned(LProperty) then
  begin

    Result := LProperty.PropertyID;
  end;
end;

procedure TProperty_List_Form.ListView1DblClick(Sender: TObject);
begin
  if ListView1.SelCount = 0 then
  begin
    ShowMessage('Няма избрани елементи за актуализиране.');
    Exit;
  end;

  if FIsCalledFromClientFrom then
    ModalResult := mrOk
  else
    UpdateClick(Sender);
end;

procedure TProperty_List_Form.UpdateClick(Sender: TObject);
var
  ListItem: TListItem;
  LProperty: TProperty;
begin

  ListItem := ListView1.Selected;

  LProperty := TProperty(ListItem.Data);

  if Assigned(LProperty) then
  begin
    if CreateUpdateForm(LProperty) then
    begin

      ListItem.Caption := IntToStr(LProperty.PropertyID);
      ListItem.SubItems[0] := LProperty.PropertyType;
      ListItem.SubItems[1] := LProperty.Address;

      ListItem.SubItems[2] := FormatFloat('0.00', LProperty.Price);
      ListItem.SubItems[3] := FormatFloat('0.00', LProperty.Area);

      ListItem.SubItems[4] := LProperty.Description;
      ListItem.SubItems[5] := IntToStr(LProperty.AgentID);

      ListItem.Data := LProperty;
    end;
  end;
end;

end.
