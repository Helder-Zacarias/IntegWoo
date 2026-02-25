unit Tela_Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Uni, UniProvider,
  MySQLUniProvider, DBAccess, MemData, MemDS, Vcl.StdCtrls, Vcl.Buttons, System.IOUtils, REST.Json, Rest.Json.Types, WooProdutoResponse,
  System.Generics.Collections, System.JSON, WPImagemResponse, WooImagemRequest, WooProdutoRequest, System.IniFiles, AppConfig, Produto,
  Vcl.ExtCtrls, Tela_Envio_Produto, WooCategoriaRequest, Tela_Cadastro_Atributo, WooAtributoRequest, WooTermoAtributoRequest,
  WooAtributoResponse, CustomObjectMapper, FileWriter, WooCreateCategoriaRequest, RESTRequest4D, WooCategoriaResponse, Secao, WooProdutoCategoriaRequest;

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
    btnCriarAtributos: TButton;
    btnBuscarAtributos: TButton;
    sqlGrades: TUniQuery;
    sqlProdutosMandala: TUniQuery;
    btnEnviarProdutosMandala: TBitBtn;
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
    procedure btnCriarAtributosClick(Sender: TObject);
    procedure btnBuscarAtributosClick(Sender: TObject);
    procedure CriarTermosDoAtributo(Termos: TArray<string>; IdAtributo: Integer);
    procedure btnEnviarProdutosMandalaClick(Sender: TObject);
    procedure EnviarProdutoSimples(Produto: TWooProdutoRequest);
    function VerificarExistenciaDaCategoria(Categoria: string): TWooCategoriaResponse;
    function WooCommerceAPICall(Resource: string; Method: string; MensagemAposRetorno: string; Body: string = ''): TJSONValue;
    function BuscarSecaoNoBanco(CodIdSecao: Integer): TSecao;
    function CriarCategoria(Secao: TSecao): TWooCategoriaResponse;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTela_Principal: TfrmTela_Principal;

implementation

uses
	DataSet.Serialize;

{$R *.dfm}

procedure TfrmTela_Principal.btnBuscarAtributosClick(Sender: TObject);
var
	Response: IResponse;
    FileName: string;
    FileWriter: TStringList;
begin
	FileName := 'C:\Users\HELDER\Desktop\RESPONSE-DELPHI\ATRIBUTOS-PAYLOADS\atributos.txt';
    FileWriter := TStringList.Create;

    try
    	Response := TRequest.New()
            .BaseURL(TAppConfig.WooApiUrl)
            .Resource('products/attributes')
            .BasicAuthentication(TAppConfig.ConsumerKey, TAppConfig.ConsumerSecret)
            .AddHeader('Content-Type', 'application/json', [poDoNotEncode])
            .Get;

    	if Response.StatusCode in [200, 201] then
    		begin
        		FileWriter.Add(Response.Content);
        		FileWriter.SaveToFile(FileName);
    	end;
    finally
       FileWriter.Free;
    end;
end;

procedure TfrmTela_Principal.btnBuscarCategoriasClick(Sender: TObject);
var
    Filename: string;
    Lines: TStringList;
    Response: IResponse;
begin
	Filename := 'C:\Users\HELDER\Desktop\RESPONSE-DELPHI\categorias.txt';
    Lines := TStringList.Create;

    try
    	Response := TRequest.New()
            .BaseURL(TAppConfig.WooApiUrl)
            .Resource('products/categories')
            .BasicAuthentication(TAppConfig.ConsumerKey, TAppConfig.ConsumerSecret)
            .AddHeader('Content-Type', 'application/json', [poDoNotEncode])
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

procedure TfrmTela_Principal.CriarTermosDoAtributo(Termos: TArray<string>; IDAtributo: Integer);
var
	Termo: string;
	TermoAtributoRequest: TWooTermoAtributoRequest;
    JSONString: string;
    Response: IResponse;
    Filename: string;
    FileWriter: TStringList;
