unit uClientList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uAgencyList, Vcl.Menus, Vcl.ComCtrls, System.UITypes,
  uClientClass;

type
  TClient_List_Form = class(TAgency_List_Form)
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure UpdateClick(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure EnterClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
  private
    { Private declarations }
    FIsCalledFromClientFrom : Boolean;
    function GetClientID: LongInt;
  public
    { Public declarations }

  end;
  function CreateClientListForm: Boolean;
  procedure SetAgentSettings;
  function CreateGetClientIDListForm(var AClientID: LongInt) : Boolean;
var
  Client_List_Form: TClient_List_Form;

implementation

{$R *.dfm}
   uses
    uClientManager, uClientUpdate;

function CreateClientListForm: Boolean;
begin
  Application.CreateForm(TClient_List_Form, Client_List_Form);
  Client_List_Form.FIsCalledFromClientFrom := False;
  Result := Client_List_Form.ShowModal = mrOk;
  Client_List_Form.Release;
end;

function CreateGetClientIDListForm(var AClientID: LongInt) : Boolean;
begin
  Application.CreateForm(TClient_List_Form, Client_List_Form);
  SetAgentSettings;
  Result := Client_List_Form.ShowModal = mrOk;
  if Result then
    AClientID := Client_List_Form.GetClientID;
end;

procedure SetAgentSettings;
begin
  Client_List_Form.FIsCalledFromClientFrom := True;
  Client_List_Form.ListView1.MultiSelect := False;
end;

procedure TClient_List_Form.DeleteClick(Sender: TObject);
var
  ListItem: TListItem;
  LClient: TClient;
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
      LClient := TClient(ListItem.Data);
      if Assigned(LClient) then
      begin
        DeleteClient(LClient); // Изтриване на записа от базата данни (ако е нужно)
        LClient.Free;             // Освобождаване на паметта
        ListItem.Data := nil;     // Зануляване на указателя
      end;

      // Изтриване на избрания елемент от ListView
      ListItem.Delete;
    end;
  end;
end;

procedure TClient_List_Form.EnterClick(Sender: TObject);
begin
  ListView1DblClick(nil);
end;

procedure TClient_List_Form.FormDestroy(Sender: TObject);
var
  i: Integer;
  LClient : TClient;
begin
  for i := 0 to ListView1.Items.Count - 1 do
  begin
    LClient := TClient(ListView1.Items[i].Data);
    LClient.Free; // Освобождаване на паметта за всеки обект
  end;
end;

procedure TClient_List_Form.FormShow(Sender: TObject);
begin
  LoadAllClients(ListView1);
end;

function TClient_List_Form.GetClientID: LongInt;
var
  ListItem: TListItem;
  LClient: TClient;
begin
  Result := -1;
  // Вземи избрания елемент
  ListItem := ListView1.Selected;
  LClient := TClient(ListItem.Data);

  if Assigned(LClient) then
  begin
    // Отваря форма за актуализация и обновява обекта, ако промените са потвърдени
    Result := LClient.ClientID;
  end;
end;

procedure TClient_List_Form.ListView1DblClick(Sender: TObject);
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

procedure TClient_List_Form.UpdateClick(Sender: TObject);
var
  ListItem: TListItem;
  LClient: TClient;
begin

  // Вземи избрания елемент
  ListItem := ListView1.Selected;

  LClient := TClient(ListItem.Data);

  if Assigned(LClient) then
  begin
    // Отваря форма за актуализация и обновява обекта, ако промените са потвърдени
    if CreateClientUpdateForm(LClient) then
    begin

      ListItem.Caption := IntToStr(LClient.ClientID);
      ListItem.SubItems[0] := LClient.Name;
      ListItem.SubItems[1] := LClient.PhoneNumber;

      // Форматиране на Price и Area с две цифри след десетичната запетая
      if LClient.ClientType = 0 then
        ListItem.SubItems.Add('Продавач')
      else
        ListItem.SubItems.Add('Куповач');


      ListItem.SubItems[3] := FormatFloat('0.00', LClient.Budget);

      ListItem.SubItems[4] := IntToStr(LClient.PropertyID);

      // Съхраняване на указателя към обекта в Data свойството
      ListItem.Data := LClient;
    end;
  end;
end;

end.
