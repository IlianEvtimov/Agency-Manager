unit uAgentCreate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uAgencyClasses,
  Vcl.StdCtrls;

type
  TAgent_Create_Form = class(TForm)
    Edt_Agency: TEdit;
    Label3: TLabel;
    Edt_Phone: TEdit;
    Label2: TLabel;
    Edt_Agent_Name: TEdit;
    Label1: TLabel;
    Btn_Add: TButton;
    Btn_Cancel: TButton;
    Button3: TButton;
    Btn_Choose_Agency: TButton;
    procedure Btn_Choose_AgencyClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Btn_AddClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
    FAgency : TAgency;
  end;
  function CreateAgentForm: Boolean;
var
  Agent_Create_Form: TAgent_Create_Form;

implementation

{$R *.dfm}
   uses
    uAgencyList, uDB, uAgencyManager, uAgentClass, uAgentManager, uAgentList;

function CreateAgentForm: Boolean;
begin
  Application.CreateForm(TAgent_Create_Form, Agent_Create_Form);
  Result := Agent_Create_Form.ShowModal = mrOk;
  Agent_Create_Form.Release;
end;

procedure TAgent_Create_Form.Btn_AddClick(Sender: TObject);
var
  LName, LPhone: string;
  LAgent : TAgent;
begin
  Lname  := Trim(Edt_Agent_Name.Text);
  LPhone := Trim(Edt_Phone.Text);

  if Lname = EmptyStr then begin
    ShowMessage('Името на агента е задължително!');
    Edt_Agent_Name.SetFocus;
    Exit;
  end;

  if not Assigned(FAgency) then begin
    ShowMessage('Изберете агнция!');
    Btn_Choose_Agency.SetFocus;
    Exit;
  end;

  LAgent := TAgent.Create(Lname, LPhone, FAgency.ID);
  try
    if InsertAgent(LAgent) then
      ShowMessage('Агента е добавен успешно!')
    else
      ShowMessage('Възникна грешка при добавяне на агента!');
  finally
    FreeAndNil(LAgent);
  end;

end;

procedure TAgent_Create_Form.Btn_Choose_AgencyClick(Sender: TObject);
var
  LAgencyID: LongInt;
begin
  if CreateGetAgency(LAgencyID) then begin
    if Assigned(FAgency) then
      FreeAndNil(FAgency);
    FAgency := GetAgencyByID(LAgencyID);
    Edt_Agency.Text := FAgency.Name;
  end;
end;

procedure TAgent_Create_Form.Button3Click(Sender: TObject);
begin
  CreateAgentListForm;
end;

procedure TAgent_Create_Form.FormDestroy(Sender: TObject);
begin
  if Assigned(FAgency) then
    FreeAndNil(FAgency);
  inherited;
end;

procedure TAgent_Create_Form.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    ModalResult := mrCancel;
  end;
end;

end.
