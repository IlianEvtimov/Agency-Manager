unit uAgencyCreate;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.DBCtrls, System.ImageList,
  Vcl.ImgList, Vcl.Menus, Firedac.Stan.Param;
type
  TAgency_Create_Form = class(TForm)
    Button3: TButton;
    Button1: TButton;
    Btn_Add: TButton;
    Btn_Cancel: TButton;
    Edt_Phone: TEdit;
    Label3: TLabel;
    Edt_Address: TEdit;
    Label2: TLabel;
    Edt_Name: TEdit;
    Label1: TLabel;
    procedure Btn_AddClick(Sender: TObject);
    procedure Btn_CancelClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure ClearEdits;
  public
    { Public declarations }
  end;
  function CreateAgencyForm: Boolean;
var
  Agency_Create_Form: TAgency_Create_Form;
implementation
{$R *.dfm}
uses
  uDB, uAgencyClasses, uAgencyUpdate, uAgencyList, uAgencyManager;
function CreateAgencyForm: Boolean;
begin
  Application.CreateForm(TAgency_Create_Form, Agency_Create_Form);
  Result := Agency_Create_Form.ShowModal = mrOk;
  Agency_Create_Form.Release;
end;
procedure TAgency_Create_Form.Btn_AddClick(Sender: TObject);
var
  LName, LAddress, LPhone: string;
  LAgency: TAgency;
  LIsAdded: Boolean;
begin
  try
    LName := Trim(Edt_Name.Text);
    LAddress := Trim(Edt_Address.Text);
    LPhone := Trim(Edt_Phone.Text);
    if LName = '' then
    begin
      ShowMessage('Името на агенцията е задължително!');
      Exit;
    end;
    LAgency := TAgency.Create(LName, LAddress, LPhone);
    LIsAdded := InsertAgency(LAgency);
    if LIsAdded then
      ShowMessage('Агенцията е добавена успешно!')
    else
      ShowMessage('Възника грешка при създаване на Агенцията!')
  finally
    FreeAndNil(LAgency);
    ClearEdits;
  end;
end;
procedure TAgency_Create_Form.Btn_CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;
procedure TAgency_Create_Form.Button1Click(Sender: TObject);
var
  i: Integer;
  AgencyName, AgencyAddress, AgencyPhone: string;
begin
  // Ensure the connection is active
  if not DM.FDConnection1.Connected then
    DM.FDConnection1.Connected := True;
  // Start a transaction
  DM.FDConnection1.StartTransaction;
  try
    // Add 1000 agencies
    for i := 1 to 1000 do
    begin
      // Example data for the agency
      AgencyName := Format('Agency %d', [i]);
      AgencyAddress := Format('Address %d, City %d', [i, i]);
      AgencyPhone := Format('Phone %d-%d', [1000 + i, 2000 + i]);
      // Prepare SQL query for insertion
      DM.FDQuery_Work.SQL.Clear;
      DM.FDQuery_Work.SQL.Add('INSERT INTO Agency (Name, Address, ContactPhone)');
      DM.FDQuery_Work.SQL.Add('VALUES (:Name, :Address, :ContactPhone)');
      // Set parameters
      DM.FDQuery_Work.ParamByName('Name').AsString := AgencyName;
      DM.FDQuery_Work.ParamByName('Address').AsString := AgencyAddress;
      DM.FDQuery_Work.ParamByName('ContactPhone').AsString := AgencyPhone;
      // Execute SQL query
      DM.FDQuery_Work.ExecSQL;
    end;
    // Commit the transaction to save changes
    DM.FDConnection1.Commit;
    ShowMessage('Successfully added 1000 agencies to the database.');
  except
    on E: Exception do
    begin
      // In case of an error, rollback the transaction
      DM.FDConnection1.Rollback;
      ShowMessage('Error adding agencies: ' + E.Message);
    end;
  end;
end;
procedure TAgency_Create_Form.Button3Click(Sender: TObject);
begin
  CreateAgencyListForm;
end;
procedure TAgency_Create_Form.ClearEdits;
begin
  Edt_Name.Text := '';
  Edt_Address.Text := '';
  Edt_Phone.Text := '';
end;
procedure TAgency_Create_Form.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    ModalResult := mrCancel;  // Closes the form with a mrCancel result
  end;
end;
procedure TAgency_Create_Form.FormShow(Sender: TObject);
begin
  Edt_Name.SetFocus;
end;
end.

