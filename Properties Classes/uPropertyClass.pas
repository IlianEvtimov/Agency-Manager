unit uPropertyClass;

interface
  type
  TProperty = class
  private
    FPropertyID: LongInt;
    FPropertyType: string;
    FAddress: string;
    FPrice: Double;
    FArea: Double;
    FDescription: string;
    FAgentID: LongInt;
  public
    constructor Create(APropertyType, AAddress: string; APrice, AArea: Double; ADescription: string; AAgentID: LongInt); overload;
    constructor Create(APropertyID: LongInt; APropertyType, AAddress: string; APrice, AArea: Double; ADescription: string; AAgentID: LongInt); overload;

    property PropertyType: string read FPropertyType write FPropertyType;
    property Address: string read FAddress write FAddress;
    property Price: Double read FPrice write FPrice;
    property Area: Double read FArea write FArea;
    property Description: string read FDescription write FDescription;
    property PropertyID: LongInt read FPropertyID write FPropertyID;
    property AgentID: LongInt read FAgentID write FAgentID;
  end;

implementation

constructor TProperty.Create(APropertyType, AAddress: string; APrice, AArea: Double; ADescription: string; AAgentID: LongInt);
begin
  FPropertyType := APropertyType;
  FAddress      := AAddress;
  FPrice        := APrice;
  FArea         := AArea;
  FDescription  := ADescription;
  FAgentID      := AAgentID;
end;

constructor TProperty.Create(APropertyID: LongInt; APropertyType, AAddress: string; APrice, AArea: Double; ADescription: string; AAgentID: LongInt);
begin
  Create(APropertyType, AAddress, APrice, AArea, ADescription, AAgentID);
  FPropertyID := APropertyID;
end;

end.
