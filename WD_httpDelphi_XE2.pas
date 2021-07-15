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

unit WD_httpDelphi_XE2;
// Uses Indy library


// Gestione errori Http senza eccezioni:
// ------------------------------------
//try
//  IdHTTP.Get('http://host/path');
//except
//  on E: EIdHTTPProtocolException do
//  begin
//    if E.ErrorCode <> 404 then Raise;
//  end;
//end;

//Update: thinking about it more, it might be worth adding a new flag to the
//TIdHTTP.HTTPOptions property to disable the exception for all status codes.
//I'm considering it.

//Update: a new hoNoProtocolErrorException flag has now been added to the
//TIdHTTP.HTTPOptions property:
//  IdHTTP.HTTPOptions := IdHTTP.HTTPOptions + [hoNoProtocolErrorException];
//  IdHTTP.Get('http://host/path');
// //use IdHTTP.ResponseCode as needed..

//Update: in addition, there is also a hoWantProtocolErrorContent flag as well.
//When hoNoProtocolErrorException is enabled and an HTTP error occurs, if
//hoWantProtocolErrorContent is enabled then the error content will be returned
//to the caller (either in a String return value or in an AResponseContent
//output stream, depending on which version of Get()/Post() is being called),
//otherwise the content will be discarded.

interface

uses
  Classes, Sysutils,

  IdHTTP, IdExceptionCore,    //xe2
  WD_http;

type
  TDelphiCommand = class(TDriverCommand)
  private
    fhttp: TIdHTTP; //xe2
  protected
    procedure InitHeader; override;
    function GetTimeout: integer; override;
    procedure SetTimeout(const Value: integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ExecuteDelete(command: string); override;
    function ExecuteGet(URL: string): string; override;
    function ExecutePost(const URL, Data: string): string; override;
  end;

implementation

constructor TDelphiCommand.Create(AOwner: TComponent);
begin
  inherited;
  fhttp := TIdHTTP.Create(); //xe2
  fhttp.ProtocolVersion := TIdHTTPProtocolVersion.pv1_1;
  // forza versione HTTP 1.1 anche in POST
  // necessaria per Chromedriver
  fhttp.HTTPOptions := fhttp.HTTPOptions + [hoKeepOrigProtocol];
end;

destructor TDelphiCommand.Destroy;
begin
  FreeAndNil(Fhttp);
  inherited;
end;

procedure TDelphiCommand.ExecuteDelete(command: string);
begin
try
  Fhttp.Delete(command);
except
    on E: EIdHTTPProtocolException do
    begin
            if (E.ErrorCode <> 404)
              and  (E.ErrorCode <> 500)
               then Raise;
    end;
end;
end;

function TDelphiCommand.ExecuteGet(URL: string): string;
begin
  result := '';
  InitHeader;
  FSTM.Clear;
  try
    Fhttp.Get(URL, FSTM);
    result := FSTM.DataString;
  except
    on E: EIdHTTPProtocolException do
    begin
            if (E.ErrorCode <> 404)
              and  (E.ErrorCode <> 500)
               then Raise
            else
               result := e.ErrorMessage;
    end;
    on E: EIdReadTimeout do
    begin
      Result := e.Message;
    end;
  end;
end;

function TDelphiCommand.ExecutePost(const URL, Data: string): string;
var
  PostStream: TStringStream;
begin
  result := '';
  PostStream := TStringStream.Create('', TEncoding.UTF8);
    try
      PostStream.WriteString(Data);
      PostStream.Position := 0;
      InitHeader;
      FSTM.Clear;
      try
        result := Fhttp.Post(URL, PostStream);  //xe2
      except
        on E: EIdHTTPProtocolException do
        begin
          if (E.ErrorCode <> 400)
            and  (E.ErrorCode <> 404)
            and  (E.ErrorCode <> 500)
             then Raise
          else
               result := E.ErrorMessage;
        end;
        on E: EIdReadTimeout do
        begin
          Result := e.Message;
        end;
        on E: Exception do
          raise;
      end;
    finally
      FreeAndNil(PostStream);
    end;
end;

function TDelphiCommand.GetTimeout: integer;
begin
  result := fhttp.ReadTimeout; //xe2
end;

procedure TDelphiCommand.InitHeader;
begin
  Fhttp.Request.UserAgent := 'Delphi http Client';  //xe2
  Fhttp.Request.ContentType := 'application/json';  //xe2
  Fhttp.Request.Accept := '*/*';  //xe2

end;

procedure TDelphiCommand.SetTimeout(const Value: integer);
begin
  fhttp.ReadTimeout := Value;   //xe2
end;

end.
