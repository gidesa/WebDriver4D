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

unit Webdriver4D;


interface

uses
  Classes, SysUtils, Windows,
  Vcl.Graphics,
  System.Generics.Collections,
  JsonDataObjects, WebClasses, WebDriverConst, WD_http  ;

type

  TWebDriver = class;

  TElement = class(TObject)
  private
    FW3C: Boolean;
    FElementData: string;
    FElementID: string;
    FWebDriver: TWebDriver;
    function GetElementID: string;
  public
    constructor create(elementData: string; W3C: Boolean);
    property ElementID: string read FElementID;
    property W3C: Boolean read FW3C write FW3C;
    property elementData: string read FElementData;

    function GetElementName: string;
    procedure setWebDriver(wd: TWebDriver);
    function executeScript(const script: string; const params: string = '[]'): string;
    procedure selectByText(const text: string);
    function CssValue(const cssproperty: string):string;
    function Attribute(const name: string): string;
    function PropertyHtml(const name: string): string;
    function text(): string;
    function tagname(): string;
    procedure Click();
    function IsSelected(): Boolean;
    function IsDisplayed(): Boolean;
    procedure Clear();
    function TableRows(): integer;
    function SelectIsMultiple():Boolean;
    function SelectedOptionText(): string;
    function SelectOptionsCount(): Integer;
    procedure SendKey(const keys: string);
  end;

  TAlert = class(TObject)
  private
    FText: string;
    FWebDriver: TWebDriver;
  public
    constructor create(text: string; WebDriver: TWebDriver);
    procedure Accept();
    procedure Dismiss();

    property text: string read FText;
  end;




  TExecCommandEvent = procedure(response: string) of object;

  TWebDriverClass = class of TWebDriver;
  TWebDriver = class(TComponent)
  strict private
    procedure CutImage(const FileName: string; Pic: string;
      X, Y, Width, Height: integer);
  private
    FCmd: TDriverCommand;
    FOnResponse: TExecCommandEvent;
    capabArray: TDictionary<string,string>;

    function GetDriverIsRunning: Boolean;
    function GetHasError: Boolean;
    function GetHost: string;
    function GetTimeout: integer;
    procedure SaveScreenToFileName(const FileName, Base64File: string);
    procedure SetTimeout(const Value: integer);
    procedure sendActions(const data: string);
    procedure normalizeFindArgs(var usingName: string; var KeyName: string);
  strict protected
    FErrorMessage: string;
    FProcessInfo: TProcessInformation;
    FStartupInfo: TStartupInfo;
    FPopup_Error: Boolean;
    FAddress: string;
    FDriverType: TDriverType;
    FBrowserExe: string;
    FBrowserPath: string;
    FProfile: string;
    FDriverName: string;
    FDriverNameAlt: string;
    FDriverDir: string;
    FLogFile: string;
    FPath: string;
    FPort: integer;
    FSessionID: string;
    FW3C: Boolean;
    function BuildParams: string; virtual;
    function ExecuteCommand(const CommandType: TCommandType;
      const Command: string; const Param: string = ''): string;
    function ProcResponse(const Resp: string): string;
    function AddCapabilities(): string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;


    procedure StartDriver(const ExeName: string = '';
           const Args: string = ''); virtual;
    procedure Assign(Source: TPersistent); override;
    procedure CloseWindow(ParamSessionID: string = '');
    function GetAllCookie: string;
    function GetAllCookieJsonArray: string;
    function GetCookieByName(cookieName: string): string;
    function AddCookie(cookieName, cookieValue: string): string;
    procedure DeleteAllCookie;
    procedure DeleteCookie(const cookieName: string);

    function FindElementByID(const ID: string): TElement;
    function FindElementByTag(const TagName: string): TElement;
    function FindElementByClassName(const ClasseNam: string): TElement;
    function FindElementByName(const Name: string): TElement;
    function FindElement(usingName, KeyName: string): TElement;
    function FindElementByLinkText(const LinkText: string): TElement;
    function FindElementByXPath(XPath: string): TElement;
    function FindElementByCSS(css: string): TElement;

    function FindElementInElement(const Element: TElement;  usingName, KeyName: string): TElement;


    function FindElements(const usingName, KeyName: string): TObjectList<TElement>;
    function FindElementsByXPath(XPath: string): TObjectList<TElement>;
    function FindElementsByTag(const TagName: string): TObjectList<TElement>;
    function FindElementsByLinkText(const LinkText: string): TObjectList<TElement>;
    function FindElementsByCSS(const css: string): TObjectList<TElement>;
    function FindElementsByClassName(const ClasName: string): TObjectList<TElement>;


    function GetElementActive: TElement;


    function GetCurrentWindowHandle: string;

    function GetElementAttribute(const Element: TElement; const attributename: string;
                      const propertyFlag: Boolean = false): string;
    function GetElementCssValue(const Element: TElement; const propertyname: string): string;
    function GetElementText(const Element: TElement): string;
    function GetElementTagname(const Element: TElement): string;
    function GetElementSelected(const Element: TElement): string;
    function GetElementDisplayed(const Element: TElement): string;
    function GetElementEnabled(const Element: TElement): string;

    procedure GetURL(const URL: string);
    function GetCurUrl: string;
    function NewSession: string; virtual; abstract;
    procedure DeleteSession(ParamSessionID: string = '');
    function GetDocument: string;
    function GetAllSessions: string; virtual;
    procedure Save_screenshot(const FileName: string);
    procedure Set_Window_Size(const Width, Height: integer;
                WindowHandle: string = 'current');
    procedure WindowMaximize();
    procedure ElementClick(const Element: TElement);
    procedure ElementClear(const Element: TElement);
    function  Element_Location(const Element: TElement): string;
    procedure Element_ScreenShot(const Element: TElement; FileName: string);
    function  Element_Size(const Element: TElement): string;
    function  ExecuteScript(const Script: string; const Args: string = '[]')
      : string; virtual;

    procedure Implicitly_Wait(const waitTime: Double);
    procedure PageLoadTimeout(const Timeout: integer);
    procedure Quit;
    procedure Refresh(ParamSessionID: string = '');
    procedure SendKey(const Element: TElement; const Key: string);
    procedure SwitchToFrame(const FrameEl: TElement); virtual;
    procedure SwitchToDefaultContent();
    function  SwitchToAlert(): TAlert;
    procedure AlertAccept();
    procedure AlertDismiss();
    procedure TerminateWebDriver;
    procedure WaitForLoaded;
    procedure SetBinary(const exename: string);
    procedure SetProfile(const profilename: string);
    procedure SetCapability(const capname, capvalue: string);
    procedure Wait(const ms: Integer);

    procedure ProcessActions(actList: TKeyboardActionContainer); overload;
    procedure ProcessActions(actList: TMouseActionContainer);  overload;


    property driverType: TDriverType read FDriverType;
    property ErrorMessage: string read FErrorMessage;
    property HasError: Boolean read GetHasError;
    property LogFile: string read FLogFile write FLogFile;
    property Host: string read GetHost;
    property Address: string read FAddress write FAddress;
    property Cmd: TDriverCommand read FCmd write FCmd;
    property DriverIsRunning: Boolean read GetDriverIsRunning;
    property DriverName: string read FDriverName;
    property DriverDir: string read FDriverDir write FDriverDir;
    property Port: integer read FPort write FPort;
    property Path: string read FPath write FPath;
    property Popup_Error: Boolean read FPopup_Error write FPopup_Error;
    property SessionID: string read FSessionID write FSessionID;
    property W3C: Boolean read FW3C;
    property browserexe: string read FBrowserExe;


  published
    procedure Clear;
    property Timeout: integer read GetTimeout write SetTimeout;
    property OnResponse: TExecCommandEvent read FOnResponse write FOnResponse;
  end;



 {**********************************************}


