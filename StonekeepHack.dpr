program StonekeepHack;

uses
  Forms,
  STKPForm in 'src/STKPForm.pas' {StonekeepForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Stonekeep Hack';
  Application.CreateForm(TStonekeepForm, StonekeepForm);
  Application.Run;
end.
