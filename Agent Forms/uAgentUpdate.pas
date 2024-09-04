unit uAgentUpdate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uAgentClass, uAgencyClasses;

type
  TAgent_Update_Form = class(TForm)
    Btn_Update: TButton;
    Btn_Cansel: TButton;
    Edt_Phone: TEdit;
    Label2: TLabel;
    Edt_Name: TEdit;
    Label1: TLabel;
    Edt_Agency: TEdit;
    Label3: TLabel;
    Btn_Choose_Agency: TButton;
    procedure Btn_CanselClick(Sender: TObject);
    procedure Btn_UpdateClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure Btn_Choose_AgencyClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FAgent : TAgent;
    FAgency : Tagency;
    procedure DisplayData;
  public
    { Public declarations }
  end;
  function CreateAgentUpdateForm(var AAgent : TAgent): Boolean;
var
  Agent_Update_Form: TAgent_Update_Form;

implementation

{$R *.dfm}
  uses
    uDB, uAgencyList, uAgencyManager, uAgentManager;

function CreateAgentUpdateForm(var AAgent : TAgent): Boolean;
begin
  Application.CreateForm(TAgent_Update_Form, Agent_Update_Form);
  Agent_Update_Form.FAgent := AAgent;
  Agent_Update_Form.FAgency := GetAgencyByID(AAgent.AgencyID);
  Result := Agent_Update_Form.ShowModal = mrOk;

  if Result then begin
    AAgent.Name := Agent_Update_Form.FAgent.Name;
    AAgent.PhoneNumber := Agent_Update_Form.FAgent.PhoneNumber;
    AAgent.AgencyID := Agent_Update_Form.FAgent.AgencyID;
  end;

  Agent_Update_Form.Release;
end;
procedure TAgent_Update_Form.Btn_CanselClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TAgent_Update_Form.Btn_Choose_AgencyClick(Sender: TObject);
var
  LAgencyID: Integer;
begin
  if CreateGetAgency(LAgencyID) then begin
    if Assigned(FAgency) then
      FreeAndNil(FAgency);
    FAgency := GetAgencyByID(LAgencyID);
    Edt_Agency.Text := FAgency.Name;
  end;
end;

procedure TAgent_Update_Form.Btn_UpdateClick(Sender: TObject);
var
  LName, LPhone : string;
  LIsAdded : Boolean;
begin
  try
    LName    := Trim(Edt_Name.Text);
    LPhone := Trim(Edt_Phone.Text);

    if LName = '' then begin
      ShowMessage('Името на агенцията е задължително!');
      Exit;
    end;

    if True then

    FAgent.Name := LName;
    FAgent.PhoneNumber := LPhone;
    FAgent.AgencyID := FAgency.ID;;

    LIsAdded := UpdateAgent(FAgent);

    if LIsAdded then
      ShowMessage('Агенцията е актуализация успешно!')
    else
      ShowMessage('Възника грешка при създаване на Агенцията!')

  finally
    ModalResult := mrOk;
  end;

end;

procedure TAgent_Update_Form.DisplayData;
begin
  Edt_Name.Text   := FAgent.Name;
  Edt_Phone.Text  := FAgent.PhoneNumber;
  Edt_Agency.Text := FAgency.Name;
end;

procedure TAgent_Update_Form.FormDestroy(Sender: TObject);
begin
  if Assigned(FAgency) then
    FreeAndNil(FAgency);
end;

procedure TAgent_Update_Form.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    ModalResult := mrCancel;
  end;
end;

procedure TAgent_Update_Form.FormShow(Sender: TObject);
begin
   DisplayData;
   Edt_Name.SetFocus;
end;

end.
