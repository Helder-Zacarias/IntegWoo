unit Tela_Cadastro_Atributo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Tela_Adicionar_Termo;

type
  TfrmTela_Cadastro_Atributo = class(TForm)
    labelNomeAtributo: TLabel;
    editNomeAtributo: TEdit;
    btnEnviarAtributo: TButton;
    btnAdicionarTermos: TButton;
    memoTermosAtributo: TMemo;
    procedure AjustarPosicoesDosElementos;
    procedure OnCreateForm(Sender: TObject);
    procedure OnResizeForm(Sender: TObject);
    procedure btnEnviarAtributoClick(Sender: TObject);
    procedure btnAdicionarTermosClick(Sender: TObject);
  private
    FAtributo: string;
    FTermos: TArray<string>;
  public
    property Atributo: string read FAtributo write FAtributo;
    property Termos: TArray<string> read FTermos write FTermos;
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
    memoTermosAtributo.Left := (memoTermosAtributo.Parent.ClientWidth - memoTermosAtributo.ClientWidth) div 2;

    labelNomeAtributo.Left := editNomeAtributo.Left;
    btnAdicionarTermos.Left := memoTermosAtributo.Left;
end;

procedure TfrmTela_Cadastro_Atributo.btnAdicionarTermosClick(Sender: TObject);
var
    AdicionarTermoForm: TfrmTela_Adicionar_Termo;
begin
	AdicionarTermoForm := TfrmTela_Adicionar_Termo.Create(Self);
    AdicionarTermoForm.Position := poScreenCenter;

    if AdicionarTermoForm.ShowModal = mrOk then
    begin
    	try
            SetLength(FTermos, Length(FTermos) + 1);
            FTermos[High(FTermos)] := AdicionarTermoForm.Termo;
            memoTermosAtributo.Lines.Add(FTermos[High(FTermos)]);
    	finally
       		AdicionarTermoForm.Free;
    end;
    end;
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
