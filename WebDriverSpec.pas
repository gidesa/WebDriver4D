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

unit WebDriverSpec;

interface
uses
  Classes,
  SysUtils,
  Windows,
  JsonDataObjects,
  WebDriverConst,
  Webdriver4D ;

type
  TPhantomjs = class(TWebDriver)
  private
    FCookieFiles: string;
    FDiskCache: Boolean;
    FDiskCachePath: string;
  strict protected
    function BuildParams: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
    function ExecuteScript(const Script: string; const Args: string = '[]')
      : string; override;
    function NewSession: string; override;
    property CookieFiles: string read FCookieFiles write FCookieFiles;
    property DiskCache: Boolean read FDiskCache write FDiskCache;
    property DiskCachePath: string read FDiskCachePath write FDiskCachePath;
  end;

  TIEDriver = class(TWebDriver)
  strict protected
    function BuildParams: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    function NewSession: string; override;
  end;

  TFireFoxDriver = class(TWebDriver)
  private
  strict protected
    function BuildParams: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function NewSession: string; override;
  end;

  TChromeDriver = class(TWebDriver)
  strict protected
    function BuildParams: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    function NewSession: string; override;
  end;

  TEdgeDriver = class(TWebDriver)
  strict protected
    function BuildParams: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    function NewSession: string; override;
  end;
{*****************************************************************************}
implementation
uses
  System.Variants, System.StrUtils;

{***************************************************************************}
constructor TPhantomjs.Create(AOwner: TComponent);
begin
  inherited;
  FDriverType := btPhantomjs;
  FDriverName := 'PHANTOMJS.EXE';
  FPort := 8080;
  FPath := '/wd/hub';
  FCookieFiles := '';
  FDiskCache := False;
  FDiskCachePath := '';
  FBrowserExe := '';

end;

procedure TPhantomjs.Assign(Source: TPersistent);
var
  WD: TPhantomjs;
begin
  inherited;
  if Source is TPhantomjs then
  begin
    WD := Source as TPhantomjs;
    self.CookieFiles := WD.CookieFiles;
    self.DiskCache := WD.DiskCache;
    self.DiskCachePath := WD.DiskCachePath;
  end;
end;

function TPhantomjs.BuildParams: string;
begin

  result := result + '  --webdriver=' + Address + ':' + inttostr(Port);
  if CookieFiles <> '' then
  begin
    result := result + ' --cookies-file=' + CookieFiles;
  end;
  if FDiskCache then
  begin
    result := result + ' --disk-cache=true';
  end
  else
  begin
    result := result + ' --disk-cache=false';
  end;
  if DiskCachePath <> '' then
  begin
    result := result + ' --disk-cache-path=' + DiskCachePath;
  end;

  if FLogFile <> '' then
  begin
    result := result + ' --webdriver-logfile=' + FLogFile;
  end;
end;

function TPhantomjs.ExecuteScript(const Script: string;
  const Args: string = '[]'): string;
var
  Command: string;
  Data: string;
  Resp: string;
  Json:TJsonObject;
begin
  Json :=TJsonObject.Create;
  try
    Command := Host + '/session/' + FSessionID + '/execute';
    Json.S['script'] := Script;
    Json.A['args'].FromJSON(Args);
    Data := Json.ToJSON();
    Resp := ExecuteCommand(cPost, Command, Data);
    result := ProcResponse(Resp);
  finally
    FreeAndNil(Json);
  end;
end;

function TPhantomjs.NewSession: string;
const
  Phantomjs_PARAM =
    '{"desiredCapabilities": {"takesScreenshot":false,"browserName":"phantomjs",'
    + '"phantomjs.page.settings.userAgent": "Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1667.0 Safari/537.36"'
    + ' , "platform": "windows", "version": "", "javascriptEnabled": true},' +
    '"capabilities": {"takesScreenshot":false,"browserName": "phantomjs", "firstMatch": [],'
    + '"phantomjs.page.settings.userAgent": "Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1667.0 Safari/537.36"'
    + ',"platform": "windows", "alwaysMatch": {}, "javascriptEnabled": true, "version": ""}}';
var
  Command: string;
  Resp: string;
  Json :TJsonObject;
begin
  Json :=TJsonObject.Create;
  try
    result := '';
    Command := Host + '/session';
    Resp := ExecuteCommand(cPost, Command, Phantomjs_PARAM);
    if Resp <> '' then
    begin
      Json.FromJSON(Resp);
      FW3C := not Json.Contains('status');
      if not Json.Contains('sessionId') then
        Json.FromJSON(Json.O['value'].ToJSON());
      FSessionID := Json.S['sessionId'];
      if FSessionID <> '' then
      begin
        result := FSessionID;
        FErrorMessage := '';
      end
      else
      begin
        if Json.Contains('message') then
          FErrorMessage := Json.S['message']
        else
          FErrorMessage := Resp;
      end;
  end
  else
  begin
    FErrorMessage := 'time out';
  end;
  finally
    FreeAndNil(Json);
  end;
end;

