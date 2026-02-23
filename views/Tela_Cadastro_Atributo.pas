unit Tela_Cadastro_Atributo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmTela_Cadastro_Atributo = class(TForm)
    labelNomeAtributo: TLabel;
    editNomeAtributo: TEdit;
    btnEnviarAtributo: TButton;
    procedure AjustarPosicoesDosElementos;
    procedure OnCreateForm(Sender: TObject);
    procedure OnResizeForm(Sender: TObject);
    procedure btnEnviarAtributoClick(Sender: TObject);
  private
    FAtributo: string;
  public
    property Atributo: string read FAtributo write Fatributo;
    { Public declarations }
  end;

var
  frmTela_Cadastro_Atributo: TfrmTela_Cadastro_Atributo;

implementation

{$R *.dfm}

procedure TfrmTela_Cadastro_Atributo.AjustarPosicoesDosElementos;
begin
	editNomeAtributo.Left := (editNomeAtributo.Parent.ClientWidth - editNomeAtributo.ClientWidth) div 2;
    btnEnviarAtributo.Left := (btnEnviarAtributo.Parent.ClientWidth - btnEnviarAtributo.ClientWidth) div 2;
    labelNomeAtributo.Left := editNomeAtributo.Left;
end;

procedure TfrmTela_Cadastro_Atributo.btnEnviarAtributoClick(Sender: TObject);
var
    Atributo: string;
begin
     FAtributo := editNomeAtributo.Text;
     ModalResult := mrOk;
end;

procedure TfrmTela_Cadastro_Atributo.OnCreateForm(Sender: TObject);
begin
    AjustarPosicoesDosElementos;
end;

procedure TfrmTela_Cadastro_Atributo.OnResizeForm(Sender: TObject);
begin
   AjustarPosicoesDosElementos;
end;

end.
