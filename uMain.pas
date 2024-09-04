unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.UITypes;

type
  TMain_Form = class(TForm)
    Panel1: TPanel;
    Label_Agency: TLabel;
    Label_Agents: TLabel;
    Label_Seller: TLabel;
    Label_Properties: TLabel;
    Label1: TLabel;
    procedure Label_AgencyMouseEnter(Sender: TObject);
    procedure Label_AgencyMouseLeave(Sender: TObject);
    procedure Label_AgencyClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Label_AgentsClick(Sender: TObject);
    procedure Label_PropertiesClick(Sender: TObject);
    procedure Label_SellerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  Main_Form: TMain_Form;

implementation

{$R *.dfm}
  uses
    uAgencyCreate, uAgentCreate, uPropertyCreate, uClientCreate, uViewingPropertyCreate;

procedure TMain_Form.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;
end;

procedure TMain_Form.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  UserResponse: Integer;
begin
  if Key = VK_ESCAPE then
  begin
    UserResponse := MessageDlg('Наистина ли искате да изтриете избрания запис?', mtConfirmation, [mbYes, mbNo], 0);
    if UserResponse = mrNo then
      Exit;

    Application.Terminate;
  end;
end;

procedure TMain_Form.Label1Click(Sender: TObject);
begin
  CreateViewingForm;
end;

procedure TMain_Form.Label_AgencyClick(Sender: TObject);
begin
  CreateAgencyForm;
end;

procedure TMain_Form.Label_AgencyMouseEnter(Sender: TObject);
begin
  (Sender as TLabel).Font.Style := (Sender as TLabel).Font.Style + [fsbold];
end;

procedure TMain_Form.Label_AgencyMouseLeave(Sender: TObject);
begin
  (Sender as TLabel).Font.Style := (Sender as TLabel).Font.Style - [fsbold];
end;

procedure TMain_Form.Label_AgentsClick(Sender: TObject);
begin
  CreateAgentForm;
end;

procedure TMain_Form.Label_PropertiesClick(Sender: TObject);
begin
  CreatePropertyForm;
end;

procedure TMain_Form.Label_SellerClick(Sender: TObject);
begin
  CreateClientForm;
end;

end.
