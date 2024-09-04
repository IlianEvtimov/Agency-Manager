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
  // Ако няма избрани елементи
  if ListView1.SelCount = 0 then
  begin
    ShowMessage('Няма избрани елементи за изтриване.');
    Exit;
  end;

  // Показване на диалог за потвърждение
  UserResponse := MessageDlg('Наистина ли искате да изтриете избрания запис?', mtConfirmation, [mbYes, mbNo], 0);
  if UserResponse = mrNo then
    Exit;

  // Извършване на итерация отзад напред през всички елементи
  for i := ListView1.Items.Count - 1 downto 0 do
  begin
    ListItem := ListView1.Items[i];

    // Проверка дали елементът е избран
    if ListItem.Selected then
    begin
      // Освобождаване на паметта за обекта, свързан с този елемент
      LProperty := TProperty(ListItem.Data);
      if Assigned(LProperty) then
      begin
        DeleteProperty(LProperty); // Изтриване на записа от базата данни (ако е нужно)
        LProperty.Free;             // Освобождаване на паметта
        ListItem.Data := nil;     // Зануляване на указателя
      end;

      // Изтриване на избрания елемент от ListView
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
    LProperty.Free; // Освобождаване на паметта за всеки обект
  end;
end;

procedure TProperty_List_Form.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    ModalResult := mrCancel;  // Затваря формата със стойност mrCancel
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
  // Вземи избрания елемент
  ListItem := ListView1.Selected;
  LProperty := TProperty(ListItem.Data);

  if Assigned(LProperty) then
  begin
    // Отваря форма за актуализация и обновява обекта, ако промените са потвърдени
    Result := LProperty.PropertyID;
  end;
end;

procedure TProperty_List_Form.ListView1DblClick(Sender: TObject);
begin
  // Ако няма избрани елементи
  if ListView1.SelCount = 0 then
  begin
    ShowMessage('Няма избрани елементи за актуализиране.');
    Exit;  // Добавяне на Exit тук
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

  // Вземи избрания елемент
  ListItem := ListView1.Selected;

  LProperty := TProperty(ListItem.Data);

  if Assigned(LProperty) then
  begin
    // Отваря форма за актуализация и обновява обекта, ако промените са потвърдени
    if CreateUpdateForm(LProperty) then
    begin

      ListItem.Caption := IntToStr(LProperty.PropertyID);
      ListItem.SubItems[0] := LProperty.PropertyType;
      ListItem.SubItems[1] := LProperty.Address;

      // Форматиране на Price и Area с две цифри след десетичната запетая
      ListItem.SubItems[2] := FormatFloat('0.00', LProperty.Price);
      ListItem.SubItems[3] := FormatFloat('0.00', LProperty.Area);

      ListItem.SubItems[4] := LProperty.Description;
      ListItem.SubItems[5] := IntToStr(LProperty.AgentID);

    // Съхраняване на указателя към обекта в Data свойството
    ListItem.Data := LProperty;
    end;
  end;
end;

end.
