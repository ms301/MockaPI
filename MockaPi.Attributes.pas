unit MockaPi.Attributes;

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
  MockaPiAttribute = class(TCustomAttribute)
  public
    function Generate: TValue; virtual; abstract;
  end;

  MockaPiNumberAttribute<T> = class(MockaPiAttribute)
  private
    FMin: T;
    FMax: T;
  public
    constructor Create(const AMin, AMax: T);
    property Min: T read FMin write FMin;
    property Max: T read FMax write FMax;
  end;

  MockaPiBooleanAttribute = class(MockaPiAttribute)
  public
    function Generate: TValue; override;
  end;

  MockaPiByteAttribute = class(MockaPiNumberAttribute<Byte>)
  public
    function Generate: TValue; override;
  end;

  MockaPiIntegerAttribute = class(MockaPiNumberAttribute<Integer>)
  public
    function Generate: TValue; override;
  end;

  MockaPiInt64Attribute = class(MockaPiNumberAttribute<Int64>)
  public
    function Generate: TValue; override;
  end;

  MockaPiStringAttribute = class(MockaPiAttribute)
  private
    FLength: Integer;
    FAlphabet: string;
  public
    constructor Create(const ALength: Integer; const AAlphabet: string);
    function Generate: TValue; override;
  end;

  MockaPiStringFromFileAttribute = class(MockaPiAttribute)
  private
    FPosition: Integer;
    FFileName: string;
  public
    constructor Create(const AFileName: string; const APosition: Integer = -1);
    function Generate: TValue; override;
  end;

  MockaPiStringEngAttribute = class(MockaPiStringAttribute)
  private
    FLength: Integer;
  public
    constructor Create(const ALength: Integer);
  end;

  MockaPiPhoneAttribute = class(MockaPiAttribute)
  private
    FKeyOper: TArray<string>;
  protected
    function GetCountryKey: string; virtual; abstract;
    function GetOperKeyRand(const AKeyOper: TArray<string>): string; virtual; abstract;
    function GetPhoneSuffix: string; virtual; abstract;
  public
    constructor Create(const AKeyOper: string);
    function Generate: TValue; override;
  end;

  MockaPiPhoneUaAttribute = class(MockaPiPhoneAttribute)
  protected
    function GetCountryKey: string; override;
    function GetOperKeyRand(const AKeyOper: TArray<string>): string; override;
    function GetPhoneSuffix: string; override;
  end;

implementation

uses
  System.IOUtils,
  System.SysUtils;

{ MockaPiNumberAttribute<T> }

constructor MockaPiNumberAttribute<T>.Create(const AMin, AMax: T);
begin
  FMin := AMin;
  FMax := AMax;
end;

{ MockaPiIntegerAttribute }

function MockaPiIntegerAttribute.Generate: TValue;
begin
  Result := FMin + Random(FMax - FMin);
end;

{ MockaPiInt64Attribute }

function MockaPiInt64Attribute.Generate: TValue;
begin
  Result := FMin + Random(FMax - FMin);
end;

{ MockaPiStringAttribute }

constructor MockaPiStringAttribute.Create(const ALength: Integer; const AAlphabet: string);
begin
  FLength := ALength;
  FAlphabet := AAlphabet;
end;

function MockaPiStringAttribute.Generate: TValue;
var
  LBuffer: string;
  I: Integer;
begin
  for I := 0 to FLength - 1 do
    LBuffer := LBuffer + FAlphabet.Substring(Random(Length(FAlphabet)), 1);
  Result := LBuffer;
end;

function MockaPiPhoneUaAttribute.GetCountryKey: string;
begin
  Result := '+38';
end;

function MockaPiPhoneUaAttribute.GetOperKeyRand(const AKeyOper: TArray<string>): string;
begin
  Result := AKeyOper[Random(Length(AKeyOper) - 1)];
end;

function MockaPiPhoneUaAttribute.GetPhoneSuffix: string;
var
  LStrGen: MockaPiStringAttribute;
begin
  LStrGen := MockaPiStringAttribute.Create(7, '0123456789');
  try
    Result := LStrGen.Generate.AsString;
  finally
    LStrGen.Free;
  end;
end;

{ MockaPiStringEngAttribute }

constructor MockaPiStringEngAttribute.Create(const ALength: Integer);
const
  Alha = 'abcdefghigklmnopqrstuvwxyz';
begin
  inherited Create(ALength, Alha);
end;

{ MockaPiPhoneAttribute }

constructor MockaPiPhoneAttribute.Create(const AKeyOper: string);
begin
  FKeyOper := AKeyOper.Split([',', ' '], TStringSplitOptions.ExcludeEmpty);
end;

function MockaPiPhoneAttribute.Generate: TValue;
var
  LKeyOper: string;
begin
  LKeyOper := GetOperKeyRand(FKeyOper);
  Result := GetCountryKey + LKeyOper + GetPhoneSuffix;
end;

{ MockaPiBooleanAttribute }

function MockaPiBooleanAttribute.Generate: TValue;
var
  LBoolGen: MockaPiByteAttribute;
  LByte: Byte;
begin
  LBoolGen := MockaPiByteAttribute.Create(0, 2);
  try
    LByte := LBoolGen.Generate.AsType<Byte>;
    Result := Boolean(LByte);
  finally
    LBoolGen.Free;
  end;
end;

{ MockaPiByteAttribute }

function MockaPiByteAttribute.Generate: TValue;
begin
  Result := FMin + Random(FMax - FMin);
end;

{ MockaPiStringFromFileAttribute }

constructor MockaPiStringFromFileAttribute.Create(const AFileName: string; const APosition: Integer = -1);
begin
  FPosition := APosition;
  FFileName := AFileName;
end;

function MockaPiStringFromFileAttribute.Generate: TValue;
var
  LLines: TArray<string>;
  LRandom: MockaPiIntegerAttribute;
  LPosition: Integer;
begin
  LLines := TFile.ReadAllLines(FFileName);
  if FPosition < 0 then
  begin
    LRandom := MockaPiIntegerAttribute.Create(0, Length(LLines) - 1);
    try
      LPosition := LRandom.Generate.AsInteger;
    finally
      LRandom.Free;
    end;
  end
  else
    LPosition := FPosition;
  Result := LLines[LPosition];
end;

initialization

Randomize;

end.