{***************************************************************************}
constructor TFireFoxDriver.Create(AOwner: TComponent);
begin
  inherited;
  FDriverType := btFirefox;
  FPort := 4444;
  FPath := '';
  FBrowserExe := 'FIREFOX.EXE';
  FDriverName := 'GECKODRIVER_X86.EXE';
end;

destructor TFireFoxDriver.Destroy;
begin
  inherited;
end;

function TFireFoxDriver.BuildParams: string;
begin
  result := ' --port '+IntToStr(FPort);
  if FLogFile<>'' then
    result := result + ' --log trace ';
// Geckodriver v 0.20 problem:
// Geckodriver can't connect to Marionette if custom profile via local path is in use
// Issue #1058
// Workaround: pass a fixed marionette port of 2828
  if FProfile<>'' then
    result := result + ' --marionette-port 2828';
end;

function TFireFoxDriver.NewSession: string;
const
  Firefox_Param =
    '{"capabilities": {"firstMatch": [{}], "alwaysMatch": {"browserName": "firefox", '
    + '"acceptInsecureCerts": true, "moz:firefoxOptions": {%s}}}, '
    + '"desiredCapabilities": {"browserName": "firefox", "acceptInsecureCerts": true, "moz:firefoxOptions": {%s}}}';

//    '{"capabilities": {'
//    + '"desiredCapabilities": {"browserName": "firefox", "acceptInsecureCerts": true, "moz:firefoxOptions": {%s}}}  }';
var
  Command: string;
  Resp: string;
  JsStr: string;
  par: string;
  capab: string;
  Json :TJsonObject;
  jsonAr: TJsonArray;
