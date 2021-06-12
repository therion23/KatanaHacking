Program katanactl;
Uses DOS;

(* Very VERY crude way of controlling the Katana *)
(* Compile with FreePascal and good luck! *)

Const
  Magic: Byte = $5A;

Var
  I,
  O: File;

  Ibuf,
  Obuf: Array[0..63] of Byte;

  NR: Word;

  B: Byte;
  W: Word;

  C1,
  C2: String;

Procedure ClearBuf;
Begin
  For B := 0 To 63 Do Begin
    Ibuf[B] := 0;
    Obuf[B] := 0;
  End;
End;

Function HexBuf(Offset: Byte): String;
Begin
  HexBuf := '';
  For B := Offset To Ibuf[2] + 2 Do HexBuf := HexBuf + (HexStr(Ibuf[B], 2));
End;

Function Word2dB(Value: Word): String;
Var
  dB: String;
Begin
  If (Value AND $7fff) < $3f00 Then dB := '0.0';
  If (Value AND $7fff) >= $3f00 Then dB := '0.5';
  If (Value AND $7fff) >= $3f80 Then dB := '1.0';
  If (Value AND $7fff) >= $3fc0 Then dB := '1.5';
  If (Value AND $7fff) >= $4000 Then dB := '2.0';
  If (Value AND $7fff) >= $4020 Then dB := '2.5';
  If (Value AND $7fff) >= $4040 Then dB := '3.0';
  If (Value AND $7fff) >= $4060 Then dB := '3.5';
  If (Value AND $7fff) >= $4080 Then dB := '4.0';
  If (Value AND $7fff) >= $4090 Then dB := '4.5';
  If (Value AND $7fff) >= $40a0 Then dB := '5.0';
  If (Value AND $7fff) >= $40b0 Then dB := '5.5';
  If (Value AND $7fff) >= $40c0 Then dB := '6.0';
  If (Value AND $7fff) >= $40d0 Then dB := '6.5';
  If (Value AND $7fff) >= $40e0 Then dB := '7.0';
  If (Value AND $7fff) >= $40f0 Then dB := '7.5';
  If (Value AND $7fff) >= $4100 Then dB := '8.0';
  If (Value AND $7fff) >= $4108 Then dB := '8.5';
  If (Value AND $7fff) >= $4110 Then dB := '9.0';
  If (Value AND $7fff) >= $4118 Then dB := '9.5';
  If (Value AND $7fff) >= $4120 Then dB := '10.0';
  If (Value AND $7fff) >= $4128 Then dB := '10.5';
  If (Value AND $7fff) >= $4130 Then dB := '11.0';
  If (Value AND $7fff) >= $4138 Then dB := '11.5';
  If (Value AND $7fff) >= $4140 Then dB := '12.0';
  dB := dB + 'dB';
  if dB <> '0.0dB' Then If (Value AND $8000) = $8000 Then dB := '-' + dB Else dB := '+' + dB;
  Word2dB := dB;
End;

Function DeviceName(Device: Byte): String;
Begin
  Case Device Of
    $01: DeviceName := 'Bluetooth';
    $04: DeviceName := 'AUX';
    $07: DeviceName := 'Optical';
    $09: DeviceName := 'USB';
    $0c: DeviceName := 'Computer';
  End;
End;

Procedure HexReg(Ofs: Byte);
Begin
  WriteLn('Value: ' + HexStr(Ibuf[Ofs + 2], 2) + ' ' +
                      HexStr(Ibuf[Ofs + 3], 2) + ' ' +
                      HexStr(Ibuf[Ofs + 4], 2) + ' ' +
                      HexStr(Ibuf[Ofs + 5], 2));
End;

Procedure DumpPalette(Ofs: Byte);
Begin
  Write(HexStr(Ibuf[Ofs], 2) +
        HexStr(Ibuf[Ofs + 1], 2) +
        HexStr(Ibuf[Ofs + 2], 2) +
        HexStr(Ibuf[Ofs + 3], 2) + ' ');
End;

