unit FormDecorator.Classes;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  System.Generics.Defaults,
  System.UITypes,
  FMX.Types,
  FMX.Controls,
  FMX.Objects,
  FMX.Forms,
  FMX.Edit;

type
  ISSFormCreator = interface
    ['{AD70C39F-365C-4655-B629-33D34E873A19}']
    function GetForm(AOwner: TComponent): TForm; overload;
    function GetForm(AOwner: TComponent; ACaption: String): TForm; overload;
  end;

  TSSSimpleForm = class(TInterfacedObject, ISSFormCreator)
  public
    function GetForm(AOwner: TComponent): TForm; overload;
    function GetForm(AOwner: TComponent; ACaption: String): TForm; overload;
  end;

  TSSDecoratorForm = class(TInterfacedObject, ISSFormCreator)
  private
    FWrappedForm: ISSFormCreator;
  protected
    function CreateGenericComponent(AClass: TFmxObjectClass; AForm: TForm): TFmxObject;
  public
    constructor Create(AWrappedForm: ISSFormCreator); reintroduce;
    function GetForm(AOwner: TComponent): TForm; overload; virtual;
    function GetForm(AOwner: TComponent; ACaption: String): TForm; overload; virtual;
  end;

  TSSDecoratorFormButtonEdit = class(TSSDecoratorForm)
  public
    function GetForm(AOwner: TComponent): TForm; override;
  end;

  TSSDecoratorFormBackground = class(TSSDecoratorForm)
  public
    function GetForm(AOwner: TComponent): TForm; override;
  end;

  TSSDecoratorFormToolbar = class(TSSDecoratorForm)
    function GetForm(AOwner: TComponent): TForm; override;
  end;

  TSSDecoratorFormShapes = class(TSSDecoratorForm)
    function GetForm(AOwner: TComponent): TForm; override;
  end;

  TSSDecoratorFormClass = class of TSSDecoratorForm;

  TSSFormBuilder = class
    class function GetFormCreator(ADecoratorFormArray: array of TSSDecoratorFormClass): ISSFormCreator;
  end;

implementation

{ TSSimpleForm }

function TSSSimpleForm.GetForm(AOwner: TComponent): TForm;
begin
  Result := TForm.CreateNew(Application);
  Result.Height   := 500;
  Result.Width    := 600;
  Result.Position := TFormPosition.poScreenCenter;
end;

function TSSSimpleForm.GetForm(AOwner: TComponent; ACaption: String): TForm;
begin
  Result := GetForm(AOwner);
  Result.Caption := ACaption;
end;

{ TSSFormDecorator }

constructor TSSDecoratorForm.Create(AWrappedForm: ISSFormCreator);
begin
  inherited Create;
  FWrappedForm := AWrappedForm;
end;

function TSSDecoratorForm.GetForm(AOwner: TComponent): TForm;
begin
  Result := FWrappedForm.GetForm(AOwner);
end;

function TSSDecoratorForm.CreateGenericComponent(AClass: TFmxObjectClass; AForm: TForm): TFmxObject;

    function GetComponentName: String;
    var
      I, ClassCount: Integer;
    begin
      ClassCount := 0;
      for I := 0 to AForm.ComponentCount - 1 do
      begin
        if AForm.Components[I] is AClass then
          Inc(ClassCount);
      end;
      Result := AClass.ClassName.Remove(0, 1) + IntToStr(ClassCount);
    end;

begin
  Result        := AClass.Create(AForm);
  Result.Parent := AForm;
  Result.Name   := GetComponentName;
end;

function TSSDecoratorForm.GetForm(AOwner: TComponent; ACaption: String): TForm;
begin
  Result := GetForm(AOwner);
  Result.Caption := ACaption;
end;

{ TSSFormDecoratorButton }

function TSSDecoratorFormButtonEdit.GetForm(AOwner: TComponent): TForm;

    procedure AddButton;
    var
      Button: TButton;
    begin
      Button := TButton(CreateGenericComponent(TButton, Result));
      Button.Position.X := 230.0;
      Button.Position.Y := 180.0;
    end;

    procedure AddEdit;
    var
      Edit: TEdit;
    begin
      Edit := TEdit(CreateGenericComponent(TEdit, Result));
      Edit.Position.X := 220.0;
      Edit.Position.Y := 150.0;
    end;

begin
  Result := inherited;
  AddButton;
  AddEdit;
end;

{ TSSFormDecoratorBackground }

function TSSDecoratorFormBackground.GetForm(AOwner: TComponent): TForm;

    procedure AddRectangle;
    var
      Rectangle: TRectangle;
    begin
      Rectangle            := TRectangle(CreateGenericComponent(TRectangle, Result));
      Rectangle.Align      := TAlignLayout.alClient;
      Rectangle.Fill.Color := TAlphaColorRec.Green;
    end;

begin
  Result := inherited;
  AddRectangle;
end;

{ TSSFormDecoratorToolbar }

function TSSDecoratorFormToolbar.GetForm(AOwner: TComponent): TForm;

    procedure AddToolBar;
    var
      Toolbar: TToolbar;
    begin
      Toolbar       := TToolbar(CreateGenericComponent(TToolbar, Result));
      Toolbar.Align := TAlignLayout.alTop;
    end;

begin
  Result := inherited;
  AddToolBar;
end;

{ TSSFormBuilder }

class function TSSFormBuilder.GetFormCreator(
  ADecoratorFormArray: array of TSSDecoratorFormClass): ISSFormCreator;
var
  I: Integer;
begin
  Result := TSSSimpleForm.Create;
  for I := High(ADecoratorFormArray) downto Low(ADecoratorFormArray) do
    Result := ADecoratorFormArray[I].Create(Result);
end;

{ TSSDecoratorFormShapes }

function TSSDecoratorFormShapes.GetForm(AOwner: TComponent): TForm;

    procedure AddRectangle;
    var
      Rectangle: TRectangle;
    begin
      Rectangle            := TRectangle(CreateGenericComponent(TRectangle, Result));
      Rectangle.Fill.Color := TAlphaColorRec.Red;
      Rectangle.Align      := TAlignLayout.alClient;
    end;

    procedure AddCircle;
    var
      Circle: TCircle;
    begin
      Circle            := TCircle(CreateGenericComponent(TCircle, Result));
      Circle.Fill.Color := TAlphaColorRec.Yellow;
      Circle.Align      := TAlignLayout.alClient;
    end;

begin
  Result := inherited;
  AddRectangle;
  AddCircle;
end;

end.
