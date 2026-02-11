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
  AppConfig in 'AppConfig.pas';

{$R *.res}

begin
  Application.Initialize;
  TAppConfig.Load;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
