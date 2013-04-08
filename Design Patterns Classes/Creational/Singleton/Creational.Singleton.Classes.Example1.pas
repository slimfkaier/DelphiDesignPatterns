unit Creational.Singleton.Classes.Example1;

interface

type
  TSingleton<T: class, constructor> = class
  strict private
    class var
      FInstance: T;
  private
    class function GetInstance: T; static;
  public
    class property Instance: T read GetInstance;
  end;

implementation

{ TSingleton<T> }

class function TSingleton<T>.GetInstance: T;
begin
  if not Assigned(FInstance) then
    FInstance := T.Create;
  Result := FInstance;
end;

end.

