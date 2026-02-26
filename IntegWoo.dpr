program IntegWoo;

uses
  Vcl.Forms,
  Tela_Envio_Produto in 'views\Tela_Envio_Produto.pas' {frmTela_Envio},
  Produto in 'models\Produto.pas',
  WooCategoriaRequest in 'rest-client\woocommerce-api\WooCategoriaRequest.pas',
  WooImagemRequest in 'rest-client\woocommerce-api\WooImagemRequest.pas',
  WooImagemResponse in 'rest-client\woocommerce-api\WooImagemResponse.pas',
  WooProdutoRequest in 'rest-client\woocommerce-api\WooProdutoRequest.pas',
  WooProdutoResponse in 'rest-client\woocommerce-api\WooProdutoResponse.pas',
  WPImagemResponse in 'rest-client\wordpress-media-api\WPImagemResponse.pas',
  Tela_Principal in 'views\Tela_Principal.pas' {frmTela_Principal},
  AppConfig in 'config\AppConfig.pas',
  Secao in 'models\Secao.pas',
  WooProductVariationsRequest in 'rest-client\woocommerce-api\WooProductVariationsRequest.pas',
  WooAtributoProduto in 'rest-client\woocommerce-api\WooAtributoProduto.pas',
  WooAtributoDaVariacao in 'rest-client\woocommerce-api\WooAtributoDaVariacao.pas',
  WooVariacaoDoProduto in 'rest-client\woocommerce-api\WooVariacaoDoProduto.pas',
  WooAtributoRequest in 'rest-client\woocommerce-api\WooAtributoRequest.pas',
  WooTermoAtributoRequest in 'rest-client\woocommerce-api\WooTermoAtributoRequest.pas',
  Tela_Cadastro_Atributo in 'views\Tela_Cadastro_Atributo.pas' {frmTela_Cadastro_Atributo},
  Tela_Adicionar_Termo in 'views\Tela_Adicionar_Termo.pas' {frmTela_Adicionar_Termo},
  WooAtributoResponse in 'rest-client\woocommerce-api\WooAtributoResponse.pas',
  CustomObjectMapper in 'utils\CustomObjectMapper.pas',
  FileWriter in 'utils\FileWriter.pas',
  WooCreateCategoriaRequest in 'rest-client\woocommerce-api\WooCreateCategoriaRequest.pas',
  WooCategoriaResponse in 'rest-client\woocommerce-api\WooCategoriaResponse.pas',
  WooProdutoCategoriaRequest in 'rest-client\woocommerce-api\WooProdutoCategoriaRequest.pas',
  TrimTexto in 'utils\TrimTexto.pas',
  ContentPrinter in 'utils\ContentPrinter.pas',
  ProdutoGrade in 'models\ProdutoGrade.pas',
  ProdutoImagem in 'models\ProdutoImagem.pas';

{$R *.res}

begin
  Application.Initialize;
  TAppConfig.Load;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmTela_Principal, frmTela_Principal);
  Application.CreateForm(TfrmTela_Cadastro_Atributo, frmTela_Cadastro_Atributo);
  Application.CreateForm(TfrmTela_Adicionar_Termo, frmTela_Adicionar_Termo);
  Application.Run;
end.
