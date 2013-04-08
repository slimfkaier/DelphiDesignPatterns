unit DesignPatternsTests;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Math,
  TestFrameWork,
  ObjectHelper.Classes,
  SmartPointer.Classes,
  Behavioral.Observer.Classes.Example1,
  Behavioral.Strategy.Classes.Example1,
  Creational.Builder.Classes.Example1,
  Creational.Factory.Classes.Example1,
  Creational.Prototype.Classes.Example1,
  Creational.Singleton.Classes.Example1,
  Structural.Decorator.Classes.Example1,
  Structural.Decorator.Classes.Example2;

type
  TSmartPointerTest = class(TTestCase)
  published
    procedure TestSmartPointer;
  end;

  TBehavioralStrategyExample1Test = class(TTestCase)
  private
    Pwd: TPassword;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestStrategy;
  end;

  TBehavioralObserverExample1Test = class(TTestCase)
  private
    YouTube: TYouTube;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestObserver;
  end;

  TCreationalFactoryExample1Test = class(TTestCase)
  published
    procedure TestFactory;
  end;

  TCreationalSingletonExample1Test = class(TTestCase)
  published
    procedure TestSingleton;
  end;

  TStructuralDecoratorExample1Test = class(TTestCase)
  published
    procedure TestDecorator;
  end;

  TStructuralDecoratorExample2Test = class(TTestCase)
  published
    procedure TestDecorator;
  end;

  TCreationalBuilderExample1Test = class(TTestCase)
  published
    procedure TestBuilder;
  end;

  TCreationalPrototypeExample1Test = class(TTestCase)
  published
    procedure TestPrototype;
  end;

implementation

uses
  IWTestFramework, Vcl.Dialogs, System.Generics.Collections;

{ TSmartPointerTest }

procedure TSmartPointerTest.TestSmartPointer;
var
  GenericList: TSmartPointer<TStringList>;
  List: TStringList;
begin
//  GenericList := TStringList.Create; { Unnecessary, but it's possible }
  CheckEquals(True, Assigned(GenericList.Instance), 'Error on check Assigned');
  GenericList.Instance.Add('Foo');
  GenericList.Instance.Add('Bar');
  CheckEquals('Foo', GenericList.Instance[0], 'Error on item 1');
  CheckEquals('Bar', GenericList.Instance[1], 'Error on item 2');
  GenericList.Instance.Add('Qux');
  CheckEquals('Qux', GenericList.Instance[2], 'Error on item 3');
  List := TStringList.Create;
  List.Add('1, 2, 3');
  GenericList := List;
  CheckEquals('1, 2, 3', GenericList.Instance[0], 'Error on pointer to "native" object');
  GenericList.Instance.Add('9, 8, 7');
  CheckEquals('9, 8, 7', List[1], 'Error on read values from "native" object');
//  List.Free; { Cannot free the variable List here 'cause its pointer is pointing to GenericList.Instance }
end;

{ TSSStrategyTest }

procedure TBehavioralStrategyExample1Test.SetUp;
begin
  inherited;
  Pwd := TPassword.Create('Helton');
end;

procedure TBehavioralStrategyExample1Test.TearDown;
begin
  inherited;
  Pwd.Free;
end;

procedure TBehavioralStrategyExample1Test.TestStrategy;
begin
  CheckEquals('Helton', Pwd.GetEncryptedKey, 'Error on encryption key - TSSNoEncryption [initialization]');
  CheckEquals('None encryption', Pwd.GetEncryptionId, 'Error on encryption id - TSSNoEncryption [initialization]');

  Pwd.Encryption := TEncryptionToUpper.Create;
  CheckEquals('HELTON', Pwd.GetEncryptedKey, 'Error on encryption key - TSSEncryptionToUpper');
  CheckEquals('ToUpper encryption', Pwd.GetEncryptionId, 'Error on encryption id - TSSEncryptionToUpper');

  Pwd.Encryption := TEncryptionToLower.Create;
  CheckEquals('helton', Pwd.GetEncryptedKey, 'Error on encryption key - TSSEncryptionToLower');
  CheckEquals('ToLower encryption' ,Pwd.GetEncryptionId, 'Error on encryption id - TSSEncryptionToLower');
end;

{ TSSObserverTest }

procedure TBehavioralObserverExample1Test.SetUp;
begin
  inherited;
  YouTube := TYouTube.Create;
