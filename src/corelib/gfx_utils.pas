unit gfx_utils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, gfxbase;

// *** Platform specific functions ***

function  fpgToOSEncoding(aString: TfpgString): string;
function  fpgFromOSEncoding(aString: string): TfpgString;
procedure fpgOpenURL(const aURL: TfpgString);


// *** Common functions for all platforms ***

function  fpgAddTrailingValue(const ALine, AValue: TfpgString; ADuplicates: boolean = true): TfpgString;


// RTL wrapper filesystem functions with platform independant encoding
// These functions are common for all platforms and rely on fpgXXXPlatformEncoding

function  fpgFindFirst(const Path: TfpgString; Attr: Longint; out Rslt: TSearchRec): Longint;
function  fpgFindNext(var Rslt: TSearchRec): Longint;
function  fpgGetCurrentDir: TfpgString;
function  fpgSetCurrentDir(const NewDir: TfpgString): Boolean;
function  fpgExpandFileName(const FileName: TfpgString): TfpgString;
function  fpgFileExists(const FileName: TfpgString): Boolean;



implementation

{ No USES clause is allowed here! Add it to the include file shown below. }


// Platform specific encoding handling functions
{$I gfx_utils_impl.inc}



function fpgAddTrailingValue(const ALine, AValue: TfpgString; ADuplicates: boolean = true): TfpgString;
begin
  if ALine = '' then
  begin
    result := ALine;
    Exit; //==>
  end;

  if ADuplicates then
  begin
    result := ALine + AValue;
    Exit; //==>
  end;

  if (not SameText(Copy(ALine, Length(ALine) - Length(AValue) + 1, Length(AValue)), AValue)) then
    result := ALine + AValue
  else
    result := ALine;
end;

function fpgFindFirst(const Path: TfpgString; Attr: Longint; out
  Rslt: TSearchRec): Longint;
begin
  Result := FindFirst(fpgToOSEncoding(Path), Attr, Rslt);
  Rslt.Name := fpgFromOSEncoding(Rslt.Name);
end;

function fpgFindNext(var Rslt: TSearchRec): Longint;
begin
  Result := FindNext(Rslt);
  Rslt.Name := fpgFromOSEncoding(Rslt.Name);
end;

function fpgGetCurrentDir: TfpgString;
begin
  Result := fpgFromOSEncoding(GetCurrentDir);
end;

function fpgSetCurrentDir(const NewDir: TfpgString): Boolean;
begin
  Result := SetCurrentDir(fpgToOSEncoding(NewDir));
end;

function fpgExpandFileName(const FileName: TfpgString): TfpgString;
begin
  Result := fpgFromOSEncoding(ExpandFileName(fpgToOSEncoding(FileName)));
end;

function fpgFileExists(const FileName: TfpgString): Boolean;
begin
  Result := FileExists(fpgToOSEncoding(FileName));
end;


end.

