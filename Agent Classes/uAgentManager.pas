unit uAgentManager;

interface

uses
  System.SysUtils, Vcl.Dialogs, Vcl.ComCtrls, Data.DB,
  FireDAC.Stan.Param,
  uDB, uAgentClass;

function InsertAgent(const AAgent: TAgent): Boolean;
function UpdateAgent(const AAgent: TAgent): Boolean;
function DeleteAgent(const AAgentID: Longint): Boolean;
function DeleteClientByAgentID(const AAgentID: LongInt): Boolean;
function DeleteVIEWINGSByAgentID(const AAgentID: LongInt): Boolean;
function DeletePROPERTIESByAgentID(const AAgentID: LongInt): Boolean;
function GetAgentByID(const AID: LongInt): TAgent;
procedure LoadAllAgents(AListView: TListView);

implementation

function InsertAgent(const AAgent: TAgent): Boolean;
begin
  try
    with DM do
    begin
      if not FDConnection1.Connected then
        FDConnection1.Connected := True;

      FDQuery_Work.SQL.Clear;
      FDQuery_Work.SQL.Text := 'INSERT INTO AGENTS (NAME, PHONENUMBER, AGENCYID) VALUES (:Name, :PhoneNumber, :AgencyID)';
      FDQuery_Work.ParamByName('Name').AsString := AAgent.Name;
      FDQuery_Work.ParamByName('PhoneNumber').AsString := AAgent.PhoneNumber;
      FDQuery_Work.ParamByName('AgencyID').AsInteger := AAgent.AgencyID;
      FDQuery_Work.ExecSQL;
      FDConnection1.Commit;
    end;
    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
    end;
  end;
end;

function UpdateAgent(const AAgent: TAgent): Boolean;
begin
  try
    with DM do
    begin
      if not FDConnection1.Connected then
        FDConnection1.Connected := True;

      FDQuery_Work.SQL.Clear;
      FDQuery_Work.SQL.Text := 'UPDATE AGENTS SET NAME = :Name, PHONENUMBER = :PhoneNumber, AGENCYID = :AgencyID WHERE AGENTID = :AgentID';
      FDQuery_Work.ParamByName('Name').AsString := AAgent.Name;
      FDQuery_Work.ParamByName('PhoneNumber').AsString := AAgent.PhoneNumber;
      FDQuery_Work.ParamByName('AgencyID').AsInteger := AAgent.AgencyID;
      FDQuery_Work.ParamByName('AgentID').AsInteger := AAgent.AgentID; // Assumes AgentID is in the AAgent object
      FDQuery_Work.ExecSQL;
      FDConnection1.Commit;
    end;
    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
    end;
  end;
end;

function DeleteAgent(const AAgentID: Longint): Boolean;
begin
  try
    with DM do
    begin
      if not FDConnection1.Connected then
        FDConnection1.Connected := True;

      if not DeleteVIEWINGSByAgentID(AAgentID) then
        ShowMessage('Error deleting from VIEWINGS table');

      if not DeleteClientByAgentID(AAgentID) then
        ShowMessage('Error deleting from CLIENT table');

      if not DeletePROPERTIESByAgentID(AAgentID) then
        ShowMessage('Error deleting from PROPERTIES table');

      FDQuery_Work.SQL.Clear;
      FDQuery_Work.SQL.Text := 'DELETE FROM AGENTS WHERE AGENTID = :AgentID';
      FDQuery_Work.ParamByName('AgentID').AsInteger := AAgentID;
      FDQuery_Work.ExecSQL;

      // Commit changes
      FDConnection1.Commit;
    end;
    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
      // Logging the error or showing an error message could be added
      ShowMessage('Error deleting from AGENTS: ' + E.Message);
      DM.FDConnection1.Rollback; // In case of error, roll back all changes
    end;
  end;
end;

function DeleteClientByAgentID(const AAgentID: LongInt): Boolean;
begin
  try
    with DM do
    begin
      // Delete records in Clients where PropertyID is associated with the given AgentID
      FDQuery_Work.SQL.Clear;
      FDQuery_Work.SQL.Text :=
        'DELETE FROM Clients ' +
        'WHERE PROPERTYID IN ( ' +
        '  SELECT PROPERTYID ' +
        '  FROM Properties ' +
        '  WHERE AGENTID = :AgentID ' +
        ')';
      FDQuery_Work.ParamByName('AgentID').AsInteger := AAgentID;
      FDQuery_Work.ExecSQL;
    end;
    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
      // Logging the error or showing an error message could be added
      ShowMessage('Error deleting from Clients: ' + E.Message);
      DM.FDConnection1.Rollback; // In case of error, roll back all changes
    end;
  end;
