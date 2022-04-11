unit MockaPi;

interface

{123456789a123456789b123456789c123456789d123456789e}
{          Доброго вечора, Ми з України!           }
{123456789a123456789b123456789c123456789d123456789e}
{                   MockaPi                        }
{        Бібліотека для заповнення структур        }
{      випадковими значеннями, через атрибути      }
{123456789a123456789b123456789c123456789d123456789e}

uses
  System.Rtti;

type

  TMockaPi = class
  private
    FRttiContext: TRttiContext;
  protected
    procedure PopulateRecord(var AValue: TValue; ARecord: TRttiRecordType);
    procedure PopulateClass(var AValue: TValue; AType: TRttiType);
    procedure ProcessField(var AValue: TValue; AField: TRttiField);
  public
    constructor Create;
    procedure Populate(var AResult: TValue); overload;
    procedure Populate<T>(var AResult: T); overload;
    destructor Destroy; override;
  end;

implementation

uses
  MockaPi.Attributes,
  System.JSON.Serializers,
  System.Rtti.Helpers,
  System.SysUtils;

{ TMockaPi }

constructor TMockaPi.Create;
begin
  FRttiContext := TRttiContext.Create;
end;

destructor TMockaPi.Destroy;
begin
  FRttiContext.Free;
  inherited;
end;

procedure TMockaPi.Populate(var AResult: TValue);
begin
  case AResult.Kind of
    tkClass:
      PopulateClass(AResult, FRttiContext.GetType(AResult.TypeInfo));
    tkRecord, tkMRecord:
      PopulateRecord(AResult, FRttiContext.GetType(AResult.TypeInfo).AsRecord);
  end;
end;

procedure TMockaPi.Populate<T>(var AResult: T);
var
  lValue: TValue;
begin
  lValue := TValue.From<T>(AResult);
  Populate(lValue);
  AResult := lValue.AsType<T>;
end;

procedure TMockaPi.PopulateClass(var AValue: TValue; AType: TRttiType);
begin
  for var lField in AType.GetFields do
    ProcessField(AValue, lField);
end;

procedure TMockaPi.PopulateRecord(var AValue: TValue; ARecord: TRttiRecordType);
begin
  for var lField in ARecord.GetFields do
    ProcessField(AValue, lField);
end;

procedure TMockaPi.ProcessField(var AValue: TValue; AField: TRttiField);
var
  LValProv: IJsonValueProvider;
begin
  LValProv := TJsonFieldValueProvider.Create(AField);
  if AField.FieldType.TypeKind in [tkRecord, tkMRecord, tkClass] then
  begin
    var
    lValue := LValProv.GetValue(AValue);
    PopulateRecord(lValue, FRttiContext.GetType(lValue.TypeInfo).AsRecord);
    LValProv.SetValue(AValue, lValue);
    Exit;
  end;
  for var lAttr in AField.GetAttributes do
    if lAttr is MockaPiAttribute then
    begin
      LValProv.SetValue(AValue, (lAttr as MockaPiAttribute).Generate);
    end;
end;

end.