implementation

uses
//Delphi versione > XE2
{$IF CompilerVersion > 23.0}
  System.NetEncoding,
{$else}
  Soap.EncdDecd,
{$ifend}
  Vcl.Imaging.pngimage;






{***********************************************************************}

constructor TWebDriver.Create(AOwner: TComponent);
begin
  inherited;
  FillChar(FProcessInfo, SizeOf(FProcessInfo), 0);
  FAddress := '127.0.0.1';
  FLogFile := '';
  FPath := '';

  FErrorMessage := '';
  FW3C := False;
  FPopup_Error := True;
  FBrowserExe := '';
  FBrowserPath := '';
  FProfile := '';

  capabArray := TDictionary<string,string>.Create;
  FDriverType := btUnknown;
  FDriverDir := '.\';
  FDriverName:='';
  FDriverNameAlt:='';
end;

destructor TWebDriver.Destroy;
begin
  if FProcessInfo.hProcess <> 0 then
  begin
    Clear;
    TerminateWebDriver;
  end;
  capabArray.Free;
  inherited;
end;

procedure TWebDriver.Assign(Source: TPersistent);
var
  WD: TWebDriver;
begin
  inherited;
  if Source is TWebDriver then
  begin
    WD := Source as TWebDriver;
    self.Address := WD.Address;

    self.Port := WD.Port;
    self.Path := WD.Path;

    self.Timeout := WD.Timeout;
  end;
end;

function TWebDriver.BuildParams: string;
begin

end;

procedure TWebDriver.CloseWindow(ParamSessionID: string = '');
var
  Command: string;
begin
  if ParamSessionID <> '' then
  begin
    Command := Host + '/session/' + ParamSessionID + '/window';
  end
  else
    Command := Host + '/session/' + FSessionID + '/window';

  ExecuteCommand(cDelete, Command);
end;

procedure TWebDriver.CutImage(const FileName: string; Pic: string;
  X, Y, Width, Height: integer);
var
  png: TPngImage;
  // Delphi version > XE2
  {$IF CompilerVersion > 23.0}
    Encd: TBase64Encoding;
  {$ifend}

  Stream: TMemoryStream;
  Byts: TBytes;
  bmp: TBitmap;
  REctS, REctD: TRect;
begin
  {$IF CompilerVersion > 23.0}
  Encd := TBase64Encoding.Create;
  {$ifend}
  Stream := TMemoryStream.Create;
  bmp := TBitmap.Create;
  png := TPngImage.Create;
  try
  {$IF CompilerVersion > 23.0}
    Byts := Encd.DecodeStringToBytes(Pic);
  {$ELSE}
    Byts := DecodeBase64(pic); //xe2
  {$ifend}
    Stream.Write(Byts[0], Length(Byts));
    Stream.Position := 0;
    png.LoadFromStream(Stream);
    REctS.Left := X;
    REctS.Top := Y;
    REctS.Width := Width;
    REctS.Height := Height;
    REctD.Left := 0;
    REctD.Top := 0;
    bmp.Width := Width;
    bmp.Height := Height;

    REctD.Width := Width;
    REctD.Height := Height;

    bmp.Canvas.CopyRect(REctD, png.Canvas, REctS);
    png.Assign(bmp);
    png.SaveToFile(FileName);

  finally
    FreeAndNil(png);
    FreeAndNil(bmp);
    FreeAndNil(Stream);
  {$IF CompilerVersion > 23.0}
    FreeAndNil(Encd);
  {$ifend}
  end;
end;

procedure TWebDriver.DeleteSession(ParamSessionID: string = '');
var
  Command: string;
begin
  if ParamSessionID <> '' then
  begin
    Command := Host + '/session/' + ParamSessionID;
  end
  else
  begin
    Command := Host + '/session/' + FSessionID;
    FSessionID := '';
  end;
  ExecuteCommand(cDelete, Command);
end;

procedure TWebDriver.ElementClick(const Element: TElement);
var
  Command: string;
  Data: string;
  Resp: string;
  Json:TJsonObject;
begin
  System.Assert(Element <> nil, 'ElementClick: element not assigned');
  Json :=TJsonObject.Create;
  try
    Command := Host + '/session/' + FSessionID + '/element/' + Element.ElementID + '/click';
    Json.S['id'] := Element.ElementID;
    Data := Json.ToJSON(False);
    Resp := ExecuteCommand(cPost, Command, Data);
    ProcResponse(Resp);
  finally
    FreeAndNil(Json);
  end;
end;

procedure TWebDriver.ElementClear(const Element: TElement);
var
  Command: string;
  Data: string;
  Resp: string;
  Json:TJsonObject;
begin
  System.Assert(Element <> nil, 'ElementClear: element not assigned');
  Json :=TJsonObject.Create;
  try
    Command := Host + '/session/' + FSessionID + '/element/' + Element.ElementID + '/clear';
    Json.S['id'] := Element.ElementID;
    Data := Json.ToJSON(False);
    Resp := ExecuteCommand(cPost, Command, Data);
    ProcResponse(Resp);
  finally
    FreeAndNil(Json);
  end;
end;


function TWebDriver.Element_Location(const Element: TElement): string;
var
  Command: string;
  Resp: string;
begin
  if FW3C then
    Command := Host + '/session/' + FSessionID + '/element/' + Element.ElementID + '/rect'
  else
    Command := Host + '/session/' + FSessionID + '/element/' + Element.ElementID +
      '/location';
  Resp := ExecuteCommand(cGet, Command);
  result := ProcResponse(Resp);
end;

function TWebDriver.Element_Size(const Element: TElement): string;
var
  Command: string;
  Resp: string;