Procedure DumpReg95(Offset: Byte);
Begin
  If Ibuf[Offset] <> $95 Then Exit;
  Case Ibuf[Offset + 1] Of
    $04: Begin
      Write('sub 0x04 - Noise Reduction: ');
      If (Ibuf[Offset + 4] = $00) And (Ibuf[Offset + 5] = $00) Then WriteLn('Off')
      Else If (Ibuf[Offset + 4] = $80) And (Ibuf[Offset + 5] = $3f) Then WriteLn('On')
      Else HexReg(Offset);
    End;
    $05: Begin
      Write('sub 0x05 - TODO: ');
      HexReg(Offset);
    End;
    $0a,
    $0b,
    $0c,
    $0d,
    $0e,
    $0f,
    $10,
    $11: Begin
      Write('sub 0x' + HexStr(Ibuf[Offset + 1], 2) + ' - Voice Morph Pattern: ');
      HexReg(Offset);
    End;
    $12: Begin
      Write('sub 0x12 - Voice Morph: ');
      HexReg(Offset);
    End;
    Else Begin
      Write('### sub 0x', HexStr(Ibuf[Offset + 1], 2), ' - Unhandled - ');
      HexReg(Offset);
    End;
  End;
End;

Procedure DumpReg96(Offset: Byte);
Begin
  If Ibuf[Offset] <> $96 Then Exit;
  Case Ibuf[Offset + 1] Of
    $00: Begin
      Write('sub 0x00 - TODO: ');
      HexReg(Offset);
    End;
    $01: Begin
      Write('sub 0x01 - TODO: ');
      HexReg(Offset);
    End;
    $02: Begin
      Write('sub 0x02 - TODO: ');
      HexReg(Offset);
    End;
    $03: Begin
      Write('sub 0x03 - Dialog Plus (1): ');
      If (Ibuf[Offset + 4] = $00) And (Ibuf[Offset + 5] = $00) Then WriteLn('Off')
      Else If (Ibuf[Offset + 4] = $80) And (Ibuf[Offset + 5] = $3e) Then WriteLn('Normal')
      Else If (Ibuf[Offset + 4] = $00) And (Ibuf[Offset + 5] = $3f) Then WriteLn('Balanced')
      Else If (Ibuf[Offset + 4] = $80) And (Ibuf[Offset + 5] = $3f) Then WriteLn('Dialog Focus')
      Else HexReg(Offset);
    End;
    $04: Begin
      Write('sub 0x04 - TODO: ');
      HexReg(Offset);
    End;
    $05: Begin
      Write('sub 0x05 - TODO: ');
      HexReg(Offset);
    End;
    $07: Begin
      Write('sub 0x07 - Crystalizer: ');
      If (Ibuf[Offset + 4] = $00) And (Ibuf[Offset + 5] = $00) Then WriteLn('Off')
      Else If (Ibuf[Offset + 4] = $80) And (Ibuf[Offset + 5] = $3f) Then WriteLn('On')
      Else HexReg(Offset);
    End;
    $08: Begin
      Write('sub 0x08 - Crystalizer: ');
      HexReg(Offset);
    End;
    $09: Begin
      Write('sub 0x09 - TODO: ');
      HexReg(Offset);
    End;
    $0a: Begin
      Write('sub 0x0a - TODO: ');
      HexReg(Offset);
    End;
    $0b: Begin
      Write('sub 0x0b -    31Hz: ');
      WriteLn(Word2dB((Ibuf[Offset + 5] SHL 8) + Ibuf[Offset + 4]));
//      HexReg(Offset);
    End;
    $0c: Begin
      Write('sub 0x0c -    62Hz: ');
      WriteLn(Word2dB((Ibuf[Offset + 5] SHL 8) + Ibuf[Offset + 4]));
//      HexReg(Offset);
    End;
    $0d: Begin
      Write('sub 0x0d -   125Hz: ');
      WriteLn(Word2dB((Ibuf[Offset + 5] SHL 8) + Ibuf[Offset + 4]));
//      HexReg(Offset);
    End;
    $0e: Begin
      Write('sub 0x0e -   250Hz: ');
      WriteLn(Word2dB((Ibuf[Offset + 5] SHL 8) + Ibuf[Offset + 4]));
//      HexReg(Offset);
    End;
    $0f: Begin
      Write('sub 0x0f -   500Hz: ');
      WriteLn(Word2dB((Ibuf[Offset + 5] SHL 8) + Ibuf[Offset + 4]));