begin
	TermoAtributoRequest := TWooTermoAtributoRequest.Create;
    FileWriter := TStringList.Create;

    try
    	for Termo in Termos do
        begin
           TermoAtributoRequest.Name := Termo;

           JSONString := TJson.ObjectToJsonString(TermoAtributoRequest);

           Response := TRequest.New
               .BaseURL(TAppConfig.WooApiUrl)
               .Resource('/products/attributes/' + IDAtributo.ToString + '/terms')
               .AddHeader('Content-Type', 'application/json', [poDoNotEncode])
               .BasicAuthentication(TAppConfig.ConsumerKey, TAppConfig.ConsumerSecret)
               .AddBody(JSONString)
               .Post;
           if Response.StatusCode in [200, 201] then
           begin
              Filename := 'C:\Users\HELDER\Desktop\RESPONSE-DELPHI\ATRIBUTOS-PAYLOADS\termos-response.txt';
              if FileExists(Filename) then
                FileWriter.LoadFromFile(FileName);

              FileWriter.Add(Response.Content);
              FileWriter.SaveToFile(Filename);
           end
           else
           	raise(Exception.Create('Termo não foi salvo com sucesso'));
        end;
    finally
    	FileWriter.Free;
        TermoAtributoRequest.Free;
    end;

end;

procedure TfrmTela_Principal.btnCriarAtributosClick(Sender: TObject);
var
    FileName: string;
    FileWriter: TStringList;
    Response: IResponse;
    TelaCadastroAtributo: TfrmTela_Cadastro_Atributo;
    JSONString: string;
    AtributoRequest: TWooAtributoRequest;
    AtributoResponse: TWooAtributoResponse;

begin
	Filename := 'C:\Users\HELDER\Desktop\RESPONSE-DELPHI\ATRIBUTOS-PAYLOADS\novo-atributo-response.txt';
    FileWriter := TStringList.Create;
    TelaCadastroAtributo := TfrmTela_Cadastro_Atributo.Create(Self);
    TelaCadastroAtributo.Position := poScreenCenter;
    AtributoRequest := TWooAtributoRequest.Create;

    if TelaCadastroAtributo.ShowModal = mrOk then
        try

            AtributoRequest.Name := TelaCadastroAtributo.Atributo;

            JSONString := TJson.ObjectToJsonString(AtributoRequest);

            Response := TRequest.New
                .BaseURL(TAppConfig.WooApiUrl)
                .Resource('products/attributes')
                .BasicAuthentication(TAppConfig.ConsumerKey, TAppConfig.ConsumerSecret)
                .AddHeader('Content-Type', 'application/json', [poDoNotEncode])
                .AddBody(AtributoRequest)
                .Post;

            AtributoResponse := TJson.JsonToObject<TWooAtributoResponse>(Response.Content);

            if Response.StatusCode in [200, 201] then
                begin
                    FileWriter.Add(Response.Content);
                    FileWriter.SaveToFile(FileName);
                    CriarTermosDoAtributo(TelaCadastroAtributo.Termos, AtributoResponse.Id);
                    ShowMessage('Atributo criado com sucesso');
                end
        	else
            	raise(Exception.Create('Criação de atributo não foi bem sucedida'));
        finally
        	FileWriter.Free;
         	TelaCadastroAtributo.Free;
    end;
end;

procedure TfrmTela_Principal.btnEnviarProdutoSimplesClick(Produto: TWooProdutoRequest; ImagePath: string; CategoriaSelecionada: string);
var
    WPImagemResponse: TWPImagemResponse;
    ArrImagens: TArray<TWooImagemRequest>;
    ArrCategorias: TArray<TWooCategoriaRequest>;
begin
//    WPImagemResponse := enviarImagem(ImagePath);
//
//    if not Assigned(WPImagemResponse) then
//    	raise(Exception.Create('Upload de Imagem Falhou'));
//
//    try
//        var Categoria := selectCategoria(CategoriaSelecionada);
//        ArrCategorias := Produto.Categories;
//        SetLength(ArrCategorias, 1);
//        ArrCategorias[0] := Categoria;
//        Produto.Categories := ArrCategorias;
//
//        var Img := TWooImagemRequest.Create;
//        Img.Id := WPImagemResponse.Id;
//        ArrImagens := Produto.Images;
//  		SetLength(ArrImagens, 1);
//  		ArrImagens[0] := Img;
//  		Produto.Images := ArrImagens;
//
//    	enviarProduto(Produto);
//    finally
//        Produto.Free;
//    end;
end;

