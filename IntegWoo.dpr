program IntegWoo;

uses
  Vcl.Forms,
  Tela_Principal in 'Tela_Principal.pas' {Form2},
  WooProdutoRequest in 'WooProdutoRequest.pas',
  WooImagemResponse in 'WooImagemResponse.pas',
  WooProdutoResponse in 'WooProdutoResponse.pas',
  WPImagemResponse in 'WPImagemResponse.pas',
  Produto in 'Produto.pas',
  WooImagemRequest in 'WooImagemRequest.pas',
  AppConfig in 'AppConfig.pas',
  Tela_Envio_Produto in 'Tela_Envio_Produto.pas' {Form1},
  WooCategoriaRequest in 'WooCategoriaRequest.pas';

{$R *.res}

begin
  Application.Initialize;
  TAppConfig.Load;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
