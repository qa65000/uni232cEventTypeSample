unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, Uni232C;

const

MAX_BUFFER_SIZE = 10;

type
  TForm6 = class(TForm)
    Uni232C1: TUni232C;
    Memo1: TMemo;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
     RxChar    : byte;
     ReadIndex : word;
     ReadBuffer: array [0..MAX_BUFFER_SIZE-1] of byte;
     procedure RxCharEvent(Ptr : PBYTE ; Size : Word);
  private
    { private 宣言 }
  public
    { public 宣言 }
  end;

var
  Form6: TForm6;

implementation

{$R *.fmx}
//////////// 初期設定　 ////////////////////////////
procedure TForm6.FormCreate(Sender: TObject);
begin
    ReadIndex := 0;
    Rxchar    := $0a;
    Uni232c1.Open;
end;

//////////// Rx Char Evnet ////////////////////////////


procedure TForm6.RxCharEvent(Ptr : PBYTE ;Size : Word);
var
  Str : AnsiString;
begin
    SetLength(Str,Size);
    Move(Ptr^, Str[1], Size);
    Memo1.Lines.Add(Str);
end;

///////////// Timer polling ///////////////////////////
procedure TForm6.Timer1Timer(Sender: TObject);
var
  Adata : array [0..63] of byte;
  ret,i : byte;

begin
   ret := Uni232C1.Read(64, @AData);
      if( ret > 0 ) then begin
        for i := 0 to ret - 1 do
        begin
          ReadBuffer[ReadIndex] := AData[i];              //とりあえずバッファリング
          if(ReadIndex < MAX_BUFFER_SIZE) then
                                              Inc(ReadIndex);
          if AData[i]= RxChar then begin
              RxCharEvent(@ReadBuffer,ReadIndex);       // Rxchar Evenet 作成
              ReadIndex := 0;
          end;
        end;
      end;
end;

end.
