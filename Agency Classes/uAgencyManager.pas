unit uAgencyManager;

interface
uses
  System.SysUtils, Vcl.ComCtrls, FireDac.Stan.Param, Data.DB,
  uDB, uAgencyClasses;

  function InsertAgency(const AAgency: TAgency): Boolean;
  function DeleteAgency(const AAgency: TAgency): Boolean;
  function UpdateAgency(const AAgency: TAgency): Boolean;
  function GetAgencyByID(const AID: LongInt): TAgency;
  procedure LoadAllAgencies(AListView: TListView);

implementation

function InsertAgency(const AAgency: TAgency): Boolean;
begin
  try
    with DM do
    begin
      if not FDConnection1.Connected then
        FDConnection1.Connected := True;

      FDQuery_Work.SQL.Clear;
      FDQuery_Work.SQL.Add('INSERT INTO Agency (Name, Address, ContactPhone)');
      FDQuery_Work.SQL.Add('VALUES (:Name, :Address, :ContactPhone)');

      FDQuery_Work.ParamByName('Name').AsString := AAgency.Name;
      FDQuery_Work.ParamByName('Address').AsString := AAgency.Address;
      FDQuery_Work.ParamByName('ContactPhone').AsString := AAgency.PhoneNumber;

      FDQuery_Work.ExecSQL;
      FDConnection1.Commit;
    end;

    Result := True;
  except
    on E: Exception do
    begin
      // Show error message if insertion fails
      Result := False;
    end;
  end;
end;

function DeleteAgency(const AAgency: TAgency): Boolean;
begin
  try
    with DM do
    begin
      // Ensure the connection is active
      if not FDConnection1.Connected then
        FDConnection1.Connected := True;

      // Prepare SQL query for deletion with parameters
      FDQuery_Work.SQL.Clear;
      FDQuery_Work.SQL.Add('DELETE FROM Agency WHERE AgencyID = :AgencyID');

      // Set parameter value (unique identifier for the agency)
      FDQuery_Work.ParamByName('AgencyID').AsInteger := AAgency.ID;

      // Execute SQL query
      FDQuery_Work.ExecSQL;
      FDConnection1.Commit;
    end;

    Result := True;
  except
    on E: Exception do
    begin
      // Show error message if deletion fails
      Result := False;
    end;
  end;
end;

function UpdateAgency(const AAgency: TAgency): Boolean;
begin
  try
    with DM do
    begin
      // Ensure the connection is active
      if not FDConnection1.Connected then
        FDConnection1.Connected := True;

      FDQuery_Work.SQL.Clear;
      FDQuery_Work.SQL.Add('UPDATE Agency SET Name = :Name, Address = :Address, ContactPhone = :ContactPhone');
      FDQuery_Work.SQL.Add('WHERE AgencyID = :AgencyID');

      FDQuery_Work.ParamByName('Name').AsString := AAgency.Name;
      FDQuery_Work.ParamByName('Address').AsString := AAgency.Address;
      FDQuery_Work.ParamByName('ContactPhone').AsString := AAgency.PhoneNumber;
      FDQuery_Work.ParamByName('AgencyID').AsInteger := AAgency.ID;

      // Execute SQL query
      FDQuery_Work.ExecSQL;
      FDConnection1.Commit;
    end;

    Result := True;
  except
    on E: Exception do
    begin
      // Show error message if update fails
      Result := False;
    end;
  end;
end;

function GetAgencyByID(const AID: LongInt): TAgency;
var
  Agency: TAgency;
begin
  // Initialize result to nil
  Result := nil;

  with DM do
  begin
    if not FDConnection1.Connected then
      FDConnection1.Connected := True;

    FDQuery_Work.SQL.Clear;
    FDQuery_Work.SQL.Text := 'SELECT AgencyID, Name, Address, ContactPhone FROM Agency WHERE AgencyID = :AgencyID';
    FDQuery_Work.ParamByName('AgencyID').AsInteger := AID;
    FDQuery_Work.Open;

    // Check if the query returned a result
    if not FDQuery_Work.IsEmpty then
    begin
      // Create a TAgency object with data from the query
      Agency := TAgency.Create(
        FDQuery_Work.FieldByName('AgencyID').AsInteger,
        FDQuery_Work.FieldByName('Name').AsString,
        FDQuery_Work.FieldByName('Address').AsString,
        FDQuery_Work.FieldByName('ContactPhone').AsString
      );
      Result := Agency;
    end;
  end;
end;

procedure LoadAllAgencies(AListView: TListView);
var
  ListItem: TListItem;
  LAgency: TAgency;
begin
  // Clear the TListView
  AListView.Items.Clear;

  // Ensure the connection is active
  if not DM.FDConnection1.Connected then
    DM.FDConnection1.Connected := True;

  // Set up and execute the query to retrieve data
  DM.FDQuery_Agency.SQL.Clear;
  DM.FDQuery_Agency.SQL.Add('SELECT * FROM Agency');
  DM.FDQuery_Agency.Open;

  // Iterate through all records in FDQuery_Agency
  DM.FDQuery_Agency.First;
  while not DM.FDQuery_Agency.Eof do
  begin
    // Create a TAgency object with data from the current record
    LAgency := TAgency.Create(
      DM.FDQuery_Agency.FieldByName('AgencyID').AsInteger,
      DM.FDQuery_Agency.FieldByName('Name').AsString,
      DM.FDQuery_Agency.FieldByName('Address').AsString,
      DM.FDQuery_Agency.FieldByName('ContactPhone').AsString
    );

    // Create a new ListItem and set data
    ListItem := AListView.Items.Add;

    ListItem.Caption := IntToStr(LAgency.ID);
    ListItem.SubItems.Add(LAgency.Name);
    ListItem.SubItems.Add(LAgency.Address);
    ListItem.SubItems.Add(LAgency.PhoneNumber);

    // Store the pointer to the object in the Data property
    ListItem.Data := LAgency;

    // Move to the next record
    DM.FDQuery_Agency.Next;
  end;

  if AListView.Items.Count > 0 then
    AListView.ItemIndex := 0;

  // Close the query
  DM.FDQuery_Agency.Close;
end;

end.

