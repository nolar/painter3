UNIT Main;

INTERFACE

uses
  Variants, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DrawThread, ComCtrls, Menus, ExtDlgs, ClipBrd, XPMan,
  ActnList;


resourcestring
	SGenerating  = 'Генерация изображения';
  SFormatting  = 'Преобразование в визуальную форму';
  SDone	       = 'Готово';
  SError		   = 'ОШИБКА';
  SErrorParams = 'Неправильные или неприемлимые значения параметров!';
  SWrongValue  = '';

type
  TFormMain = class(TForm)
    Splitter: TSplitter;
    Tree: TTreeView;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    SaveDialog: TSavePictureDialog;
    N3: TMenuItem;
    N4: TMenuItem;
    Params: TPanel;
    XPManifest: TXPManifest;
    X1: TEdit;
    X1Label: TLabel;
    Y1Label: TLabel;
    Y1: TEdit;
    X2Label: TLabel;
    X2: TEdit;
    Y2Label: TLabel;
    Y2: TEdit;
    XSLabel: TLabel;
    XS: TEdit;
    YSLabel: TLabel;
    YS: TEdit;
    ButtonSize: TButton;
    ButtonSave: TButton;
    ScrollBox: TScrollBox;
    Paint: TPaintBox;
    ButtonClipboard: TButton;
    ActionList: TActionList;
    ActionSave: TAction;
    ActionClip: TAction;
    ActionSetup: TAction;
    ActionAbout: TAction;
    ButtonAbout: TButton;
    StatusBar: TStatusBar;
    Proportion: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TreeChange(Sender: TObject; Node: TTreeNode);
    procedure PaintPaint(Sender: TObject);
    procedure ActionSetupExecute(Sender: TObject);
    procedure ActionSaveExecute(Sender: TObject);
    procedure ActionClipExecute(Sender: TObject);
    procedure ActionAboutExecute(Sender: TObject);
    procedure ThreadTerminate(Sender: TObject);
    procedure ProportionClick(Sender: TObject);
    procedure ParamChange(Sender: TObject);
  private
    { Private declarations }
    DrawThread:TDrawThread;
    ProportionMode: (propNone, propX1, propX2, propY1, propY2, propXS, propYS);
  public
    { Public declarations }
    Bitmap: TBitmap;
  end;

var
  FormMain: TFormMain;

IMPLEMENTATION

uses About;

{$R *.DFM}
var DLLs:Variant;
    pch:array[1..255]of char;


procedure TFormMain.FormCreate(Sender: TObject);
var Path:String;
    s:ShortString;
    idx,i,r:Integer;
    e1,e2,e3:Extended;
    sr:TSearchRec;
    lib:THandle;
    prc:function(var Name:ShortString):Variant;
    vrt:Variant;
    obj:TProc;
    tr:TTreeNode;
begin
	Bitmap := TBitmap.Create;
  DrawThread := nil;
  ProportionMode := propNone;

  Path:=ExtractFilePath(ParamStr(0));
  idx:=1; DLLs:=VarArrayCreate([idx,idx],varInteger);
  r:=FindFirst(Path+'*.dll',faAnyFile,sr);
  while(r=0)do
    begin
      lib:=LoadLibrary(PChar(Path+sr.Name));
      if(lib<>0)then
        begin
          DLLs[idx]:=lib; idx:=idx+1; VarArrayRedim(DLLs,idx);
          @prc:=GetProcAddress(lib,'Painter'); s:=sr.name; vrt:=prc(s);
          tr:=Tree.Items.Add(nil,s);
          for i:=VarArrayLowBound(vrt,1) to VarArrayHighBound(vrt,1) do
            begin
              obj:=TProc.Create;
              strpcopy(@pch,String(vrt[i]));
              @obj.Addr:=GetProcAddress(lib,@pch);
              if(@obj.Addr<>nil)then
                begin
//                  e1:=0; e2:=0; e3:=0; s:=obj.Addr(0,0,0,-1,e1,e2,e3);
//                  obj.Sym:=Trunc(e1); obj.Cut:=Trunc(e2);
                  s:=pch; obj.Cut := cutFrac;
                  Tree.Items.AddChildObject(tr,s,obj);
                end else
                obj.Free;  
            end;
        end;
      r:=FindNext(sr);
    end;
  VarArrayRedim(DLLs,idx-1);
  Tree.Selected:=nil;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
var idx:Integer;
begin
  if (DrawThread <> nil) then begin
    DrawThread.Free;
    DrawThread := nil;
  end;

  Bitmap.Free;
  Bitmap := nil;

  for idx:=1 to VarArrayHighBound(DLLs,1) do
    FreeLibrary(DLLs[idx]);
end;

procedure TFormMain.TreeChange(Sender: TObject; Node: TTreeNode);
begin
  ActionSetupExecute(Sender);
end;

procedure TFormMain.PaintPaint(Sender: TObject);
var
  R: TRect;