end;

procedure TBehavioralObserverExample1Test.TearDown;
begin
  inherited;
  FreeAndNil(YouTube);
end;

procedure TBehavioralObserverExample1Test.TestObserver;
var
  Person1, Person2: TPerson;
begin
  Person1 := TPerson.Create('John', [vtGame, vtComedy]);
  Person2 := TPerson.Create('Peter', [vtSports]);
  try
    YouTube.RegisterObserver(Person1);
    YouTube.RegisterObserver(Person2);
    YouTube.AddVideo(TVideo.Create('Video de com�dia 1', vtComedy));
    YouTube.AddVideo(TVideo.Create('Video de games 1', vtGame));
    YouTube.AddVideo(TVideo.Create('Video de esportes 1', vtSports));
    YouTube.AddVideo(TVideo.Create('Video de esportes 2', vtSports));
    YouTube.AddVideo(TVideo.Create('Video de games 2', vtGame));
    YouTube.AddVideo(TVideo.Create('Video de com�dia 2', vtComedy));
    CheckEquals('YouTube Videos'+sLineBreak+
                '=========='+sLineBreak+
                'Name: Video de com�dia 1'+sLineBreak+
                'VideoType: vtComedy'+sLineBreak+
                '=========='+sLineBreak+
                'Name: Video de games 1'+sLineBreak+
                'VideoType: vtGame'+sLineBreak+
                '=========='+sLineBreak+
                'Name: Video de esportes 1'+sLineBreak+
                'VideoType: vtSports'+sLineBreak+
                '=========='+sLineBreak+
                'Name: Video de esportes 2'+sLineBreak+
                'VideoType: vtSports'+sLineBreak+
                '=========='+sLineBreak+
                'Name: Video de games 2'+sLineBreak+
                'VideoType: vtGame'+sLineBreak+
                '=========='+sLineBreak+
                'Name: Video de com�dia 2'+sLineBreak+
                'VideoType: vtComedy', YouTube.GetVideosList);
    CheckEquals('Videos of "John"'+sLineBreak+
                '=========='+sLineBreak+
                'Name: Video de com�dia 1'+sLineBreak+
                'VideoType: vtComedy'+sLineBreak+
                '=========='+sLineBreak+
                'Name: Video de games 1'+sLineBreak+
                'VideoType: vtGame'+sLineBreak+
                '=========='+sLineBreak+
                'Name: Video de games 2'+sLineBreak+
                'VideoType: vtGame'+sLineBreak+
                '=========='+sLineBreak+
                'Name: Video de com�dia 2'+sLineBreak+
                'VideoType: vtComedy', Person1.GetVideosList);
    CheckEquals('Videos of "Peter"'+sLineBreak+
                '=========='+sLineBreak+
                'Name: Video de esportes 1'+sLineBreak+
                'VideoType: vtSports'+sLineBreak+
                '=========='+sLineBreak+
                'Name: Video de esportes 2'+sLineBreak+
                'VideoType: vtSports', Person2.GetVideosList);
    YouTube.UnregisterObserver(Person1);
    YouTube.AddVideo(TVideo.Create('Video de games 3', vtGame));
    CheckEquals('YouTube Videos'+sLineBreak+
                '=========='+sLineBreak+
                'Name: Video de com�dia 1'+sLineBreak+
                'VideoType: vtComedy'+sLineBreak+
                '=========='+sLineBreak+
                'Name: Video de games 1'+sLineBreak+
                'VideoType: vtGame'+sLineBreak+
                '=========='+sLineBreak+
                'Name: Video de esportes 1'+sLineBreak+
                'VideoType: vtSports'+sLineBreak+
                '=========='+sLineBreak+
                'Name: Video de esportes 2'+sLineBreak+
                'VideoType: vtSports'+sLineBreak+
                '=========='+sLineBreak+
                'Name: Video de games 2'+sLineBreak+
                'VideoType: vtGame'+sLineBreak+
                '=========='+sLineBreak+
                'Name: Video de com�dia 2'+sLineBreak+
                'VideoType: vtComedy'+sLineBreak+
                '=========='+sLineBreak+
                'Name: Video de games 3'+sLineBreak+
                'VideoType: vtGame', YouTube.GetVideosList);
    CheckEquals('Videos of "John"'+sLineBreak+
                '=========='+sLineBreak+
                'Name: Video de com�dia 1'+sLineBreak+
                'VideoType: vtComedy'+sLineBreak+
                '=========='+sLineBreak+
                'Name: Video de games 1'+sLineBreak+
                'VideoType: vtGame'+sLineBreak+
                '=========='+sLineBreak+
                'Name: Video de games 2'+sLineBreak+
                'VideoType: vtGame'+sLineBreak+
                '=========='+sLineBreak+
                'Name: Video de com�dia 2'+sLineBreak+
                'VideoType: vtComedy', Person1.GetVideosList);
  finally
    Person1.Free;
    Person2.Free;
  end;
