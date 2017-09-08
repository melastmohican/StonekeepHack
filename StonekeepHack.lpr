program StonekeepHack;

{$MODE Delphi}

uses
  Forms, Interfaces,
  STKPForm in 'src/STKPForm.pas' {StonekeepForm};

{.$R *.RES}

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Stonekeep Hack';
  Application.CreateForm(TStonekeepForm, StonekeepForm);
  Application.Run;
end.