function TfrmTela_Principal.WooCommerceAPICall(
    Resource: string;
    Method:string;
    MensagemAposRetorno: string;
    Body: string = ''): TJSONValue;
var
    Request: IRequest;
    Response: IResponse;
begin
    Request := TRequest.New
        .BaseURL(TAppConfig.WooApiUrl)
        .Resource(Resource)
        .AddHeader('Content-Type', 'application/json', [poDoNotEncode])
        .BasicAuthentication(TAppConfig.ConsumerKey, TAppConfig.ConsumerSecret);

    if not Body.IsEmpty then
    	Request.AddBody(Body);

    if  UpperCase(Method) = 'GET' then
    	Response := Request.Get
    else if UpperCase(Method) = 'POST' then
        Response := Request.Post
    else if UpperCase(Method) = 'PUT' then
         Response := Request.Put
    else if UpperCase(Method) = 'DELETE' then
         Response := Request.Delete
    else
        raise(Exception.Create('Método HTTP não suportado'));

    if Response.StatusCode in [200, 201] then
    begin
        ShowMessage(MensagemAposRetorno);
    end
    else
        raise(Exception.Create('Requisição falhou. ' + Response.StatusCode.ToString + ': ' + Response.Content));

    Result := TJSONObject.ParseJSONValue(Response.Content);
end;

function TfrmTela_Principal.BuscarSecaoNoBanco(CodIdSecao: Integer) : TSecao;
var
    SelectSecaoQuery: TUniQuery;
    SecoesDB: TObjectList<TSecao>;
    Secao: TSecao;
begin
	SelectSecaoQuery := TUniQuery.Create(nil);

    try
    	SelectSecaoQuery.Connection := Database;
    	SelectSecaoQuery.SQL.Text := 'SELECT * FROM db_sgci.secoes WHERE COD_ID_EMPRESA = 1451 AND COD_ID_SECAO = :COD_ID_SECAO LIMIT 10';
        SelectSecaoQuery.ParamByName('COD_ID_SECAO').AsInteger := CodIdSecao;
    	SelectSecaoQuery.Open;

        if not SelectSecaoQuery.Eof then
        begin
            Secao := TSecao.Create;
            Secao.CodIdSecao := SelectSecaoQuery.FieldByName('COD_ID_SECAO').AsInteger;
            Secao.DscSecao := SelectSecaoQuery.FieldByName('DSC_SECAO').AsString;
        end;

    finally
       SelectSecaoQuery.Free;
    end;

    Result := Secao;
end;

function TfrmTela_Principal.VerificarExistenciaDaCategoria(Categoria: string): TWooCategoriaResponse;
var
	JSONValue: TJSONValue;
    CategoriasJSONArray: TJSONArray;
    CategoriaRetornada: string;
    CategoriaResponse: TWooCategoriaResponse;
begin
	CategoriaResponse := nil;
    JSONValue := WooCommerceAPICall('products/categories', 'GET', 'Categorias retornadas com sucesso!');
    CategoriasJSONArray :=  JSONValue as TJSONArray;

    for var CategoriaJSON in CategoriasJSONArray do
    begin
        CategoriaRetornada := CategoriaJSON.GetValue<string>('name');

        if SameText(Categoria, CategoriaRetornada) then
        begin
           CategoriaResponse := TJson.JsonToObject<TWooCategoriaResponse>(CategoriaJSON.ToJSON());
           Break;
        end;
    end;

    Result := CategoriaResponse;
end;

function TfrmTela_Principal.CriarCategoria(Secao: TSecao): TWooCategoriaResponse;
var
    CategoriaId: Integer;
    RequestPayload: string;
    JSONResponse: TJSONValue;
    CategoriaRequest: TWooCategoriaRequest;
    CategoriaResponse: TWooCategoriaResponse;
begin
    CategoriaRequest := TWooCategoriaRequest.Create;

    try
        CategoriaRequest.Name :=  Secao.DscSecao;
    	RequestPayload := TJson.ObjectToJsonString(CategoriaRequest);
    	JSONResponse := WooCommerceAPICall('products/categories', 'POST', 'Categoria criada com sucesso!', RequestPayload);
    	CategoriaResponse := TJson.JsonToObject<TWooCategoriaResponse>(JSONResponse.ToJSON);
    finally
        CategoriaRequest.Free;
    end;

	Result := CategoriaResponse;
