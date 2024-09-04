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
  Result := 0; // По подразбиране, ако няма резултат

  with DM do
  begin
    // Уверете се, че връзката е активна
    if not DM.FDConnection1.Connected then
      DM.FDConnection1.Connected := True;

    // Настройка и изпълнение на заявка за броене на гледанията
    FDQuery_Work.SQL.Clear;
    FDQuery_Work.SQL.Add('SELECT COUNT(*) AS ViewingCount FROM VIEWINGS');
    FDQuery_Work.SQL.Add('WHERE CLIENTID = :ClientID AND PROPERTYID = :PropertyID');
    FDQuery_Work.ParamByName('ClientID').AsInteger := ClientID;
    FDQuery_Work.ParamByName('PropertyID').AsInteger := PropertyID;
    FDQuery_Work.Open;

    // Проверка на резултата
    if not FDQuery_Work.IsEmpty then
      Result := FDQuery_Work.FieldByName('ViewingCount').AsInteger;

    // Затваряне на заявката
    FDQuery_Work.Close;
  end;
end;

function InsertViewing(PropertyID, AgentID, ClientID: Integer; ViewingDate: TDateTime): Boolean;
begin
  Result := False; // По подразбиране, ако не успее

  with DM do
  begin
    // Уверете се, че връзката е активна
    if not FDConnection1.Connected then
      FDConnection1.Connected := True;

    // Настройка и изпълнение на заявка за вмъкване
    FDQuery_Work.SQL.Clear;
    FDQuery_Work.SQL.Add('INSERT INTO VIEWINGS (PROPERTYID, AGENTID, CLIENTID, VIEWINGDATE)');
    FDQuery_Work.SQL.Add('VALUES (:PropertyID, :AgentID, :ClientID, :ViewingDate)');

    // Задаване на параметрите на заявката
    FDQuery_Work.ParamByName('PropertyID').AsInteger := PropertyID;
    FDQuery_Work.ParamByName('AgentID').AsInteger := AgentID;
    FDQuery_Work.ParamByName('ClientID').AsInteger := ClientID;
    FDQuery_Work.ParamByName('ViewingDate').AsDateTime := ViewingDate;

    try
      // Изпълнение на SQL заявката
      FDQuery_Work.ExecSQL;

      // Потвърдете транзакцията
      FDConnection1.Commit;

      Result := True; // Успешно вмъкване
    except
      on E: Exception do
      begin
        // Връщане на транзакцията при грешка
        FDConnection1.Rollback;

        // Показване на съобщение за грешка (може да се премахне или промени)
        ShowMessage('Error inserting viewing: ' + E.Message);
      end;
    end;
  end;
end;


end.
