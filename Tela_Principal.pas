unit Tela_Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Uni, UniProvider,
  MySQLUniProvider, DBAccess, MemData, MemDS, Vcl.StdCtrls, Vcl.Buttons, System.IOUtils, REST.Json, Rest.Json.Types, WooProdutoResponse,
  System.Generics.Collections, System.JSON, WPImagemResponse, WooImagemRequest, WooProdutoRequest, System.IniFiles, AppConfig;

type
  TForm2 = class(TForm)
    MySQL: TMySQLUniProvider;
    Database: TUniConnection;
    sqlProdutos: TUniQuery;
    sqlImagens: TUniQuery;
    butEnviarProdutos: TBitBtn;
    butReceberProdutos: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    btnEnviarFull: TBitBtn;
    procedure DatabaseConnectionLost(Sender: TObject; Component: TComponent;
      ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
    procedure butEnviarProdutosClick(Sender: TObject);
    procedure butReceberProdutosClick(Sender: TObject);
    procedure btnEnviarProduto(Sender: TObject);
    procedure btnEnviarImagemTestClick(Sender: TObject);
    function enviarImagem(ImagePath: string): TWPImagemResponse;
    function enviarProduto(Produto: TWooProdutoRequest): TWooProdutoResponse;
    procedure btnEnviarFullClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses
    RESTRequest4D,
	DataSet.Serialize;

{$R *.dfm}

procedure TForm2.btnEnviarFullClick(Sender: TObject);
var
	Produto: TWooProdutoRequest;
    WPImagemResponse: TWPImagemResponse;
    Arr: TArray<TWooImagemRequest>;
begin
    WPImagemResponse := enviarImagem(TAppConfig.TestImagePath);

    if not Assigned(WPImagemResponse) then
    	raise(Exception.Create('Upload de Imagem Falhou'));

    Produto := TWooProdutoRequest.Create;
    try
    	Produto.Name := 'Produto Teste';
        Produto.Slug := 'produto-teste';
        Produto.Description := 'Essa é a descrição longa do produto teste';
        Produto.ShortDescription := 'Desc Curta Teste';
        Produto.RegularPrice := '77.89';
        
        var Img := TWooImagemRequest.Create;
        Img.Id := WPImagemResponse.Id;
        Arr := Produto.Images;
  		SetLength(Arr, 1);
  		Arr[0] := Img;
  		Produto.Images := Arr;

    	enviarProduto(Produto);
    finally
        Produto.Free;
    end;
end;

function TForm2.enviarImagem(ImagePath: string): TWPImagemResponse;
var
	iRes: IResponse;
    MS: TMemoryStream;
    Filename: String;
    Lines: TStringList;
    WPImagemResponse: TWPImagemResponse;
begin
	Result := nil;
    MS := TMemoryStream.Create;
    
    try
    	MS.LoadFromFile(ImagePath);

        iRes := TRequest.New()
            .BaseURL(TAppConfig.WordPressApiUrl)
            .BasicAuthentication(TAppConfig.WPUser, TAppConfig.WPPassword)
            .ContentType('image/png')
            .AddHeader('Content-Disposition', 'attachment; filename="delphi-img-test.png"', [poDoNotEncode])
            .AddBody(MS)
            .Post;

    	if (iRes.StatusCode = 200) or (iRes.StatusCode = 201) then
            begin
            	WPImagemResponse := TJson.JsonToObject<TWPImagemResponse>(iRes.Content);
                Result := WPImagemResponse;
            end
        else
            ShowMessage('Status code: ' + iRes.StatusCode.ToString);

    finally
	end;

end;

function TForm2.enviarProduto(Produto: TWooProdutoRequest): TWooProdutoResponse;
var
	iRes: IResponse;
    JSONString: string;
    ProdutoResponse: TWooProdutoResponse;
begin
	JSONString := TJson.ObjectToJsonString(Produto);
        
    iRes := TRequest.New()
      	.BaseURL(TAppConfig.WooApiUrl)
        .Resource('products')
        .BasicAuthentication(TAppConfig.ConsumerKey, TAppConfig.ConsumerSecret)
        .ContentType('application/json')
        .AddBody(JSONString)
        .Post;

    ProdutoResponse := TJson.JsonToObject<TWooProdutoResponse>(iRes.Content);

    if (iRes.StatusCode = 200) or (iRes.StatusCode = 201) then
        begin
            Result := ProdutoResponse
        end
    else
    	raise(Exception.Create('Envio do produto falhou'))
end;

procedure TForm2.btnEnviarImagemTestClick(Sender: TObject);

begin
    enviarImagem(TAppConfig.TestImagePath);
end;

procedure TForm2.btnEnviarProduto(Sender: TObject);
var
	iRes: IResponse;
    ProdutoRequest: TWooProdutoRequest;
begin
	ProdutoRequest := TWooProdutoRequest.Create;
    ProdutoRequest.Name := 'Produto Teste';
    ProdutoRequest.Slug := 'produto-teste';
    ProdutoRequest.Description := 'Essa é a descrição longa do produto teste';
    ProdutoRequest.ShortDescription := 'Desc Curta Teste';
    ProdutoRequest.RegularPrice := '77.89';
    
    enviarProduto(ProdutoRequest)
end;

procedure TForm2.butEnviarProdutosClick(Sender: TObject);
var
	iRes: IResponse;
begin
    with sqlProdutos do
    begin
        Close;
        Connection:= Self.Database;
        Open;

        while not Eof do
        begin
        	ShowMessage(
            	'Id: ' + sqlProdutos.FieldByName('COD_ID_PRODUTO').AsString + sLineBreak +
            	'Detalhes: ' + sqlProdutos.FieldByName('DSC_DETALHES').AsString
            );
//        	iRes := TRequest.New()
//            	.BaseURL(WOOCOMMERCE_API_URL)
//        		.Resource('products')
//        		.BasicAuthentication(CONSUMER_KEY, CONSUMER_SECRET)
//        		.ContentType('application/json')
////        		.AddBody('{"name": "Tênis Delphi", "slug": "tenis-delphi", "description": "Envio teste do a partir da API Delphi", "short_description": "Tênis enviado por teste", "regular_price": "125" }')
//        		.Post;

//            if iRes.StatusCode = 200 then
//            begin
//
//
//            end
//            else
//                raise Exception.Create(iRes.StatusText + #13 + iRes.Content);
            //
            Next;
        end;
    end;
end;

procedure TForm2.butReceberProdutosClick(Sender: TObject);
var
    iRes: IResponse;
    JsonArray: TJSONArray;
    Produtos: TObjectList<TWooProdutoResponse>;
begin
    iRes := TRequest.New()
        .BaseURL(TAppConfig.WooApiUrl)
        .Resource('products')
        .BasicAuthentication(TAppConfig.ConsumerKey, TAppConfig.ConsumerSecret)
        .AddHeader('ContentType', 'application/json', [poDoNotEncode])
        .Get;

    if iRes.StatusCode = 200 then
    begin
    	JsonArray := TJSONObject.ParseJSONValue(iRes.Content) as TJSONArray;

        if not Assigned(JsonArray) then
        	raise Exception.Create('JSON Inválido');
        
    	Produtos := TObjectList<TWooProdutoResponse>.Create(True);

        try
            for var JsonValue in JsonArray do
            begin
            	var Produto := TJson.JsonToObject<TWooProdutoResponse>(JsonValue.ToJSON);
                Produtos.Add(Produto);
            end;

            for var Produto in Produtos do
        	begin
                ShowMessage(
                    'name: ' + Produto.Name + sLineBreak +
                    'slug: ' + Produto.Slug + sLineBreak +
                    'description: ' + Produto.Description + sLineBreak +
                    'short_description: ' + Produto.ShortDescription + sLineBreak +
                    'regular_price: ' + Produto.RegularPrice
                );

                for var Image in Produto.Images do
                    ShowMessage('id: ' + Image.Id + sLineBreak + 'src: ' + Image.Src)
        	end;
        finally
            Produtos.Free;
        end;
    end
    else
    	ShowMessage(iRes.StatusText);
end;

procedure TForm2.DatabaseConnectionLost(Sender: TObject; Component: TComponent;
  ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
begin
	RetryMode := rmReconnectExecute;
end;

end.