end;

procedure TfrmTela_Principal.EnviarProdutoSimples(Produto: TWooProdutoRequest);
var
    Response: IResponse;
    JSONString: string;
begin
    JSONString := TJSON.ObjectToJsonString(Produto);

    WriteContentToFile('C:\Users\HELDER\Desktop\RESPONSE-DELPHI\STRING_PAYLOADS\produto-json.txt', JSONString);

    Response := TRequest.New
         .BaseURL(TAppConfig.WooApiUrl)
         .Resource('products')
         .AddHeader('Content-Type', 'application/json', [poDoNotEncode])
         .BasicAuthentication(TAppConfig.ConsumerKey, TAppConfig.ConsumerSecret)
         .AddBody(JSONString)
         .Post;
     try
         if Response.StatusCode in [200, 201] then
            ShowMessage('Requisição bem sucedida')
         else
            raise(Exception.Create('Requisição falhou.' + Response.StatusCode.ToString + ': ' + Response.Content));
     finally
     end;
end;

procedure TfrmTela_Principal.btnEnviarProdutosMandalaClick(Sender: TObject);
var
    ProdutoDB: TProduto;
    WooProdutoRequest: TWooProdutoRequest;
    Slug: string;
    CodIdGrade: TField;
    Count: Integer;
    TipoProduto: string;
    Secao: TSecao;
    CategoriaResponse: TWooCategoriaResponse;
    CategoriaId: Integer;
begin
    with sqlProdutosMandala do
    begin
    	Close;
        Connection:= Self.Database;
        Open;

        ProdutoDB := TProduto.Create;
        WooProdutoRequest := nil;
        Count := 0;

        try
        	while (not sqlProdutosMandala.Eof) and (Count < 1) do

            begin
                CodIdGrade := sqlProdutosMandala.FindField('COD_ID_GRADE');

            	if (not Assigned(CodIdGrade)) or (CodIdGrade.IsNull) or (not CodIdGrade.AsInteger <> 0) then
                    TipoProduto := 'simple'
                else
                    TipoProduto := 'variable';

                ProdutoDB.CodIdProduto := sqlProdutosMandala.FieldByName('COD_ID_PRODUTO').AsInteger;
                ProdutoDB.CodProduto := sqlProdutosMandala.FieldByName('COD_PRODUTO').AsLargeInt;
                ProdutoDB.CodIdGrade := sqlProdutosMandala.FieldByName('COD_ID_GRADE').AsInteger;
                ProdutoDB.CodIdSecao := sqlProdutosMandala.FieldByName('COD_ID_SECAO').AsInteger;
                ProdutoDB.NumPrecoVarejo := sqlProdutosMandala.FieldByName('NUM_PRECO_VAREJO').AsCurrency;
                ProdutoDB.DscCompleta := sqlProdutosMandala.FieldByName('DSC_COMPLETA').AsString;
                ProdutoDB.DscAbreviada := sqlProdutosMandala.FieldByName('DSC_ABREVIADA').AsString;
                ProdutoDB.DscObservacoes := sqlProdutosMandala.FieldByName('DSC_OBSERVACOES').AsString;
                ProdutoDB.DscDetalhes := sqlProdutosMandala.FieldByName('DSC_DETALHES').AsString;

                Secao := BuscarSecaoNoBanco(ProdutoDB.CodIdSecao);
                CategoriaResponse := VerificarExistenciaDaCategoria(Secao.DscSecao);

                if not Assigned(CategoriaResponse) then
                	CategoriaResponse := CriarCategoria(Secao);

               	WooProdutoRequest := ProdutoToWooProdutoRequest(ProdutoDB, TipoProduto, CategoriaResponse.Id);

                Inc(Count);
//                EnviarProdutoSimples(WooProdutoRequest);
                Next;
            end;
        finally
        	ProdutoDB.Free;
            WooProdutoRequest.Free;
        end;

    end;
end;

function TfrmTela_Principal.selectCategoria(CategoriaString: string): TWooCategoriaRequest;
var
    Categoria: TWooCategoriaRequest;