begin
  if FW3C then
    Command := Host + '/session/' + FSessionID + '/element/' + Element.ElementID + '/rect'
  else
    Command := Host + '/session/' + FSessionID + '/element/' + Element.ElementID + '/size';
  Resp := ExecuteCommand(cGet, Command);
  result := ProcResponse(Resp);

end;

function TWebDriver.ExecuteScript(const Script: string;
  const Args: string = '[]'): string;
var
  Command: string;
  Data: string;
  Resp: string;
  Json:TJsonObject;
begin
  Json :=TJsonObject.Create;
  try
    Command := Host + '/session/' + FSessionID + '/execute/sync';
    Json.S['script'] :=Script;
    Json.A['args'].FromJSON(args);
    Data :=Json.ToJSON();
    Resp := ExecuteCommand(cPost, Command, Data);
    result := ProcResponse(Resp);
  Finally
    FreeAndNil(Json);
  end;

end;

function TWebDriver.FindElementByID(const ID: string): TElement;
begin
  result := FindElement('id', ID);
end;

function TWebDriver.FindElementByTag(const TagName: string): TElement;
begin
  result := FindElement('tag name', TagName);
end;

function TWebDriver.FindElementByClassName(const ClasseNam: string): TElement;
begin
  result := FindElement('class name', ClasseNam);
end;

procedure TWebDriver.normalizeFindArgs(var usingName: string; var KeyName: string);
begin
  if FW3C then
  begin
    if SameText(usingName, 'id') then
    begin
      usingName := 'css selector';
      KeyName := format('[id="%s" ]', [KeyName]);
    end
    else if SameText(usingName, 'tag name') then
    begin
      usingName := 'css selector';
    end
    else if SameText(usingName, 'class name') then
    begin
      usingName := 'css selector';
      KeyName := format('.%s', [KeyName]);
    end
    else if SameText(usingName, 'name') then
    begin
      usingName := 'css selector';
      KeyName := format('[name="%s"]', [KeyName]);

    end;
  end;

end;

function TWebDriver.FindElement(usingName, KeyName: string): TElement;
var
  Command: string;
  Data: string;
  Resp: string;
  JsonData:string;
  Json:TJsonObject;
  ele: TElement;
begin

  Command := Host + '/session/' + FSessionID + '/element';
  normalizeFindArgs(usingName, KeyName);
  Json :=TJsonObject.Create;
  try
    Json.S['using'] :=usingName;
    Json.S['value'] :=KeyName;

    Data := Json.ToJSON();

    Resp := ExecuteCommand(cPost, Command, Data);

    JsonData :=ProcResponse(Resp);
    if not HasError then
    begin
      ele:=TElement.Create(JsonData, FW3C);
      ele.setWebDriver(self);
      result := ele;
    end else
    begin
      Result :=nil;
  end;
  finally
    FreeAndNil(Json);
  end;

end;

function TWebDriver.FindElementInElement(const Element: TElement;
             usingName: string;  KeyName: string): TElement;
var
  Command: string;
  Data: string;
  Resp: string;
  JsonData:string;
  Json:TJsonObject;
  ele: TElement;
begin
  System.Assert(Element<>nil, 'FindElementInElement: element null' );
  Command := Host + '/session/' + FSessionID + '/element/' + Element.ElementID
        + '/element';
  normalizeFindArgs(usingName, KeyName);
  Json :=TJsonObject.Create;
  try
    Json.S['using'] :=usingName;
    Json.S['value'] :=KeyName;

    Data := Json.ToJSON();

    Resp := ExecuteCommand(cPost, Command, Data);

    JsonData :=ProcResponse(Resp);
    if not HasError then
    begin
      ele:=TElement.Create(JsonData, FW3C);
      ele.setWebDriver(self);
      result := ele;
    end else
    begin
      Result :=nil;
    end;
  finally
    FreeAndNil(Json);
  end;

end;

function TWebDriver.FindElementByLinkText(const LinkText: string): TElement;
begin
  result := FindElement('link text', LinkText);
end;

function TWebDriver.FindElementByXPath(XPath: string): TElement;
begin
  result := FindElement('xpath', XPath);
end;

function TWebDriver.FindElementByCSS(css: string): TElement;
begin
  result := FindElement('css selector', css);
end;

function TWebDriver.GetElementActive: TElement;
var
  Command: string;
  Data: string;
  Resp: string;
  JsonData:string;
  Json:TJsonObject;
  ele: TElement;
begin
  Command := Host + '/session/' + FSessionID + '/element/active';
//  Json :=TJsonObject.Create;
  try
//    Data := Json.ToJSON();

    Resp := ExecuteCommand(cGet, Command);

    JsonData :=ProcResponse(Resp);
    if not HasError then
    begin
      ele:=TElement.Create(JsonData, FW3C);
      ele.setWebDriver(self);
      result := ele;
    end else
    begin
      Result :=nil;
    end;
  finally
//    FreeAndNil(Json);
  end;

end;


function TWebDriver.GetAllSessions: string;
var
  Command: string;
  Resp: string;
begin
  // command /sessions not existing in W3C  protocol,
  // that is in all drivers (as geckodriver)

  try
    Command := Host + '/sessions';
    Resp := ExecuteCommand(cGet, Command);


    if Resp <> '' then
    begin
      result := ProcResponse(Resp);
    end
    else
    begin
      result := '';
    end;
  except
    on E: exception do
      raise Exception.Create('Command /sessions error: '  + E.Message + ' - response <|' + Resp + '|>');
  end;
end;

function TWebDriver.GetCurrentWindowHandle: string;
var
  Command: string;
  Resp: string;
begin
  if FW3C then
    Command := Host + '/session/' + FSessionID + '/window'
  else
    Command := Host + '/session/' + FSessionID + '/window_handle';

  Resp := ExecuteCommand(cGet, Command);
  result := ProcResponse(Resp);
end;



function TWebDriver.GetElementAttribute(const Element: TElement; const attributename
  : string; const propertyFlag: Boolean = false): string;
var
  Command: string;
  Resp: string;
  attribProp: string;
begin
  System.Assert(Element<>nil, 'GetElementAttribute: element null' );
//  if FW3C then
//  begin
//    js :=Format('return (%s).apply(null, arguments);',[ATTRIBUTE_JS]);
//    args:='[{"ELEMENT":'+'"'+Element.ElementID+'",'+'"'+Element.GetElementName+'"'+
//    ':'+'"'+Element.ElementID+'"}'+','+'"'+attributename+'"]';
//    result :=Self.ExecuteScript(js,args);
//  end else
  begin
    if propertyFlag then attribProp := '/property/' else attribProp := '/attribute/';
    Command := Host + '/session/' + FSessionID + '/element/' + Element.ElementID + attribProp
      + attributename;
    Resp := ExecuteCommand(cGet, Command);
    result := ProcResponse(Resp);
  end;
