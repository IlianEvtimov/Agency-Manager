program AgencyProject;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {Main_Form},
  Vcl.Themes,
  Vcl.Styles,
  uDB in 'uDB.pas' {DM: TDataModule},
  uAgencyCreate in 'Agency Forms\uAgencyCreate.pas' {Agency_Create_Form},
  uAgentList in 'Agent Forms\uAgentList.pas' {Agent_List_Form},
  uAgentUpdate in 'Agent Forms\uAgentUpdate.pas' {Agent_Update_Form},
  uAgencyClasses in 'Agency Classes\uAgencyClasses.pas',
  uAgentCreate in 'Agent Forms\uAgentCreate.pas' {Agent_Create_Form},
  uAgentManager in 'Agent Classes\uAgentManager.pas',
  uAgencyManager in 'Agency Classes\uAgencyManager.pas',
  uAgentClass in 'Agent Classes\uAgentClass.pas',
  uPropertyList in 'Properties Forms\uPropertyList.pas' {Property_List_Form},
  uPropertyCreate in 'Properties Forms\uPropertyCreate.pas' {Property_Create_Form},
  uPropertyClass in 'Properties Classes\uPropertyClass.pas',
  uPropertyManager in 'Properties Classes\uPropertyManager.pas',
  uAgencyUpdate in 'Agency Forms\uAgencyUpdate.pas' {Agency_Update_Form},
  uAgencyList in 'Agency Forms\uAgencyList.pas' {Agency_List_Form},
  uPropertyUpdate in 'Properties Forms\uPropertyUpdate.pas' {Property_Update_Form},
  uClientCreate in 'Client Forms\uClientCreate.pas' {Create_Clietn_Form},
  uClientClass in 'Client Classes\uClientClass.pas',
  uClientManager in 'Client Classes\uClientManager.pas',
  uClientList in 'Client Forms\uClientList.pas' {Client_List_Form},
  uClientUpdate in 'Client Forms\uClientUpdate.pas' {Client_Update_Form},
  uPropertyImageClass in 'Properties Classes\uPropertyImageClass.pas',
  uViewingPropertyCreate in 'Viewings Forms\uViewingPropertyCreate.pas' {Viewing_Crete_Form},
  uViewingClients in 'Viewings Forms\uViewingClients.pas' {Viewing_Clients_Form},
  uViewingsClass in 'Viewings Classes\uViewingsClass.pas',
  uViewingsProperty in 'Viewings Forms\uViewingsProperty.pas' {Viewings_Property_Form},
  uViewingsManager in 'Viewings Classes\uViewingsManager.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Iceberg Classico');
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TMain_Form, Main_Form);
  Application.CreateForm(TViewings_Property_Form, Viewings_Property_Form);
  Application.Run;
end.
