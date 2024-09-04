unit uClientManager;

interface
uses
  System.SysUtils, Vcl.Dialogs, Vcl.ComCtrls, FireDac.Stan.Param,
  uClientClass;

function InsertClient(const AClient: TClient): Boolean;
function UpdateClient(const AClient: TClient): Boolean;
procedure LoadAllClients(AListView: TListView);
function DeleteClient(const AClient: TClient): Boolean;
function GetClientByID(ClientID: Integer): TClient;

implementation
uses
  uDB, uPropertyManager;

function InsertClient(const AClient: TClient): Boolean;
begin
  try
    with DM do
    begin
      if not FDConnection1.Connected then
        FDConnection1.Connected := True;
      FDQuery_Work.SQL.Clear;
      FDQuery_Work.SQL.Text := 'INSERT INTO CLIENTS (NAME, PHONENUMBER, CLIENTTYPE_INT, BUDGET, PROPERTYID) ' +
                               'VALUES (:Name, :PhoneNumber, :ClientType, :Budget, :PropertyID)';
      FDQuery_Work.ParamByName('Name').AsString         := AClient.Name;          // Client's name
      FDQuery_Work.ParamByName('PhoneNumber').AsString  := AClient.PhoneNumber;   // Phone number
      FDQuery_Work.ParamByName('ClientType').AsInteger   := AClient.ClientType;    // Client type
      FDQuery_Work.ParamByName('Budget').AsFloat        := AClient.Budget;        // Budget (use AsFloat for Double values)

      // Check if PropertyID is zero and set to NULL if so
      if AClient.PropertyID = 0 then
        FDQuery_Work.ParamByName('PropertyID').Clear  // Set PropertyID to NULL
      else
        FDQuery_Work.ParamByName('PropertyID').AsInteger := AClient.PropertyID;  // Set the value of PropertyID

      FDQuery_Work.ExecSQL;
      FDConnection1.Commit;
    end;
    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
      // Logging or showing an error message can be added here
      ShowMessage('Error inserting CLIENTS: ' + E.Message);
      DM.FDConnection1.Rollback;  // Rollback the transaction on error
    end;
  end;
end;

procedure LoadAllClients(AListView: TListView);
var
  ListItem: TListItem;
  LClient: TClient;
begin

  // Ensure the connection is active
  if not DM.FDConnection1.Connected then
    DM.FDConnection1.Connected := True;

  // Set up and execute the query to retrieve data
  DM.FDQuery_Agency.SQL.Clear;
  DM.FDQuery_Agency.SQL.Add('SELECT * FROM CLIENTS');
  DM.FDQuery_Agency.Open;

  // Iterate through all records in FDQuery_Agency
  DM.FDQuery_Agency.First;
  while not DM.FDQuery_Agency.Eof do
  begin
    // Create a TClient object with data from the current record
    LClient := TClient.Create(
      DM.FDQuery_Agency.FieldByName('CLIENTID').AsInteger,
      DM.FDQuery_Agency.FieldByName('NAME').AsString,
      DM.FDQuery_Agency.FieldByName('PHONENUMBER').AsString,
      DM.FDQuery_Agency.FieldByName('CLIENTTYPE_INT').AsInteger,
      DM.FDQuery_Agency.FieldByName('BUDGET').AsFloat,
      DM.FDQuery_Agency.FieldByName('PROPERTYID').AsInteger
    );

    // Create a new ListItem and set data
    ListItem := AListView.Items.Add;

    ListItem.Caption := IntToStr(LClient.ClientID);
    ListItem.SubItems.Add(LClient.Name);
    ListItem.SubItems.Add(LClient.PhoneNumber);
    if LClient.ClientType = 0 then
      ListItem.SubItems.Add('Seller')
    else
      ListItem.SubItems.Add('Buyer');

    // Format Budget with two decimal places
    ListItem.SubItems.Add(FormatFloat('0.00', LClient.Budget));
    ListItem.SubItems.Add(IntToStr(LClient.PropertyID));

    // Store pointer to the object in Data property
    ListItem.Data := LClient;

    // Move to the next record
    DM.FDQuery_Agency.Next;
  end;

  if AListView.Items.Count > 0 then
    AListView.ItemIndex := 0;

  // Close the query
  DM.FDQuery_Agency.Close;
end;

