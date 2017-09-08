unit STKPForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, ComCtrls;

type
  THeroRec = packed record
    Xcoordinate: SmallInt;
    Ycoordinate: SmallInt;
    DirectionFaced: SmallInt;
    LevelOfTheCastle: SmallInt;
    SomeUnknownData1: array[0..288] of byte;
    Strength: Byte;
    SomeUnknownData2: array[0..10] of byte;
    Agility: Byte;
    SomeUnknownData3: array[0..10] of byte;
    Health: Byte;
    SomeUnknownData4: array[0..10] of byte;
    CurrentHitPoints: SmallInt;
    MaximumHitPoints: SmallInt;
    MissileSkill: Byte;
    SomeUnknownData6: array[0..4] of byte;
    AxeSkill: Byte;
    SomeUnknownData7: array[0..4] of byte;
    BrawlSkill: Byte;
    SomeUnknownData8: array[0..4] of byte;
    DaggerSkill: Byte;
    SomeUnknownData9: array[0..4] of byte;
    HammerSkill: Byte;
    SomeUnknownData10: array[0..4] of byte;
    PArmSkill: Byte;
    SomeUnknownData11: array[0..4] of byte;
    SwordSkill: Byte;
    SomeUnknownData12: array[0..4] of byte;
    ShieldSkill: Byte;
    SomeUnknownData13: array[0..4] of byte;
    StealthSkill: Byte;
    SomeUnknownData14: array[0..4] of byte;
    MagicSkill: Byte;
  end;
  PHeroRec = ^THeroRec;

  TStonekeepForm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    OpenDialog1: TOpenDialog;
    XPosEd: TEdit;
    YPosEd: TEdit;
    DirectEd: TEdit;
    LevelEd: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    StrEd: TEdit;
    Label6: TLabel;
    AgiEd: TEdit;
    Label7: TLabel;
    HeaEd: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    HpEd: TEdit;
    MaxHp: TEdit;
    Label10: TLabel;
    MissileEd: TEdit;
    Label11: TLabel;
    AxeEd: TEdit;
    Label12: TLabel;
    BrawlEd: TEdit;
    Label13: TLabel;
    DaggerEd: TEdit;
    Label14: TLabel;
    HammerEd: TEdit;
    Label15: TLabel;
    PArmEd: TEdit;
    Label16: TLabel;
    SwordEd: TEdit;
    Label17: TLabel;
    ShieldEd: TEdit;
    Label18: TLabel;
    StealthEd: TEdit;
    Label19: TLabel;
    MagicEd: TEdit;
    XPosUd: TUpDown;
    YPosUd: TUpDown;
    DirectUd: TUpDown;
    LevelUd: TUpDown;
    StrUd: TUpDown;
    AgiUd: TUpDown;
    HeaUd: TUpDown;
    HpUd: TUpDown;
    MaxHpUd: TUpDown;
    MissileUd: TUpDown;
    AxeUd: TUpDown;
    BrawlUd: TUpDown;
    DaggerUd: TUpDown;
    HammerUd: TUpDown;
    PArmUd: TUpDown;
    SwordUd: TUpDown;
    ShieldUd: TUpDown;
    StealthUd: TUpDown;
    MagicUd: TUpDown;
    procedure Open1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
  private
    { Private declarations }
    HeroRec: THeroRec;    // in-memory hero record
    FileBuffer: PChar;    // buffer for loading savegame file
    FileHandle: Integer;  // savegame file handle
    SizeOfFile: Integer;
    procedure FillControls(rec: THeroRec);
    procedure ReadControls(var rec: THeroRec);
  public
    { Public declarations }
  end;

Const
  DRAKE_OFFSET = 7;

var
  StonekeepForm: TStonekeepForm;

implementation

{$R *.DFM}