end;

function TWebDriver.GetElementCssValue(const Element: TElement; const propertyname: string): string;
var
  Command: string;
  Resp: string;
begin
  System.Assert(Element<>nil, 'GetElementCssValue: element null' );
    Command := Host + '/session/' + FSessionID + '/element/' + Element.ElementID + '/css/'
      + propertyname;
    Resp := ExecuteCommand(cGet, Command);
    result := ProcResponse(Resp);

end;

function TWebDriver.GetElementSelected(const Element: TElement): string;
var
  Command: string;
  Resp: string;
begin
  System.Assert(Element<>nil, 'GetElementSelected: element null' );
    Command := Host + '/session/' + FSessionID + '/element/' + Element.ElementID + '/selected';
    Resp := ExecuteCommand(cGet, Command);
    result := ProcResponse(Resp);

end;

function TWebDriver.GetElementDisplayed(const Element: TElement): string;
var
  Command: string;
  Resp: string;
begin
  System.Assert(Element<>nil, 'GetElementDisplayed: element null' );
    Command := Host + '/session/' + FSessionID + '/element/' + Element.ElementID + '/displayed';
    Resp := ExecuteCommand(cGet, Command);
    result := ProcResponse(Resp);

end;

function TWebDriver.GetElementEnabled(const Element: TElement): string;
var
  Command: string;
  Resp: string;
begin
  System.Assert(Element<>nil, 'GetElementEnabled: element null' );
    Command := Host + '/session/' + FSessionID + '/element/' + Element.ElementID + '/enabled';
    Resp := ExecuteCommand(cGet, Command);
    result := ProcResponse(Resp);

end;

function TWebDriver.GetElementTagname(const Element: TElement): string;
var
  Command: string;
  Resp: string;
begin
  System.Assert(Element<>nil, 'GetElementTagname: element null' );
    Command := Host + '/session/' + FSessionID + '/element/' + Element.ElementID + '/name';
    Resp := ExecuteCommand(cGet, Command);
    result := ProcResponse(Resp);

end;

function TWebDriver.GetElementText(const Element: TElement): string;
var
  Command: string;
  Resp: string;
  oldTimeout: Integer;
begin
  System.Assert(Element<>nil, 'GetElementText: element null' );
    Command := Host + '/session/' + FSessionID + '/element/' + Element.ElementID + '/text';

    oldTimeout := Timeout;
    Timeout := 60000;
    Resp := ExecuteCommand(cGet, Command);
    Timeout := oldTimeout;
    result := ProcResponse(Resp);

end;

function TWebDriver.GetHost: string;
begin
  result := format('http://%s:%d%s', [FAddress, FPort, FPath]);
end;

procedure TWebDriver.GetURL(const URL: string);
var
  Command: string;
  Data: string;
  Resp: string;
  Json:TJsonObject;
begin
  Command := Host + '/session/' + FSessionID + '/url';
  Json :=TJsonObject.Create;
  try
    Json.S['url'] := URL;
    Json.S['sessionid'] := FSessionID;
    Data := Json.ToJSON();
    Resp := ExecuteCommand(cPost, Command, Data);
    ProcResponse(Resp);
    if not HasError then
      WaitForLoaded;
  finally
    FreeAndNil(Json);
  end;
end;


procedure TWebDriver.Quit;
begin
  if FSessionID <> '' then
  begin
    DeleteSession(FSessionID);
    FSessionID := '';
  end;
end;

procedure TWebDriver.Refresh(ParamSessionID: string = '');
var
  Command: string;
  Data: string;
  Resp: string;
  Json:TJsonObject;
begin
  Json :=TJsonObject.Create;
  try
    if ParamSessionID <> '' then
      Command := Host + '/session/' + ParamSessionID + '/refresh'
    else
      Command := Host + '/session/' + FSessionID + '/refresh';
    Json.S['sessionid'] := FSessionID;
    Data := Json.ToJSON();
    Resp := ExecuteCommand(cPost, Command, Data);
    ProcResponse(Resp);
  finally
    FreeAndNil(Json);
  end;
end;

procedure TWebDriver.SaveScreenToFileName(const FileName, Base64File: string);
var
  {$IF CompilerVersion > 23.0}
    Encode: TBase64Encoding;
  {$ifend}
  bytes: TBytes;
  Fs: TFileStream;
begin
  {$IF CompilerVersion > 23.0}
  Encode := TBase64Encoding.Create;
  {$ifend}
  try
  {$IF CompilerVersion > 23.0}
    bytes := Encode.DecodeStringToBytes(Base64File);
  {$ELSE}
    bytes := DecodeBase64(Base64File); //xe2
  {$ifend}
    Fs := TFileStream.Create(FileName, fmCreate);
    try
      Fs.WriteBuffer(bytes[0], Length(bytes));

    finally
      FreeAndNil(Fs);
    end;
  finally
  {$IF CompilerVersion > 23.0}
    FreeAndNil(Encode);
  {$ifend}
  end;
end;

procedure TWebDriver.StartDriver(const ExeName: string = '';
  const Args: string = '');
var
  Command: string;
  drivName: string;
begin
  if (ExeName <>'') then
  begin
    if not FileExists(FDriverDir+ExeName) then
      raise Exception.Create('D1-Driver file not exists. ' + ExeName);
    FDriverName :=ExeName;
  end;
  if FProcessInfo.hProcess <> 0 then
    Exit;
  FillChar(FStartupInfo, SizeOf(FStartupInfo), 0);
  FillChar(FProcessInfo, SizeOf(FProcessInfo), 0);
  FStartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  FStartupInfo.wShowWindow := SW_HIDE;
  if Args = '' then
    Command := self.BuildParams
  else
    Command := Args;

  windows.OutputDebugString(PWideChar('>>>Driver>>> '+FDriverDir+FDriverName + ' ' + Command));

  if FileExists(FDriverDir+FDriverName) then
    drivName:=FDriverName
  else
     if (FDriverNameAlt<>'') and (FileExists(FDriverDir+FDriverNameAlt)) then
      drivName:=FDriverNameAlt
     else
        raise Exception.Create('D2-Driver file not exists. ' + FDriverName + ' or ' + FDriverNameAlt);

  if CreateProcess(nil, Pchar(FDriverDir+drivName + ' ' + Command), nil, nil, False,
    NORMAL_PRIORITY_CLASS, nil, nil, FStartupInfo, FProcessInfo) then
  begin
    // start ok
  end else
  begin
    raise Exception.Create('Driver not started. Last OS error: ' + IntToStr(windows.GetLastError));
  end;
end;

