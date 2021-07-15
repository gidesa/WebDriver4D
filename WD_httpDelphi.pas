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

unit WD_httpDelphi;

interface

uses
  Classes, Sysutils,
  System.Net.HttpClient, System.Net.URLClient,
  System.NetConsts,
  WD_http;

type
  TDelphiCommand = class(TDriverCommand)
  private
    Fhttp: THTTPClient;
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
  Fhttp := THTTPClient.Create;
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
    //
  end;
end;

function TDelphiCommand.ExecuteGet(URL: string): string;
begin
  result := '';
  try
    InitHeader;
    FSTM.Clear;
    Fhttp.Get(URL, FSTM);
    result := FSTM.DataString;
  except
    result := FSTM.DataString;
  end;
end;

function TDelphiCommand.ExecutePost(const URL, Data: string): string;
var
  PostStream: TStringStream;
begin
  result := '';
  PostStream := TStringStream.Create('', TEncoding.UTF8);
  try
    try
      PostStream.WriteString(Data);
      PostStream.Position := 0;
      InitHeader;
      FSTM.Clear;
      Fhttp.Post(URL, PostStream, FSTM);
      result := FSTM.DataString;
    finally
      FreeAndNil(PostStream);
    end;
  except
    //
  end;
end;

function TDelphiCommand.GetTimeout: integer;
begin
  result := Fhttp.ResponseTimeout;
end;

procedure TDelphiCommand.InitHeader;
begin
   Fhttp.UserAgent := 'Delphi http Client';
   Fhttp.ContentType := 'application/json';
   Fhttp.Accept := '*/*';
end;

procedure TDelphiCommand.SetTimeout(const Value: integer);
begin
  Fhttp.ResponseTimeout := Value;
end;

end.
