
Unit STKPForm;

{$MODE Delphi}

Interface

Uses 
LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls,
Forms, Dialogs,
Menus, StdCtrls, ComCtrls;

Type 
  THeroRec = packed Record
    Xcoordinate: SmallInt;
    Ycoordinate: SmallInt;
    DirectionFaced: SmallInt;
    LevelOfTheCastle: SmallInt;
    SomeUnknownData1: array[0..288] Of byte;
    Strength: Byte;
    SomeUnknownData2: array[0..10] Of byte;
    Agility: Byte;
    SomeUnknownData3: array[0..10] Of byte;
    Health: Byte;
    SomeUnknownData4: array[0..10] Of byte;
    CurrentHitPoints: SmallInt;
    MaximumHitPoints: SmallInt;
    MissileSkill: Byte;
    SomeUnknownData6: array[0..4] Of byte;
    AxeSkill: Byte;
    SomeUnknownData7: array[0..4] Of byte;
    BrawlSkill: Byte;
    SomeUnknownData8: array[0..4] Of byte;
    DaggerSkill: Byte;
    SomeUnknownData9: array[0..4] Of byte;
    HammerSkill: Byte;
    SomeUnknownData10: array[0..4] Of byte;
    PArmSkill: Byte;
    SomeUnknownData11: array[0..4] Of byte;
    SwordSkill: Byte;
    SomeUnknownData12: array[0..4] Of byte;
    ShieldSkill: Byte;
    SomeUnknownData13: array[0..4] Of byte;
    StealthSkill: Byte;
    SomeUnknownData14: array[0..4] Of byte;
    MagicSkill: Byte;
  End;
  PHeroRec = ^THeroRec;

  TStonekeepForm = Class(TForm)
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
    Procedure Open1Click(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure FormDestroy(Sender: TObject);
    Procedure Save1Click(Sender: TObject);
    Procedure Exit1Click(Sender: TObject);
    Private 
    { Private declarations }
      HeroRec: THeroRec;
      // in-memory hero record
      FileBuffer: PChar;
      // buffer for loading savegame file
      FileHandle: Integer;
      // savegame file handle
      SizeOfFile: Integer;
      Procedure FillControls(rec: THeroRec);
      Procedure ReadControls(Var rec: THeroRec);
    Public 
    { Public declarations }
  End;

Const 
  DRAKE_OFFSET = 7;

Var 
  StonekeepForm: TStonekeepForm;

Implementation

{$R *.lfm}

Procedure TStonekeepForm.Open1Click(Sender: TObject);
Begin
  With OpenDialog1 Do
    If Execute Then
      Begin
        // Open savgefile for R/W operations
        FileHandle := FileOpen(FileName, fmOpenReadWrite Or fmShareDenyNone);

        // Calculate size of file by jumping to the end of file and reading position
        SizeOfFile := FileSeek(FileHandle,0,2);
        // if FileBuffer is not empty free buffer memory
        If FileBuffer <> Nil Then StrDispose(FileBuffer);
        // Allocate meory for file buffer
        FileBuffer := StrAlloc(SizeOfFile+2);
        If FileHandle > 0 Then
          Begin
            // Go back to beginning of file
            FileSeek(FileHandle,0,0);
            // Read file into buffer in memory
            If FileRead(FileHandle,FileBuffer^,SizeOfFile) > 0 Then
              Begin
                // Read record from buffer to HeroRec variable
                Move(PHeroRec(FileBuffer+DRAKE_OFFSET)^,HeroRec,SizeOf(THeroRec)
                );
                FillControls(HeroRec);
              End;
          End
        Else
          ShowMessage('Open error: FileHandle = negative DOS error code');
        // Cleanup
        StrDispose(FileBuffer);
        FileBuffer := Nil;
      End;
End;

Procedure TStonekeepForm.FormCreate(Sender: TObject);
Begin
  FileBuffer := Nil;
End;

Procedure TStonekeepForm.FormDestroy(Sender: TObject);
Begin
  If FileBuffer <> Nil Then StrDispose(FileBuffer);
  If FileHandle > 0 Then FileClose(FileHandle);
End;

Procedure TStonekeepForm.FillControls(rec: THeroRec);
Begin
  With rec Do
    Begin
      XPosEd.Text   := IntToStr(Xcoordinate);
      YPosEd.Text   := IntToStr(Ycoordinate);
      DirectEd.Text := IntToStr(DirectionFaced);
      LevelEd.Text  := IntToStr(LevelOfTheCastle);
      StrEd.Text    := IntToStr(Strength);
      AgiEd.Text    := IntToStr(Agility);
      HeaEd.Text    := IntToStr(Health);
      HpEd.Text     := IntToStr(CurrentHitPoints);
      MaxHp.Text    := IntToStr(MaximumHitPoints);
      MissileEd.Text := IntToStr(MissileSkill);
      AxeEd.Text    := IntToStr(AxeSkill);
      BrawlEd.Text  := IntToStr(BrawlSkill);
      DaggerEd.Text := IntToStr(DaggerSkill);
      HammerEd.Text := IntToStr(HammerSkill);
      PArmEd.Text   := IntToStr(PArmSkill);
      SwordEd.Text  := IntToStr(SwordSkill);
      ShieldEd.Text := IntToStr(ShieldSkill);
      StealthEd.Text := IntToStr(StealthSkill);
      MagicEd.Text  := IntToStr(MagicSkill);
    End;
End;

Procedure TStonekeepForm.ReadControls(Var rec: THeroRec);
Begin
  With rec Do
    Begin
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
    End;
End;

Procedure TStonekeepForm.Save1Click(Sender: TObject);
Begin
  If FileBuffer =  Nil Then exit;
  ReadControls(HeroRec);
  Move(HeroRec,PHeroRec(FileBuffer+DRAKE_OFFSET)^,SizeOf(THeroRec));
  If FileHandle > 0 Then
    Begin
      // Go to beginning of file
      FileSeek(FileHandle,0,0);
      // Write buffer into file
      FileWrite(FileHandle,FileBuffer^,SizeOfFile);
    End;
End;

Procedure TStonekeepForm.Exit1Click(Sender: TObject);
Begin
  Close;
End;

End.
