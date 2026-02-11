unit Tela_Envio_Produto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, WooProdutoRequest, VCL.NumberBox;

type
  TForm1= class(TForm)
    editNome: TEdit;
    labelDescricao: TLabel;
    editDescricao: TEdit;
    labelDescricaoCurta: TLabel;
    editDescricaoCurta: TEdit;
    labelPreco: TLabel;
    labelNome: TLabel;
    btnEnviarProduto: TButton;
    boxPreco: TNumberBox;
    procedure FormShow(Sender: TObject);
    procedure DefinirPosicaoDosElementos();
    procedure FormResize(Sender: TObject);
    procedure btnRetornarInformacoes(Sender: TObject);
  private
    FProdutoInfo: TWooProdutoRequest;
  public
    property ProdutoInfo: TWooProdutoRequest read FProdutoInfo write FProdutoInfo;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormResize(Sender: TObject);
begin
    DefinirPosicaoDosElementos;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
      DefinirPosicaoDosElementos;
end;

procedure TForm1.btnRetornarInformacoes(Sender: TObject);
begin
    FProdutoInfo := TWooProdutoRequest.Create;

    FProdutoInfo.Name := editNome.Text;
    FProdutoInfo.Description := editDescricao.Text;
    FProdutoInfo.ShortDescription := editDescricaoCurta.Text;
    FProdutoInfo.RegularPrice := boxPreco.Text;
    ModalResult := mrOk;
end;

procedure TForm1.DefinirPosicaoDosElementos;
begin
	editNome.Left := (editNome.Parent.ClientWidth - editNome.Width) div 2;
    editDescricao.Left := (editDescricaoCurta.Parent.ClientWidth - editDescricao.Width) div 2;
    editDescricaoCurta.Left := (editDescricaoCurta.Parent.ClientWidth - editDescricaoCurta.Width) div 2;
    boxPreco.Left := (boxPreco.Parent.ClientWidth - boxPreco.Width) div 2;
    btnEnviarProduto.Left := (btnEnviarProduto.Parent.ClientWidth - btnEnviarProduto.Width) div 2;

    labelNome.Left := editNome.Left;
    labelDescricao.Left := editDescricao.Left;
    labelDescricaoCurta.Left := editDescricaoCurta.Left;
    labelPreco.Left := boxPreco.Left;
end;

end.
