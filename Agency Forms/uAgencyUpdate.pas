unit uAgencyUpdate;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uAgencyClasses;
type
  TAgency_Update_Form = class(TForm)
    Btn_Update: TButton;
    Btn_Cansel: TButton;
    Edt_Phone: TEdit;
    Label3: TLabel;
    Edt_Address: TEdit;
    Label2: TLabel;
    Edt_Name: TEdit;
    Label1: TLabel;
    procedure Btn_CanselClick(Sender: TObject);
    procedure Btn_UpdateClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FAgency: TAgency;
    procedure DisplayData;
  public
    { Public declarations }
  end;
  function CreateAgencyUpdateForm(var AAgency: TAgency): Boolean;
var
  Agency_Update_Form: TAgency_Update_Form;
implementation
{$R *.dfm}
uses
  uDB, uAgencyManager;
function CreateAgencyUpdateForm(var AAgency: TAgency): Boolean;
begin
  Application.CreateForm(TAgency_Update_Form, Agency_Update_Form);
  Agency_Update_Form.FAgency := AAgency;
  Result := Agency_Update_Form.ShowModal = mrOk;
  if Result then
  begin
    AAgency.Name := Agency_Update_Form.FAgency.Name;
    AAgency.Address := Agency_Update_Form.FAgency.Address;
    AAgency.PhoneNumber := Agency_Update_Form.FAgency.PhoneNumber;
  end;
  Agency_Update_Form.Release;
end;
procedure TAgency_Update_Form.Btn_CanselClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;
procedure TAgency_Update_Form.Btn_UpdateClick(Sender: TObject);
var
  LName, LAddress, LPhone: string;
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
    FAgency.Name := LName;
    FAgency.Address := LAddress;
    FAgency.PhoneNumber := LPhone;
    LIsAdded := UpdateAgency(FAgency);
    if LIsAdded then
      ShowMessage('Агенцията е актуализация успешно!')
    else
      ShowMessage('Възника грешка при създаване на Агенцията!')
  finally
    ModalResult := mrOk;
  end;
end;
procedure TAgency_Update_Form.DisplayData;
begin
  Edt_Name.Text := FAgency.Name;
  Edt_Address.Text := FAgency.Address;
  Edt_Phone.Text := FAgency.PhoneNumber;
end;
procedure TAgency_Update_Form.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    ModalResult := mrCancel;  // Closes the form with a mrCancel result
  end;
end;
procedure TAgency_Update_Form.FormShow(Sender: TObject);
begin
  DisplayData;
  Edt_Name.SetFocus;
end;
end.

