unit uAgencyClasses;

interface
  uses
    System.SysUtils, Classes;
type
  TAgency = class
  private
    FID: LongInt;
    FName: string;
    FAddress: string;
    FPhoneNumber: string;
  public
    constructor Create(const AName, AAddress, APhoneNumber: string); overload;
    constructor Create(const AID: LongInt; const AName, AAddress, APhoneNumber: string); overload;

    function ToString: string; override;

    property ID: LongInt read FID write FID;
    property Name: string read FName write FName;
    property Address: string read FAddress write FAddress;
    property PhoneNumber: string read FPhoneNumber write FPhoneNumber;

  end;


implementation

{ TAgency }

constructor TAgency.Create(const AName, AAddress, APhoneNumber: string);
begin
  FName := AName;
  FAddress := AAddress;
  FPhoneNumber := APhoneNumber;
end;

constructor TAgency.Create(const AID: LongInt; const AName, AAddress, APhoneNumber: string);
begin
  FID := AID;
  Create(AName, AAddress, APhoneNumber);
end;

function TAgency.ToString: string;
begin
  Result := Format('Agency Name: %s, Address: %s, Phone: %s', [FName, FAddress, FPhoneNumber]);
end;


end.