//      HexReg(Offset);
    End;
    $10: Begin
      Write('sub 0x10 -  1000Hz: ');
      WriteLn(Word2dB((Ibuf[Offset + 5] SHL 8) + Ibuf[Offset + 4]));
//      HexReg(Offset);
    End;
    $11: Begin
      Write('sub 0x11 -  2000Hz: ');
      WriteLn(Word2dB((Ibuf[Offset + 5] SHL 8) + Ibuf[Offset + 4]));
//      HexReg(Offset);
    End;
    $12: Begin
      Write('sub 0x12 -  4000Hz: ');
      WriteLn(Word2dB((Ibuf[Offset + 5] SHL 8) + Ibuf[Offset + 4]));
//      HexReg(Offset);
    End;
    $13: Begin
      Write('sub 0x13 -  8000Hz: ');
      WriteLn(Word2dB((Ibuf[Offset + 5] SHL 8) + Ibuf[Offset + 4]));
//      HexReg(Offset);
    End;
    $14: Begin
      Write('sub 0x14 - 16000Hz: ');
      WriteLn(Word2dB((Ibuf[Offset + 5] SHL 8) + Ibuf[Offset + 4]));
//      HexReg(Offset);
      End;
    $70: Begin
      Write('sub 0x70 - Smart Volume: ');
      If (Ibuf[Offset + 4] = $00) And (Ibuf[Offset + 5] = $40) Then WriteLn('Off')
      Else If (Ibuf[Offset + 4] = $00) And (Ibuf[Offset + 5] = $00) Then WriteLn('Auto')
      Else If (Ibuf[Offset + 4] = $80) And (Ibuf[Offset + 5] = $3f) Then WriteLn('Night')
      Else HexReg(Offset);
    End;
    $71: Begin
      Write('sub 0x71 - Immersion: ');
      If (Ibuf[Offset + 4] = $00) And (Ibuf[Offset + 5] = $00) Then WriteLn('Normal')
      Else If (Ibuf[Offset + 4] = $80) And (Ibuf[Offset + 5] = $3f) Then WriteLn('Wide')
      Else If (Ibuf[Offset + 4] = $00) And (Ibuf[Offset + 5] = $40) Then WriteLn('Ultra Wide')
      Else HexReg(Offset);
    End;
    $72: Begin
      Write('sub 0x72 - Dialog Plus (2): ');
      If (Ibuf[Offset + 4] = $00) And (Ibuf[Offset + 5] = $00) Then WriteLn('Off')
      Else If (Ibuf[Offset + 4] = $80) And (Ibuf[Offset + 5] = $3f) Then WriteLn('Normal')
      Else If (Ibuf[Offset + 4] = $00) And (Ibuf[Offset + 5] = $40) Then WriteLn('Balanced')
      Else If (Ibuf[Offset + 4] = $40) And (Ibuf[Offset + 5] = $40) Then WriteLn('Dialog Focus')
      Else HexReg(Offset);
    End;
    Else Begin
      Write('### sub 0x', HexStr(Ibuf[Offset + 1], 2), ' - Unhandled');
      HexReg(Offset);
    End;
  End;
End;

Procedure DumpReg97(Offset: Byte);
Begin
  If Ibuf[Offset] <> $97 Then Exit;
  Case Ibuf[Offset + 1] Of
    $02: Begin
      Write('sub 0x02 - Dolby: ');
      If (Ibuf[Offset + 4] = $80) And (Ibuf[Offset + 5] = $3f) Then WriteLn('Full')
      Else If (Ibuf[Offset + 4] = $00) And (Ibuf[Offset + 5] = $40) Then WriteLn('Normal')
      Else If (Ibuf[Offset + 4] = $40) And (Ibuf[Offset + 5] = $40) Then WriteLn('Night')
      Else HexReg(Offset);
    End;
    Else Begin
      Write('### sub 0x', HexStr(Ibuf[Offset + 1], 2), ' - Unhandled - ');
      HexReg(Offset);
    End;
  End;
End;

