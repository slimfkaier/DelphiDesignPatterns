unit Creational.Factory.Classes.Example1;

interface

type
  TVehicles = (vCar, vBus, vBicycle);

  TVehicle = class abstract
  public
    function GetName: String; virtual; abstract;
  end;

  TCar = class(TVehicle)
  public
    function GetName: String; override;
  end;

  TBus = class(TVehicle)
  public
    function GetName: String; override;
  end;

  TBicycle = class(TVehicle)
  public
    function GetName: String; override;
  end;

  TVehicleFactory = class
  public
    class function GetVehicle(aVehicleType: TVehicles): TVehicle;
  end;

implementation

{ TCar }

function TCar.GetName: String;
begin
  Result := 'I''m a car.';
end;

{ TBus }

function TBus.GetName: String;
begin
  Result := 'I''m a bus.';
end;

{ TBicycle }

function TBicycle.GetName: String;
begin
  Result := 'I''m a bicycle.';
end;

{ TVehicleFactory }

class function TVehicleFactory.GetVehicle(aVehicleType: TVehicles): TVehicle;
begin
  case aVehicleType of
    vCar:
      Result := TCar.Create;
    vBus:
      Result := TBus.Create;
    vBicycle:
      Result := TBicycle.Create;
    else
      Result := nil;
  end;
end;

end.
