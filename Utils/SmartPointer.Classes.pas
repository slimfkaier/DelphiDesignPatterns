unit SmartPointer.Classes;

interface

uses
  SysUtils;

type
  TSmartPointer<T: class, constructor> = record
  strict private
    class var
      FInstance: T;
    constructor Create(const aValue: T); overload;
    class destructor Destroy;
    class function GetInstance: T; static;
  public
    class operator Implicit(const AValue: T): TSmartPointer<T>; overload;
    class operator Implicit(const AValue: TSmartPointer<T>): T; overload;
    class property Instance: T read GetInstance;
  end;

implementation

{ TSmartPointer<T> }

constructor TSmartPointer<T>.Create(const aValue: T);
begin
  FInstance := aValue;
end;

class destructor TSmartPointer<T>.Destroy;
begin
  if Assigned(PPointer(@FInstance)^) then
    FreeAndNil(FInstance);
  inherited;
end;

class function TSmartPointer<T>.GetInstance: T;
begin
  if not Assigned(PPointer(@FInstance)^) then
    FInstance := T.Create;
  Result := FInstance;
end;

class operator TSmartPointer<T>.Implicit(const AValue: TSmartPointer<T>): T;
begin
  inherited;
  FInstance := aValue.Instance;
end;

class operator TSmartPointer<T>.Implicit(const AValue: T): TSmartPointer<T>;
begin
  Result := TSmartPointer<T>.Create(AValue);
end;

end.
