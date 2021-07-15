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

program WebDriver4DTests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options 
  to use the console test runner.  Otherwise the GUI test runner will be used by 
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}


uses
  DUnitTestRunner,
  vcl.Forms,
  System.SysUtils,
  TestWebDriver in 'TestWebDriver.pas',
  Webdriver4D in '..\Webdriver4D.pas',
  JsonDataObjects in '..\JsonDataObjects.pas',
  WD_http in '..\WD_http.pas',
  WD_httpDelphi_XE2 in '..\WD_httpDelphi_XE2.pas',
  WebClasses in '..\WebClasses.pas',
  WebDriverConst in '..\WebDriverConst.pas',
  WebDriverSpec in '..\WebDriverSpec.pas';

{frmSpSettings}


{$R *.RES}






begin
	{$IFDEF DEBUG}
  	ReportMemoryLeaksOnShutdown :=true;
  {$ENDIF}

 

  	DUnitTestRunner.RunRegisteredTests;
 
end.

