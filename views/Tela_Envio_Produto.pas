unit Tela_Envio_Produto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, WooProdutoRequest, VCL.NumberBox,
  Vcl.ExtDlgs, Vcl.CheckLst;

type
  TfrmTela_Envio= class(TForm)
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
    labelCor: TLabel;
    listBoxCor: TCheckListBox;
    labelTipoProduto: TLabel;
    comboTipoProduto: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure DefinirPosicaoDosElementos();
    procedure FormResize(Sender: TObject);
    procedure btnRetornarInformacoes(Sender: TObject);
    procedure editClickOpenImageExplorer(Sender: TObject);
    procedure onFormCreate(Sender: TObject);
    procedure AddItensToCombo(CustomListControl: TCustomListControl; Items: TArray<string>);
    procedure onEscolhaTipoProduto(Sender: TObject);
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
  frmTela_Envio: TfrmTela_Envio;

implementation

{$R *.dfm}

procedure TfrmTela_Envio.FormResize(Sender: TObject);
begin
    DefinirPosicaoDosElementos;
end;

procedure TfrmTela_Envio.FormShow(Sender: TObject);
begin
      DefinirPosicaoDosElementos;
end;

procedure TfrmTela_Envio.onEscolhaTipoProduto(Sender: TObject);
begin
    if comboTipoProduto.Text = 'Variável' then
    begin
        labelCor.Visible := True;
        listBoxCor.Visible := True
    end
    else
    begin
    	labelCor.Visible := False;
        listBoxCor.Visible := False
    end;
end;

procedure TfrmTela_Envio.onFormCreate(Sender: TObject);
begin
    AddItensToCombo(comboCategoria, ['Camisetas', 'Calçados', 'Acessórios', 'Moletons', 'Categoria Teste']);
    AddItensToCombo(listBoxCor, ['Azul', 'Vermelho', 'Marrom', 'Bege']);
    AddItensToCombo(comboTipoProduto, ['simple', 'variable']);
end;

procedure TfrmTela_Envio.AddItensToCombo(CustomListControl: TCustomListControl; Items: TArray<string>);
begin
    for var Item in Items do
       CustomListControl.AddItem(Item, nil);

    CustomListControl.ItemIndex := 0;
end;

procedure TfrmTela_Envio.btnRetornarInformacoes(Sender: TObject);
begin
    FProdutoInfo := TWooProdutoRequest.Create;

    FProdutoInfo.Name := editNome.Text;
    FProdutoInfo.Description := editDescricao.Text;
    FProdutoInfo.ShortDescription := editDescricaoCurta.Text;
    FProdutoInfo.RegularPrice := boxPreco.Text;
    FProdutoInfo.PType := comboTipoProduto.Text;

    FPathImagem := editPathImagem.text;
    FCategoria := comboCategoria.Text;

    ModalResult := mrOk;
end;

procedure TfrmTela_Envio.DefinirPosicaoDosElementos;
begin
	editNome.Left := (editNome.Parent.ClientWidth - editNome.Width) div 2;
    editDescricao.Left := (editDescricaoCurta.Parent.ClientWidth - editDescricao.Width) div 2;
    editDescricaoCurta.Left := (editDescricaoCurta.Parent.ClientWidth - editDescricaoCurta.Width) div 2;
    boxPreco.Left := (boxPreco.Parent.ClientWidth - boxPreco.Width) div 2;
    btnEnviarProduto.Left := (btnEnviarProduto.Parent.ClientWidth - btnEnviarProduto.Width) div 2;
    editPathImagem.Left := (editPathImagem.Parent.ClientWidth - editPathImagem.Width) div 2;
    comboCategoria.Left := (comboCategoria.Parent.ClientWidth - comboCategoria.Width) div 2;
    comboTipoProduto.Left := (comboTipoProduto.Parent.ClientWidth - comboTipoProduto.Width) div 2;

    listBoxCor.Left := (listBoxCor.Parent.ClientWidth - listBoxCor.Width) div 2;

    labelNome.Left := editNome.Left;
    labelDescricao.Left := editDescricao.Left;
    labelDescricaoCurta.Left := editDescricaoCurta.Left;
    labelPreco.Left := boxPreco.Left;
    labelPathImagem.Left := editPathImagem.Left;
    labelCategoria.Left := comboCategoria.Left;
    labelTipoProduto.Left := comboTipoProduto.Left;

    labelCor.Left := listBoxCor.Left;
end;

procedure TfrmTela_Envio.editClickOpenImageExplorer(Sender: TObject);
begin
 	dialogPathImagem.Filter := 'Image Files|*.jpg;*.jpeg;*.png';
    if dialogPathImagem.Execute then
        editPathImagem.Text := dialogPathImagem.FileName;
end;

end.
