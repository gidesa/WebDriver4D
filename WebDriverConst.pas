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
unit WebDriverConst;

interface

const
  WEB_ELEMENT_CONST_W3C =  'element-6066-11e4-a52e-4f735466cecf';
  WEB_ELEMENT_CONST     =  'ELEMENT';

  // Special keys values
  kUNIDENTIFIED = $E000;
  kCANCEL = $E001;
  kHELP = $E002;
  kBACKSPACE = $E003;
  kTAB = $E004;
  kCLEAR = $E005;
  kRETURN = $E006;
  kENTER = $E007;
  kSHIFT = $E008;
  kCONTROL = $E009;
  kALT = $E00A;
  kPAUSE = $E00B;
  kESCAPE = $E00C;
  kBLANK = $E00D;
  kPAGEUP = $E00E;
  kPAGEDOWN = $E00F;
  kEND = $E010;
  kHOME = $E011;
  kARROWLEFT = $E012;
  kARROWUP = $E013;
  kARROWRIGHT = $E014;
  kARROWDOWN = $E015;
  kINSERT = $E016;
  kDELETE = $E017;
  kF1 = $E031;
  kF2 = $E032;
  kF3 = $E033;
  kF4 = $E034;
  kF5 = $E035;
  kF6 = $E036;
  kF7 = $E037;
  kF8 = $E038;
  kF9 = $E039;
  kF10 = $E03A;
  kF11 = $E03B;
  kF12 = $E03C;
  kMETA = $E03D;
  kZENKAKUHANKAKU = $E040;
  kSHIFT2 = $E050;
  kCONTROL2 = $E051;
  kALT2 = $E052;
  kMETA2 = $E053;
  kPAGEUP2 = $E054;
  kPAGEDOWN2 = $E055;
  kEND2 = $E056;
  kHOME2 = $E057;
  kARROWLEFT2 = $E058;
  kARROWUP2 = $E059;
  kARROWRIGHT2 = $E05A;
  kARROWDOWN2 = $E05B;
  kINSERT2 = $E05C;
  kDELETE2 = $E05D;

type
  TBrowserActionType = (batPointer, batKey, batNone);
  TActionPointerType = (aptMouse, aptPen, aptTouch);
  TActionPointer     = (apPause, apPointerUp, apPointerDown, apPointerMove, apPointerCancel);
  TActionKey         = (akPause, akKeyUp, akKeyDown);

  TCommandType = (cGet, cPost, cDelete);
  TDriverType = (btUnknown, btPhantomjs, btIE, btFirefox, btChrome, btEdge);


{*************************************************************************}
implementation


end.