procedure TWebDriver.Save_screenshot(const FileName: string);
var
  Command: string;
  Resp: string;
  Pic: string;
begin
  Command := Host + '/session/' + FSessionID + '/screenshot';
  Resp := ExecuteCommand(cGet, Command);
  Pic := ProcResponse(Resp);
  if not HasError then
  begin
    SaveScreenToFileName(FileName, Pic);
  end;
end;

procedure TWebDriver.Element_ScreenShot(const Element: TElement; FileName: string);
var
  Command: string;
  Resp: string;
  Pic: string;
  Size: string;
  Loc: string;
  X, Y, Width, Height: integer;
  Json :TJsonObject;
begin
  System.Assert(Element <> nil, 'Element_Screenshot: element not assigned');
  Json :=TJsonObject.Create;
  if FW3C then
  begin
        command := Host + '/session/' + FSessionID + '/element/' + Element.ElementID +
          '/screenshot';
  end else
  begin
        Command := Host + '/session/' + FSessionID + '/screenshot';
  end;
  try
    Resp := ExecuteCommand(cGet, Command);
    Json.FromJSON(Resp);
    if not HasError then
    begin
      Pic := Json.S['value'];
      Loc := Element_Location(Element);
      Json.FromJSON(Loc);

      X := Json.I['x'];
      Y := Json.I['y'];
      Size := Element_Size(Element);
      Json.FromJSON(Size);
      Width := Json.I['width'];
      Height := Json.I['height'];
      CutImage(FileName, Pic, X, Y, Width, Height);
    end;
  finally
    FreeAndNil(Json);
  end;

end;

function TWebDriver.FindElementsByXPath(XPath: string): TObjectList<TElement>;
begin
  result := FindElements('xpath', XPath);
end;

function TWebDriver.FindElementsByTag(const TagName: string): TObjectList<TElement>;
begin
  result := FindElements('tag name', TagName);
end;

function TWebDriver.FindElementsByLinkText(const LinkText: string): TObjectList<TElement>;
begin
  result := FindElements('link text', LinkText);
end;

function TWebDriver.FindElementsByCSS(const css: string): TObjectList<TElement>;
begin
  result := FindElements('css selector', css);
end;

function TWebDriver.FindElementsByClassName(const ClasName: string): TObjectList<TElement>;
begin
  result := FindElements('css selector', '.'+ClasName);
end;


function TWebDriver.FindElements(const usingName, KeyName: string): TObjectList<TElement>;
var
  i: Integer;
  Command: string;
  Data: string;
  Resp: string;
  res: string;
  Json :TJsonObject;
  aryJson: TJsonArray;
  tmpJson: TJsonObject;

  ele: TElement;
  eleList: TObjectList<TElement>;
begin
  Json :=TJsonObject.Create;
  eleList := nil;
  try
    Command := Host + '/session/' + FSessionID + '/elements';
    Json.S['value'] := KeyName;
    Json.S['sessionid'] := FSessionID;
    Json.S['using'] := usingName;
    Data := Json.ToJSON(False);
    Resp := ExecuteCommand(cPost, Command, Data);
    res := ProcResponse(Resp);

    if HasError = true then
    begin
       result := nil;
       Exit;
    end;

    aryJson := TJsonBaseObject.Parse(res) as TJsonArray;
    if aryJson <> nil then
    begin
      eleList := TObjectList<TElement>.Create(true);
      for I := 0 to aryJson.Count - 1 do
      begin
        tmpJson := aryJson.O[I];
        ele := TElement.create(tmpJson.ToJSON(), FW3C);
        ele.setWebDriver(self);
        eleList.Add(ele);
      end;
      aryJson.Free;
    end;
    result := eleList;
  finally
    FreeAndNil(Json);
  end;
end;



procedure TWebDriver.SendKey(const Element: TElement; const Key: string);
var
  Command: string;
  Data: string;
  Resp: string;
  I: integer;
  Arr:TJsonArray;
  Json:TJsonObject;
begin
  System.Assert(Element <> nil, 'SendKey: element not assigned');
  Json :=TJsonObject.Create;
  try
    Command := Host + '/session/' + FSessionID + '/element/' + Element.ElementID + '/value';
    Arr :=Json.A['value'];
    for I := 1 to Length(Key) do
    begin
      Arr.Add(Key[I]);
    end;
    Json.S['text'] := Key;
    Json.S['id'] := Element.ElementID;
    Data := Json.ToJSON();
    Resp := ExecuteCommand(cPost, Command, Data);
    ProcResponse(Resp);
  finally
    FreeAndNil(Json);
  end;
end;

procedure TWebDriver.Set_Window_Size(const Width, Height: integer;
  WindowHandle: string = 'current');
var
  Command: string;
  Data: string;
  Resp: string;
  Json :TJsonObject;
begin
  Json :=TJsonObject.Create;
  try
    if W3C then
    begin
      Command := Host + '/session/' + FSessionID + '/window/rect';
      Json.I['width'] := Width;
      Json.I['height'] := Height;
      Json.S['windowHandle'] := WindowHandle;
    end
    else
    begin
      Command := Host + '/session/' + FSessionID + '/window/' + WindowHandle
        + '/size';

      Json.I['width'] := Width;
      Json.I['height'] := Height;

    end;

    Data := Json.ToJSON();
    Resp := ExecuteCommand(cPost, Command, Data);
    ProcResponse(Resp);
  finally
    FreeAndNil(Json);
  end;
end;

procedure TWebDriver.WindowMaximize();
var
  Command: string;
  Data: string;
  Resp: string;
begin
//    if W3C then
//    begin
      Command := Host + '/session/' + FSessionID + '/window/maximize';
//    end
//    else
//    begin
//      //???
//    end;

    Resp := ExecuteCommand(cPost, Command, Data);
    ProcResponse(Resp);
end;


procedure TWebDriver.TerminateWebDriver;
begin
  TerminateProcess(FProcessInfo.hProcess, 0);
  WaitForSingleObject(FProcessInfo.hProcess, 60000);
  FillChar(FStartupInfo, SizeOf(FStartupInfo), 0);
  FillChar(FProcessInfo, SizeOf(FProcessInfo), 0);
end;

procedure TWebDriver.Clear;
var
  AllSession: string;
  Json: TJsonArray;
  Session: string;
  I: integer;
begin
  Json := TJsonArray.Create;
  try
    // close the opened session
    if (FSessionID<>'') then
    begin
        CloseWindow(FSessionID);
        sleep(500);
        DeleteSession(FSessionID);
    end;
  finally
    FSessionID := '';
    FreeAndNil(Json);
  end;
end;

procedure TWebDriver.DeleteAllCookie;
var
  Command: string;
