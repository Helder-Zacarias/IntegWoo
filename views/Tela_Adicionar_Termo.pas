unit Tela_Adicionar_Termo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmTela_Adicionar_Termo = class(TForm)
    editTermo: TEdit;
    labelTermo: TLabel;
    btnAdicionarTermo: TButton;
    procedure btnAdicionarTermoCLick(Sender: TObject);
    procedure AjustarPosicoesDosElementos;
    procedure OnFormCreate(Sender: TObject);
    procedure OnFormResize(Sender: TObject);
  private
  	FTermo: string;
  public
    property Termo: string read FTermo write FTermo;
  end;

var
  frmTela_Adicionar_Termo: TfrmTela_Adicionar_Termo;

implementation

{$R *.dfm}

procedure TfrmTela_Adicionar_Termo.AjustarPosicoesDosElementos;
begin
    editTermo.Left := (editTermo.Parent.ClientWidth -editTermo.ClientWidth) div 2;
    btnAdicionarTermo.Left := (btnAdicionarTermo.Parent.ClientWidth - btnAdicionarTermo.ClientWidth) div 2;

    labelTermo.Left := editTermo.Left;
end;

procedure TfrmTela_Adicionar_Termo.btnAdicionarTermoCLick(Sender: TObject);
begin
  FTermo := editTermo.Text;
  ModalResult := mrOk;
end;

procedure TfrmTela_Adicionar_Termo.OnFormCreate(Sender: TObject);
begin
   AjustarPosicoesDosElementos;
end;

procedure TfrmTela_Adicionar_Termo.OnFormResize(Sender: TObject);
begin
    AjustarPosicoesDosElementos;
end;

end.
