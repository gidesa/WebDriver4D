{ W3C Webdriver library for Delphi

  Copyright (C) 2021 Giandomenico De Sanctis gidesay@yahoo.com

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 51 Franklin Street - Fifth Floor, Boston, MA 02110-1335, USA.
}

unit WebClasses;

interface
uses
  Classes,
  SysUtils,
  Windows,
  System.Generics.Collections,
  JsonDataObjects, webdriverConst;

type


  TBrowserAction = class(TObject)
  private
    FType: TBrowserActionType;
  public
    constructor create();
    function toJson(): string; virtual;
    function toJsonObject(): TJsonObject; virtual;
  end;

  TMouseAction = class(TBrowserAction)
  private
    FAction: TActionPointer;
    FButton: Integer;
    FX: Integer;
    FY: Integer;
    FDuration: Integer;
    FOrigin: string;
  public
    constructor create(const action: TActionPointer);
    function toJsonObject(): TJsonObject; override;
    property x: Integer read FX write FX;
    property y: Integer read FY write FY;
    property button: integer read FButton write FButton;
    property origin: string read FOrigin write FOrigin;
    property duration: Integer read FDuration write FDuration;
  end;

  TKeyboardAction = class(TBrowserAction)
  private
    FAction: TActionKey;
    FValue: Char;
  public
    constructor create(const action: TActionKey; const value: Char);
    function toJsonObject(): TJsonObject; override;

    property value: Char read FValue;
  end;





  TMouseActionContainer = class(TObjectList<TMouseAction>)
  private
    Fid: string;
    FType: TBrowserActionType;
    FPointerType: TActionPointerType;
  public
    constructor create(const id: string; const pointerType: TActionPointerType);
    function toJson(): string;
    property pointerType: TActionPointerType read fpointerType;
    property id: string read FId ;
  end;

  TKeyboardActionContainer = class(TObjectList<TKeyboardAction>)
  private
    Fid: string;
    FType: TBrowserActionType;
  public
    constructor create(const id: string);
    function toJson(): string;
    property id: string read FId ;
  end;

{*************************************************************************}
implementation
constructor TBrowserAction.create();
begin
  inherited create;
  FType := batNone;
end;

function TBrowserAction.toJson(): string;
var
  jsonOb: TJsonObject;
begin
  jsonOb := toJsonObject();
  result := jsonOb.ToJSON();
  jsonOb.Free;
end;

function TBrowserAction.toJsonObject;
begin
  result := nil;
end;


constructor TMouseAction.create(const action: TActionPointer);
begin
  inherited create();
  FAction := action;
  FOrigin := '';
  FButton := 0;
  FX := 0;
  FY := 0;
end;



function TMouseAction.toJsonObject(): TJsonObject;
var
  pActionAr: array[0..10] of string;
  jsonOb, jsonOrig: TJsonObject;
//  TActionPointer     = (apPause, apPointerUp, apPointerDown, apPointerMove, apPointerCancel);
begin

  pActionAr[0]:= 'pause';
  pActionAr[1]:= 'pointerUp';
  pActionAr[2]:= 'pointerDown';
  pActionAr[3]:= 'pointerMove';
  pActionAr[4]:= 'pointerCancel';

  JsonOb :=TJsonObject.Create;
  jsonOrig:=TJsonObject.Create;

  jsonOb.S['type']:= pActionAr[Ord(FAction)];

  JsonOb.I['duration'] := FDuration;
  if FOrigin<>'' then
  begin
      jsonOrig.S[WEB_ELEMENT_CONST_W3C]:=FOrigin;
      jsonOb.O['origin']:= jsonOrig;
  end;
  jsonOb.I['x']:=FX;
  jsonOb.I['y']:=FY;
  jsonOb.I['button']:=FButton;


  result := JsonOb;

end;

{***************************************************************************}
constructor TKeyboardAction.create(const action: TActionKey; const value: Char);
begin
  inherited create();
  FAction := action;
  FValue := value;
end;


function TKeyboardAction.toJsonObject: TJsonObject;
var
  jsonOb: TJsonObject;
  pActionAr: array[0..10] of string;
//  TActionKey         = (akPause, akKeyUp, akKeyDown);
begin

  pActionAr[0]:= 'pause';
  pActionAr[1]:= 'keyUp';
  pActionAr[2]:= 'keyDown';

  JsonOb :=TJsonObject.Create;

  jsonOb.S['type']:= pActionAr[Ord(FAction)];

  jsonOb.S['value']:=FValue;


  result := JsonOb;

end;


{***************************************************************************}
constructor TMouseActionContainer.create(const id: string; const pointerType: TActionPointerType);
begin
  inherited create;
  System.Assert(id<>'', 'TMouseActionContainer.Create: id is empty string');
  OwnsObjects := True;

  Fid := id;
  FType := batPointer;
  FPointerType := pointerType;
end;

function TMouseActionContainer.toJson(): string;
var
  act: TMouseAction;
  pTypeAr: array[0..10] of string;
  jsonAr, jsonArActions: TJsonArray;
  jsonOb, jsonOb1, jsonCont: TJsonObject;
begin
//  TActionPointerType = (aptMouse, aptPen, aptTouch);
  pTypeAr[0] := 'mouse';
  pTypeAr[1] := 'pen';
  pTypeAr[2] := 'touch';

  result := '';
  jsonCont := TJsonObject.Create;
  jsonAr := TJsonArray.Create;
  jsonOb := TJsonObject.Create;
  jsonOb1 := TJsonObject.Create;
  jsonArActions := TJsonArray.Create;
  try
    jsonOb.S['id'] :=Fid;
    jsonOb.S['type'] :='pointer';
    jsonOb1.S['pointerType'] :=  pTypeAr[Ord(FPointerType)];
    jsonOb.O['parameters'] :=jsonOb1;

    for act in Self do
    begin
      jsonArActions.Add(act.toJsonObject);
    end;

    jsonOb.A['actions']:= jsonArActions;

    jsonAr.Add(jsonOb);

    jsonCont.A['actions']:=jsonAr;

    Result := jsonCont.ToJSON();


  finally
    jsonCont.Free;
  end;
end;

{***************************************************************************}
constructor TKeyboardActionContainer.create(const id: string);
begin
  inherited create;
  System.Assert(id<>'', 'TMouseActionContainer.Create: id is empty string');
  OwnsObjects := True;

  Fid := id;
  FType := batKey;
end;

function TKeyboardActionContainer.toJson(): string;
var
  act: TKeyboardAction;
  jsonAr, jsonArActions: TJsonArray;
  jsonOb,  jsonCont: TJsonObject;
begin

  result := '';
  jsonCont := TJsonObject.Create;
  jsonAr := TJsonArray.Create;
  jsonOb := TJsonObject.Create;
  jsonArActions := TJsonArray.Create;
  try
    jsonOb.S['id'] :=Fid;
    jsonOb.S['type'] :='key';

    for act in Self do
    begin
      jsonArActions.Add(act.toJsonObject);
    end;

    jsonOb.A['actions']:= jsonArActions;

    jsonAr.Add(jsonOb);

    jsonCont.A['actions']:=jsonAr;

    Result := jsonCont.ToJSON();


  finally
    jsonCont.Free;
  end;
end;

end.
