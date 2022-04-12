program Sandbox;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  MockaPi in 'MockaPi.pas',
  MockaPi.Attributes in 'MockaPi.Attributes.pas',
  System.RTTI.Helpers in 'System.RTTI.Helpers.pas',
  System.RTTI;

type
  TTestB = record
  public
    [MockaPiInteger(0, 9)]
    aaa: Integer;
  end;

  TTest = record
  public
    B: TTestB;
    [MockaPiStringEng(3)]
    StringValue: string;
    [MockaPiInteger(1000, 9999)]
    IntValue: Integer;
    [MockaPiPhoneUa('066, 099, 068')]
    PhoneNumber: string;
  end;

  TMockApiGetMe = class
  public
    [MockaPiInt64(Integer.MaxValue, Int64.MaxValue)]
    id: Int64;
    [MockaPiBoolean]
    is_bot: Boolean;
    [MockaPiStringFromFile('..\..\Resources\NameDatabases\NamesDatabases\first names\all.txt')]
    first_name: string;
    [MockaPiStringFromFile('..\..\Resources\NameDatabases\NamesDatabases\surnames\all.txt')]
    last_name: string;
    [MockaPiStringFromFile('..\..\Resources\NameDatabases\NamesDatabases\surnames\all.txt')]
    username: string;
  end;

procedure Test;
var
  LMockApi: TMockaPi;
  LTest: TTest;

  kk: TMockApiGetMe;
begin
  LMockApi := TMockaPi.Create;
  kk := TMockApiGetMe.Create;
  try
    LMockApi.Populate<TMockApiGetMe>(kk);
  finally
    LMockApi.Free;
  end;
end;

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    Test;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
