UNIT DrawThread;

INTERFACE

uses
  Windows, Graphics, Classes, SysUtils;

const
  symZero=0; symHorz=1; symVert=2; symNone=3;
  cutFrac=0; cutNear=1;
type
  TProc    = class(TObject)
  public
    Addr:function(x,y,a,d:Extended; var r,g,b:Extended):ShortString;
    Sym,Cut:Integer;
  end;

  PBuffer = ^TBuffer;
  TBuffer = array[0..0] of TColor;

  TDrawThread = class(TThread)
  private
    { Private declarations }
    Buffer: PBuffer;
  protected
    procedure Stat;
    procedure Copy;
    procedure Execute; override;
  public
    obj: TProc;
    X1, Y1, X2, Y2: Extended;
    XS, YS: Integer;
    Progress: Extended;
  end;

IMPLEMENTATION

uses Main;



procedure TDrawThread.Stat;
begin
  FormMain.StatusBar.Panels[0].Text := inttostr(trunc(Progress*100)) + '%';
end;

procedure TDrawThread.Copy;
var
  X, Y: Integer;
begin
	FormMain.StatusBar.Panels[1].Text := SFormatting;
  FormMain.Bitmap.Width  := XS;
  FormMain.Bitmap.Height := YS;
  for X := 0 to XS-1 do
  for Y := 0 to YS-1 do
	  {$R-}
    FormMain.Bitmap.Canvas.Pixels[X,Y] := Buffer^[X*YS+Y];
    {$R+}
  FormMain.Paint.Invalidate;
end;



procedure TDrawThread.Execute;
var
	X, Y: Integer;
  XC, YC, AC, DC, RC, GC, BC: Extended;
begin
  if obj = nil then exit;
  // ограничения на значения
  if (XS < 2) then XS := 2;
  if (YS < 2) then YS := 2;
  if (X2 < X1) then begin XC := X1; X1 := X2; X2 := XC; end;
  if (Y2 < Y1) then begin YC := Y1; Y1 := Y2; Y2 := YC; end;
  // создаем объект, куда будет рисоваться
  Buffer := AllocMem(XS*YS*sizeof(Buffer^[0]));
  // выполняем попиксельную прорисовку
  for X := 0 to XS-1 do begin
    for Y := 0 to YS-1 do begin
      xc := X1 + (X/(XS-1)) * (X2-X1);
      yc := Y1 + (Y/(YS-1)) * (Y2-Y1);
      if (xc = 0) then ac := arctan(yc/1e-10) else ac := arctan(yc/xc);
      dc := sqrt(sqr(xc)+sqr(yc));
      rc := 0; gc := 0; bc := 0;
      try obj.Addr(xc,yc,ac,dc , rc,gc,bc);
      except
      on EInvalidOp do;
      on EDivByZero do;
      on EZeroDivide do;
      on EOverflow do;
      end;
      case(obj.Cut)of
        cutFrac:begin
                  rc:=abs(frac(rc));
                  gc:=abs(frac(gc));
                  bc:=abs(frac(bc));
                end;
        cutNear:begin
                  if(rc>1)then rc:=1; if(rc<0)then rc:=0;
                  if(gc>1)then gc:=1; if(gc<0)then gc:=0;
                  if(bc>1)then bc:=1; if(bc<0)then bc:=0;
                end;
      end;
      Progress := (X*YS+Y) / (XS*YS-1);
      {$R-}
      Buffer^[X*YS+Y] := rgb(trunc(rc*$ff),trunc(gc*$ff),trunc(bc*$ff));
      {$R+}
      if terminated then break;
    end;
    Synchronize(Stat);
    if terminated then break;
  end;
  Synchronize(Stat);
  Synchronize(Copy);
  FreeMem(Buffer);
end;

END.
