unit uViewingsProperty;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uPropertyUpdate, Vcl.StdCtrls,
  Vcl.ExtCtrls, uPropertyClass, uAgentClass, uPropertyImageClass;

type
  TViewings_Property_Form = class(TProperty_Update_Form)
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_NextClick(Sender: TObject);
    procedure Btn_BackClick(Sender: TObject);
  private
    { Private declarations }
    FProperty : TProperty;
    FAgent : TAgent;
    FPropertyImageLoader : TPropertyImageLoader;
    procedure DisplayData;
    procedure DisableForm;
    procedure PossitionImageButtons;
  public
    { Public declarations }
  end;
  function CreateViewingsPropertyForm(var AProperty: TProperty): Boolean;
var
  Viewings_Property_Form: TViewings_Property_Form;

implementation

{$R *.dfm}
  uses
    uAgentManager;

function CreateViewingsPropertyForm(var AProperty: TProperty): Boolean;
begin
  Application.CreateForm(TViewings_Property_Form, Viewings_Property_Form);
  Viewings_Property_Form.FProperty := AProperty;
  Viewings_Property_Form.FAgent    := GetAgentByID(AProperty.AgentID);
  Result := Viewings_Property_Form.ShowModal = mrOk;

  Viewings_Property_Form.Release;
end;

procedure TViewings_Property_Form.Btn_BackClick(Sender: TObject);
begin
  FPropertyImageLoader.Previous;
end;

procedure TViewings_Property_Form.Btn_NextClick(Sender: TObject);
begin
  FPropertyImageLoader.Next;
end;

procedure TViewings_Property_Form.DisableForm;
begin
  Edt_Propery_Type.Enabled := False;
  Edt_Address.Enabled      := False;
  Edt_Price.Enabled        := False;
  Edt_Area.Enabled         := False;
  Memo_Description.Enabled := False;
  Edt_Agent.Enabled        := False;
  Btn_Add_Image.Visible    := False;
  Btn_Delete.Visible       := False;
  Btn_Agent.Visible        := False;
  Btn_Create.Visible       := False;

end;

procedure TViewings_Property_Form.DisplayData;
begin
  Edt_Propery_Type.Text := FProperty.PropertyType;
  Edt_Address.Text      := FProperty.Address;
  Edt_Price.Text        := FormatFloat('0.00', FProperty.Price);
  Edt_Area.Text         := FormatFloat('0.00', FProperty.Area);
  Memo_Description.Text := FProperty.Description;
  Edt_Agent.Text        := FAgent.Name;

  FPropertyImageLoader := TPropertyImageLoader.Create(FProperty.PropertyID, Image1, Lbl_Image_Count);
  FPropertyImageLoader.LoadImage;
end;

procedure TViewings_Property_Form.FormDestroy(Sender: TObject);
begin
  if Assigned(FPropertyImageLoader) then
    FreeAndNil(FPropertyImageLoader);

//  if Assigned(FProperty) then  // Освобождава се в UpropertyList формата
//    FreeAndNil(FProperty);

  if Assigned(FAgent) then
    FreeAndNil(FAgent);
end;

procedure TViewings_Property_Form.FormShow(Sender: TObject);
begin
  DisplayData;
  DisableForm;
  PossitionImageButtons;
end;

procedure TViewings_Property_Form.PossitionImageButtons;
begin
  Btn_Back.Left := 433;
  Lbl_Image_Count.Left := 490;
  Btn_Next.Left := 555;
end;

end.
