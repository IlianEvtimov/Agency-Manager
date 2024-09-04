unit uAgentClass;

interface
   uses
    System.SysUtils;
 type
  TAgent = class
  private
    FAgentID: LongInt;
    FName: string;
    FPhoneNumber: string;
    FAgencyID: LongInt;
  public
    constructor Create; overload;
    constructor Create(const AAgentID: LongInt; const AName, APhoneNumber: string; const AAgencyID: LongInt); overload;
    constructor Create(const AName, APhoneNumber: string; const AAgencyID: Integer); overload;
    property AgentID: LongInt read FAgentID write FAgentID;
    property Name: string read FName write FName;
    property PhoneNumber: string read FPhoneNumber write FPhoneNumber;
    property AgencyID: LongInt read FAgencyID write FAgencyID;

  end;
implementation

constructor TAgent.Create;
begin
  inherited Create;
  FAgentID := 0;
  FName := '';
  FPhoneNumber := '';
  FAgencyID := 0;
end;

constructor TAgent.Create(const AName, APhoneNumber: string; const AAgencyID: Integer);
begin
  inherited Create;
  FName := AName;
  FPhoneNumber := APhoneNumber;
  FAgencyID := AAgencyID;
end;

constructor TAgent.Create(const AAgentID: LongInt; const AName, APhoneNumber: string; const AAgencyID: LongInt);
begin
  inherited Create;
  FAgentID := AAgentID;
  FName := AName;
  FPhoneNumber := APhoneNumber;
  FAgencyID := AAgencyID;
end;

end.
