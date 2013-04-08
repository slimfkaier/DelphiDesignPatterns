unit Main.Form;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Rtti, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Edit,
  FMX.Layouts, FMX.Grid, Data.DB, Datasnap.DBClient, Data.SqlExpr, FMX.Objects;

type
  TForm1 = class(TForm)
    BT_CreateCustomForm: TButton;
    GB_Options: TGroupBox;
    LayoutOptions: TLayout;
    ED_FormCaption: TEdit;
    LB_Caption: TLabel;
    CB_AddGreenBackground: TCheckBox;
    CB_AddShapes: TCheckBox;
    CB_AddButtonEdit: TCheckBox;
    CB_AddToolbar: TCheckBox;
    procedure BT_CreateCustomFormClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  FormDecorator.Classes, System.Math;

{$R *.fmx}

procedure TForm1.BT_CreateCustomFormClick(Sender: TObject);
var
  FormCreator: ISSFormCreator;
  Form: TForm;
  DecoratorFormClassArray: array of TSSDecoratorFormClass;

  procedure AddClassToArray(ADecoratorFormClass: TSSDecoratorFormClass);
  begin
    SetLength(DecoratorFormClassArray, Length(DecoratorFormClassArray)+1);
    DecoratorFormClassArray[High(DecoratorFormClassArray)] := ADecoratorFormClass;
  end;

begin
//  FormCreator := TSSDecoratorFormButtonEdit.Create(
//                    TSSDecoratorFormToolbar.Create(
//                       TSSDecoratorFormBackground.Create(
//                          TSSDecoratorFormToolbar.Create(
//                             TSSSimpleForm.Create))));
//  FormCreator := TSSFormBuilder.GetFormCreator([TSSDecoratorFormButtonEdit,
//                                                TSSDecoratorFormToolbar,
//                                                TSSDecoratorFormBackground,
//                                                TSSDecoratorFormToolbar]);
  if CB_AddToolbar.IsChecked then
    AddClassToArray(TSSDecoratorFormToolbar);
  if CB_AddButtonEdit.IsChecked then
    AddClassToArray(TSSDecoratorFormButtonEdit);
  if CB_AddGreenBackground.IsChecked then
    AddClassToArray(TSSDecoratorFormBackground);
  if CB_AddShapes.IsChecked then
    AddClassToArray(TSSDecoratorFormShapes);
  FormCreator := TSSFormBuilder.GetFormCreator(DecoratorFormClassArray);
  Form := FormCreator.GetForm(nil, ED_FormCaption.Text);
  Form.Show;
end;

end.
