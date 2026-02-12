unit Tela_Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Uni, UniProvider,
  MySQLUniProvider, DBAccess, MemData, MemDS, Vcl.StdCtrls, Vcl.Buttons, System.IOUtils, REST.Json, Rest.Json.Types, WooProdutoResponse,
  System.Generics.Collections, System.JSON, WPImagemResponse, WooImagemRequest, WooProdutoRequest, System.IniFiles, AppConfig, Produto,
  Vcl.ExtCtrls, Tela_Envio_Produto, WooCategoriaRequest;

type
  TfrmTela_Principal = class(TForm)
    MySQL: TMySQLUniProvider;
    Database: TUniConnection;
    sqlProdutos: TUniQuery;
    sqlImagens: TUniQuery;
    butEnviarProdutos: TBitBtn;
    butReceberProdutos: TBitBtn;
    btnEnviarFull: TBitBtn;
    btnHamburguer: TButton;
    panelSide: TPanel;
    btnTestConexao: TButton;
    btnBuscarCategorias: TButton;
    procedure DatabaseConnectionLost(Sender: TObject; Component: TComponent;
      ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
    procedure butEnviarProdutosdoBancoClick(Sender: TObject);
    procedure butBuscarProdutosClick(Sender: TObject);
    function enviarImagem(ImagePath: string): TWPImagemResponse;
    function enviarProduto(Produto: TWooProdutoRequest): TWooProdutoResponse;
    procedure btnEnviarProdutoSimplesClick(Produto: TWooProdutoRequest; ImagePath: string; CategoriaSelecionada: string);
    procedure btnHamburguerClick(Sender: TObject);
    procedure btnOpenModalClick(Sender: TObject);
    procedure btnTestarConexãoClick(Sender: TObject);
    function selectCategoria(CategoriaString: string): TWooCategoriaRequest;
    procedure btnBuscarCategoriasClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTela_Principal: TfrmTela_Principal;

implementation

uses
    RESTRequest4D,
	DataSet.Serialize;

{$R *.dfm}

procedure TfrmTela_Principal.btnBuscarCategoriasClick(Sender: TObject);
var
    Filename: string;
    Lines: TStringList;
    Response: IResponse;
begin
	Filename :=  'C:\Users\HELDER\Desktop\RESPONSE-DELPHI\categorias.txt';
    Lines := TStringList.Create;

    try
    	Response := TRequest.New()
            .BaseURL(TAppConfig.WooApiUrl)
            .Resource('products/categories')
            .BasicAuthentication(TAppConfig.ConsumerKey, TAppConfig.ConsumerSecret)
            .AddHeader('Content-Type', 'application/json', [poDoNoTEncode])
            .Get;

    	if Response.StatusCode = 200 then
            begin
            	Lines.Add(Response.Content);
            	Lines.SaveToFile(Filename);
    	end;
    finally
    	Lines.Free;
    end;
   
end;

procedure TfrmTela_Principal.btnEnviarProdutoSimplesClick(Produto: TWooProdutoRequest; ImagePath: string; CategoriaSelecionada: string);
var
    WPImagemResponse: TWPImagemResponse;
    ArrImagens: TArray<TWooImagemRequest>;
    ArrCategorias: TArray<TWooCategoriaRequest>;
begin
    WPImagemResponse := enviarImagem(ImagePath);

    if not Assigned(WPImagemResponse) then
    	raise(Exception.Create('Upload de Imagem Falhou'));

    try
        var Categoria := selectCategoria(CategoriaSelecionada);
        ArrCategorias := Produto.Categories;
        SetLength(ArrCategorias, 1);
        ArrCategorias[0] := Categoria;
        Produto.Categories := ArrCategorias;
        
        var Img := TWooImagemRequest.Create;
        Img.Id := WPImagemResponse.Id;
        ArrImagens := Produto.Images;
  		SetLength(ArrImagens, 1);
  		ArrImagens[0] := Img;
  		Produto.Images := ArrImagens;

    	enviarProduto(Produto);
    finally
        Produto.Free;
    end;
end;

function TfrmTela_Principal.selectCategoria(CategoriaString: string): TWooCategoriaRequest;
var
    Categoria: TWooCategoriaRequest;
begin
    Categoria := TWooCategoriaRequest.Create;

    if CategoriaString = 'Camisetas' then
    begin
    	Categoria.Id :=  '15';
        Categoria.Name := 'Camisetas';
        Categoria.Slug := 'camisetas';
    end
    else if CategoriaString = 'Calçados' then
    begin
    	Categoria.Id :=  '28';
        Categoria.Name := 'Calçados';
        Categoria.Slug := 'calçados';
    end
    else if CategoriaString = 'Acessórios' then
    begin
        Categoria.Id :=  '29';
        Categoria.Name := 'Acessórios';
        Categoria.Slug := 'acessorios';
    end
    else if CategoriaString = 'Moletons' then
    begin
    	Categoria.Id :=  '30';
        Categoria.Name := 'Moletons';
        Categoria.Slug := 'moletons';
    end
    else
    begin
       	Categoria.Id :=  '55';
        Categoria.Name := 'Nova Categoria Teste';
        Categoria.Slug := 'nova-categoria-teste';
    end;

    Result := Categoria;
end;

function TfrmTela_Principal.enviarImagem(ImagePath: string): TWPImagemResponse;
var
	iRes: IResponse;
    MS: TMemoryStream;
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

function TfrmTela_Principal.enviarProduto(Produto: TWooProdutoRequest): TWooProdutoResponse;
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

procedure TfrmTela_Principal.butEnviarProdutosdoBancoClick(Sender: TObject);
var
    ProdutoDB: TProduto;
    WooProdutoRequest: TWooProdutoRequest;
begin
    with sqlProdutos do
    begin
        Close;
        Connection:= Self.Database;
        Open;

//        while not Eof do
        for var i := 1 to 5 do
        begin
            ProdutoDB := TProduto.Create;

            ProdutoDB.CodIdProduto := sqlProdutos.FieldByName('COD_ID_PRODUTO').asInteger;
            ProdutoDB.DscCompleta := sqlProdutos.FieldByName('DSC_COMPLETA').asString;
            ProdutoDB.DscAbreviada := sqlProdutos.FieldByName('DSC_ABREVIADA').asString;
            ProdutoDB.DscObservacoes := sqlProdutos.FieldByName('DSC_OBSERVACOES').asString;
            ProdutoDB.DscDetalhes := sqlProdutos.FieldByName('DSC_DETALHES').asString;

            ShowMessage(
                'COD_ID_PRODUTO: ' +  sqlProdutos.FieldByName('COD_ID_PRODUTO').AsString + sLineBreak +
                'DSC_COMPLETA: ' +  sqlProdutos.FieldByName('DSC_COMPLETA').asString + sLineBreak +
                'DSC_ABREVIADA: ' +  sqlProdutos.FieldByName('DSC_ABREVIADA').asString + sLineBreak +
                'DSC_OBSERVACOES: ' +  sqlProdutos.FieldByName('DSC_OBSERVACOES').asString + sLineBreak +
                'DSC_DETALHES: ' +  sqlProdutos.FieldByName('DSC_DETALHES').asString + sLineBreak +
                'DSC_CHAVE: ' +  sqlProdutos.FieldByName('DSC_CHAVE').asString + sLineBreak +
                'NUM_PRECO_VAREJO: ' +  sqlProdutos.FieldByName('NUM_PRECO_VAREJO').asString + sLineBreak +
                'NUM_ESTQ_ATUAL: ' +  sqlProdutos.FieldByName('NUM_ESTQ_ATUAL').asString + sLineBreak +
                'IMG_PRODUTO: ' +  sqlProdutos.FieldByName('IMG_PRODUTO').asString
            );

            WooProdutoRequest := TWooProdutoRequest.Create;
            WooProdutoRequest.Name := ProdutoDB.DscCompleta;
            WooProdutoRequest.ShortDescription := ProdutoDB.DscAbreviada;

            enviarProduto(WooProdutoRequest);
            Next;
        end;
    end;
end;

procedure TfrmTela_Principal.btnOpenModalClick(Sender: TObject);
var
    ProdutoForm: TfrmTela_Envio;
    ProdutoRequest: TWooProdutoRequest;
    PathImagem: string;
begin
    ProdutoForm := TfrmTela_Envio.Create(Self);
    ProdutoForm.Position := poScreenCenter;
    try
        if ProdutoForm.ShowModal = mrOk then
        begin
            ProdutoRequest := ProdutoForm.ProdutoInfo;
            PathImagem := ProdutoForm.PathImagem;
            btnEnviarProdutoSimplesClick(ProdutoRequest, PathImagem, ProdutoForm.Categoria);
        end;
    finally
    	ProdutoForm.Free;
    end;
end;

procedure TfrmTela_Principal.btnTestarConexãoClick(Sender: TObject);
var
    Tables: TStringList;
    Filename: string;
    SelectQuery:  TUniQuery;
begin
    Filename := 'C:\Users\HELDER\Desktop\RESPONSE-DELPHI\schema-tables.txt';
    Tables := TStringList.Create;
    try
    	Database.GetTableNames(Tables);
    	ShowMessage(Tables.Text);
        Tables.SaveToFile(Filename);

        SelectQuery := TUniQuery.Create(nil);

//        SelectQuery.Connection := Database;
//        SelectQuery.SQL.Text := 'SELECT * FROM information_schema';
//        SelectQuery.Open;
//        SelectQuery.SaveToXML('C:\Users\HELDER\Desktop\RESPONSE-DELPHI\select-schema.xml');
    finally
//        Tables.Free;
        SelectQuery.Free;
    end;

end;

procedure TfrmTela_Principal.btnHamburguerClick(Sender: TObject);
begin
    panelSide.Visible := not panelSide.Visible;
    btnHamburguer.BringToFront;
end;

procedure TfrmTela_Principal.butBuscarProdutosClick(Sender: TObject);
var
    iRes: IResponse;
    JsonArray: TJSONArray;
    Produtos: TObjectList<TWooProdutoResponse>;
    Lines: TStringList;
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

        Lines := TStringList.Create;


        if not Assigned(JsonArray) then
        	raise Exception.Create('JSON Inválido');
        
    	Produtos := TObjectList<TWooProdutoResponse>.Create(True);

        try
            var Count := 1;
            for var JsonValue in JsonArray do
            begin
            	Lines.Add(JsonValue.ToString);
                Lines.SaveToFile('C:\Users\HELDER\Desktop\RESPONSE-DELPHI\produto-' + Count.ToString + '.txt');
                Inc(Count);
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
            Lines.Free;
        end;
    end
    else
    	ShowMessage(iRes.StatusText);
end;

procedure TfrmTela_Principal.DatabaseConnectionLost(Sender: TObject; Component: TComponent;
  ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
begin
	RetryMode := rmReconnectExecute;
end;

end.
