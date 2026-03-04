unit Tela_Principal;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.IOUtils,
  System.Generics.Collections, System.JSON, System.IniFiles, System.Threading,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Data.DB, Uni, UniProvider, MySQLUniProvider, DBAccess, MemData, MemDS,
  REST.Json, Rest.Json.Types, RESTRequest4D,
  AppConfig, Tela_Envio_Produto, Tela_Cadastro_Atributo,
  FileWriter, TrimTexto, ContentPrinter, CustomObjectMapper,
  Produto, ProdutoGrade, ProdutoImagem, Secao, Variacao,
  WooProdutoRequest, WooProdutoResponse, WPImagemResponse, WooImagemRequest,
  WooCategoriaRequest, WooAtributoRequest, WooTermoAtributoRequest,
  WooAtributoResponse, WooCreateCategoriaRequest, WooCategoriaResponse,
  WooProdutoCategoriaRequest, WooImagemResponse,
  WooAtributosProdutoRequest, WooTermoResponse;

type
  TfrmTela_Principal = class(TForm)
    MySQL: TMySQLUniProvider;
    Database: TUniConnection;
    sqlProdutos: TUniQuery;
    sqlImagens: TUniQuery;
    butReceberProdutos: TBitBtn;
    btnHamburguer: TButton;
    panelSide: TPanel;
    btnEnviarProdutosMandala: TBitBtn;
    procedure DatabaseConnectionLost(Sender: TObject; Component: TComponent;
      ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
    procedure btnHamburguerClick(Sender: TObject);
    procedure butBuscarProdutosClick(Sender: TObject);
    procedure btnEnviarProdutosClick(Sender: TObject);
    function ChamadaAPIWooCommerce(Resource: string; Metodo: string;
    	MensagemAposRetorno: string = ''; Body: string = ''): TJSONValue;
    function DownloadImage(ImageUrl: string = ''): TMemoryStream;
	function EnviarImagem(ListaImagens: TObjectList<TProdutoImagem>): TObjectList<TWPImagemResponse>;
    procedure EnviarProduto(Produto: TWooProdutoRequest);
    function CriarCategoria(Secao: TSecao): TWooCategoriaResponse;
    function EnviarTermos(TabelaVariacao: string; AtributoId: Integer): TObjectList<TWooTermoResponse>;
    function VerificarExistenciaDaCategoria(Categoria: string): TWooCategoriaResponse;
    function BuscarAtributos: TObjectList<TWooAtributoResponse>;
    function BuscarSecaoNoBanco(CodIdEmpresa: Integer; CodIdSecao: Integer): TSecao;
    function BuscarImagemProdutoNoBanco(CodIdEmpresa: Integer; CodIdProduto: Integer): TObjectList<TProdutoImagem>;
    function CriarQuery: TUniQuery;
    function RetornarImagensRequest(CodIdProduto: Integer): TObjectList<TWooImagemRequest>;
    function ChecarERetornarJSONArray(JSONResponse: TJSONValue): TJSONArray;
    procedure FormCreate(Sender: TObject);
    function CriarAtributos: TObjectList<TWooAtributoResponse>;
    function CompararTermos(TermosAPI: TObjectList<TWooTermoResponse>; TermosDB: TList<string>): TList<string>;
    function BuscarTermosProduto(CodIdEmpresa: Integer; CodIdGrade: Integer;
    	CodIdProduto: Integer; TabelaVariacao: string): TList<string>;
  private
    FSQLProdutosBase: string;
  	FSQLImagensBase: string;
    FCodIdProduto: Integer;
    FTabelasVariacao: TArray<string>;
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

procedure TfrmTela_Principal.FormCreate(Sender: TObject);
begin
	FSQLProdutosBase := sqlProdutos.SQL.Text;
    FSQLImagensBase := sqlImagens.SQL.Text;
    FCodIdProduto := 4832699;
    FTabelasVariacao := ['db_sgci.grades_variacao_1', 'db_sgci.grades_variacao_2'];
end;

procedure TfrmTela_Principal.btnHamburguerClick(Sender: TObject);
begin
    panelSide.Visible := not panelSide.Visible;
    btnHamburguer.BringToFront;
end;

function TfrmTela_Principal.CriarQuery: TUniQuery;
begin
    if not Assigned(Database) then
        raise Exception.Create('Não há conexão com o banco!');

    Result := TUniQuery.Create(nil);
    Result.Connection := Database;
end;

function TfrmTela_Principal.ChamadaAPIWooCommerce(
    Resource: string;
    Metodo: string;
    MensagemAposRetorno: string = '';
    Body: string = ''): TJSONValue;
var
    Request: IRequest;
    Response: IResponse;
    JSONResposta: TJSONValue;
begin
	Result := nil;

    Request := TRequest.New
        .BaseURL(TAppConfig.WooApiUrl)
        .Resource(Resource)
        .AddHeader('Content-Type', 'application/json', [poDoNotEncode])
        .BasicAuthentication(TAppConfig.ConsumerKey, TAppConfig.ConsumerSecret);

    if not Body.IsEmpty then
    	Request.AddBody(Body);

    if  UpperCase(Metodo) = 'GET' then
    	Response := Request.Get
    else if UpperCase(Metodo) = 'POST' then
        Response := Request.Post
    else if UpperCase(Metodo) = 'PUT' then
         Response := Request.Put
    else if UpperCase(Metodo) = 'DELETE' then
         Response := Request.Delete
    else
        raise Exception.CreateFmt('Método %s não suportado', [Metodo]);

     if (not Assigned(Response)) then
     	raise Exception.Create('Nehuma resposta do servidor!');

    if Response.StatusCode in [200, 201] then
    begin
    	if (not MensagemAposRetorno.IsEmpty) then
        	ShowMessage(MensagemAposRetorno);
    end
    else
        raise(Exception.Create('Requisição falhou. ' + Response.StatusCode.ToString + ': ' + Response.Content));

    JSONResposta := TJSONObject.ParseJSONValue(Response.Content);

    if not Assigned(JSONResposta) then
        raise Exception.Create('JSON Retornado é inválido!');

    Result := JSONResposta;
end;

function TfrmTela_Principal.ChecarERetornarJSONArray(JSONResponse: TJSONValue): TJSONArray;
begin
	if not Assigned(JSONResponse) then
        raise Exception.Create('JSONResponse é nulo!');

	if not (JSONResponse is TJSONArray) then
    	raise Exception.CreateFmt('Foi recebido %s ao invés de TJSONArray!', [JSONResponse.ClassName]);

    Result := JSONResponse as TJSONArray;
end;

procedure TfrmTela_Principal.butBuscarProdutosClick(Sender: TObject);
begin
    TTask.Run(
        procedure
        var
            JSONResposta: TJSONValue;
        begin
        	JSONResposta := nil;

            try
    			JSONResposta := ChamadaAPIWooCommerce('products', 'GET');

                if not Assigned(JSONResposta) then
                    raise Exception.Create('Nenhuma Resposta da API do WOooComemrce!');

                TThread.Queue(
                    nil,
                    procedure
                    begin
                        ShowMessage('Produtos retornados com sucesso!');
                    end
                );
    		finally
         		JSONResposta.Free;
    		end;
        end
    );
end;

function TfrmTela_Principal.BuscarTermosProduto(
    CodIdEmpresa: Integer;
    CodIdGrade: Integer;
    CodIdProduto: Integer;
    TabelaVariacao: string
): TList<string>;
var
    SelectGradesQuery: TUniQuery;
begin
    Result := nil;

    try
        Result := TList<string>.Create;

    	SelectGradesQuery := CriarQuery;
        SelectGradesQuery.Close;
        SelectGradesQuery.SQL.Text := 'SELECT DISTINCT ' + TabelaVariacao + '.DSC_VARIACAO ' + sLineBreak +
        	'FROM db_sgci.produtos_grades pg ' + sLineBreak +
            'JOIN ' + TabelaVariacao + ' ON pg.COD_ID_GRADE = ' + TabelaVariacao + '.COD_ID_GRADE ' + sLineBreak +
            'WHERE pg.COD_ID_EMPRESA = :COD_ID_EMPRESA AND ' + sLineBreak +
            'pg.COD_ID_GRADE = :COD_ID_GRADE AND ' + sLineBreak +
            'pg.COD_ID_PRODUTO = :COD_ID_PRODUTO';
        SelectGradesQuery.ParamByName('COD_ID_EMPRESA').AsInteger := CodIdEmpresa;
        SelectGradesQuery.ParamByName('COD_ID_GRADE').AsInteger := CodIdGrade;
        SelectGradesQuery.ParamByName('COD_ID_PRODUTO').AsInteger := CodIdProduto;
        SelectGradesQuery.Open;

        try
        	while not SelectGradesQuery.Eof do
            begin
            	Result.Add(SelectGradesQuery.FieldByName('DSC_VARIACAO').AsString);
                SalvarConteudoEmArquivo(
                	TPath.Combine(TPath.GetDocumentsPath, 'termos-distintos-variacao-' + TabelaVariacao + '.txt'),
                	SelectGradesQuery.FieldByName('DSC_VARIACAO').AsString
                );
                SelectGradesQuery.Next;
            end;

            SelectGradesQuery.Close;
            except
            	Result.Free;
                raise Exception.Create('Erro na criação da lista de termos');
            end;
    finally
        SelectGradesQuery.Free;
    end;
end;

function TfrmTela_Principal.CriarAtributos: TObjectList<TWooAtributoResponse>;
var
	Atributos: TArray<TWooAtributoRequest>;
    JSONResposta: TJSONValue;
begin
	Result := nil;
	SetLength(Atributos, 2);
	Atributos[0] := TWooAtributoRequest.Create;
    Atributos[0].Name := 'Grade 1';

    Atributos[1] := TWooAtributoRequest.Create;
    Atributos[1].Name := 'Grade 2';
    
    try
        Result := TObjectList<TWooAtributoResponse>.Create(True);

    	for var I := 0 to High(Atributos) do
        begin
        	JSONResposta := nil;
            
        	try
            	JSONResposta := ChamadaAPIWooCommerce(
                    'products/attributes', 'POST', 'Atributo criado com sucesso',
                    TJson.ObjectToJsonString(Atributos[I])
            	);
                Result.Add(TJson.JsonToObject<TWooAtributoResponse>(JSONResposta.ToJSON)) ;
            finally
                JSONResposta.Free;
            end;
        end;
    finally
    	for var I := 0 to High(Atributos) do
        	Atributos[I].Free;
    end;
end;

function TfrmTela_Principal.BuscarAtributos: TObjectList<TWooAtributoResponse>;
var
    JSONResposta: TJSONValue;
    JSONArray: TJSONArray;
    Payload: string;
begin
	Result := nil;
    JSONResposta := nil;
    JSONArray := nil;

     try
        JSONResposta := ChamadaAPIWooCommerce('products/attributes', 'GET', 'Atributos retornados com sucesso');
        JSONArray := ChecarERetornarJSONArray(JSONResposta);

        if (not Assigned(JSONArray)) or (JSONArray.Count = 0) then
    	begin
//            JSONResposta.Free;
//            JSONArray.Free;
            Result := CriarAtributos;

            if not Assigned(Result) then
                raise Exception.Create('Erro na criação de atributos');
        	Exit(Result);
    	end;

        try
        	for var Response in JSONArray do
            	Result.Add(TJson.JsonToObject<TWooAtributoResponse>(Response.ToJSON));
        except
           Result.Free;
           raise Exception.Create('Erro ao adicionar atributos a lista!');
        end;
     finally
        JSONResposta.Free;
     end;
end;

function TfrmTela_Principal.EnviarTermos(
	TabelaVariacao: string;
	AtributoId: Integer
): TObjectList<TWooTermoResponse>;
var
	SelectVariacaoQuery: TUniQuery;
    SQLText: string;
    JSONResposta: TJSONValue;
    Termo: TWooTermoAtributoRequest;
begin
    SQLText := 'SELECT DISTINCT DSC_VARIACAO FROM ' + TabelaVariacao + ' LIMIT 5';
    SelectVariacaoQuery := CriarQuery;
    Result := nil;

    try
        Result := TObjectList<TWooTermoResponse>.Create(True);

        SelectVariacaoQuery.SQL.Text := SQLText;
        SelectVariacaoQuery.Open;
        
        SelectVariacaoQuery.SaveToXML(TPath.Combine(
        	TPath.GetDocumentsPath, 
        	TabelaVariacao + '_descricao.xml')
        );

        while not SelectVariacaoQuery.EoF do
        begin
        	JSONResposta := nil;
            Termo := nil;
            
            try
                Termo := TWooTermoAtributoRequest.Create;
            	Termo.Name := SelectVariacaoQuery.FieldByName('DSC_VARIACAO').AsString;

                JSONResposta := ChamadaAPIWooCommerce(
                    '/products/attributes/' + AtributoId.ToString + '/terms',
                    'POST',
                    'Termo criado com sucesso!',
                    TJson.ObjectToJsonString(Termo)
                );

                try
                	Result.Add(TJson.JsonToObject<TWooTermoResponse>(JSONResposta.ToJson));
                except
                    Result.Free;
                    raise Exception.Create('Erro na criação do termo!');
                end;

                SelectVariacaoQuery.Next;
            finally
                JSONResposta.Free;
                Termo.Free;
            end;
        end;
    finally
    	SelectVariacaoQuery.Free;
    end;
end;

function TfrmTela_Principal.BuscarSecaoNoBanco(
    CodIdEmpresa: Integer;
	CodIdSecao: Integer
 ): TSecao;
var
    SelectSecaoQuery: TUniQuery;
begin
	Result := nil;
	SelectSecaoQuery := CriarQuery;

    try
    	SelectSecaoQuery.SQL.Text := 'SELECT * FROM db_sgci.secoes ' +sLineBreak +
        	'WHERE COD_ID_EMPRESA = :COD_ID_EMPRESA AND COD_ID_SECAO = :COD_ID_SECAO LIMIT 10';
        SelectSecaoQuery.ParamByName('COD_ID_EMPRESA').AsInteger := CodIdEmpresa;
        SelectSecaoQuery.ParamByName('COD_ID_SECAO').AsInteger := CodIdSecao;
    	SelectSecaoQuery.Open;

        if not SelectSecaoQuery.IsEmpty then
        begin
        	Result := TSecao.Create;
            Result.CodIdSecao := SelectSecaoQuery.FieldByName('COD_ID_SECAO').AsInteger;
            Result.DscSecao := SelectSecaoQuery.FieldByName('DSC_SECAO').AsString;
        end;
    finally
       SelectSecaoQuery.Free;
    end;
end;

function TfrmTela_Principal.VerificarExistenciaDaCategoria(Categoria: string): TWooCategoriaResponse;
var
	JSONResposta: TJSONValue;
    CategoriasJSONArray: TJSONArray;
    CategoriaRetornada: string;
begin
	Result := nil;
    JSONResposta := nil;

    try
        JSONResposta := ChamadaAPIWooCommerce('products/categories', 'GET', 'Categorias retornadas com sucesso!');
    	CategoriasJSONArray := ChecarERetornarJSONArray(JSONResposta);

        for var CategoriaJSON in CategoriasJSONArray do
        begin
            CategoriaRetornada := CategoriaJSON.GetValue<string>('name');

            if RemoverEspacos(Categoria) = RemoverEspacos(CategoriaRetornada) then
            begin
               Result := TJson.JsonToObject<TWooCategoriaResponse>(CategoriaJSON as TJSONObject);
               Break;
            end;
        end;
    finally
        JSONResposta.Free;
    end;

end;

function TfrmTela_Principal.CriarCategoria(Secao: TSecao): TWooCategoriaResponse;
var
    RequestPayload: string;
    JSONResposta: TJSONValue;
    CategoriaRequest: TWooCategoriaRequest;
begin
    Result := nil;
    JSONResposta := nil;
    CategoriaRequest := nil;

    try
    	CategoriaRequest := TWooCategoriaRequest.Create;
        CategoriaRequest.Name := Secao.DscSecao;
    	RequestPayload := TJson.ObjectToJsonString(CategoriaRequest);
        JSONResposta := ChamadaAPIWooCommerce('products/categories', 'POST', 'Categoria criada com sucesso!', RequestPayload);
        Result := TJson.JsonToObject<TWooCategoriaResponse>(JSONResposta as TJSONObject);

    finally
    	JSONResposta.Free;
        CategoriaRequest.Free;
    end;
end;

function TfrmTela_Principal.BuscarImagemProdutoNoBanco(
    CodIdEmpresa: Integer;
    CodIdProduto: Integer
): TObjectList<TProdutoImagem>;
var
    Query: TUniQuery;
    ProdutoImagem: TProdutoImagem;
begin
	Result := nil;
    Query := CriarQuery;

    try
    	Result := TObjectList<TProdutoImagem>.Create(True);
        
        try
        	Query.SQL.Text := 'SELECT pi.COD_ID_IMAGEM, pi.COD_ID_EMPRESA, pi.COD_ID_PRODUTO, pi.URL_IMAGEM ' + sLineBreak +
                'FROM db_sgci.produtos_imagens pi ' + sLineBreak +
                'WHERE COD_ID_EMPRESA = :COD_ID_EMPRESA AND ' + sLineBreak +
                'COD_ID_PRODUTO = :COD_ID_PRODUTO';

            Query.ParamByName('COD_ID_EMPRESA').AsInteger := CodIdEmpresa;
            Query.ParamByName('COD_ID_PRODUTO').AsInteger := CodIdProduto;
            Query.Open;

            while not Query.Eof do
            begin
                ProdutoImagem := ProdutoImagemQueryToProdutoImagem(Query);
                Result.Add(ProdutoImagem);
                Query.Next;
            end;
        except
        	Result.Free;
            raise Exception.Create('Erro ao buscar imagens no banco!');
        end;
    finally
    	Query.Free;
    end;
end;

function TfrmTela_Principal.DownloadImage(ImageUrl: string = ''): TMemoryStream;
var
	Response: IResponse;
begin
	Result := TMemoryStream.Create;

    try
    	Response := TRequest.New.BaseURL(ImageUrl).Accept('*/*').Get;
        
        if Response.StatusCode <> 200 then
        	raise Exception.Create('Rquisição falhou: ' + Response.StatusText);

        Result.LoadFromStream(Response.ContentStream);
    except
       Result.Free;
       raise Exception.Create('Error ao baixar a imagem!');
    end;
end;

function TfrmTela_Principal.RetornarImagensRequest(CodIdProduto: Integer): TObjectList<TWooImagemRequest>;
var
	ListaImagens: TObjectList<TProdutoImagem>;
    ListaImagensResponse: TObjectList<TWPImagemResponse>;
    ListaImagensRequest: TObjectList<TWooImagemRequest>;
    CodIdEmpresa: Integer;
begin
    Result := nil;

	sqlImagens.Close;
    sqlImagens.SQL.Text := FSQLImagensBase;

    if sqlImagens.SQL.Text.Contains(':COD_ID_PRODUTO') = False then
    	sqlImagens.SQL.Add('AND COD_ID_PRODUTO = :COD_ID_PRODUTO');

    sqlImagens.ParamByName('COD_ID_PRODUTO').AsInteger := CodIdProduto;
    sqlImagens.Open;

    if sqlImagens.IsEmpty then
    	Exit(nil);

    CodIdEmpresa := sqlImagens.FieldByName('COD_ID_EMPRESA').AsInteger;

    ListaImagens := BuscarImagemProdutoNoBanco(CodIdEmpresa, CodIdProduto);

    try
    	ListaImagensResponse := EnviarImagem(ListaImagens);

        try
        	ListaImagensRequest := TObjectList<TWooImagemRequest>.Create(True);

            try
            	for var ImagemResponse in ListaImagensResponse do
                	ListaImagensRequest.Add(WPImagemResponseToWooImagemRequest(ImagemResponse));
            	Result := ListaImagensRequest;
            except
            	ListaImagensRequest.Free;
                raise Exception.Create('Erro!');
            end;

        finally
        	ListaImagensResponse.Free;
        end;
    finally
    	ListaImagens.Free;
    end;
end;

function TfrmTela_Principal.EnviarImagem(ListaImagens: TObjectList<TProdutoImagem>): TObjectList<TWPImagemResponse>;
var
	iRes: IResponse;
    Stream: TMemoryStream;
    ImagemProduto: TProdutoImagem;
    ImagemResponse: TWPImagemResponse;
begin
    Result := TObjectList<TWPImagemResponse>.Create(True);

    try
    	for ImagemProduto in ListaImagens do
    	begin
    		Stream := DownloadImage(ImagemProduto.UrlImagem);

        	try
        		Stream.Position := 0;

            	iRes := TRequest.New()
                    .BaseURL(TAppConfig.WordPressApiUrl)
                    .BasicAuthentication(TAppConfig.WPUser, TAppConfig.WPPassword)
                    .AddHeader('Content-Type', 'image/png', [poDoNotEncode])
                    .AddHeader('Content-Disposition', 'attachment; filename="imagem.png"', [poDoNotEncode])
                    .AddBody(Stream, False)
                    .Post;

            	if not (iRes.StatusCode in [200, 201]) then
                	raise Exception.Create('Requisição falhou: ' + iRes.StatusCode.ToString + '. ' + iRes.Content);

            	ImagemResponse := TJson.JsonToObject<TWPImagemResponse>(iRes.Content);
            	Result.Add(ImagemResponse);
            	ShowMessage('Upload de imagem bem sucedido');
        	finally
        		Stream.Free;
    		end;
    	end;
    except
    	Result.Free;
        raise Exception.Create('Erro ao enviar imagem para o WooCommerce');
    end;
end;

procedure TfrmTela_Principal.EnviarProduto(Produto: TWooProdutoRequest);
var
    JSONString: string;
    JSONResposta: TJSONValue;
begin
	JSONResposta := nil;
    JSONString := TJSON.ObjectToJsonString(Produto);

    try
    	JSONResposta := ChamadaAPIWooCommerce('products', 'POST', 'Produto cadastrado com sucesso', JSONString);
    	SalvarConteudoEmArquivo('C:\Users\HELDER\Desktop\RESPONSE-DELPHI\WOOCOMMERCE-PAYLOADS\PRODUTO-JSON.TXT ', JSONResposta.ToJSON);
    finally
       JSONResposta.Free;
    end;
end;

function TfrmTela_Principal.CompararTermos(
	TermosAPI: TObjectList<TWooTermoResponse>;
	TermosDB: TList<string>
) : TList<string>;
var
    TermosDistintos: TList<string>;
begin
    Result := nil;
    TermosDistintos := TList<string>.Create;

    for var Termo in TermosApi do
        TermosDistintos.Add(Termo.Name);

    try
        Result := TList<string>.Create;

        for var Termo in TermosDB do
        begin
            if TermosDistintos.Contains(Termo) then
            	Result.Add(Termo);
        end;
    except
        Result.Free;
        raise Exception.Create('Erro ao comparar termos');
    end;
end;

procedure TfrmTela_Principal.btnEnviarProdutosClick(Sender: TObject);
var
    ProdutoDB: TProduto;
    WooProdutoRequest: TWooProdutoRequest;
    TipoProduto: string;
    Secao: TSecao;
    CategoriaResponse: TWooCategoriaResponse;
    Atributos: TObjectList<TWooAtributoResponse>;
    ListaImagensRequest: TObjectList<TWooImagemRequest>;
    TermosAPI: TObjectList<TObjectList<TWooTermoResponse>>;
    TermosDB: TList<string>;
    TermosProduto: TDictionary<Integer, TList<string>>;
begin
	with sqlProdutos do
	begin
        Close;
        Connection:= Self.Database;
        SQL.Text := FSQLProdutosBase;

        if SQL.Text.Contains(':COD_ID_PRODUTO') = False then
            SQL.Add('AND COD_ID_PRODUTO = :COD_ID_PRODUTO');

        ParamByName('COD_ID_PRODUTO').AsInteger := FCodIdProduto;
        Open;

        if sqlProdutos.IsEmpty then
        	Exit;

        ProdutoDB := nil;
        WooProdutoRequest := nil;
    	Atributos := nil;
        CategoriaResponse := nil;
        ListaImagensRequest := nil;
        Secao := nil;
        TermosProduto := nil;
        TermosAPI := nil;

        try
        	ProdutoDB := ProdutoQueryToProduto(sqlProdutos);

            if FieldByName('COD_ID_GRADE').IsNull then
                TipoProduto := 'simple'
            else
            begin
                TipoProduto := 'variable';
                Atributos := BuscarAtributos;

                if Atributos.Count <> Length(FTabelasVariacao) then
                    raise Exception.CreateFmt(
                        'Atributos e FTabelasVariação são de tamanhos diferentes!' + sLineBreak +
                        'Atributos: %d. FTabelasVariação: %d.',
                        [Atributos.Count, Length(FTabelasVariacao)]
                    );

                try
                	TermosAPI := TObjectList<TObjectList<TWooTermoResponse>>.Create(True);

                    for var I := 0 to Atributos.Count - 1 do
                	begin
                    	TermosAPI.Add(EnviarTermos(FTabelasVariacao[I], Atributos[I].Id));
                	end;

                    if Atributos.Count <> TermosAPI.Count then
                    raise Exception.CreateFmt(
                        'Atributos e TermosAPI são de tamanhos diferentes!' + sLineBreak +
                        'Atributos: %d. TermosAPI: %d.',
                        [Atributos.Count, TermosAPI.Count]
                    );

                	TermosProduto := TDictionary<Integer, TList<string>>.Create;

                	for var I := 0 to Atributos.Count - 1 do
                	begin
                    	TermosDB := BuscarTermosProduto(
                            ProdutoDB.CodIdEmpresa,
                            ProdutoDb.CodIdGrade,
                            ProdutoDB.CodIdProduto,
                            FTabelasVariacao[I]
                    	);

                		TermosProduto.Add(Atributos[I].Id, CompararTermos(TermosAPI[I], TermosDB));
                	end;
                finally

                end;
            end;

            ListaImagensRequest := RetornarImagensRequest(ProdutoDB.CodIdProduto);
            Secao := BuscarSecaoNoBanco(ProdutoDB.CodIdEmpresa, ProdutoDB.CodIdSecao);

            if not Assigned(Secao) then
            	raise Exception.Create('Seção não encontrda no banco!');
            
            CategoriaResponse := VerificarExistenciaDaCategoria(Secao.DscSecao);

            if not Assigned(CategoriaResponse) then
                CategoriaResponse := CriarCategoria(Secao);

            if not Assigned(CategoriaResponse) then
                raise Exception.Create('Categoria inválida retornada pela API');

        	WooProdutoRequest := ProdutoToWooProdutoRequest(
                ProdutoDB,
                TipoProduto,
                CategoriaResponse.Id,
                ListaImagensRequest,
                TermosProduto);

        	EnviarProduto(WooProdutoRequest);
        finally
        	WooProdutoRequest.Free;
            CategoriaResponse.Free;
            Secao.Free;
            ListaImagensRequest.Free;
            ProdutoDB.Free;
            Atributos.Free;
            TermosProduto.Free;
            TermosAPI.Free;
        end;
	end;
end;

procedure TfrmTela_Principal.DatabaseConnectionLost(Sender: TObject; Component: TComponent;
  ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
begin
	RetryMode := rmReconnectExecute;
end;

end.
