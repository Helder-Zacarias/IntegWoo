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
  Secao in 'models\Secao.pas';

{$R *.res}

begin
  Application.Initialize;
  TAppConfig.Load;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmTela_Principal, frmTela_Principal);
  Application.Run;
end.