begin
  R.Left   := 0;
  R.Top    := 0;
  R.Right  := Bitmap.Width ;
  R.Bottom := Bitmap.Height;
  Paint.Canvas.CopyRect(R, Bitmap.Canvas, R);
end;

procedure TFormMain.ActionSetupExecute(Sender: TObject);
var
  EverythingOk: Boolean;
begin
  MessageBeep(0);
  if ((Tree.Selected <> nil) and (Tree.Selected.Data <> nil)) then begin
    Caption := Application.Title + ' - ' + Tree.Selected.Text;
    if (DrawThread <> nil) then DrawThread.Free;
    DrawThread := TDrawThread.Create(true);
    try
    	EverythingOk := true;
      DrawThread.X1 := StrToFloat(X1.Text);
      DrawThread.Y1 := StrToFloat(Y1.Text);
      DrawThread.X2 := StrToFloat(X2.Text);
      DrawThread.Y2 := StrToFloat(Y2.Text);
      DrawThread.XS := StrToInt(XS.Text);
      DrawThread.YS := StrToInt(YS.Text);
      Paint.Width  := DrawThread.XS;
      Paint.Height := DrawThread.YS;
    except on EConvertError do EverythingOk := false;
    end;
    DrawThread.Obj := TProc(Tree.Selected.Data);
    DrawThread.OnTerminate := ThreadTerminate;
    if EverythingOk then begin
      DrawThread.Resume;
      StatusBar.Panels[1].Text := SGenerating;
    end else begin
    	DrawThread.Free;
      DrawThread := nil;
      StatusBar.Panels[0].Text := SError;
      StatusBar.Panels[1].Text := SErrorParams;
    end;
  end;
end;

procedure TFormMain.ActionSaveExecute(Sender: TObject);
begin
  if(SaveDialog.Execute)then begin
  	Bitmap.SaveToFile(SaveDialog.Filename);
  end;
end;

procedure TFormMain.ActionClipExecute(Sender: TObject);
var Clp:TClipBoard;
begin
  Clp:=TClipBoard.Create;
  Clp.Assign(Bitmap);
  Clp.Free;
end;

procedure TFormMain.ActionAboutExecute(Sender: TObject);
begin
  with(TAboutWin.Create(nil))do
    try ShowModal;
    finally Free;
    end;
end;

procedure TFormMain.ThreadTerminate(Sender: TObject);
begin
  Paint.Invalidate;
  StatusBar.Panels[1].Text := SDone;
end;

procedure TFormMain.ProportionClick(Sender: TObject);
begin
  case Proportion.ItemIndex of
    0: ProportionMode := propNone;
    1: ProportionMode := propX1;
    2: ProportionMode := propX2;
    3: ProportionMode := propY1;
    4: ProportionMode := propY2;
    5: ProportionMode := propXS;
    6: ProportionMode := propYS;
  end;
  X1.Enabled := ProportionMode <> propX1;
  X2.Enabled := ProportionMode <> propX2;
  Y1.Enabled := ProportionMode <> propY1;
  Y2.Enabled := ProportionMode <> propY2;
  XS.Enabled := ProportionMode <> propXS;
  YS.Enabled := ProportionMode <> propYS;
  ParamChange(Sender);
end;

procedure TFormMain.ParamChange(Sender: TObject);
var
	x1v, x2v, y1v, y2v: Extended;
  xsv, ysv: Integer;
  EverythingOk: Boolean;
begin
  EverythingOk := true;
  try
    if ProportionMode <> propX1 then x1v := strtofloat(X1.Text);
    if ProportionMode <> propX2 then x2v := strtofloat(X2.Text);
    if ProportionMode <> propY1 then y1v := strtofloat(Y1.Text);
    if ProportionMode <> propY2 then y2v := strtofloat(Y2.Text);
    if ProportionMode <> propXS then xsv := strtoint(XS.Text);
    if ProportionMode <> propYS then ysv := strtoint(YS.Text);
  except on EConvertError do EverythingOk := false;
  end;
  case ProportionMode of
    propX1: if EverythingOk then X1.Text := floattostr(  X2v-(Y2v-Y1v)*XSv/YSv  ) else X1.Text := SWrongValue;
    propX2: if EverythingOk then X2.Text := floattostr(  X1v+(Y2v-Y1v)*XSv/YSv  ) else X2.Text := SWrongValue;
    propY1: if EverythingOk then Y1.Text := floattostr(  Y2v-(X2v-X1v)*YSv/XSv  ) else Y1.Text := SWrongValue;
    propY2: if EverythingOk then Y2.Text := floattostr(  Y1v+(X2v-X1v)*YSv/XSv  ) else Y2.Text := SWrongValue;
    propXS: if EverythingOk then XS.Text := inttostr(trunc(  (X2v-X1v)*YSv/(Y2v-Y1v)  )) else XS.Text := SWrongValue;
    propYS: if EverythingOk then YS.Text := inttostr(trunc(  (Y2v-Y1v)*XSv/(X2v-X1v)  )) else YS.Text := SWrongValue;
  end;
end;

END.