end;

{ TFactoryTest }

procedure TCreationalFactoryExample1Test.TestFactory;
var
  Vehicle: TVehicle;
begin
  Vehicle := TVehicleFactory.GetVehicle(vCar);
  CheckEquals('I''m a car.', Vehicle.GetName, 'Error on get car vehicle');
  Vehicle.Free;
  Vehicle := TVehicleFactory.GetVehicle(vBus);
  CheckEquals('I''m a bus.', Vehicle.GetName, 'Error on get bus vehicle');
  Vehicle.Free;
  Vehicle := TVehicleFactory.GetVehicle(vBicycle);
  CheckEquals('I''m a bicycle.', Vehicle.GetName, 'Error on get bicycle vehicle');
  Vehicle.Free;
end;

{ TSingletonTest }

procedure TCreationalSingletonExample1Test.TestSingleton;
begin
  TSingleton<TStringList>.Instance.Add('foo, bar, qux');
  CheckEquals('foo, bar, qux', Trim(TSingleton<TStringList>.Instance.Text), 'Error on compare text');
end;

{ TDecoratorExample1Test }

procedure TStructuralDecoratorExample1Test.TestDecorator;
var
  Pizza: IPizza;
begin
  Pizza := TPlainPizza.Create;
  Check(SameValue(4.00, Pizza.Cost), 'Error on pizza cost [Plain Pizza]');
  CheckEquals('Thin dough', Pizza.Description, 'Error on pizza description [Plain Pizza]');

  Pizza := TMozzarella.Create(Pizza);
  Check(SameValue(4.00 + 0.50, Pizza.Cost), 'Error on pizza cost [Mozzarella]');
  CheckEquals('Thin dough, mozzarella', Pizza.Description, 'Error on pizza description [Mozzarella]');

  Pizza := TTomatoSauce.Create(Pizza);
  Check(SameValue(4.00 + 0.50 + 0.35, Pizza.Cost), 'Error on pizza cost [TomatoSauce]');
  CheckEquals('Thin dough, mozzarella, tomato sauce', Pizza.Description, 'Error on pizza description [TomatoSauce]');

  Pizza := TThreeCheese.Create(Pizza);
  Check(SameValue(4.00 + 0.50 + 0.35 + 10.50, Pizza.Cost), 'Error on pizza cost [ThreeCheese]');
  CheckEquals('Thin dough, mozzarella, tomato sauce, mozzarella, fontina, parmesan cheese pizza', Pizza.Description, 'Error on pizza description [ThreeCheese]');
end;

{ TDecoratorExample2Test }

procedure TStructuralDecoratorExample2Test.TestDecorator;
var
  Employee: IEmployee;