begin
  Command := Host + '/session/' + FSessionID + '/cookie';
  ExecuteCommand(cDelete, Command)
end;

procedure TWebDriver.DeleteCookie(const cookieName: string);
var
  Command: string;
begin
  Command := Host + '/session/' + FSessionID + '/cookie' + '/' + cookieName;
  ExecuteCommand(cDelete, Command);
end;

function TWebDriver.GetAllCookie: string;
var
  S: string;
  I: integer;
  aryJson: TJsonArray;
  tmpJson: TJsonObject;
begin
  result := '';
  S := GetAllCookieJsonArray;
  aryJson := TJsonBaseObject.Parse(S) as TJsonArray;
  if aryJson <> nil then
  begin
    for I := 0 to aryJson.Count - 1 do
    begin
      tmpJson := aryJson.O[I];
      if result = '' then
        result := tmpJson.S['name'] + '=' + tmpJson.S['value']
      else
        result := result + '; ' + tmpJson.S['name'] + '=' + tmpJson.S['value'];
    end;
    aryJson.Free;
  end;
end;

function TWebDriver.AddCookie(cookieName, cookieValue: string): string;
var
  Command: string;
  Data: string;
  Resp: string;
  Json, ckJson: TJsonObject;
begin
  Json :=TJsonObject.Create;
  try
    ckJson :=Json.O['cookie'];
    ckJson.S['name'] := cookieName;
    ckJson.S['value'] := cookieValue;
    Command := Host + '/session/' + FSessionID + '/cookie';
    Data := Json.ToJSON(True);
    Resp := ExecuteCommand(cPost, Command, Data);
    ProcResponse(Resp);
  finally
    FreeAndNil(Json);
  end;
end;

function TWebDriver.GetTimeout: integer;
begin
  result := FCmd.Timeout;
end;

procedure TWebDriver.PageLoadTimeout(const Timeout: integer);
var
  Command: string;
  Data: string;
  Resp: string;
  Json :TJsonObject;
begin
  Json :=TJsonObject.Create;
  try
    Command := Host + '/session/' + FSessionID + '/timeouts';
    Json.I['pageLoad'] := Timeout;
    Data := Json.ToJSON(False);
    Resp := ExecuteCommand(cPost, Command, Data);
    ProcResponse(Resp);
  finally
    FreeAndNil(Json);
  end;
end;

procedure TWebDriver.Implicitly_Wait(const waitTime: Double);
var
  Command: string;
  Data: string;
  Resp: string;
  Json:TJsonObject;
begin
  Json :=TJsonObject.Create;
  try
    if W3C then
    begin
      Command := Host + '/session/' + FSessionID + '/timeouts';
      Json.F['implicit'] := waitTime;
      Data := Json.ToJSON();
    end
    else
    begin
      Command := Host + '/session/' + FSessionID + '/timeouts/implicit_wait';
      Json.F['ms'] := waitTime;
      Json.S['session'] := FSessionID;
      Data := Json.ToJSON();
    end;
    Resp := ExecuteCommand(cPost, Command, Data);
    ProcResponse(Resp);
  finally
    FreeAndNil(Json);
  end;
end;



function TWebDriver.ExecuteCommand(const CommandType: TCommandType;
  const Command: string; const Param: string = ''): string;
var
  paramJson: string;
begin

  FErrorMessage :='';
  Result := '';

  if Param = '' then paramJson := '{}'
  else
    paramJson := Param;
  if FCmd = nil then
  begin
    raise Exception.Create('Twebdriver.ExecuteCommand: Command object not assigned');
  end;

    case CommandType of
      cGet:
        begin
          result := FCmd.ExecuteGet(Command);
        end;
      cPost:
        begin
          result := FCmd.ExecutePost(Command, paramJson);
        end;
      cDelete:
        begin
          FCmd.ExecuteDelete(Command);
        end;

    end;
    if Assigned(FOnResponse) then
    begin
      FOnResponse(result);
    end;

end;

function TWebDriver.FindElementByName(const Name: string): TElement;
begin
  result := FindElement('name', Name);
end;

function TWebDriver.GetDocument: string;
var
  Command: string;
begin
  result := '';
  if FSessionID <> '' then
  begin
    Command := Host + '/session/' + FSessionID + '/source';
    result := ProcResponse(ExecuteCommand(cGet, Command));
  end;
end;

function TWebDriver.GetAllCookieJsonArray: string;
var
  Command: string;
  Resp: string;
begin
  Command := Host + '/session/' + FSessionID + '/cookie';
  Resp := ExecuteCommand(cGet, Command);
  if Resp <> '' then
    result := ProcResponse(Resp)
  else
    result := '[]';
end;

function TWebDriver.GetCookieByName(cookieName: string): string;
var
  Command: string;
  Resp: string;
  S: string;
  I: integer;
  aryJson: TJsonArray;
  tmpJson: TJsonObject;
begin
  Command := Host + '/session/' + FSessionID + '/cookie';
  Resp := ExecuteCommand(cGet, Command);
  if Resp <> '' then
    S := ProcResponse(Resp)
  else
    S := '[]';

  aryJson := TJsonBaseObject.Parse(S) as TJsonArray;
  if aryJson <> nil then
  begin
    for I := 0 to aryJson.Count - 1 do
    begin
      tmpJson := aryJson.O[I];
      if tmpJson.S['name'] = cookieName then
      begin
        result := tmpJson.S['value'];
        break;
      end;
    end;
    aryJson.Free;
  end;
end;

function TWebDriver.GetCurUrl: string;
var
  Command: string;
  Resp: string;
begin
  Command := Host + '/session/' + FSessionID + '/url';
  Resp := ExecuteCommand(cGet, Command);
  result := ProcResponse(Resp);
end;

function TWebDriver.GetDriverIsRunning: Boolean;
begin
  Result := FProcessInfo.hProcess <>0;
end;

function TWebDriver.GetHasError: Boolean;
begin
  result := FErrorMessage <> '';
end;

function TWebDriver.ProcResponse(const Resp: string): string;
var
  valueObj, Json, Obj: TJsonObject;
  jType: TJsonDataType;

    procedure respSuccess;
    begin
            jType := Json.Types['value'];
            case jType of
              jdtString, jdtInt, jdtLong, jdtULong, jdtFloat, jdtDateTime, jdtBool:
                begin
                  result := Json.S['value'];
                end;
              jdtObject:
                begin
                  Obj:=nil;
                  Obj := Json.O['value'];
                  if Assigned(Obj) then
                  begin
                    if Obj.Contains('message') then
                      FErrorMessage := Obj.S['message']
                    else
                      result := Obj.ToJSON();
                  end
                  else
                    result := '';
                end;
              jdtArray:
                begin
                  result := Json.A['value'].ToJSON();
                end;
            else
              result := Json.S['value'];
            end;
    end;

    procedure respFailed;
    begin
      if (valueObj<>nil) and  (valueObj.Contains('message')) then
        FErrorMessage := valueObj.S['error'] + ' ' + valueObj.S['message']
      else
        FErrorMessage := Resp;
      result := '';
      if FPopup_Error then
          raise Exception.Create(FErrorMessage);
    end;


