unit uViewingsManager;

interface
   uses
    System.SysUtils, System.Classes, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Graphics, Vcl.ExtCtrls,
    FireDAC.Comp.Client, FireDAC.Stan.Param, Data.DB, uDB;

    function GetViewingCount(ClientID, PropertyID: Integer): Integer;
    function InsertViewing(PropertyID, AgentID, ClientID: Integer; ViewingDate: TDateTime): Boolean;

implementation

function GetViewingCount(ClientID, PropertyID: Integer): Integer;
begin
  Result := 0;

  with DM do
  begin
    if not DM.FDConnection1.Connected then
      DM.FDConnection1.Connected := True;

    FDQuery_Work.SQL.Clear;
    FDQuery_Work.SQL.Add('SELECT COUNT(*) AS ViewingCount FROM VIEWINGS');
    FDQuery_Work.SQL.Add('WHERE CLIENTID = :ClientID AND PROPERTYID = :PropertyID');
    FDQuery_Work.ParamByName('ClientID').AsInteger := ClientID;
    FDQuery_Work.ParamByName('PropertyID').AsInteger := PropertyID;
    FDQuery_Work.Open;

    if not FDQuery_Work.IsEmpty then
      Result := FDQuery_Work.FieldByName('ViewingCount').AsInteger;

    FDQuery_Work.Close;
  end;
end;

function InsertViewing(PropertyID, AgentID, ClientID: Integer; ViewingDate: TDateTime): Boolean;
begin
  Result := False;
  with DM do
  begin
    if not FDConnection1.Connected then
      FDConnection1.Connected := True;
    FDQuery_Work.SQL.Clear;
    FDQuery_Work.SQL.Add('INSERT INTO VIEWINGS (PROPERTYID, AGENTID, CLIENTID, VIEWINGDATE)');
    FDQuery_Work.SQL.Add('VALUES (:PropertyID, :AgentID, :ClientID, :ViewingDate)');
    FDQuery_Work.ParamByName('PropertyID').AsInteger := PropertyID;
    FDQuery_Work.ParamByName('AgentID').AsInteger := AgentID;
    FDQuery_Work.ParamByName('ClientID').AsInteger := ClientID;
    FDQuery_Work.ParamByName('ViewingDate').AsDateTime := ViewingDate;
    try
      FDQuery_Work.ExecSQL;
      FDConnection1.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        FDConnection1.Rollback;
        ShowMessage('Error inserting viewing: ' + E.Message);
      end;
    end;
  end;
end;


end.