begin
  Employee := TEmployeeImpl.Create('John Fox');
  CheckEquals('John Fox joined on 31/03/2013', Employee.Join(EncodeDate(2013, 03, 31)), 'Error on Join method');
  CheckEquals('John Fox terminate on 20/10/2015', Employee.Terminate(EncodeDate(2015, 10, 20)), 'Error on Terminate method');
  Check(SameValue(5000.00, Employee.Salary), 'Error on salary of employee');

  Employee := TTeamMember.Create(Employee);
  CheckEquals('[Team Member] John Fox is coordinating with other members of his team.', TTeamMember(Employee).CoordinateWithOthers, 'Error on CoordinateWithOthers method [Team Member]');
  CheckEquals('[Team Member] John Fox is performing his assigned tasks.', TTeamMember(Employee).PerformTask, 'Error on PerformTask method [Team Member]');
  Check(SameValue(5000.00 + 2000.00, Employee.Salary), 'Error on salary of employee [Team Member]');

  Employee := TTeamLead.Create(Employee);
  CheckEquals('[Team Lead] John Fox is planning.', TTeamLead(Employee).Planning, 'Error on Planning method [Team Lead]');
  CheckEquals('[Team Lead] John Fox is motivating his members.', TTeamLead(Employee).Motivate, 'Error on Motivate method [Team Lead]');
  Check(SameValue(5000.00 + 2000.00 + 3500.00, Employee.Salary), 'Error on salary of employee [Team Lead]');

  Employee := TManager.Create(Employee);
  CheckEquals('[Manager] John Fox is assigning tasks.', TManager(Employee).AssignTasks, 'Error on Planning AssignTasks [Manager]');
  CheckEquals('[Manager] John Fox is profiling employees.', TManager(Employee).ProfileEmployee, 'Error on ProfileEmployee method [Manager]');
  CheckEquals('[Manager] John Fox is creating requirement documents.', TManager(Employee).CreateRequirements, 'Error on CreateRequirements method [Manager]');
  Check(SameValue(5000.00 + 2000.00 + 3500.00 + 5000.00, Employee.Salary), 'Error on salary of employee [Manager]');


  Employee := TManager.Create(TEmployeeImpl.Create('Peter Hansfield'));
  CheckEquals('[Manager] Peter Hansfield is assigning tasks.', TManager(Employee).AssignTasks, 'Error on Planning AssignTasks [Manager]');
  CheckEquals('[Manager] Peter Hansfield is profiling employees.', TManager(Employee).ProfileEmployee, 'Error on ProfileEmployee method [Manager]');
  CheckEquals('[Manager] Peter Hansfield is creating requirement documents.', TManager(Employee).CreateRequirements, 'Error on CreateRequirements method [Manager]');
  Check(SameValue(5000.00 + 5000.00, Employee.Salary), 'Error on salary of employee [Manager]');
end;

{ TCreationalBuilderExample1Test }

procedure TCreationalBuilderExample1Test.TestBuilder;
var
  MealDirector: TMealDirector;
begin
  MealDirector := TMealDirector.Create(TItalianMealBuilder.Create);
  MealDirector.ConstructMeal;
  CheckEquals('Drink.....: Red Wine' + sLineBreak +
              'MainCourse: Pizza' + sLineBreak +
              'Side......: Bread', MealDirector.GetMeal.ToString);
  MealDirector.Free;

  MealDirector := TMealDirector.Create(TJapaneseMealBuilder.Create);
  MealDirector.ConstructMeal;
  CheckEquals('Drink.....: Saque' + sLineBreak +
              'MainCourse: Chicken Teriyaki' + sLineBreak +
              'Side......: Miso Soup', MealDirector.GetMeal.ToString);
  MealDirector.Free;
end;

{ TCreationalPrototypeExample1Test }

procedure TCreationalPrototypeExample1Test.TestPrototype;
var
  Employee, ClonedEmployee: TEmployee;
begin
  Employee                   := TEmployee.Create('Martin Fowler', 'Software Developer', 'Development Department');
  //ClonedEmployee             := TEmployee(Employee.GetClone);
  ClonedEmployee             := Employee.Clone<TEmployee>;
  Employee.Name              := 'Phillip';
  Employee.Job.JobName       := 'Tester';
  Employee.Job.JobDepartment := 'Testing Department';
  CheckEquals('Name..........: Phillip'+sLineBreak+
              'Surname.......: Fowler'+sLineBreak+
              'Job name......: Tester'+sLineBreak+
              'Job department: Testing Department', Employee.ToString, 'Error on GetClone [original object]');
  CheckEquals('Name..........: Martin'+sLineBreak+
              'Surname.......: Fowler'+sLineBreak+
              'Job name......: Software Developer'+sLineBreak+
              'Job department: Development Department', ClonedEmployee.ToString, 'Error on GetClone method [cloned object]');
  Employee.Free;
  ClonedEmployee.Free;
end;

initialization
  RegisterTests([TSmartPointerTest.Suite,
                 TBehavioralStrategyExample1Test.Suite,
                 TBehavioralObserverExample1Test.Suite,
                 TCreationalBuilderExample1Test.Suite,
                 TCreationalFactoryExample1Test.Suite,
                 TCreationalPrototypeExample1Test.Suite,
                 TCreationalSingletonExample1Test.Suite,
                 TStructuralDecoratorExample1Test.Suite,
                 TStructuralDecoratorExample2Test.Suite]);
end.