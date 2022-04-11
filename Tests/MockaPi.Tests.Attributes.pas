unit MockaPi.Tests.Attributes;

interface

uses
  MockaPi.Attributes,
  DUnitX.TestFramework;

type
  [TestFixture]
  TTestGeneratorInteger = class
  private
  public
    [Test]
    [TestCase('TestA', '100')]
    [TestCase('TestB', '300')]
    procedure CheckMaxValue(const AValue1: Integer);
    [Test]
    [TestCase('TestA', '100,300')]
    [TestCase('TestB', '300,1000')]
    procedure CheckMinMaxValue(const AValue1, AValue2: Integer);
    [Test]
    [TestCase('TestB', '20')]
    procedure TestBooleanAttribute(const AValue1: Integer);
  end;

implementation

uses
  System.SysUtils;

procedure TTestGeneratorInteger.CheckMaxValue(const AValue1: Integer);
var
  LGen: MockaPiIntegerAttribute;
  LCurrentValue: Integer;
  I: Integer;
begin
  LGen := MockaPiIntegerAttribute.Create(0, AValue1);
  for I := 0 to 999 do
  begin
    LCurrentValue := LGen.Generate.AsInteger;
    Assert.AreEqual(True, LCurrentValue <= AValue1);
  end;
end;

procedure TTestGeneratorInteger.CheckMinMaxValue(const AValue1, AValue2: Integer);
var
  LGen: MockaPiIntegerAttribute;
  LCurrentValue: Integer;
  I: Integer;
begin
  LGen := MockaPiIntegerAttribute.Create(AValue1, AValue2);
  for I := 0 to 999 do
  begin
    LCurrentValue := LGen.Generate.AsInteger;
    Assert.AreEqual(True, LCurrentValue >= AValue1, LCurrentValue.ToString + ' !>= ' + AValue1.ToString);
    Assert.AreEqual(True, LCurrentValue <= AValue2, LCurrentValue.ToString + ' !<= ' + AValue1.ToString);
  end;

end;

procedure TTestGeneratorInteger.TestBooleanAttribute(const AValue1: Integer);
const
  TOTAL = 1000;
var
  LGen: MockaPiBooleanAttribute;
  I: Integer;
  t, f: Integer;
begin
  t := 0;
  f := 0;
  LGen := MockaPiBooleanAttribute.Create;
  for I := 0 to TOTAL - 1 do
  begin
    if LGen.Generate.AsBoolean then
      inc(t)
    else
      inc(f);
  end;
  Assert.AreEqual(True, t / TOTAL * 100 >= AValue1, t.ToString + '*true !>= ' + AValue1.ToString);
  Assert.AreEqual(True, f / TOTAL * 100 >= AValue1, f.ToString + '*false !>= ' + AValue1.ToString);
end;

initialization

TDUnitX.RegisterTestFixture(TTestGeneratorInteger);

end.