begin
  windows.OutputDebugString(PWideChar('Driver response: <<'+resp+'>>'));
  FErrorMessage := '';
  Result:='';
  Json := TJsonObject.Create;
  try
    if Resp <> '' then
    begin
    try
      Json.FromJSON(Resp);
      valueObj:=nil;

      if Json.Contains('value') then
      begin
        if  Json.Types['value']=jdtObject then
            valueObj:=Json.O['value'];
        // it's error response if inside response there is a 'value' object, and it contains 'error' member
        if (valueObj<>nil) and  ( valueObj.Contains('error')  ) then
        begin
          // failed
          respFailed;
        end
        else
        begin
          // no 'value' object, or it not contains 'error' member
          // success
          respSuccess;
        end;
      end else
        begin
          // no 'value' object: failed
          respFailed;
        end;
    except
        on E: EJsonException do
          // not valid Json data
          raise Exception.Create('No valid Json response: <<'+resp+'>>');
        on E: Exception do
          raise Exception.Create('Exception: <<'+e.Message+'>> Response <<'+resp+'>>');
    end;
    end else
    begin
      FErrorMessage := 'HTTP request error, no response';
      result := '';
    end;
  finally
    FreeAndNil(Json);
  end;

end;

procedure TWebDriver.SetTimeout(const Value: integer);
begin
  FCmd.Timeout := Value;
end;

procedure TWebDriver.SwitchToFrame(const FrameEl: TElement);
var
  Command: string;
  Data: string;
  Resp: string;
begin
  Command := Host + '/session/' + FSessionID + '/frame';


    Data := '{"id": {"'+ FrameEl.GetElementName + '": "' + FrameEl.ElementID + '"}}';

  Resp := ExecuteCommand(cPost, Command, Data);
  ProcResponse(Resp);

end;

function TWebDriver.SwitchToAlert(): TAlert;
var
  Command: string;
  Data: string;
  Resp: string;
  txt: string;
  ale: TAlert;
begin
  Command := Host + '/session/' + FSessionID + '/alert/text';


  Resp := ExecuteCommand(cGet, Command, Data);
  txt := ProcResponse(Resp);
  if GetHasError then
    result := nil
  else
  begin
    ale := TAlert.create(txt, self);
    result := ale;
  end;
end;

procedure TWebDriver.AlertAccept;
var
  Command: string;
  Resp: string;
begin
  Command := Host + '/session/' + FSessionID + '/alert/accept';


  Resp := ExecuteCommand(cPost, Command);
  ProcResponse(Resp);
end;

procedure TWebDriver.AlertDismiss;
var
  Command: string;
  Resp: string;
begin
  Command := Host + '/session/' + FSessionID + '/alert/dismiss';


  Resp := ExecuteCommand(cPost, Command);
  ProcResponse(Resp);

end;


procedure TWebDriver.SwitchToDefaultContent();
var
  Command: string;
  Data: string;
  Resp: string;
begin
  Command := Host + '/session/' + FSessionID + '/frame';


  Data := '{"id": null}';
  Resp := ExecuteCommand(cPost, Command, Data);
  ProcResponse(Resp);

end;

procedure TWebDriver.WaitForLoaded;
var
  I: integer;
begin
  I := 0;
  while I < Timeout do
  begin
    sleep(500);
    Inc(I, 1000);
    if ExecuteScript('return document.readyState') = 'complete' then
      break;
  end;
end;

procedure TWebDriver.SetBinary(const exename: string);
begin
  FBrowserPath := exename;
end;

procedure TWebDriver.SetProfile(const profilename: string);
begin
  FProfile := profilename;
end;

procedure TWebDriver.SetCapability(const capname: string; const capvalue: string);
begin
  if capname<>'' then
  begin
    if capabArray.ContainsKey(capname)=true then
        capabArray.Remove(capname);
    capabArray.Add(capname, capvalue)
  end;
end;

procedure TWebDriver.Wait(const ms: Integer);
begin
  Sleep(ms);
end;

function TWebDriver.AddCapabilities(): string;
var
  k, v: string;
  buf: string;
begin
  result := '';
  if capabArray.Count>0 then
  begin
    buf := '';
    for k in capabArray.Keys do
    begin
      if buf<>'' then
        buf := buf+',';
      if (k[1]<>'[') and (k[1]<>'{') then
      buf := buf + '"' + k + '": ';
      v := capabArray.Items[k];
      if (v='true') or (v='false')
         or (v[1]='[') or (v[1]='{')  // Json array or object
      then
        buf := buf + v
      else
        buf := buf + '"' + v + '"';
    end;
    result := buf;
  end;

end;

procedure TWebDriver.sendActions(const data: string);
var
  Command: string;
  Resp: string;
begin
  Command := Host + '/session/' + FSessionID + '/actions';


  Resp := ExecuteCommand(cPost, Command, Data);


  ProcResponse(Resp);

end;

procedure TWebDriver.ProcessActions(actList: TMouseActionContainer);
var
  Data: string;
begin
  Data := '';
  Data := actList.toJson;
  sendActions(data);
end;

procedure TWebDriver.ProcessActions(actList: TKeyboardActionContainer);
var
  Data: string;
begin
  Data := '';
  Data := actList.toJson;
  sendActions(data);
end;

{**************************************************************************}
constructor TElement.Create(elementData: string; W3C: Boolean);
begin
  System.Assert(elementData<>'', 'Element.Create: data empty)');
  inherited Create;
  FElementData := elementData;
  FW3C := w3C;

  FElementID := GetElementID;
  FWebDriver := nil;
end;


function TElement.GetElementID: string;
var
  Json: TJsonObject;
begin
  Json := TJsonObject.Create;
  try
    Json.FromJSON(FElementData);
    if FW3C then
    begin
      result := Json.Items[0].Value;
    end
    else
    begin
      result := Json.S['ELEMENT'];
    end;
  finally
    FreeAndNil(Json);
  end;
end;

function TElement.GetElementName: string;
begin
  if not FW3C then
    result := WEB_ELEMENT_CONST
  else
  begin
    result := WEB_ELEMENT_CONST_W3C;
  end;
end;


procedure TElement.setWebDriver(wd: TWebDriver);
begin
  if wd<>nil then
    FWebDriver := wd;
end;

function TElement.executeScript(const script: string; const params: string = '[]'): string;
var
  scriptEle: string;
  paramsEle: string;
  elemConst: string;
