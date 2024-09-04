unit uClientClass;

interface

  type
  TClient = class
  private
    FClientID: Integer;
    FName: string;
    FPhoneNumber: string;
    FClientType: Integer;
    FBudget: Double;
    FPropertyID: Integer;

  public
    // Конструктор и деструктор
    constructor Create(AClientID: Integer; AName, APhoneNumber: string; AClientType: Integer; ABudget: Double; APropertyID: Integer); overload;
    constructor Create(AName, APhoneNumber: string; AClientType: Integer; ABudget: Double; APropertyID: Integer); overload;

    // Свойства за достъп
    property ClientID: Integer read FClientID write FClientID;
    property Name: string read FName write FName;
    property PhoneNumber: string read FPhoneNumber write FPhoneNumber;
    property ClientType: Integer read FClientType write FClientType;
    property Budget: Double read FBudget write FBudget;
    property PropertyID: Integer read FPropertyID write FPropertyID;
  end;

implementation

{ TClient }

constructor TClient.Create(AName, APhoneNumber: string; AClientType: Integer; ABudget: Double; APropertyID: Integer);
begin
  FName := AName;
  FPhoneNumber := APhoneNumber;
  FClientType := AClientType;
  FBudget := ABudget;
  FPropertyID := APropertyID;
end;

constructor TClient.Create(AClientID: Integer; AName, APhoneNumber: string; AClientType: Integer; ABudget: Double; APropertyID: Integer);
begin
  Create(AName, APhoneNumber, AClientType, ABudget, APropertyID);
  FClientID := AClientID;
end;

end.
