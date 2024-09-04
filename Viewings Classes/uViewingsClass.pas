unit uViewingsClass;

interface
type
  TViewing = class
  private
    FViewingID: Integer;
    FPropertyID: Integer;
    FAgentID: Integer;
    FClientID: Integer;
    FViewingDate: TDateTime;

    procedure SetViewingID(Value: Integer);
    procedure SetPropertyID(Value: Integer);
    procedure SetAgentID(Value: Integer);
    procedure SetClientID(Value: Integer);
    procedure SetViewingDate(Value: TDateTime);
  public
    constructor Create(AViewingID, APropertyID, AAgentID, AClientID: Integer; AViewingDate: TDateTime);

    // Properties
    property ViewingID: Integer read FViewingID write SetViewingID;
    property PropertyID: Integer read FPropertyID write SetPropertyID;
    property AgentID: Integer read FAgentID write SetAgentID;
    property ClientID: Integer read FClientID write SetClientID;
    property ViewingDate: TDateTime read FViewingDate write SetViewingDate;
  end;

implementation

{ TViewing }

constructor TViewing.Create(AViewingID, APropertyID, AAgentID, AClientID: Integer; AViewingDate: TDateTime);
begin
  FViewingID := AViewingID;
  FPropertyID := APropertyID;
  FAgentID := AAgentID;
  FClientID := AClientID;
  FViewingDate := AViewingDate;
end;

procedure TViewing.SetViewingID(Value: Integer);
begin
  FViewingID := Value;
end;

procedure TViewing.SetPropertyID(Value: Integer);
begin
  FPropertyID := Value;
end;

procedure TViewing.SetAgentID(Value: Integer);
begin
  FAgentID := Value;
end;

procedure TViewing.SetClientID(Value: Integer);
begin
  FClientID := Value;
end;

procedure TViewing.SetViewingDate(Value: TDateTime);
begin
  FViewingDate := Value;
end;

end.