begin
  System.Assert(FWebDriver<>nil, 'TElement.ExecuteScript: web driver not assigned');


  scriptEle := 'return (function(){' + script + '}).apply(arguments[0],arguments[1]);';

  if FW3C then
    elemConst :=  '{"'+WEB_ELEMENT_CONST_W3C+'": "'+FElementID+'"}'
  else
    elemConst :=  '{"'+WEB_ELEMENT_CONST+'": "'+FElementID+'"}' ;

  if params = '[]' then
  begin
    paramsEle := '['+elemConst+' , [0]]';
  end else
  begin
    paramsEle := '['+elemConst + ', '+params+']';

  end;

  Result := FWebDriver.ExecuteScript(scriptEle, paramsEle);
end;

procedure TElement.selectByText(const text: string);
var
  js: string;
  res: string;
  optEle: TElement;
begin
  System.Assert(FWebDriver<>nil, 'TElement.selectByText: web driver not assigned');

  if FWebDriver.GetElementTagname(self)<>'select' then
    raise Exception.Create('Element.selectByText: element is not a select');

//js := 'flFound=false; for (var i = 0; i < this.options.length; i++) {' +
//      ' if (this.options[i].text === "'+text+'") {'     +
//      ' this.selectedIndex = i; flFound=true;'                        +
//      ' break;'                                       +
//      ' };'                                           +
//      ' };' +
//      'return (flFound);';
 
   optEle := nil;
   optEle := FWebDriver.FindElementInElement(Self, 'xpath', 'option[text()="'+text+'"]');
   if (optEle = nil) then
    raise Exception.Create('selectByText: option "'+text+'" not found');
   optEle.Click();
   optEle.Free;
end;

function TElement.SelectIsMultiple(): boolean;
var
  js: string;
begin
  System.Assert(FWebDriver<>nil, 'TElement.SelectIsMultiple: web driver not assigned');

  if FWebDriver.GetElementTagname(self)<>'select' then
    raise Exception.Create('Element.SelectIsMultiple: element is not a select');

  js :=    'return (this.multiple);' ;
  Result := (self.ExecuteScript(js) = 'true');

end;

function TElement.SelectedOptionText(): string;
var
  js: string;
begin
  System.Assert(FWebDriver<>nil, 'TElement.SelectedOptionText: web driver not assigned');

  if FWebDriver.GetElementTagname(self)<>'select' then
    raise Exception.Create('Element.SelectedOptionText: element is not a select');

  js :=
      'var result = "";'  +
      'var options = this && this.options; '+
      'var opt;' +

      'for (var i=0, iLen=options.length; i<iLen; i++) {' +
      '  opt = options[i];' +

      '  if (opt.selected) { ' +
      '    if (result != "") {result = result + "|"};' +
      '    result=result + opt.text; ' +
      '  }; ' +
      '}; ' +
      'return result;' ;

  Result := self.ExecuteScript(js);

end;

function TElement.SelectOptionsCount(): integer;
var
  js: string;
begin
  System.Assert(FWebDriver<>nil, 'TElement.SelectOptionsCount: web driver not assigned');

  if FWebDriver.GetElementTagname(self)<>'select' then
    raise Exception.Create('Element.SelectOptionsCount: element is not a select');

  js :=    'return (this.options.length);' ;
  Result := StrToInt(self.ExecuteScript(js));

end;



function TElement.CssValue(const cssproperty: string): string;
begin
  System.Assert(FWebDriver<>nil, 'TElement.CssValue: web driver not assigned');

  Result := FWebDriver.GetElementCssValue(Self, cssproperty);
end;

function TElement.Attribute(const name: string): string;
begin
  System.Assert(FWebDriver<>nil, 'TElement.Attribute: web driver not assigned');
  Result := FWebDriver.GetElementAttribute(Self, name, false);
end;

function TElement.PropertyHtml(const name: string): string;
begin
  System.Assert(FWebDriver<>nil, 'TElement.PropertyHtml: web driver not assigned');

  Result := FWebDriver.GetElementAttribute(Self, name, true);
end;

function TElement.text(): string;
begin
  System.Assert(FWebDriver<>nil, 'TElement.Text: web driver not assigned');

  result := FWebDriver.GetElementText(self);

end;

function TElement.tagname(): string;
begin
  System.Assert(FWebDriver<>nil, 'TElement.tagname: web driver not assigned');

  result := FWebDriver.GetElementTagname(self);

end;

procedure TElement.Click;
begin
  System.Assert(FWebDriver<>nil, 'TElement.Click: web driver not assigned');


  FWebDriver.ElementClick(self);
end;

function TElement.IsSelected(): boolean;
var
  rs: string;
begin
  System.Assert(FWebDriver<>nil, 'TElement.IsSelected: web driver not assigned');

  // make sense only for OPTION,  RADIO, CHECKBOX
  rs := FWebDriver.GetElementSelected(self);
  Result := (rs = 'true');
end;

function TElement.IsDisplayed(): boolean;
var
  rs: string;
begin
  System.Assert(FWebDriver<>nil, 'TElement.IsDisplayed: web driver not assigned');

  rs := FWebDriver.GetElementDisplayed(self);
  Result := (rs = 'true');
end;

procedure TElement.Clear;
begin
  System.Assert(FWebDriver<>nil, 'TElement.Clear: web driver not assigned');


  FWebDriver.ElementClear(self);

end;

function TElement.TableRows(): integer;
var
  js: string;
begin
  System.Assert(FWebDriver<>nil, 'TElement.TableRows: web driver not assigned');

  if FWebDriver.GetElementTagname(self)<>'table' then
    raise Exception.Create('Element.TableRows: element is not a table');

  js := 'return (this.rows.length);';

  result := StrToInt(self.ExecuteScript(js));
end;

procedure TElement.SendKey(const keys: string);
begin
  System.Assert(FWebDriver<>nil, 'TElement.SendKeys: web driver not assigned');


  FWebDriver.SendKey(Self, keys);
end;

{***************************************************************************}
constructor TAlert.create(text: string; WebDriver: TWebDriver);
begin
  System.Assert((text<>'') and (WebDriver<>nil), 'TAlert.Create: text empty, or webdriver not assigned');
  FWebDriver := WebDriver;
  FText := text;

end;

procedure TAlert.Accept;
begin
  System.Assert(FWebDriver<>nil, 'TAlert.Accept: web driver not assigned');

  FWebDriver.AlertAccept;
end;

procedure TAlert.Dismiss;
begin
  System.Assert(FWebDriver<>nil, 'TAlert.Dismiss: web driver not assigned');

  FWebDriver.AlertDismiss;
end;
{************************************************************************************}



end.