begin
//    Categoria := TWooCategoriaRequest.Create;
//
//    if CategoriaString = 'Camisetas' then
//    begin
//    	Categoria.Id :=  '15';
//        Categoria.Name := 'Camisetas';
//        Categoria.Slug := 'camisetas';
//    end
//    else if CategoriaString = 'Calçados' then
//    begin
//    	Categoria.Id :=  '28';
//        Categoria.Name := 'Calçados';
//        Categoria.Slug := 'calçados';
//    end
//    else if CategoriaString = 'Acessórios' then
//    begin
//        Categoria.Id :=  '29';
//        Categoria.Name := 'Acessórios';
//        Categoria.Slug := 'acessorios';
//    end
//    else if CategoriaString = 'Moletons' then
//    begin
//    	Categoria.Id :=  '30';
//        Categoria.Name := 'Moletons';
//        Categoria.Slug := 'moletons';
//    end
//    else
//    begin
//       	Categoria.Id :=  '55';
//        Categoria.Name := 'Nova Categoria Teste';
//        Categoria.Slug := 'nova-categoria-teste';
//    end;
//
//    Result := Categoria;
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
        	if sqlProdutos.FieldByName('COD_ID_GRADE').IsNull then
                ShowMessage('Produto simples')
            else
            	ShowMessage('Produto variável');

            ProdutoDB := TProduto.Create;

            try
//            	ProdutoDB.CodIdProduto := sqlProdutos.FieldByName('COD_ID_PRODUTO').asInteger;
//                ProdutoDB.DscCompleta := sqlProdutos.FieldByName('DSC_COMPLETA').asString;
//                ProdutoDB.DscAbreviada := sqlProdutos.FieldByName('DSC_ABREVIADA').asString;
//                ProdutoDB.DscObservacoes := sqlProdutos.FieldByName('DSC_OBSERVACOES').asString;
//                ProdutoDB.DscDetalhes := sqlProdutos.FieldByName('DSC_DETALHES').asString;
//
//                ShowMessage(
//                    'COD_ID_PRODUTO: ' +  sqlProdutos.FieldByName('COD_ID_PRODUTO').AsString + sLineBreak +
//                    'DSC_COMPLETA: ' +  sqlProdutos.FieldByName('DSC_COMPLETA').asString + sLineBreak +
//                    'DSC_ABREVIADA: ' +  sqlProdutos.FieldByName('DSC_ABREVIADA').asString + sLineBreak +
//                    'DSC_OBSERVACOES: ' +  sqlProdutos.FieldByName('DSC_OBSERVACOES').asString + sLineBreak +
//                    'DSC_DETALHES: ' +  sqlProdutos.FieldByName('DSC_DETALHES').asString + sLineBreak +
//                    'DSC_CHAVE: ' +  sqlProdutos.FieldByName('DSC_CHAVE').asString + sLineBreak +
//                    'NUM_PRECO_VAREJO: ' +  sqlProdutos.FieldByName('NUM_PRECO_VAREJO').asString + sLineBreak +
//                    'NUM_ESTQ_ATUAL: ' +  sqlProdutos.FieldByName('NUM_ESTQ_ATUAL').asString + sLineBreak +
//                    'IMG_PRODUTO: ' +  sqlProdutos.FieldByName('IMG_PRODUTO').asString
//                );
//
//                WooProdutoRequest := TWooProdutoRequest.Create;
//                WooProdutoRequest.Name := ProdutoDB.DscCompleta;
//                WooProdutoRequest.ShortDescription := ProdutoDB.DscAbreviada;
//
//                enviarProduto(WooProdutoRequest);
                Next;
            finally
               ProdutoDB.Free;
            end;
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
//    Filename := 'C:\Users\HELDER\Desktop\RESPONSE-DELPHI\grades.txt';
//    Tables := TStringList.Create;
    try
//    	Database.GetTableNames(Tables);
//    	ShowMessage(Tables.Text);
//        Tables.SaveToFile(Filename);

        SelectQuery := TUniQuery.Create(nil);

        SelectQuery.Connection := Database;
        SelectQuery.SQL.Text := 'SELECT * FROM db_sgci.secoes WHERE COD_ID_EMPRESA = 1451';
        SelectQuery.Open;
        SelectQuery.SaveToXML('C:\Users\HELDER\Desktop\RESPONSE-DELPHI\DB_QUERIES\select-secoes-mandala.xml');
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
