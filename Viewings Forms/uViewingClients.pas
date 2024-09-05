unit uViewingClients;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uClientList, Vcl.Menus, Vcl.ComCtrls;

type
  TViewing_Clients_Form = class(TClient_List_Form)
    procedure ListView1DblClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure EnterClick(Sender: TObject);
    procedure UpdateClick(Sender: TObject);
  private
    { Private declarations }
    FCLientID: LongInt;
  public
    { Public declarations }
  end;
  function CreateClientListForm(var AClientID: LongInt): Boolean;
var
  Viewing_Clients_Form: TViewing_Clients_Form;

implementation

{$R *.dfm}
    uses
      uClientClass;

function CreateClientListForm(var AClientID: LongInt): Boolean;
begin
  Application.CreateForm(TViewing_Clients_Form, Viewing_Clients_Form);
  Result := Viewing_Clients_Form.ShowModal = mrOk;
  if Result then
  begin
    AClientID := Viewing_Clients_Form.FCLientID;
  end;
  Viewing_Clients_Form.Release;
end;

procedure TViewing_Clients_Form.DeleteClick(Sender: TObject);
begin
  //
end;

procedure TViewing_Clients_Form.EnterClick(Sender: TObject);
begin
   ListView1DblClick(nil);
end;

procedure TViewing_Clients_Form.ListView1DblClick(Sender: TObject);
var
  ListItem: TListItem;
  LClient: TClient;
begin
  if ListView1.SelCount = 0 then
  begin
    ShowMessage('Няма избрани елементи за актуализиране.');
    Exit;
  end;

  ListItem := ListView1.Selected;

  LClient := TClient(ListItem.Data);

  if Assigned(LClient) then
  begin
    FCLientID := LClient.ClientID;
    ModalResult := mrOk;
  end;
end;

procedure TViewing_Clients_Form.UpdateClick(Sender: TObject);
begin
  //
end;

end.