Procedure Monitor;
Begin
  While True Do Begin
    ClearBuf;
{$I-}
    BlockRead(I, Ibuf[0], 64, NR);
{$I-}
    If NR = 64 Then Begin
      Write('<-- ');
      Case Ibuf[1] Of
        $02: WriteLn('0x02 - Error - ' + HexBuf(3));
        $05: WriteLn('0x05 - TODO - ' + HexBuf(3));
        $06: WriteLn('0x06 - TODO - ' + HexBuf(3));
        $07: Begin
          Write('0x07 - Firmware - ');
          If Ibuf[2] = $10 Then Write('USB VID: ' + HexStr(Ibuf[8], 2) + HexStr(Ibuf[7], 2) + ' - ' +
                                      'PID: ' + HexStr(Ibuf[4], 2) + HexStr(Ibuf[3], 2) + ' - ' +
                                      'REV: ' + HexStr(Ibuf[6], 2) + HexStr(Ibuf[5], 2))
          Else If Ibuf[3] In [$31..$34] Then Begin
            Write('Revision: ');
            For B := 0 To (Ibuf[2] - 1) Do Write(Chr(Ibuf[B + 3]))
          End
          Else If Ibuf[Ibuf[2] + 2] = $00 Then Begin
            Write('USB Serial: ');
            For B := 0 To (Ibuf[2] - 1) Do Write(Chr(Ibuf[B + 3]))
          End
          Else Write(HexBuf(3));
          WriteLn;
        End;
        $10: WriteLn('0x10 - TODO - ' + HexBuf(3));
        $11: Begin
          Write('0x11 - Equalizer - Type ' + HexStr(Ibuf[5], 2) + ' - ');
          Case Ibuf[5] Of
            $95: Begin
              WriteLn('Voice');
              For B := 1 To Ibuf[3] Do DumpReg95((B * 6) - 1);
            End;
            $96: Begin
              WriteLn('Sound');
              For B := 1 To Ibuf[3] Do DumpReg96((B * 6) - 1);
            End;
            $97: Begin
              WriteLn('Dolby');
              For B := 1 To Ibuf[3] Do DumpReg97((B * 6) - 1);
            End;
            Else WriteLn(HexBuf(5));
          End;
        End;
        $15: WriteLn('0x15 - TODO - ' + HexBuf(3));
        $18: WriteLn('0x18 - TODO - ' + HexBuf(3));
        $1a: WriteLn('0x1a - Profile active: ', HexStr(Ibuf[4], 2));
        $1b: WriteLn('0x1b - TODO - ' + HexBuf(3));
        $1c: WriteLn('0x1c - TODO - ' + HexBuf(3));
        $1d: WriteLn('0x1d - TODO - ' + HexBuf(3));
        $20: WriteLn('0x20 - TODO - ' + HexBuf(3));
        $23: WriteLn('0x23 - Volume set to: ', Ibuf[4]);
        $26: WriteLn('0x26 - TODO - ' + HexBuf(3));
        $2c: WriteLn('0x2c - TODO - ' + HexBuf(3));
        $30: WriteLn('0x30 - TODO - ' + HexBuf(3));
        $39: WriteLn('0x39 - TODO - ' + HexBuf(3));
        $3a: Begin
          Write('0x3a - Light - Type ' + HexStr(Ibuf[3], 2) + ' - ');
          Case Ibuf[3] Of
            $05: Begin
              Write('Set pattern in profile ' + HexStr(Ibuf[5], 2) + ' to ');
              For B := 1 To (Ibuf[6] * 7) Do Begin
                Write(Chr((Ibuf[B + 7]) + 48));
                If (B MOD 7) = 0 Then Write(' ');
              End;
              WriteLn;
            End;
            $09: WriteLn('Set pattern in profile ' + HexStr(Ibuf[4], 2) + ' to type ' + HexStr(Ibuf[5], 2));
            $0b: Case Ibuf[6] Of
              $01: Begin
                Write('Set palette in profile ' + HexStr(Ibuf[5], 2) + ' to ');
                B := 8;
                While B < (Ibuf[2] + 3) Do Begin
                  DumpPalette(B);
                  B := B + 4;
                End;
                WriteLn;
              End;
              $03: WriteLn('Set pattern in profile ' + HexStr(Ibuf[5], 2) + ' to speed ', 60000 DIV ((Ibuf[8] SHL 8) + Ibuf[7]));
              $04: WriteLn('Set pattern in profile ' + HexStr(Ibuf[5], 2) + ' to direction ' + HexStr(Ibuf[7], 2) + ' and flag ' + HexStr(Ibuf[8], 2));
              Else WriteLn(HexBuf(3));
            End;
            Else WriteLn(HexBuf(3));
          End;
        End;
        $9c: Begin
          Write('0x11 - Input - Type ' + HexStr(Ibuf[3], 2) + ' - ');
          Case Ibuf[3] Of
            $00: WriteLn('Set input to ' + DeviceName(Ibuf[4]));
            $01: WriteLn('Input set to ' + DeviceName(Ibuf[4]));
            $02: WriteLn('TODO - ' + HexBuf(3));
            $06: Begin
              Write('Ready inputs');
              If Ibuf[8] = 1 Then Write(' - ' + DeviceName(Ibuf[7]));
              If Ibuf[10] = 1 Then Write(' - ' + DeviceName(Ibuf[9]));
              If Ibuf[12] = 1 Then Write(' - ' + DeviceName(Ibuf[11]));
              If Ibuf[14] = 1 Then Write(' - ' + DeviceName(Ibuf[13]));
              If Ibuf[16] = 1 Then Write(' - ' + DeviceName(Ibuf[15]));
            End;
            Else Write(HexBuf(5));
          End;
          WriteLn;
        End;
        Else Begin
          Write('### 0x' + HexStr(Ibuf[1], 2));
          If Ibuf[2] > 0 Then WriteLn(' - ' + HexBuf(3)) Else WriteLn;
        End;
      End;
    End;
  End;
  Close(I);
  Halt(0);