function UpdateClient(const AClient: TClient): Boolean;
begin
  try
    with DM do
    begin
      if not FDConnection1.Connected then
        FDConnection1.Connected := True;

      FDQuery_Work.SQL.Clear;
      FDQuery_Work.SQL.Text := 'UPDATE CLIENTS SET ' +
                               'NAME = :Name, ' +
                               'PHONENUMBER = :PhoneNumber, ' +
                               'CLIENTTYPE_INT = :ClientType, ' +
                               'BUDGET = :Budget, ' +
                               'PROPERTYID = :PropertyID ' +
                               'WHERE CLIENTID = :ClientID';

      // Set parameter values from the LClient object
      FDQuery_Work.ParamByName('Name').AsString        := AClient.Name;          // Client's name
      FDQuery_Work.ParamByName('PhoneNumber').AsString := AClient.PhoneNumber;   // Phone number
      FDQuery_Work.ParamByName('ClientType').AsInteger  := AClient.ClientType;    // Client type
      FDQuery_Work.ParamByName('Budget').AsFloat       := AClient.Budget;        // Budget

      // Check if PropertyID is zero and set to NULL if so
      if AClient.PropertyID = 0 then
        FDQuery_Work.ParamByName('PropertyID').Clear  // Set PropertyID to NULL
      else
        FDQuery_Work.ParamByName('PropertyID').AsInteger := AClient.PropertyID;  // Set the value of PropertyID

      FDQuery_Work.ParamByName('ClientID').AsInteger   := AClient.ClientID;      // Unique client identifier

      FDQuery_Work.ExecSQL;
      FDConnection1.Commit;
    end;
    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
      ShowMessage('Error updating CLIENTS: ' + E.Message);
      DM.FDConnection1.Rollback;  // Rollback the transaction on error
    end;
  end;
end;

function DeleteClient(const AClient: TClient): Boolean;
begin
  try
    with DM do
    begin
      if not FDConnection1.Connected then
        FDConnection1.Connected := True;

      if not DeleteViewingByPropertyID(AClient.PropertyID) then
        ShowMessage('Error deleting VIEWINGS!');

      // Step 1: Set PROPERTYID to NULL
      DM.FDQuery_Work.SQL.Clear;
      DM.FDQuery_Work.SQL.Add('UPDATE CLIENTS SET PROPERTYID = NULL WHERE CLIENTID = :ClientID');
      DM.FDQuery_Work.ParamByName('ClientID').AsInteger := AClient.ClientID;
      DM.FDQuery_Work.ExecSQL;

      FDQuery_Work.SQL.Clear;
      FDQuery_Work.SQL.Text := 'DELETE FROM CLIENTS WHERE CLIENTID = :ClientID';  // Delete the record with the specified ClientID
      FDQuery_Work.ParamByName('ClientID').AsInteger := AClient.ClientID;  // ClientID of the record to be deleted
      FDQuery_Work.ExecSQL;
      FDConnection1.Commit;
    end;
    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
      // Logging or showing an error message can be added here
      // ShowMessage('Error deleting client: ' + E.Message);
      DM.FDConnection1.Rollback;  // Rollback the transaction on error
    end;
  end;
end;

function GetClientByID(ClientID: Integer): TClient;
begin
  Result := nil; // Default to nil if the client is not found

  // Ensure the connection is active
  if not DM.FDConnection1.Connected then
    DM.FDConnection1.Connected := True;

  // Set up and execute the query to retrieve data
  DM.FDQuery_Agency.SQL.Clear;
  DM.FDQuery_Agency.SQL.Add('SELECT * FROM CLIENTS WHERE CLIENTID = :ClientID');
  DM.FDQuery_Agency.ParamByName('ClientID').AsInteger := ClientID;
  DM.FDQuery_Agency.Open;

  // Check if the record was found
  if not DM.FDQuery_Agency.IsEmpty then
  begin
    // Create a TClient object with data from the current record
    Result := TClient.Create(
      DM.FDQuery_Agency.FieldByName('CLIENTID').AsInteger,
      DM.FDQuery_Agency.FieldByName('NAME').AsString,
      DM.FDQuery_Agency.FieldByName('PHONENUMBER').AsString,
      DM.FDQuery_Agency.FieldByName('CLIENTTYPE_INT').AsInteger,
      DM.FDQuery_Agency.FieldByName('BUDGET').AsFloat,
      DM.FDQuery_Agency.FieldByName('PROPERTYID').AsInteger
    );
  end;

  // Close the query
  DM.FDQuery_Agency.Close;
end;

end.

