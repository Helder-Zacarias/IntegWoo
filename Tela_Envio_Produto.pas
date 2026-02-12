unit Tela_Envio_Produto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, WooProdutoRequest, VCL.NumberBox,
  Vcl.ExtDlgs;

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
    dialogPathImagem: TOpenPictureDialog;
    editPathImagem: TEdit;
    labelPathImagem: TLabel;
    comboCategoria: TComboBox;
    labelCategoria: TLabel;
    procedure FormShow(Sender: TObject);
    procedure DefinirPosicaoDosElementos();
    procedure FormResize(Sender: TObject);
    procedure btnRetornarInformacoes(Sender: TObject);
    procedure editClickOpenImageExplorer(Sender: TObject);
    procedure onFormCreate(Sender: TObject);
  private
    FProdutoInfo: TWooProdutoRequest;
    FPathImagem: string;
    FCategoria: string;
  public
    property ProdutoInfo: TWooProdutoRequest read FProdutoInfo write FProdutoInfo;
    property PathImagem: string read FPathImagem write FPathImagem;
    property Categoria: string read FCategoria write FCategoria;
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

procedure TForm1.onFormCreate(Sender: TObject);
begin
	comboCategoria.Items.Add('Camisetas');
    comboCategoria.Items.Add('Calçados');
    comboCategoria.Items.Add('Acessórios');
    comboCategoria.Items.Add('Moletons');
    comboCategoria.Items.Add('Categoria Teste');
    comboCategoria.ItemIndex := 0;
end;

procedure TForm1.btnRetornarInformacoes(Sender: TObject);
begin
    FProdutoInfo := TWooProdutoRequest.Create;

    FProdutoInfo.Name := editNome.Text;
    FProdutoInfo.Description := editDescricao.Text;
    FProdutoInfo.ShortDescription := editDescricaoCurta.Text;
    FProdutoInfo.RegularPrice := boxPreco.Text;

    FPathImagem := editPathImagem.text;
    FCategoria := comboCategoria.Text;

    ModalResult := mrOk;
end;

procedure TForm1.DefinirPosicaoDosElementos;
begin
	editNome.Left := (editNome.Parent.ClientWidth - editNome.Width) div 2;
    editDescricao.Left := (editDescricaoCurta.Parent.ClientWidth - editDescricao.Width) div 2;
    editDescricaoCurta.Left := (editDescricaoCurta.Parent.ClientWidth - editDescricaoCurta.Width) div 2;
    boxPreco.Left := (boxPreco.Parent.ClientWidth - boxPreco.Width) div 2;
    btnEnviarProduto.Left := (btnEnviarProduto.Parent.ClientWidth - btnEnviarProduto.Width) div 2;
    editPathImagem.Left := (editPathImagem.Parent.ClientWidth - editPathImagem.Width) div 2;
    comboCategoria.Left := (comboCategoria.Parent.ClientWidth - comboCategoria.Width) div 2;

    labelNome.Left := editNome.Left;
    labelDescricao.Left := editDescricao.Left;
    labelDescricaoCurta.Left := editDescricaoCurta.Left;
    labelPreco.Left := boxPreco.Left;
    labelPathImagem.Left := editPathImagem.Left;
    labelCategoria.Left := comboCategoria.Left;
end;

procedure TForm1.editClickOpenImageExplorer(Sender: TObject);
begin
 	dialogPathImagem.Filter := 'Image Files|*.jpg;*.jpeg;*.png';
    if dialogPathImagem.Execute then
        editPathImagem.Text := dialogPathImagem.FileName;
end;

end.