end;

function DeleteVIEWINGSByAgentID(const AAgentID: LongInt): Boolean;
begin
  try
    with DM do
    begin
      // Delete records in the VIEWINGS table
      FDQuery_Work.SQL.Clear;
      FDQuery_Work.SQL.Text := 'DELETE FROM VIEWINGS WHERE AGENTID = :AgentID';
      FDQuery_Work.ParamByName('AgentID').AsInteger := AAgentID;
      FDQuery_Work.ExecSQL;
    end;

    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
      // Logging the error or showing an error message could be added
      ShowMessage('Error deleting from VIEWINGS: ' + E.Message);
      DM.FDConnection1.Rollback; // In case of error, roll back all changes
    end;
  end;
end;

function DeletePROPERTIESByAgentID(const AAgentID: LongInt): Boolean;
begin
  try
    with DM do
    begin
      // Delete records in the PROPERTIES table
      FDQuery_Work.SQL.Clear;
      FDQuery_Work.SQL.Text := 'DELETE FROM PROPERTIES WHERE AGENTID = :AgentID';
      FDQuery_Work.ParamByName('AgentID').AsInteger := AAgentID;
      FDQuery_Work.ExecSQL;
    end;

    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
      // Logging the error or showing an error message could be added
      ShowMessage('Error deleting from PROPERTIES: ' + E.Message);
      DM.FDConnection1.Rollback; // In case of error, roll back all changes
    end;
  end;
end;

function GetAgentByID(const AID: LongInt): TAgent;
begin
  // Initialize result with nil
  Result := nil;
  try
    with DM do
    begin
      if not FDConnection1.Connected then
        FDConnection1.Connected := True;

      FDQuery_Work.SQL.Clear;
      FDQuery_Work.SQL.Text := 'SELECT * FROM AGENTS WHERE AGENTID = :AGENTID';
      FDQuery_Work.ParamByName('AGENTID').AsInteger := AID;
      FDQuery_Work.Open;

      // Check if the query returned any results
      if not FDQuery_Work.IsEmpty then
      begin
        // Create a TAgent object with the data from the query
        Result := TAgent.Create(
          FDQuery_Work.FieldByName('AGENTID').AsInteger,
          FDQuery_Work.FieldByName('NAME').AsString,
          FDQuery_Work.FieldByName('PHONENUMBER').AsString,
          FDQuery_Work.FieldByName('AGENCYID').AsInteger
        );
      end;
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Error fetching AGENTS by ID: ' + E.Message);
    end;
  end;
end;

procedure LoadAllAgents(AListView: TListView);
var
  ListItem: TListItem;
  LAgent: TAgent;
begin
  // Clear the TListView
  AListView.Items.Clear;

  // Ensure the connection is active
  if not DM.FDConnection1.Connected then
    DM.FDConnection1.Connected := True;

  // Set up and execute the query to retrieve agents and their agencies
  DM.FDQuery_Agency.SQL.Clear;
  DM.FDQuery_Agency.SQL.Add('SELECT a.AgentID, a.Name, a.PhoneNumber, a.AGENCYID, ag.Name AS AgencyName ' +
                            'FROM Agents a ' +
                            'LEFT JOIN AGENCY ag ON a.AGENCYID = ag.AGENCYID');
  DM.FDQuery_Agency.Open;

  // Iterate through all records in FDQuery_Agency
  DM.FDQuery_Agency.First;
  while not DM.FDQuery_Agency.Eof do
  begin
    // Create a TAgent object with the data from the current record
    LAgent := TAgent.Create(
      DM.FDQuery_Agency.FieldByName('AgentID').AsInteger,
      DM.FDQuery_Agency.FieldByName('Name').AsString,
      DM.FDQuery_Agency.FieldByName('PhoneNumber').AsString,
      DM.FDQuery_Agency.FieldByName('AGENCYID').AsInteger
    );

    // Create a new ListItem and set data
    ListItem := AListView.Items.Add;

    ListItem.Caption := IntToStr(LAgent.AgentID);
    ListItem.SubItems.Add(LAgent.Name);
    ListItem.SubItems.Add(LAgent.PhoneNumber);

    // Use AgencyName retrieved from SQL query
    ListItem.SubItems.Add(DM.FDQuery_Agency.FieldByName('AgencyName').AsString);

    // Store a pointer to the object in the Data property
    ListItem.Data := LAgent;

    // Move to the next record
    DM.FDQuery_Agency.Next;
  end;

  if AListView.Items.Count > 0 then
    AListView.ItemIndex := 0;

  // Close the query
  DM.FDQuery_Agency.Close;
end;

end.