begin
  if FSessionID<>'' then
  begin
    FErrorMessage := 'Session is already started. Only one session is possible';
    Exit;
  end;
  Json :=TJsonObject.Create;
  try
    if FBrowserPath <> '' then
    begin
      if not FileExists(FBrowserPath) then
      begin
        raise Exception.Create('Firefox executable not found:' + FBrowserPath);
      end;
      JsStr := ReplaceStr(FBrowserPath, '\', '\\');
      SetCapability('binary', JsStr);
    end;

    if FProfile<>'' then
    begin
       jsonAr := TJsonArray.Create;
       jsonAr.Add( '-profile');
       jsonAr.Add(FProfile);
       SetCapability('args', jsonAr.ToJSON());
       jsonAr.Free;
    end;



    result := '';
    Command := Host + '/session';

    par := '';
    par := AddCapabilities();
    capab := Format(Firefox_Param, [par, par]) ;
    Resp := ExecuteCommand(cPost, Command, capab);
    if Resp <> '' then
    begin
    try
      Json.FromJSON(Resp);
      FW3C := not Json.Contains('status');
      if not Json.Contains('sessionId') then
        Json.FromJSON(Json.O['value'].ToJSON());
      FSessionID := Json.S['sessionId'];


      if FSessionID <> '' then
      begin
        result := FSessionID;
        FErrorMessage := '';
      end
      else
      begin
        if Json.Contains('message') then
          FErrorMessage := Json.S['message']
        else
          FErrorMessage := Resp;
      end;
    except
        on E: EJsonException do
          // not valid Json data
          raise Exception.Create('No valid Json response: <<'+resp+'>>');
        on E: Exception do
          raise Exception.Create('Firefox new session error: <<'+e.Message+'>> Response <<'+resp+'>>');
    end;
    end
    else
    begin
      FErrorMessage := 'time out';
    end;
  finally
    FreeAndNil(Json);
  end;
end;


{***************************************************************************}
constructor TIEDriver.Create(AOwner: TComponent);
begin
  inherited;
  FDriverType := btIE;
  FDriverName := 'IEDRIVERSERVER_X86.EXE';
  FPort := 5555;
  FBrowserExe := 'IEXPLORER.EXE';
end;

function TIEDriver.BuildParams: string;
begin
  result := ' /port=' + inttostr(FPort)  ;
  if FLogFile<>'' then
      result := result + ' /log-level=TRACE /log-file=' + FLogFile;
end;

function TIEDriver.NewSession: string;
const
  IE_desiredCapabilities =
    '{"desiredCapabilities": {"browserName": "internet explorer", "platformName": "windows"  %s}}';

var                                                                                     // "se:ieOptions": {
  Command: string;
  Resp: string;
  Json :TJsonObject;
  par: string;
  cap: string;
begin
  Json :=TJsonObject.Create;
  try
  result := '';
  Command := Host + '/session';


 // legacy type capabilities
  cap := AddCapabilities;
  if cap<>'' then
    cap := ','+cap;
  par := Format(IE_desiredCapabilities, [cap]);
  Resp := ExecuteCommand(cPost, Command, par);
  if Resp <> '' then
  begin
  try
      Json.FromJSON(Resp);
      FW3C := not Json.Contains('status');
      if not Json.Contains('sessionId') then
        Json.FromJSON(Json.O['value'].ToJSON());
      FSessionID := Json.S['sessionId'];
      if FSessionID <> '' then
      begin
        result := FSessionID;
        FErrorMessage := '';
      end
      else
      begin
        if Json.Contains('message') then
          FErrorMessage := Json.S['message']
        else
          FErrorMessage := Resp;
        if FPopup_Error then
          raise Exception.Create(FErrorMessage);
      end;
  except
        on E: EJsonException do
          // not valid Json data
          raise Exception.Create('No valid Json response: <<'+resp+'>>');
        on E: Exception do
          raise Exception.Create('TIEDriver.newSession error: <<'+e.Message+'>>');
  end;
  end
  else
  begin
    FErrorMessage := 'time out';
  end;
  finally
    FreeAndNil(Json);
  end;
end;

{***************************************************************************}
constructor TChromeDriver.Create(AOwner: TComponent);
begin
  inherited;
  FDriverType := btChrome;
  FDriverName := 'CHROMEDRIVER.EXE';
  FPort := 6666;
  FBrowserExe := 'CHROME.EXE';
end;

function TChromeDriver.BuildParams: string;
begin
  result := ' --port=' + inttostr(FPort);
  if FLogFile<>'' then
    result := result + ' --log-level=INFO --log-path=' + FLogFile;
end;

function TChromeDriver.NewSession: string;
const
  Chrome_Param =
    '{"capabilities": {"firstMatch": [{}], "alwaysMatch": {"browserName": "chrome",'
    + ' "platformName": "any", "goog:chromeOptions": {%s} }},'
    + ' "desiredCapabilities": {"browserName": "chrome", "version": "", "platform": "ANY",'
    + ' "goog:chromeOptions": {%s} }}';
var
  Command: string;
  Resp: string;
  par: string;
  capab: string;
  JsStr: string;
  Json:TJsonObject;
begin
  if FBrowserPath <> '' then
  begin
    if not FileExists(FBrowserPath) then
    begin
      raise Exception.Create('Chrome executable not found:' + FBrowserPath);
    end;
    JsStr := ReplaceStr(FBrowserPath, '\', '\\');
    SetCapability('binary', JsStr);
  end;
  Json :=TJsonObject.Create;
  try
  result := '';
  Command := Host + '/session';

  par := AddCapabilities();
  capab := Format(Chrome_Param, [par, par]) ;
  Windows.OutputDebugString(PWideChar('Chrome new session command >> '+command+'<< cap >>'+capab));
  Resp := ExecuteCommand(cPost, Command, capab);
  if Resp <> '' then
  begin
    Json.FromJSON(Resp);
    FW3C := not Json.Contains('status');
    if not Json.Contains('sessionId') then
      Json.FromJSON(Json.O['value'].ToJSON());
    FSessionID := Json.S['sessionId'];
    if FSessionID <> '' then
    begin
      result := FSessionID;
      FErrorMessage := '';
    end
    else
    begin
      if Json.Contains('message') then
        FErrorMessage := Json.S['message']
      else
        FErrorMessage := Resp;
    end;
  end
  else
  begin
    FErrorMessage := 'time out';
  end;
  finally
    FreeAndNil(Json);
  end;
end;


{***************************************************************************}
constructor TEdgeDriver.Create(AOwner: TComponent);
begin
  inherited;
  FDriverType := btEdge;
  FDriverName := 'MSEDGEDRIVER.EXE';
  FDriverNameAlt := 'MICROSOFTWEBDRIVER.EXE';
  FPort := 7777;
  FAddress := 'localhost';
  FBrowserExe := 'MICROSOFTEDGE.EXE';
end;

function TEdgeDriver.BuildParams: string;
begin
  result := ' --port=' + inttostr(FPort);
end;

function TEdgeDriver.NewSession: string;
const
  Edge_Param =
    '{"capabilities": {"firstMatch": [{}], "alwaysMatch": {"browserName": "MicrosoftEdge",'
    + ' "platformName": "windows"}}, "desiredCapabilities": {"browserName": "MicrosoftEdge",'
    + ' "version": "", "platform": "WINDOWS"}}';
var
  Command: string;
  Resp: string;
  Json :TJsonObject;
begin
  Json :=TJsonObject.Create;
  try
    result := '';
    Command := Host + '/session';
    Resp := ExecuteCommand(cPost, Command, Edge_Param);
    if Resp <> '' then
    begin
      Json.FromJSON(Resp);
      FW3C := not Json.Contains('status');
      if (not Json.Contains('sessionId')) or
      (Json.Values['sessionId'].VariantValue= null) then
        Json.FromJSON(Json.O['value'].ToJSON());
      FSessionID := Json.S['sessionId'];
      if FSessionID <> '' then
      begin
        result := FSessionID;
        FErrorMessage := '';
      end
      else
      begin
        if Json.Contains('message') then
          FErrorMessage := Json.S['message']
        else
          FErrorMessage := Resp;
      end;
    end
    else
    begin
      FErrorMessage := 'time out';
    end;
  finally
    FreeAndNil(Json);
  end;
end;



end.
