program Painter;

uses
  Forms,
  DrawThread in 'drawthread.pas',
  Main in 'main.pas' {FormMain},
  About in 'About.pas' {AboutWin};

{$R *.RES}

begin
  Randomize;
  Application.Initialize;
  Application.Title := 'Художник';
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TAboutWin, AboutWin);
  Application.Run;
end.
