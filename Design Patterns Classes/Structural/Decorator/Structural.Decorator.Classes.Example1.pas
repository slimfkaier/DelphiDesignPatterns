unit Structural.Decorator.Classes.Example1;

interface

uses
  System.Generics.Defaults,
  System.Generics.Collections,
  VCL.Dialogs;

type
  IPizza = interface
    ['{8647AD34-9971-4A9B-BD96-0960A15C60D3}']
    function GetDescription: String;
    function GetCost: Double;
    property Cost: Double read GetCost;
    property Description: String read GetDescription;
  end;

  TPlainPizza = class(TInterfacedObject, IPizza)
  public
    function GetDescription: String; virtual;
    function GetCost: Double; virtual;
  end;

  TToppingDecorator = class abstract(TInterfacedObject, IPizza)
  private
    FTempPizza: IPizza;
  public
    function GetDescription: String; virtual;
    function GetCost: Double; virtual;
  public
    constructor Create(aNewPizza: IPizza); reintroduce;
  end;

  TMozzarella = class(TToppingDecorator)
  public
    function GetDescription: String; override;
    function GetCost: Double; override;
  end;

  TThreeCheese = class(TToppingDecorator)
  public
    function GetDescription: String; override;
    function GetCost: Double; override;
  end;

  TTomatoSauce = class(TToppingDecorator)
  public
    function GetDescription: String; override;
    function GetCost: Double; override;
  end;

implementation

{ TPlainPizza }

function TPlainPizza.GetCost: Double;
begin
  Result := 4.00;
end;

function TPlainPizza.GetDescription: String;
begin
  Result := 'Thin dough';
end;

{ TToppingPizza }

constructor TToppingDecorator.Create(aNewPizza: IPizza);
begin
  inherited Create;
  FTempPizza := aNewPizza;
end;

function TToppingDecorator.GetCost: Double;
begin
  Result := FTempPizza.GetCost;
end;

function TToppingDecorator.GetDescription: String;
begin
  Result := FTempPizza.GetDescription;
end;

{ TMozzarella }

function TMozzarella.GetCost: Double;
begin
  Result := inherited + 0.50;
end;

function TMozzarella.GetDescription: String;
begin
  Result := inherited + ', mozzarella';
end;

{ TThreeCheese }

function TThreeCheese.GetCost: Double;
begin
  Result := inherited + 10.50;
end;

function TThreeCheese.GetDescription: String;
begin
  Result := inherited + ', mozzarella, fontina, parmesan cheese pizza';
end;

{ TTomatoSauce }

function TTomatoSauce.GetCost: Double;
begin
  Result := inherited + 0.35;
end;

function TTomatoSauce.GetDescription: String;
begin
  Result := inherited + ', tomato sauce';
end;

end.
