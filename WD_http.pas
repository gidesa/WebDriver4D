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

unit WD_http;

interface

uses
  Classes, Sysutils; 

type

  TDriverCommand = class(TComponent)
  private
    FTimeout: integer;
  protected
    FSTM: TStringStream;
    procedure InitHeader; virtual; abstract;
    function GetTimeout: integer; virtual; abstract;
    procedure SetTimeout(const Value: integer); virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ExecuteDelete(command: string); virtual; abstract;
    function ExecuteGet(URL: string): string; virtual; abstract;
    function ExecutePost(const URL, Data: string): string; virtual; abstract;
    property Timeout: integer read GetTimeout write SetTimeout;
  end;

implementation

constructor TDriverCommand.Create(AOwner: TComponent);
begin
  inherited;
  FSTM := TStringStream.Create('', TEncoding.UTF8);
  FTimeout := 10000;
end;

destructor TDriverCommand.Destroy;
begin
  FreeAndNil(FSTM);
  inherited;
end;

end.
