unit System.Rtti.Helpers;

interface

uses
  System.Rtti;

type
  TRttiNamedObjectHelper = class helper for TRttiNamedObject
  public
    function GetRttiPath(const ADelimeter: string = '.'): string;
  end;

  TRttiObjectHelper = class helper for TRttiObject
  public
    function FindAttributesByType<T: TCustomAttribute>: TArray<T>;
  end;

implementation

uses
  System.SysUtils;

{ TRttiNamedObjectHelper }

function TRttiNamedObjectHelper.GetRttiPath(const ADelimeter: string): string;
var
  LMember: TRttiNamedObject;
begin
  LMember := Self;
  Result := '';
  while LMember <> nil do
  begin
    Result := LMember.Name + ADelimeter + Result;
    LMember := LMember.Parent as TRttiNamedObject;
  end;
  Result := Result.Remove(Result.Length - 1);
end;

{ TRttiObjectHelper }

function TRttiObjectHelper.FindAttributesByType<T>: TArray<T>;
var
  LCurrentAttribute: TCustomAttribute;
begin
  Result := nil;
  for LCurrentAttribute in GetAttributes do
    if LCurrentAttribute is T then
      Result := Result + [LCurrentAttribute as T];
end;

end.