procedure TStonekeepForm.Open1Click(Sender: TObject);
begin
  with OpenDialog1 do
    if Execute then
      begin
        // Open savgefile for R/W operations
        FileHandle := FileOpen(FileName, fmOpenReadWrite or fmShareDenyNone);
        // Calculate size of file by jumping to the end of file and reading position
        SizeOfFile := FileSeek(FileHandle,0,2);
        // if FileBuffer is not empty free buffer memory
        if FileBuffer <> nil then StrDispose(FileBuffer);
        // Allocate meory for file buffer
        FileBuffer := StrAlloc(SizeOfFile+2);
        if FileHandle > 0 then
          begin
            // Go back to beginning of file
            FileSeek(FileHandle,0,0);
            // Read file into buffer in memory
            if FileRead(FileHandle,FileBuffer^,SizeOfFile) > 0 then
              begin
                // Read record from buffer to HeroRec variable
                Move(PHeroRec(FileBuffer+DRAKE_OFFSET)^,HeroRec,SizeOf(THeroRec));
                FillControls(HeroRec);
              end;
          end
        else
          ShowMessage('Open error: FileHandle = negative DOS error code');
        // Cleanup
        StrDispose(FileBuffer);
        FileBuffer := nil;
      end;
end;

procedure TStonekeepForm.FormCreate(Sender: TObject);
begin
  FileBuffer := nil;
end;

procedure TStonekeepForm.FormDestroy(Sender: TObject);
begin
  if FileBuffer <> nil then StrDispose(FileBuffer);
  if FileHandle > 0 then FileClose(FileHandle);
end;

procedure TStonekeepForm.FillControls(rec: THeroRec);
begin
  with rec do
    begin
      XPosEd.Text   := IntToStr(Xcoordinate);
      YPosEd.Text   := IntToStr(Ycoordinate);
      DirectEd.Text := IntToStr(DirectionFaced);
      LevelEd.Text  := IntToStr(LevelOfTheCastle);
      StrEd.Text    := IntToStr(Strength);
      AgiEd.Text    := IntToStr(Agility);
      HeaEd.Text    := IntToStr(Health);
      HpEd.Text     := IntToStr(CurrentHitPoints);
      MaxHp.Text    := IntToStr(MaximumHitPoints);
      MissileEd.Text:= IntToStr(MissileSkill);
      AxeEd.Text    := IntToStr(AxeSkill);
      BrawlEd.Text  := IntToStr(BrawlSkill);
      DaggerEd.Text := IntToStr(DaggerSkill);
      HammerEd.Text := IntToStr(HammerSkill);
      PArmEd.Text   := IntToStr(PArmSkill);
      SwordEd.Text  := IntToStr(SwordSkill);
      ShieldEd.Text := IntToStr(ShieldSkill);
      StealthEd.Text:= IntToStr(StealthSkill);
      MagicEd.Text  := IntToStr(MagicSkill);
    end;
end;

procedure TStonekeepForm.ReadControls(var rec: THeroRec);
begin
  with rec do
    begin
      Xcoordinate      := StrToIntDef(XPosEd.Text,0);
      Ycoordinate      := StrToIntDef(YPosEd.Text,0);
      DirectionFaced   := StrToIntDef(DirectEd.Text,0);
      LevelOfTheCastle := StrToIntDef(LevelEd.Text,0);
      Strength         := StrToIntDef(StrEd.Text,0);
      Agility          := StrToIntDef(AgiEd.Text,0);
      Health           := StrToIntDef(HeaEd.Text,0);
      CurrentHitPoints := StrToIntDef(HpEd.Text,0);
      MaximumHitPoints := StrToIntDef(MaxHp.Text,0);
      MissileSkill     := StrToIntDef(MissileEd.Text,0);
      AxeSkill         := StrToIntDef(AxeEd.Text,0);
      BrawlSkill       := StrToIntDef(BrawlEd.Text,0);
      DaggerSkill      := StrToIntDef(DaggerEd.Text,0);
      HammerSkill      := StrToIntDef(HammerEd.Text,0);
      PArmSkill        := StrToIntDef(PArmEd.Text,0);
      SwordSkill       := StrToIntDef(SwordEd.Text,0);
      ShieldSkill      := StrToIntDef(ShieldEd.Text,0);
      StealthSkill     := StrToIntDef(StealthEd.Text,0);
      MagicSkill       := StrToIntDef(MagicEd.Text,0);
    end;
end;

procedure TStonekeepForm.Save1Click(Sender: TObject);
begin
  if FileBuffer =  nil then exit;
  ReadControls(HeroRec);
  Move(HeroRec,PHeroRec(FileBuffer+DRAKE_OFFSET)^,SizeOf(THeroRec));
  if FileHandle > 0 then
    begin
      // Go to beginning of file
      FileSeek(FileHandle,0,0);
      // Write buffer into file
      FileWrite(FileHandle,FileBuffer^,SizeOfFile);
    end;
end;

procedure TStonekeepForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

end.