End;

Begin
  If (ParamCount < 2) OR (ParamCount > 3) Then Begin
    WriteLn('Usage: katanactl file/device monitor -or- katanactl file/device command parameter');
    Halt($ff);
  End;
  Assign(I, ParamStr(1));
{$I-}
  Reset(I, 1);
{$I+}
  W := IOResult;
  Case W Of
    0: WriteLn('-*- Communicating with ' + ParamStr(1));
    2: WriteLn('-!- Device not found');
    5: WriteLn('-!- Device cannot be opened');
    Else WriteLn('-!- Unknown error');
  End;
  If W > 0 Then Halt(W);

  C1 := Copy(LowerCase(ParamStr(2)), 1, 3);
  C2 := Copy(LowerCase(ParamStr(3)), 1, 3);

  If C1 = 'mon' Then Monitor;

  ClearBuf;

  Assign(O, ParamStr(1));
  Rewrite(O, 1);
  Obuf[0] := Magic;

  If C1 = 'pro' Then Begin
    Obuf[1] := $1a;
    Obuf[2] := $03;
    Obuf[3] := $00;
    Obuf[4] := $02;
    Obuf[5] := Ord(C2[1]) - 48;
  End;

  If C1 = 'lig' Then Begin
    Obuf[1] := $3a;
    Obuf[2] := $02;
    Obuf[3] := $06;
    If C2 = 'on' Then Obuf[4] := $01;
    If C2 = 'off' Then Obuf[4] := $00;
  End;

  If C1 = 'inp' Then Begin;
    Obuf[1] := $9c;
    If C2 = 'blu' Then Obuf[4] := $01;
    If C2 = 'aux' Then Obuf[4] := $04;
    If C2 = 'opt' Then Obuf[4] := $07;
    If C2 = 'usb' Then Obuf[4] := $09;
    If C2 = 'com' Then Obuf[4] := $0c;
    If Obuf[4] > $00 Then Begin
      Obuf[2] := $02;
      Obuf[3] := $00;
    End
    Else Begin
      Obuf[2] := $01;
      Obuf[3] := $01;
    End;
  End;

  If Obuf[1] <> $00 Then Begin
    Write('--> ');
    For B := 0 To Obuf[2] + 2 Do Write(HexStr(Obuf[B], 2), ' ');
    WriteLn;
    BlockWrite(O, Obuf[0], Obuf[2] + 3);
  End;
  Close(O);
  Close(I);
End.
