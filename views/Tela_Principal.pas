unit Tela_Principal;

interface

uses
	Winapi.Windows, Winapi.Messages,
    System.SysUtils, System.Variants, System.Classes, System.IOUtils, System.NetEncoding,
    System.Generics.Defaults, System.Generics.Collections, System.JSON, System.IniFiles, System.Threading, System.DateUtils,
    Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
    Data.DB, Uni, UniProvider, MySQLUniProvider, DBAccess, MemData, MemDS,
    REST.Json, Rest.Json.Types, RESTRequest4D,
    Horse,
    AppConfig,FileWriter, TransformadorDeTexto, ContentPrinter, CustomObjectMapper, AplicadorMascara,
    Produto, ProdutoGrade, ProdutoImagem, Secao, Variacao,
    Cliente, PedidoVenda, PedidoVendaItem, PedidoVendaPgtos, Municipio, Uf, Finalizadora,
    WooProdutoRequest, WooProdutoResponse,
    WPImagemResponse, WooImagemRequest, WooImagemResponse,
    WooCreateCategoriaRequest, WooCategoriaRequest, WooCategoriaResponse, WooProdutoCategoriaRequest,
    WooAtributoRequest, WooAtributoResponse,
    WooTermoAtributoRequest, WooTermoResponse,
    WooVariacaoProdutoResponse, WooVariacaoProdutoRequest, WooAtributoDaVariacao,
    WooAtributoProduto, WooVariacaoProdutoBatchRequest, WooPedido;

type
    TfrmTela_Principal = class(TForm)
        MySQL: TMySQLUniProvider;
        Database: TUniConnection;
        sqlProdutos: TUniQuery;
        sqlImagens: TUniQuery;
        btnHamburguer: TButton;
        panelSide: TPanel;
        btnEnviarProdutosMandala: TBitBtn;
        procedure OnFormCreate(Sender: TObject);
        procedure RegistrarRotas;
        procedure DatabaseConnectionLost(Sender: TObject; Component: TComponent;
        	ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
        procedure btnHamburguerClick(Sender: TObject);
        procedure btnEnviarProdutosClick(Sender: TObject);
        function SQLToProduto(Query: TUniQuery): TProduto;
        function CriarQuery: TUniQuery;
        function BuscarProdutoPorIdDoWoocommerce(CodIdSite: string): TWooProdutoResponse;
        function BuscarProdutoPorSKU(SKU: string): TWooProdutoResponse;
        function ChecarERetornarJSONArray(JSONResponse: TJSONValue): TJSONArray;
        function ChamadaAPIWooCommerce(Resource: string; Metodo: string;
        	MensagemAposRetorno: string = ''; Body: string = ''): TJSONValue;
        function BuscarProdutosGrade(CodIdEmpresa: Integer; CodIdLoja: Integer;
        	CodIdProduto: Integer): TObjectList<TProdutoGrade>;
        function BuscarAtributos: TObjectList<TWooAtributoResponse>;
        function CriarAtributos: TObjectList<TWooAtributoResponse>;
        function EnviarTermos(Atributos: TObjectList<TWooAtributoResponse>;
        	ProdutosGrade: TObjectList<TProdutoGrade>): TObjectDictionary<Integer, TObjectList<TWooTermoResponse>>;
        function GerarListasDeVariacoesDosProdutosGrade(Atributos: TObjectList<TWooAtributoResponse>;
        	ProdutosGrade: TObjectList<TProdutoGrade>): TObjectDictionary<Integer, TObjectList<TWooTermoResponse>>;
        function BuscarTermosNaApi(AtributoID: Integer): TObjectList<TWooTermoResponse>;
        function GerarListaDeStringsDosTermosDaAPI(TermosAPI: TObjectList<TWooTermoResponse>): TList<string>;
        function FiltrarTermosRepetidos(Variacoes: TList<string>): TList<string>;
        function PostarTermoNaAPI(AtributoId: Integer; Termo: TWooTermoAtributoRequest): TWooTermoResponse;
        function RetornarImagensRequest(CodIdProduto: Integer): TObjectList<TWooImagemRequest>;
        function EnviarImagem(ListaImagens: TObjectList<TProdutoImagem>): TObjectList<TWPImagemResponse>;
        function DownloadImage(ImageUrl: string = ''): TMemoryStream;
        function BuscarSecaoNoBanco(CodIdEmpresa: Integer; CodIdSecao: Integer): TSecao;
        function BuscarCategorias(Secao: TSecao): TWooCategoriaResponse;
        function CriarCategoria(Secao: TSecao): TWooCategoriaResponse;
        function EnviarProduto(ProdutoRequest: TWooProdutoRequest;
        	ProdutoRecebido: TWooProdutoResponse): TWooProdutoResponse;
        procedure SalvarCodIdSiteDoProduto(CodIdSite: string; CodIdProduto: Integer; CodProduto: Int64;
        	CodIdEmpresa: Integer; CodIdLoja: Integer);
        procedure CriarVariacoesDoProduto(ProdutoResponse:
        	TWooProdutoResponse; ProdutosGrade: TObjectList<TProdutoGrade>);
        procedure HorseAPISalvarPedido(Req: THorseRequest; Res: THorseResponse; Next: TProc);
        function ChecarBodyDoWebHook(ReqBody: string): Boolean;
        function BuscarOuInserirClienteNoBanco(CodIdSite: string; Billing: TBilling;
        	CodIdEmpresa: Integer; CodIdLoja: Integer): TCliente;
        function BuscarClienteNoBanco(CodIdSite: string; CodIdEmpresa: Integer;
        	CodIdLoja: Integer; CPF: string; CNPJ: string): TCliente;
        function SQLToCliente(Query: TUniQuery; IdCliente: Integer = 0): TCliente;
        function BuscarMunicipio(Municipio: string): TMunicipio;
        function BuscarOuInserirPedidoVendaNoBanco(CodIdEmpresa: Integer; CodIdLoja: Integer;
        	WooPedido: TWooPedido; Cliente: TCliente): TPedidoVenda;
        function BuscarPedidoVendaNoBanco(CodIdPedidoSite: string; CodIdEmpresa: Integer;
        	CodIdLoja: Integer): TPedidoVenda;
        function ChecarStatusDoPedido(Status: string): Integer;
        function SQLToPedidoVenda(Query: TUniQuery): TPedidoVenda;
        function RetornarItensDoPedidoDeVenda(Itens: TArray<TLineItem>; CodIdEmpresa: Integer;
        	CodIdLoja: Integer; CodIdPedido: Int64): TArray<TPedidoVendaItem>;
        function BuscarProdutoNoBanco(CodIdEmpresa: Integer; CodIdLoja: Integer;
        	CodIdSite: string; SKU: Int64): TProduto;
        procedure SalvarProdutosDoPedido(ProdutosPedido: TArray<TPedidoVendaItem>);
        function BuscarOuAssociarFinalizadora(PaymentMethod: string; PaymentMethodTitle: string;
        	CodIdEmpresa: Integer; CodIdLoja: Integer; CodIdCliente: Integer): TFinalizadora;
        function BuscarFinalizadoraPorCodIdSite(CodIdEmpresa: Integer; CodIdLoja: Integer;
        	CodIdSite: string): TFinalizadora;
        function BuscarFinalizadorasDoBanco(CodIdEmpresa: Integer; CodIdLoja: Integer): TArray<TFinalizadora>;
        function AssociarFinalizadora( DescricaoPagamento: string; DescricaoPagamentoDetalhada: string;
        	Finalizadoras: TArray<TFinalizadora>): TFinalizadora;
        function SQLToFinalizadora(Query: TUniQuery): TFinalizadora;
        function InserirPagamentoNoBanco(CodIdEmpresa: Integer; CodIdLoja: Integer;
            CodIdPedido: Int64; CodIdFinalizadora: Integer; DataPagamento: TDateTime;
            ValorPedido: Double): TPedidoVendaPgtos;
        function SQLToPagamentoDaVenda(Query: TUniQuery): TPedidoVendaPgtos;
        procedure SalvarParcelasDoPagamento(PedidoVenda: TPedidoVenda; Pagamento: TPedidoVendaPgtos);
        procedure OnFormDestroy(Sender: TObject);
	private
    	FSQLProdutosBase: string;
        FSQLImagensBase: string;
    	FTabelasVariacao: TArray<string>;
    	FFolderPath: string;
        const HORSE_PORT = 9000;
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

procedure TfrmTela_Principal.OnFormCreate(Sender: TObject);
begin
	FSQLProdutosBase := sqlProdutos.SQL.Text;
    FSQLImagensBase := sqlImagens.SQL.Text;
    FTabelasVariacao := ['db_sgci.grades_variacao_1', 'db_sgci.grades_variacao_2'];
    FFolderPath := TPath.Combine(TPath.GetDocumentsPath, 'Ecommerce');
    RegistrarRotas;
end;

procedure TfrmTela_Principal.RegistrarRotas;
begin
	THorse.Post(
        '/api/pedido-woocommerce/:codIdEmpresa/:codIdLoja',
        HorseAPISalvarPedido
    );

    THorse.Listen(HORSE_PORT);
end;

procedure TfrmTela_Principal.DatabaseConnectionLost(Sender: TObject; Component: TComponent;
	ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
begin
	RetryMode := rmReconnectExecute;
end;

procedure TfrmTela_Principal.btnHamburguerClick(Sender: TObject);
begin
	panelSide.Visible := not panelSide.Visible;
    btnHamburguer.BringToFront;
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
    TermosProduto: TObjectDictionary<Integer, TObjectList<TWooTermoResponse>>;
    WooProdutoResponse: TWooProdutoResponse;
    ProdutosGrade: TObjectList<TProdutoGrade>;
    ProdutoRecebido: TWooProdutoResponse;
    QueryProdutos: TUniQuery;
begin
	QueryProdutos := nil;

    try
        QueryProdutos := CriarQuery;

    	with QueryProdutos do
    	begin
        	SQL.Text :=
                'SELECT pd.COD_ID_PRODUTO,' +
                '	pd.COD_ID_EMPRESA,' +
                '	pd.COD_ID_LOJA,' +
                '	pd.COD_ID_SITE,' +
                '	pd.COD_PRODUTO,' +
                '	pd.COD_BARRAS,' +
                '	pd.COD_ID_GRADE,' +
                '	pd.COD_ID_SECAO,' +
                '	pd.DSC_COMPLETA,' +
                '	pd.NUM_TIPO_PRODUTO, ' +
                '	pr.NUM_PRECO_VAREJO AS PRECO_VAREJO, ' +
                'CASE WHEN pd.NUM_CONTROLA_ESTOQUE = 1 THEN ' +
                    'CASE WHEN lj.NUM_TIPO_ESTABELECIMENTO = 0 THEN ' +
                        'CASE WHEN emp.NUM_CAD_FILIAIS_UNIFICADO = 1 THEN ' +
                            'COALESCE(pd.NUM_ESTOQUE_INICIAL, 0.000) + ' +
                            'COALESCE(db_sgci.fn_consulta_estoque_atual(pd.COD_ID_EMPRESA, ' +
                            	'pd.COD_ID_LOJA, pd.COD_ID_PRODUTO), 0.00) ' +
                        'ELSE ' +
                            'COALESCE(e.NUM_ESTOQUE_INICIAL, 0.000) + ' +
                            'COALESCE(db_sgci.fn_consulta_estoque_atual(pd.COD_ID_EMPRESA, ' +
                            	'pd.COD_ID_LOJA, pd.COD_ID_PRODUTO), 0.00) ' +
                        'END + ' +
                        'COALESCE(db_sgci.fn_consulta_estoque_composicao(pd.COD_ID_EMPRESA, ' +
                        	'pd.COD_ID_LOJA, pd.COD_ID_PRODUTO), 0.00) ' +
                    'ELSE ' +
                        'CASE WHEN emp.NUM_CAD_FILIAIS_UNIFICADO = 1 THEN ' +
                            'COALESCE(pd.NUM_ESTOQUE_INI_PED, 0.000) + ' +
                            'COALESCE(db_sgci.fn_consulta_estoque_pedido(pd.COD_ID_EMPRESA, ' +
                            	'pd.COD_ID_LOJA, pd.COD_ID_PRODUTO), 0.00) ' +
                        'ELSE ' +
                            'COALESCE(e.NUM_ESTOQUE_INI_PED, 0.000) + ' +
                            'COALESCE(db_sgci.fn_consulta_estoque_pedido(pd.COD_ID_EMPRESA, ' +
                            	'pd.COD_ID_LOJA, pd.COD_ID_PRODUTO), 0.00) ' +
                        'END + ' +
                        'COALESCE(db_sgci.fn_consulta_estoque_composicao(pd.COD_ID_EMPRESA, ' +
                        	'pd.COD_ID_LOJA, pd.COD_ID_PRODUTO), 0.00) ' +
                    'END ' +
                'ELSE ' +
                '	0.000 ' +
                'END AS ESTOQUE_ATUAL ' +
                'FROM db_sgci.produtos pd ' +
                'INNER JOIN db_sgci.precos pr ' +
                '	ON pd.COD_ID_PRODUTO  = pr.COD_ID_PRODUTO ' +
                '	AND pd.COD_ID_EMPRESA = pr.COD_ID_EMPRESA ' +
                '	AND pd.COD_ID_LOJA    = pr.COD_ID_LOJA ' +
                'LEFT JOIN db_sgci.estoques e ' +
                '	ON pd.COD_ID_PRODUTO  = e.COD_ID_PRODUTO ' +
                '	AND pd.COD_ID_EMPRESA = e.COD_ID_EMPRESA ' +
                '	AND pd.COD_ID_LOJA    = e.COD_ID_LOJA ' +
                'INNER JOIN db_sgci.empresas emp ' +
                '	ON emp.COD_ID_EMPRESA = pd.COD_ID_EMPRESA ' +
                'INNER JOIN db_sgci.lojas lj ' +
                '	ON lj.COD_ID_EMPRESA = pd.COD_ID_EMPRESA ' +
                '	AND lj.COD_ID_LOJA   = pd.COD_ID_LOJA ' +
                'WHERE pd.COD_ID_EMPRESA = 2433 ' +
                '	AND pd.COD_ID_LOJA   = 90 ' +
                '	AND NUM_TIPO_PRODUTO != 5 ' +
                'LIMIT 5';
            Open;
            SaveToXML(TPath.Combine(FFolderPath, 'produto-com-preco-e-estoque.xml'));

            while not Eof do
            begin
                ProdutoDB           := nil;
                WooProdutoRequest   := nil;
                Atributos           := nil;
                CategoriaResponse   := nil;
                ListaImagensRequest := nil;
                Secao               := nil;
                TermosProduto       := nil;
                WooProdutoResponse  := nil;
                ProdutosGrade       := nil;

            	try
                    ProdutoDB := SQLToProduto(QueryProdutos);

                    if not ProdutoDB.CodIdSite.IsEmpty then
                    	ProdutoRecebido := BuscarProdutoPorIdDoWoocommerce(ProdutoDB.CodIdSite);

                    if not Assigned(ProdutoDB) then
                    	ProdutoRecebido := BuscarProdutoPorSKU(ProdutoDB.CodProduto.ToString);

                    if ProdutoDB.NumTipoProduto <> 5 then
                        TipoProduto := 'simple'
                    else
                    begin
                        TipoProduto := 'variable';
                        Atributos := BuscarAtributos;

                        ProdutosGrade := BuscarProdutosGrade(
                          ProdutoDB.CodIdEmpresa,
                          ProdutoDB.CodIdEmpresa,
                          ProdutoDB.CodIdProduto
                        );

                        TermosProduto := EnviarTermos(Atributos, ProdutosGrade);
                    end;

                    ListaImagensRequest := RetornarImagensRequest(ProdutoDB.CodIdProduto);
                    Secao := BuscarSecaoNoBanco(ProdutoDB.CodIdEmpresa, ProdutoDB.CodIdSecao);
                    CategoriaResponse := BuscarCategorias(Secao);

                    WooProdutoRequest := ProdutoToWooProdutoRequest(
                        ProdutoDB,
                        TipoProduto,
                        CategoriaResponse.Id,
                        ListaImagensRequest,
                        TermosProduto
                    );

                    if (Assigned(ProdutoRecebido)) and
                        (not SameText(WooProdutoRequest.Sku, ProdutoRecebido.Sku))
                    then
                    begin
                        raise Exception.Create('SKU do produto diverge do código do produto no banco');
                    end;

                    WooProdutoResponse := EnviarProduto(
                        WooProdutoRequest,
                        ProdutoRecebido
                    );

                    if ProdutoDB.CodIdSite.IsEmpty then
                    	SalvarCodIdSiteDoProduto(
                        	WooProdutoResponse.Id.ToString,
                        	ProdutoDB.CodIdProduto,
                        	ProdutoDB.CodProduto,
                        	ProdutoDB.CodIdEmpresa,
                        	ProdutoDB.CodIdLoja
                    	);

                    if WooProdutoResponse.PType = 'variable' then
                        CriarVariacoesDoProduto(WooProdutoResponse, ProdutosGrade);

                    Next;
                finally
                	WooProdutoResponse.Free;
                    WooProdutoRequest.Free;
                    CategoriaResponse.Free;
                    Secao.Free;
                    TermosProduto.Free;
                    ProdutosGrade.Free;
                    Atributos.Free;
                    ProdutoDB.Free;
                end;
            end;
    	end;
    finally
    	QueryProdutos.Free;
    end;
end;

function TfrmTela_Principal.SQLToProduto(Query: TUniQuery): TProduto;
begin
	Result := nil;

    try
        with Query do
        begin
        	Result                := TProduto.Create;
            Result.CodIdProduto   := FieldByName('COD_ID_PRODUTO').AsInteger;
            Result.CodIdEmpresa   := FieldByName('COD_ID_EMPRESA').AsInteger;
            Result.CodIdSite      := FieldByName('COD_ID_SITE').AsString;
            Result.CodIdLoja      := FieldByName('COD_ID_LOJA').AsInteger;
            Result.CodProduto     := FieldByName('COD_PRODUTO').AsLargeInt;
            Result.CodBarras      := FieldByName('COD_BARRAS').AsString;
            Result.CodIdGrade     := FieldByName('COD_ID_GRADE').AsInteger;
            Result.CodIdSecao     := FieldByName('COD_ID_SECAO').AsInteger;
            Result.DscCompleta    := FieldByName('DSC_COMPLETA').AsString;
            Result.NumTipoProduto := FieldByName('NUM_TIPO_PRODUTO').AsInteger;
            Result.NumPrecoVarejo := FieldByName('PRECO_VAREJO').AsCurrency;
            Result.NumEstqAtual   := FieldByName('ESTOQUE_ATUAL').AsFloat;
        end;

    except
        Result.Free;
        raise;
    end;
end;

function TfrmTela_Principal.CriarQuery: TUniQuery;
begin
	if not Assigned(Database) then
    	raise Exception.Create('Não há conexão com o banco!');

    Result := TUniQuery.Create(nil);
    Result.Connection := Database;
end;

function TfrmTela_Principal.BuscarProdutoPorIdDoWoocommerce(CodIdSite: string): TWooProdutoResponse;
var
    JSONArray: TJSONArray;
begin
    JSONArray := nil;
    Result := nil;

    try
    	try
            JSONArray := ChecarERetornarJSONArray(
                ChamadaAPIWooCommerce(
                    Format('products/%s', [CodIdSite]),
                    'GET'
                )
            );

            if JSONArray.Count > 1 then
                raise Exception.Create('Há mais de um produto com ID ' + CodIdSite);

            for var Resposta in JSONArray AS TJSONArray do
            	Result := TJson.JsonToObject<TwooProdutoResponse>(Resposta.ToJSON);

            SalvarConteudoEmArquivo(
                TPath.Combine(FFolderPath, 'produto-por-id.txt'),
                JSONArray.ToJSON
            );
        except
            Result.Free;
            raise;
        end;
    finally
    	JSONArray.Free;
    end;
end;

function TfrmTela_Principal.BuscarProdutoPorSKU(SKU: string): TWooProdutoResponse;
var
    JSONArray: TJSONArray;
begin
    JSONArray := nil;
    Result := nil;

    try
        try
        	JSONArray := ChecarERetornarJSONArray(
                ChamadaAPIWooCommerce(
                    Format('products?sku=%s', [SKU]),
                    'GET'
                )
            );

            if JSONArray.Count > 1 then
                raise Exception.Create('Há mais de um produto com o mesmo SKU');

            for var Resposta in JSONArray AS TJSONArray do
            	Result := TJson.JsonToObject<TwooProdutoResponse>(Resposta.ToJSON);

            SalvarConteudoEmArquivo(
                TPath.Combine(FFolderPath, 'produto-por-sku.txt'),
                JSONArray.ToJSON
            );
        except
        	Result.Free;
            raise;
        end;
    finally
        JSONArray.Free;
    end;
end;

function TfrmTela_Principal.ChecarERetornarJSONArray(JSONResponse: TJSONValue): TJSONArray;
begin
	if not (JSONResponse is TJSONArray) then
    	raise Exception.CreateFmt('Foi recebido %s ao invés de TJSONArray!', [JSONResponse.ClassName]);

  	Result := JSONResponse as TJSONArray;
end;

function TfrmTela_Principal.ChamadaAPIWooCommerce(
	Resource: string;
	Metodo: string;
	MensagemAposRetorno: string = '';
	Body: string = ''
): TJSONValue;
var
    Request: IRequest;
    Response: IResponse;
    JSONResposta: TJSONValue;
begin
    Result := nil;

    Request := TRequest.New
        .BaseURL(TAppConfig.WooApiUrl)
        .Resource(Resource)
        .Timeout(1360000)
        .AddHeader('Content-Type', 'application/json', [poDoNotEncode])
        .BasicAuthentication(TAppConfig.ConsumerKey, TAppConfig.ConsumerSecret);

    if not Body.IsEmpty then
    	Request.AddBody(Body);

    if UpperCase(Metodo) = 'GET' then
    	Response := Request.Get
    else if UpperCase(Metodo) = 'POST' then
    	Response := Request.Post
    else if UpperCase(Metodo) = 'PUT' then
    	Response := Request.Put
    else if UpperCase(Metodo) = 'DELETE' then
    	Response := Request.Delete
    else
    	raise Exception.CreateFmt('Método %s não suportado', [Metodo]);

    if not Assigned(Response) then
    	raise Exception.Create('Nenhuma resposta do servidor!');

    if Response.StatusCode in [200, 201] then
    begin
        if not MensagemAposRetorno.IsEmpty then
        	OutputDebugString(PChar(MensagemAposRetorno));
    end
    else
    	raise Exception.Create('Requisição falhou. ' + Response.StatusCode.ToString + ': ' + Response.Content);

    JSONResposta := TJSONObject.ParseJSONValue(Response.Content);

    if not Assigned(JSONResposta) then
    	raise Exception.Create('JSON Retornado é inválido!');

    Result := JSONResposta;
end;

// ============================================================
// MUDANÇA 4: BuscarProdutosGrade agora gera o SQL dinamicamente
// com base em FTabelasVariacao. Os JOINs, os campos SELECT e a
// leitura dos campos do dataset são todos gerados por loop.
// TProdutoGrade.Variacoes substitui VariacaoUm e VariacaoDois.
// ============================================================
function TfrmTela_Principal.BuscarProdutosGrade(
	CodIdEmpresa: Integer;
	CodIdLoja: Integer;
	CodIdProduto: Integer
): TObjectList<TProdutoGrade>;
var
    Query: TUniQuery;
    ProdutoGrade: TProdutoGrade;
    Variacao: TVariacao;
    JSONArray: TJSONArray;
    I: Integer;
    AliasVar: string;
begin
    Query     := CriarQuery;
    Result    := nil;
	JSONArray := TJSONArray.Create;

	try
        // SELECT fixo
        Query.SQL.Add('SELECT');
        Query.SQL.Add('   PG.COD_ID_PRD_GRD,');
        Query.SQL.Add('   COALESCE(PG.NUM_PRECO_UNITARIO, S.NUM_PRECO_VAREJO) AS NUM_PRECO_UNITARIO,');
        Query.SQL.Add('   PG.NUM_ESTOQUE_INICIAL + SUM(COALESCE(E.NUM_QUANTIDADE, 0)) AS NUM_ESTOQUE');

        // SELECT dinâmico: uma linha por tabela de variação
        for I := 0 to High(FTabelasVariacao) do
        begin
            AliasVar := 'V' + IntToStr(I + 1);
            Query.SQL.Add(Format(', %s.COD_ID_VARIACAO AS COD_ID_VAR_%d', [AliasVar, I + 1]));
            Query.SQL.Add(Format(', %s.DSC_VARIACAO   AS DSC_VAR_%d',     [AliasVar, I + 1]));
        end;

        // FROM e JOINs fixos
        Query.SQL.Add('FROM db_sgci.produtos_grades PG');
        Query.SQL.Add('LEFT JOIN db_sgci.produtos P ON P.COD_ID_PRODUTO = PG.COD_ID_PRODUTO');
        Query.SQL.Add('LEFT JOIN db_sgci.precos S ON');
        Query.SQL.Add('   S.COD_ID_EMPRESA = P.COD_ID_EMPRESA AND');
        Query.SQL.Add('   S.COD_ID_LOJA    = :COD_ID_LOJA AND');
        Query.SQL.Add('   S.COD_ID_PRODUTO = P.COD_ID_PRODUTO');

        // JOINs dinâmicos: um por tabela de variação
        for I := 0 to High(FTabelasVariacao) do
        begin
            AliasVar := 'V' + IntToStr(I + 1);
            Query.SQL.Add(Format('INNER JOIN %s %s ON', [FTabelasVariacao[I], AliasVar]));
            Query.SQL.Add(Format('   %s.COD_ID_VARIACAO = PG.COD_ID_VAR_%d AND', [AliasVar, I + 1]));
            Query.SQL.Add(Format('   %s.NUM_STATUS = 1', [AliasVar]));
        end;

        // Resto do SQL fixo
        Query.SQL.Add('LEFT JOIN db_sgci.estoques_grades E ON');
        Query.SQL.Add('   E.COD_ID_PRD_GRD        = PG.COD_ID_PRD_GRD AND');
        Query.SQL.Add('   COALESCE(E.NUM_INDC, 0) = 0');
        Query.SQL.Add('WHERE');
        Query.SQL.Add('   PG.COD_ID_EMPRESA = :COD_ID_EMPRESA AND');
        Query.SQL.Add('   PG.COD_ID_PRODUTO = :COD_ID_PRODUTO');
        Query.SQL.Add('GROUP BY PG.COD_ID_PRD_GRD');

        Query.ParamByName('COD_ID_LOJA').AsInteger    := CodIdLoja;
        Query.ParamByName('COD_ID_EMPRESA').AsInteger := CodIdEmpresa;
        Query.ParamByName('COD_ID_PRODUTO').AsInteger := CodIdProduto;
        Query.Open;

        Query.SaveToXML(TPath.Combine(FFolderPath, 'variacoes-preco-unitario.xml'));

        Result := TObjectList<TProdutoGrade>.Create(True);

        try
            while not Query.Eof do
            begin
                ProdutoGrade := TProdutoGrade.Create;
                ProdutoGrade.NumPrecoUnitario := Query.FieldByName('NUM_PRECO_UNITARIO').AsCurrency;
                ProdutoGrade.NumEstoque       := Query.FieldByName('NUM_ESTOQUE').AsInteger;

                // Leitura dinâmica: uma TVariacao por coluna, usando os aliases gerados no SELECT
                for I := 0 to High(FTabelasVariacao) do
                begin
                    Variacao               := TVariacao.Create;
                    Variacao.CodIdVariacao := Query.FieldByName(Format('COD_ID_VAR_%d', [I + 1])).AsInteger;
                    Variacao.DscVariacao   := Query.FieldByName(Format('DSC_VAR_%d',    [I + 1])).AsString;
                    ProdutoGrade.Variacoes.Add(Variacao);
                end;

                JSONArray.AddElement(TJson.ObjectToJsonObject(ProdutoGrade));
                Result.Add(ProdutoGrade);
                Query.Next;
            end;

            SalvarConteudoEmArquivo(FFolderPath + 'array-produtos-grade.txt', JSONArray.ToString);
        except
            Result.Free;
            raise;
        end;
    finally
        JSONArray.Free;
        Query.Free;
    end;
end;

function TfrmTela_Principal.BuscarAtributos: TObjectList<TWooAtributoResponse>;
var
	JSONResposta: TJSONValue;
	JSONArray: TJSONArray;
begin
    Result := nil;
    JSONResposta := nil;
    JSONArray := nil;

    try
    	JSONResposta := ChamadaAPIWooCommerce('products/attributes', 'GET', 'Atributos retornados com sucesso');
        JSONArray    := ChecarERetornarJSONArray(JSONResposta);

        if (not Assigned(JSONArray)) or (JSONArray.Count = 0) then
        begin
        	Result := CriarAtributos;

        	if not Assigned(Result) then
            	raise Exception.Create('Erro na criação de atributos');

    		Exit(Result);
		end;

        try
        	Result := TObjectList<TWooAtributoResponse>.Create(True);

        	for var Response in JSONArray do
        		Result.Add(TJson.JsonToObject<TWooAtributoResponse>(Response.ToJSON));
        except
        	Result.Free;
        	raise;
		end;
	finally
		JSONResposta.Free;
	end;
end;

// ============================================================
// MUDANÇA 1: CriarAtributos agora é dinâmico — cria um atributo
// para cada entrada em FTabelasVariacao, sem quantidade fixa.
// ============================================================
function TfrmTela_Principal.CriarAtributos: TObjectList<TWooAtributoResponse>;
var
	Atributo: TWooAtributoRequest;
    JSONResposta: TJSONValue;
begin
    Result := TObjectList<TWooAtributoResponse>.Create(True);

    try
        for var I := 0 to High(FTabelasVariacao) do
        begin
            Atributo     := TWooAtributoRequest.Create;
            Atributo.Name := 'Grade ' + IntToStr(I + 1);
            JSONResposta  := nil;

            try
                JSONResposta := ChamadaAPIWooCommerce(
                    'products/attributes', 'POST', 'Atributo criado com sucesso',
                    TJson.ObjectToJsonString(Atributo)
                );
                Result.Add(TJson.JsonToObject<TWooAtributoResponse>(JSONResposta.ToJSON));
            finally
                JSONResposta.Free;
                Atributo.Free;
            end;
    	end;
    except
        Result.Free;
        raise;
    end;
end;

function TfrmTela_Principal.EnviarTermos(
	Atributos: TObjectList<TWooAtributoResponse>;
    ProdutosGrade: TObjectList<TProdutoGrade>
): TObjectDictionary<Integer, TObjectList<TWooTermoResponse>>;
begin
	Result := GerarListasDeVariacoesDosProdutosGrade(
        Atributos,
        ProdutosGrade
    );
end;

// ============================================================
// MUDANÇA 2: GerarListasDeVariacoesDosProdutosGrade agora itera
// sobre todos os atributos dinamicamente via loop, em vez de
// acessar Atributos[0] e Atributos[1] de forma fixa.
// Cada coluna de variação (I) é lida de Grade.Variacoes[I].
// ============================================================
function TfrmTela_Principal.GerarListasDeVariacoesDosProdutosGrade(
	Atributos: TObjectList<TWooAtributoResponse>;
  	ProdutosGrade: TObjectList<TProdutoGrade>
): TObjectDictionary<Integer, TObjectList<TWooTermoResponse>>;
var
	I: Integer;
    Variacoes: TList<string>;
    TermosAPI: TObjectList<TWooTermoResponse>;
    TermosExistentes: TList<string>;
    Termo: TWooTermoAtributoRequest;
begin
	Result := TObjectDictionary<Integer, TObjectList<TWooTermoResponse>>.Create([doOwnsValues]);

    for I := 0 to Atributos.Count - 1 do
    begin
        TermosAPI        := BuscarTermosNaApi(Atributos[I].Id);
        TermosExistentes := GerarListaDeStringsDosTermosDaAPI(TermosAPI);

        Variacoes := TList<string>.Create;
    	try
            // Coleta a descrição da variação na posição I de cada produto
            for var Grade in ProdutosGrade do
            	Variacoes.Add(Grade.Variacoes[I].DscVariacao);

            	Variacoes := FiltrarTermosRepetidos(Variacoes);

        for var DscVariacao in Variacoes do
        begin
        	if not TermosExistentes.Contains(DscVariacao) then
        	begin
                Termo      := TWooTermoAtributoRequest.Create;
                Termo.Name := DscVariacao;
                TermosAPI.Add(PostarTermoNaAPI(Atributos[I].Id, Termo));
        	end;
        end;

    	Result.Add(Atributos[I].Id, TermosAPI);
    	finally
            TermosExistentes.Free;
            Variacoes.Free;
        end;
    end;
end;

function TfrmTela_Principal.BuscarTermosNaApi(AtributoID: Integer): TObjectList<TWooTermoResponse>;
var
	JSONResposta: TJSONValue;
    ListaTermosAPI: TJSONArray;
begin
    Result       := TObjectList<TWooTermoResponse>.Create(True);
    JSONResposta := nil;

    try
        try
            JSONResposta := ChamadaAPIWooCommerce(
                'products/attributes/' + AtributoId.ToString + '/terms?per_page=100',
                'GET'
            );

            ListaTermosAPI := ChecarERetornarJSONArray(JSONResposta);

            for var TermoAPI in ListaTermosAPI do
            	Result.Add(TJson.JsonToObject<TWooTermoResponse>(TermoAPI.ToJSON));
        except
            Result.Free;
            raise;
        end;
    finally
    	JSONResposta.Free;
    end;
end;

function TfrmTela_Principal.GerarListaDeStringsDosTermosDaAPI(
	TermosAPI: TObjectList<TWooTermoResponse>
): TList<string>;
begin
	Result := TList<string>.Create;

  	for var Termo in TermosAPI do
    	Result.Add(Termo.Name);
end;

function TfrmTela_Principal.FiltrarTermosRepetidos(Variacoes: TList<string>): TList<string>;
var
	TermosDistintos: TStringList;
begin
	Result := TList<string>.Create;
    TermosDistintos := TStringList.Create;
    TermosDistintos.Sorted := True;
    TermosDistintos.Duplicates := dupIgnore;

    for var Variacao in Variacoes do
    	TermosDistintos.Add(Variacao);

    for var Termo in TermosDistintos do
    	Result.Add(Termo);
end;

function TfrmTela_Principal.PostarTermoNaAPI(
    AtributoId: Integer;
    Termo: TWooTermoAtributoRequest
): TWooTermoResponse;
var
	JSONResposta: TJSONValue;
begin
    JSONResposta := nil;

    try
        JSONResposta := ChamadaAPIWooCommerce(
              '/products/attributes/' + AtributoId.ToString + '/terms',
              'POST',
              'Termo criado com sucesso!',
              TJson.ObjectToJsonString(Termo)
        );

        Result := TJson.JsonToObject<TWooTermoResponse>(JSONResposta.ToJSON);
    finally
    	JSONResposta.Free;
    end;
end;

function TfrmTela_Principal.RetornarImagensRequest(CodIdProduto: Integer): TObjectList<TWooImagemRequest>;
var
	ListaImagens: TObjectList<TProdutoImagem>;
  	ListaImagensResponse: TObjectList<TWPImagemResponse>;
  	ListaImagensRequest: TObjectList<TWooImagemRequest>;
  	ProdutoImagem: TProdutoImagem;
begin
    Result       := nil;
    ListaImagens := nil;

    sqlImagens.Close;
    sqlImagens.SQL.Text := FSQLImagensBase;

    if not sqlImagens.SQL.Text.Contains(':COD_ID_PRODUTO') then
        sqlImagens.SQL.Add('AND COD_ID_PRODUTO = :COD_ID_PRODUTO');

    sqlImagens.ParamByName('COD_ID_PRODUTO').AsInteger := CodIdProduto;
    sqlImagens.Open;

    try
        ListaImagens := TObjectList<TProdutoImagem>.Create(True);

        while not sqlImagens.Eof do
        begin
            if not Assigned(sqlImagens.FieldByName('URL_IMAGEM'))
            	or sqlImagens.FieldByName('URL_IMAGEM').IsNull
            then
            begin
                sqlImagens.Next;
                Continue;
            end;

            ProdutoImagem := ProdutoImagemQueryToProdutoImagem(sqlImagens);
            ListaImagens.Add(ProdutoImagem);
            sqlImagens.Next;
        end;

        ListaImagensResponse := nil;

        try
            ListaImagensResponse := EnviarImagem(ListaImagens);
            ListaImagensRequest  := TObjectList<TWooImagemRequest>.Create(True);

            try
                for var ImagemResponse in ListaImagensResponse do
                    ListaImagensRequest.Add(WPImagemResponseToWooImagemRequest(ImagemResponse));

                    Result := ListaImagensRequest;
            except
                ListaImagensRequest.Free;
                Result.Free;
                raise;
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
    		finally
    			Stream.Free;
    		end;
    	end;
    except
    	Result.Free;
        raise;
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
        	raise Exception.Create('Requisição falhou: ' + Response.StatusText);

        Result.LoadFromStream(Response.ContentStream);
    except
        Result.Free;
        raise;
    end;
end;

function TfrmTela_Principal.BuscarSecaoNoBanco(
	CodIdEmpresa: Integer;
    CodIdSecao: Integer
): TSecao;
var
	SelectSecaoQuery: TUniQuery;
begin
	Result           := nil;
	SelectSecaoQuery := CriarQuery;

    try
        SelectSecaoQuery.SQL.Text :=
        'SELECT * FROM db_sgci.secoes ' +
        'WHERE COD_ID_EMPRESA = :COD_ID_EMPRESA' +
        '	AND COD_ID_SECAO = :COD_ID_SECAO LIMIT 10';

        SelectSecaoQuery.ParamByName('COD_ID_EMPRESA').AsInteger := CodIdEmpresa;
        SelectSecaoQuery.ParamByName('COD_ID_SECAO').AsInteger   := CodIdSecao;
        SelectSecaoQuery.Open;

        if SelectSecaoQuery.IsEmpty then
        	raise Exception.Create('Seção não encontrada no banco!');

        Result            := TSecao.Create;
        Result.CodIdSecao := SelectSecaoQuery.FieldByName('COD_ID_SECAO').AsInteger;
        Result.DscSecao   := SelectSecaoQuery.FieldByName('DSC_SECAO').AsString;
    finally
    	SelectSecaoQuery.Free;
    end;
end;

function TfrmTela_Principal.BuscarCategorias(Secao: TSecao): TWooCategoriaResponse;
var
	JSONResposta: TJSONValue;
    CategoriasJSONArray: TJSONArray;
    CategoriaRetornada: string;
    Categoria: string;
begin
	Result       := nil;
    JSONResposta := nil;
    Categoria    := Secao.DscSecao;

    try
        JSONResposta := ChamadaAPIWooCommerce(
            'products/categories?search=' + TNetEncoding.URL.Encode(Categoria),
            'GET',
            'Categorias retornadas com sucesso!'
        );

        CategoriasJSONArray := ChecarERetornarJSONArray(JSONResposta);

        if (CategoriasJSONArray = nil) or (CategoriasJSONArray.Count = 0) then
        	Exit(CriarCategoria(Secao));

        for var CategoriaJSON in CategoriasJSONArray do
        begin
    		CategoriaRetornada := CategoriaJSON.GetValue<string>('name');

    		if NormalizarTexto(Categoria) = NormalizarTexto(CategoriaRetornada) then
    		begin
    			Result := TJson.JsonToObject<TWooCategoriaResponse>(CategoriaJSON.ToJSON);
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
    Result           := nil;
    JSONResposta     := nil;
    CategoriaRequest := nil;

    try
        CategoriaRequest := TWooCategoriaRequest.Create;
        CategoriaRequest.Name := Secao.DscSecao;
        RequestPayload := TJson.ObjectToJsonString(CategoriaRequest);

        JSONResposta := ChamadaAPIWooCommerce(
            'products/categories',
            'POST',
            'Categoria criada com sucesso!',
        	RequestPayload
        );

        Result := TJson.JsonToObject<TWooCategoriaResponse>(JSONResposta as TJSONObject);
    finally
        JSONResposta.Free;
        CategoriaRequest.Free;
    end;
end;

function TfrmTela_Principal.EnviarProduto(
	ProdutoRequest: TWooProdutoRequest;
	ProdutoRecebido: TWooProdutoResponse
): TWooProdutoResponse;
var
	JSONString: string;
    JSONResposta: TJSONValue;
    Method: string;
    Resource: string;
    MensagemRetorno: string;
begin
    JSONResposta := nil;
    Result := nil;

    if(Assigned(ProdutoRecebido)) then
    begin
        Method := 'PUT';
        Resource := Format('products/%d', [ProdutoRecebido.Id]);
        ProdutoRequest.Id := ProdutoRecebido.Id;
        MensagemRetorno := 'Produto atualizado com sucesso';
    end
    else
    begin
        Resource := 'products';
        Method := 'POST';
        MensagemRetorno :='Produto cadastrado com sucesso';
    end;

    try
    	try
        	JSONString := TJson.ObjectToJsonString(ProdutoRequest);

            JSONResposta := ChamadaAPIWooCommerce(
            Resource,
                Method,
                MensagemRetorno,
                JSONString,
            );

            SalvarConteudoEmArquivo(
                TPath.Combine(FFolderPath, 'produto-response-after-created.txt'),
                JSONResposta.ToJSON
            );

    		Result := TJson.JsonToObject<TWooProdutoResponse>(JSONResposta.ToJSON);
        except
            Result.Free;
            raise;
    	end;
    finally
    	JSONResposta.Free;
    end;
end;

procedure TfrmTela_Principal.SalvarCodIdSiteDoProduto(
	CodIdSite: string;
    CodIdProduto: Integer;
    CodProduto: Int64;
	CodIdEmpresa: Integer;
	CodIdLoja: Integer);
var
	Query: TUniQuery;
begin
	Query := nil;

    try
        Query := CriarQuery;

        with Query do
        begin
            SQL.Text :=
            'UPDATE db_sgci.produtos ' +
            'SET COD_ID_SITE = :COD_ID_SITE '+
            'WHERE COD_ID_PRODUTO  = :COD_ID_PRODUTO' +
            '	AND COD_PRODUTO    = :COD_PRODUTO' +
            '	AND COD_ID_EMPRESA = :COD_ID_EMPRESA' +
            '	AND COD_ID_LOJA    = :COD_ID_LOJA';

            ParamByName('COD_ID_SITE').AsString := CodIdSite;
            ParamByName('COD_ID_PRODUTO').AsInteger := CodIdProduto;
            ParamByName('COD_PRODUTO').AsLargeInt := CodProduto;
            ParamByName('COD_ID_EMPRESA').AsInteger := CodIdEmpresa;
            ParamByName('COD_ID_LOJA').AsInteger := CodIdLoja;

            ExecSql;
        end;
    finally
    	Query.Free;
    end;
end;

// ============================================================
// MUDANÇA 3: CriarVariacoesDoProduto substituiu os dois blocos
// fixos de AdicionarAtributo e o GerarSKUVariacao(a, b) por
// um loop sobre Grade.Variacoes, tornando-o compatível com
// qualquer número de atributos. GerarSKUVariacao foi removido.
// ============================================================
procedure TfrmTela_Principal.CriarVariacoesDoProduto(
	ProdutoResponse: TWooProdutoResponse;
  	ProdutosGrade: TObjectList<TProdutoGrade>
);
var
	BatchRequest: TWooVariacaoProdutoBatchRequest;
    VariacaoProdutoRequest: TWooVariacaoProdutoRequest;
    RespostaAPI: TJSONValue;
    SKUPartes: TStringList;
begin
	BatchRequest := TWooVariacaoProdutoBatchRequest.Create;
	RespostaAPI  := nil;

    try
    	for var Grade in ProdutosGrade do
    	begin
        	VariacaoProdutoRequest := TWooVariacaoProdutoRequest.Create;
            VariacaoProdutoRequest.RegularPrice :=
            	FormatFloat(
                    '0.00',
                    Grade.NumPrecoUnitario,
                	TFormatSettings.Invariant
            	);
            VariacaoProdutoRequest.StockQuantity := Grade.NumEstoque;

            SKUPartes := TStringList.Create;
            try
                SKUPartes.Add(ProdutoResponse.Name);

                // Itera sobre todas as variações do produto dinamicamente
                for var I := 0 to Grade.Variacoes.Count - 1 do
                begin
                    VariacaoProdutoRequest.AdicionarAtributo(
                        ProdutoResponse.Attributes[I].Id,
                        Grade.Variacoes[I].DscVariacao
                    );
                    SKUPartes.Add(Grade.Variacoes[I].DscVariacao);
                end;

                // SKU montado com todas as variações, independente da quantidade
                VariacaoProdutoRequest.Sku := SubstituirEspacosPorTraco(
                    String.Join(' ', SKUPartes.ToStringArray)
                );
            finally
                SKUPartes.Free;
            end;

    		BatchRequest.AdicionarVariacao(VariacaoProdutoRequest);
    	end;

        RespostaAPI := ChamadaAPIWooCommerce(
            'products/' + ProdutoResponse.Id.ToString + '/variations/batch',
            'POST',
            'Variações do produto ' + ProdutoResponse.Name + ' criadas com sucesso',
            TJson.ObjectToJsonString(BatchRequest)
        );

        SalvarConteudoEmArquivo(
        TPath.Combine(FFolderPath, 'variacoes-criadas-api.txt'),
        RespostaAPI.ToJSON
        );
    finally
        RespostaAPI.Free;
        BatchRequest.Free;
    end;
end;

// Início das funções para salvar pedido
procedure TfrmTela_Principal.HorseAPISalvarPedido(
	Req: THorseRequest;
    Res: THorseResponse;
	Next: TProc
);
var
	CodIdEmpresa: Integer;
    CodIdLoja: Integer;
    Conexao: TUniConnection;
    Cliente: TCliente;
    ProdutosPedido: TArray<TPedidoVendaItem>;
    Finalizadora: TFinalizadora;
    WooPedido: TWooPedido;
    PedidoRetornado: TPedidoVenda;
    PagamentoPedidoVenda: TPedidoVendaPgtos;
begin
    Cliente := nil;
    Finalizadora := nil;
    WooPedido := nil;
    PedidoRetornado := nil;
    Conexao := nil;
    PagamentoPedidoVenda := nil;

	try
        CodIdEmpresa := Req.Params
            .Field('codIdEmpresa')
            .Required(True)
            .RequiredMessage('"codIdEmpresa" não foi recebido na URL da requisição')
            .AsInteger;

        CodIdLoja := Req.Params
            .Field('codIdLoja')
            .Required(True)
            .RequiredMessage('"codIdLoja" não foi recebido na URL da requisição')
            .AsInteger;

        ChecarBodyDoWebHook(Req.Body);
        WooPedido := TJSON.JsonToObject<TWooPedido>(Req.Body);

        SalvarConteudoEmArquivo(
                TPath.Combine(TPath.GetDocumentsPath, 'PEDIDO-WOOCOMMERCE.txt'),
                TJson.ObjectToJsonString(WooPedido)
            );

        Conexao := Database;

        try
            Conexao.StartTransaction;

            Cliente := BuscarOuInserirClienteNoBanco(
                WooPedido.CustomerId.ToString,
                WooPedido.Billing,
                CodIdEmpresa,
                CodIdLoja
            );

            PedidoRetornado := BuscarOuInserirPedidoVendaNoBanco(
            	CodIdEmpresa,
                CodIdLoja,
                WooPedido,
                Cliente
            );

            ProdutosPedido := RetornarItensDoPedidoDeVenda(
                WooPedido.LineItems,
                CodIdEmpresa,
                CodIdLoja,
                PedidoRetornado.CodIdPedido
            );

            SalvarProdutosDoPedido(ProdutosPedido);

            Finalizadora := BuscarOuAssociarFinalizadora(
                WooPedido.PaymentMethod,
                WooPedido.PaymentMethodTitle,
                CodIdEmpresa,
                CodIdLoja,
                Cliente.CodIdCliente
            );

            PagamentoPedidoVenda := InserirPagamentoNoBanco(
            	CodIdEmpresa,
                CodIdLoja,
                PedidoRetornado.CodIdPedido,
                Finalizadora.CodIdFinalizadora,
                PedidoRetornado.DatPedido,
                StrToFloat(
                    WooPedido.Total,
                    TFormatSettings.Invariant
                )
            );

            SalvarParcelasDoPagamento(
            	PedidoRetornado,
            	PagamentoPedidoVenda
            );

            Conexao.Commit;

            Res.Status(THTTPStatus.Created)
            	.Send('Pedido criado com sucesso!');
        except
            on E: Exception do
            begin
                Res.Status(THTTPStatus.InternalServerError)
                	.Send('Erro ao salvar pedido!\n');
                if Conexao.InTransaction then
                	Conexao.Rollback;
            end;
        end;
	finally
    	PagamentoPedidoVenda.Free;
    	Finalizadora.Free;
    	PedidoRetornado.Free;
        WooPedido.Free;
    	Cliente.Free;
	end;
end;

function TfrmTela_Principal.ChecarBodyDoWebHook(ReqBody: string): Boolean;
begin
	if ReqBody.Trim.IsEmpty then
    begin
        raise Exception.Create('"Body" da requisição não foi enviado');
        Result := False;
	end
else
    Result := True;

//        if ReqBody.Trim.IsEmpty then
//        	raise EBadRequest.Create('"Body" da requisição não foi enviado');
//
//        if not TApiUtils.ValidarJsonString(Req.Body) then
//            raise Exception.Create('JSON inválido no corpo da requisição');
//            raise EBadRequest.Create('JSON inválido no corpo da requisição.');
//
//        if iRev.NovoUsuario(Req.Body, Resp) then
//            Res.Status(THTTPStatus.OK).Send(Resp)
//        else
//            Res.Status(THTTPStatus.BadRequest).Send(Resp);
end;

function TfrmTela_Principal.BuscarOuInserirClienteNoBanco(
	CodIdSite: string;
    Billing: TBilling;
    CodIdEmpresa: Integer;
    CodIdLoja: Integer
): TCliente;
var
    Query: TUniQuery;
    ClienteID: Integer;
    Municipio: TMunicipio;
begin
    Query := CriarQuery;
	Municipio := nil;
    Result := nil;

	try
    	Result := BuscarClienteNoBanco(
            CodIdSite,
            CodIdEmpresa,
            CodIdLoja,
            Billing.Cpf,
            Billing.Cnpj
        );

        if Assigned(Result) then
        begin
            OutputDebugString(PChar('Cliente encontrado no banco'));
            Exit(Result);
        end;

    	Municipio := BuscarMunicipio(Billing.City);

        if not Assigned(Municipio) then
            raise Exception.Create('Município não encontrado');

		Query.SQL.Text :=
            'INSERT INTO db_sgci.clientes ( ' +
            '	COD_ID_EMPRESA, ' +
            '   COD_ID_LOJA, ' +
            '	COD_ID_SITE,' +
            '   NUM_TIPO, ' +
            '   NUM_SEXO, ' +
            '   DSC_NOME, ' +
            '   DSC_ENDERECO, ' +
            '   DSC_NUMERO, ' +
            '   DSC_COMPLEMENTO, ' +
            '   DSC_BAIRRO, ' +
            '   COD_ID_UF, ' +
            '   COD_ID_MUNICIPIO, ' +
            '   DSC_CEP, ' +
            '   DSC_TELEFONE, ' +
            '   DSC_CELULAR, ' +
            '   DSC_CPF_CNPJ, ' +
            '   DSC_EMAIL, ' +
            '   DAT_NASCIMENTO, ' +
            '   DSC_IE, ' +
            '   DAT_CADASTRO ' +
            ') VALUES ( ' +
            '   :COD_ID_EMPRESA, ' +
            '	:COD_ID_LOJA,' +
            '   :COD_ID_SITE, ' +
            '   :NUM_TIPO, ' +
            '   :NUM_SEXO, ' +
            '   :DSC_NOME, ' +
            '   :DSC_ENDERECO, ' +
            '   :DSC_NUMERO, ' +
            '   :DSC_COMPLEMENTO, ' +
            '   :DSC_BAIRRO, ' +
            '   :COD_ID_UF, ' +
            '   :COD_ID_MUNICIPIO, ' +
            '   :DSC_CEP, ' +
            '   :DSC_TELEFONE, ' +
            '   :DSC_CELULAR, ' +
            '   :DSC_CPF_CNPJ, ' +
            '   :DSC_EMAIL, ' +
            '   :DAT_NASCIMENTO, ' +
            '   :DSC_IE, ' +
            '   NOW() ' +
            ') ON DUPLICATE KEY UPDATE ' +
            '    COD_CLIENTE = LAST_INSERT_ID(COD_CLIENTE)';

        Query.ParamByName('COD_ID_EMPRESA').AsInteger := CodIdEmpresa;
        Query.ParamByName('COD_ID_LOJA').AsInteger    := CodIdLoja;
        Query.ParamByName('COD_ID_SITE').AsString     := CodIdSite;

        if Billing.PersonType = 'F' then
        begin
        	Query.ParamByName('NUM_TIPO').AsInteger    := 0;
        	Query.ParamByName('DSC_CPF_CNPJ').AsString := AplicarMascaraCPF(Billing.Cpf);
        end
        else
        begin
            Query.ParamByName('NUM_TIPO').AsInteger    := 1;
            Query.ParamByName('DSC_CPF_CNPJ').AsString := AplicarMascaraCNPJ(Billing.Cnpj);
        end;

        if Billing.Gender = 'F' then
        	Query.ParamByName('NUM_SEXO').AsInteger := 0
        else if Billing.Gender = 'M' then
        	Query.ParamByName('NUM_SEXO').AsInteger := 1
        else
        	Query.ParamByName('NUM_SEXO').Clear;

        Query.ParamByName('DSC_NOME').AsString :=
        	Trim(Billing.FirstName + ' ' + Billing.LastName);

        Query.ParamByName('DSC_ENDERECO').AsString    := Billing.Address1;
        Query.ParamByName('DSC_NUMERO').AsString      := Billing.Number;
        Query.ParamByName('DSC_COMPLEMENTO').AsString := Billing.Address2;
        Query.ParamByName('DSC_BAIRRO').AsString      := Billing.Neighborhood;
        Query.ParamByName('DSC_CEP').AsString         := AplicarMascaraCEP(Billing.Postcode);

        if Assigned(Municipio) then
        begin
            Query.ParamByName('COD_ID_UF').AsInteger :=
            	Municipio.CodIdUf;

            Query.ParamByName('COD_ID_MUNICIPIO').AsInteger :=
            	Municipio.CodIdMunicipio;
        end
        else
        begin
            Query.ParamByName('COD_ID_UF').Clear;
            Query.ParamByName('COD_ID_MUNICIPIO').Clear;
        end;
        if Billing.Phone <> '' then
        	Query.ParamByName('DSC_TELEFONE').AsString := Billing.Phone
        else
        	Query.ParamByName('DSC_TELEFONE').Clear;

        if Billing.Cellphone <> '' then
        	Query.ParamByName('DSC_CELULAR').AsString := Billing.Cellphone
        else
        	Query.ParamByName('DSC_CELULAR').Clear;

        	Query.ParamByName('DSC_EMAIL').AsString := Billing.Email;

        if Billing.Ie <> '' then
        	Query.ParamByName('DSC_IE').AsString := Billing.Ie
        else
        	Query.ParamByName('DSC_IE').Clear;

        if Billing.Birthdate <> '' then
        	Query.ParamByName('DAT_NASCIMENTO').AsDate :=
            	StrToDateDef(Billing.Birthdate, 0)
        else
        	Query.ParamByName('DAT_NASCIMENTO').Clear;

        Query.ExecSQL;
        Query.SQL.Text := 'SELECT LAST_INSERT_ID() AS ID';
        Query.Open;
        ClienteID := Query.FieldByName('ID').AsInteger;
        Query.Close;

        Query.SQL.Text := 'SELECT * FROM db_sgci.clientes WHERE COD_ID_CLIENTE = :ID';
        Query.ParamByName('ID').AsInteger := ClienteID;
        Query.Open;

        Result := SQLToCliente(Query, ClienteID);
	finally
    	Query.Free;
	end;
end;

function TfrmTela_Principal.BuscarClienteNoBanco(
    CodIdSite: string;
    CodIdEmpresa: Integer;
    CodIdLoja: Integer;
    CPF: string;
	CNPJ: string
): TCliente;
var
	Query: TUniQuery;
begin
    Query := nil;
    Result := nil;

    try
        Query := CriarQuery;

        try
        	with Query do
            begin
                SQL.Text :=
                    'SELECT * FROM db_sgci.clientes ' +
                    'WHERE COD_ID_EMPRESA = :COD_ID_EMPRESA ' +
                    '	AND COD_ID_LOJA   = :COD_ID_LOJA ';

                if CodIdSite <> '0' then
                begin
                   SQL.Add('AND COD_ID_SITE = :COD_ID_SITE ');
                   ParamByName('COD_ID_SITE').AsString := CodIdSite;
                end;

                if CPF <> '' then
                begin
                    SQL.Add('AND DSC_CPF_CNPJ = :CPF ');
                    ParamByName('CPF').AsString := AplicarMascaraCPF(CPF);
                end
                else if CNPJ <> '' then
                begin
                    SQL.Add('AND DSC_CPF_CNPJ = :CNPJ ');
                    ParamByName('CNPJ').AsString := AplicarMascaraCNPJ(CNPJ);
                end;

                ParamByName('COD_ID_EMPRESA').AsInteger := CodIdEmpresa;
                ParamByName('COD_ID_LOJA').AsInteger    := CodIdLoja;
        	end;

            Query.Open;

            if Query.IsEmpty then
            begin
                OutputDebugString(PChar('Usuário não foi encontrado'));
                Exit;
            end;

            Result := SQLToCliente(Query);
        except
            Result.Free;
            raise;
        end;
    finally
        Query.Free;
    end;
end;

function TfrmTela_Principal.SQLToCliente(
    Query: TUniQuery;
	IdCliente: Integer = 0
): TCliente;
begin
	with Query do
    begin
    	Result := TCliente.Create;

        if IdCliente <> 0 then
        	Result.CodIdCliente := FieldByName('COD_ID_CLIENTE').AsInteger;

        Result.CodIdSite       := FieldByName('COD_ID_SITE').AsString;
        Result.CodIdEmpresa    := FieldByName('COD_ID_EMPRESA').AsInteger;
        Result.CodIdLoja       := FieldByName('COD_ID_LOJA').AsInteger;
        Result.CodCliente      := FieldByName('COD_CLIENTE').AsInteger;
        Result.DscNome         := FieldByName('DSC_NOME').AsString;
        Result.DscCpfCnpj      := FieldByName('DSC_CPF_CNPJ').AsString;
        Result.DscEmail        := FieldByName('DSC_EMAIL').AsString;
        Result.DscTelefone     := FieldByName('DSC_TELEFONE').AsString;
        Result.DscCelular      := FieldByName('DSC_CELULAR').AsString;
        Result.DscEndereco     := FieldByName('DSC_ENDERECO').AsString;
        Result.DscNumero       := FieldByName('DSC_NUMERO').AsString;
        Result.DscComplemento  := FieldByName('DSC_COMPLEMENTO').AsString;
        Result.DscBairro       := FieldByName('DSC_BAIRRO').AsString;
        Result.CodCep          := FieldByName('DSC_CEP').AsString;
        Result.DatInclusao     := FieldByName('DAT_CADASTRO').AsDateTime;
    end;
end;

function TfrmTela_Principal.BuscarMunicipio(Municipio: string): TMunicipio;
var
	Query: TUniQuery;
begin
	Query := nil;
    Result := nil;

    try
        try
        	Query := CriarQuery;

            with Query do
            begin
            	SQL.Text :=
                	'SELECT * FROM db_sgci.municipios WHERE ' +
                    	'DSC_MUNICIPIO = :DSC_MUNICIPIO';
        		ParamByName('DSC_MUNICIPIO').AsString := Municipio;
                Open;

            	Result                  := TMunicipio.Create;
                Result.CodIdMunicipio   := FieldByName('COD_ID_MUNICIPIO').AsInteger;
                Result.CodIdUf          := FieldByName('COD_ID_UF').AsInteger;
                Result.CodUf            := FieldByName('COD_UF').AsInteger;
                Result.CodMunicipioIbge := FieldByName('COD_MUNICIPIO_IBGE').AsInteger;
                Result.DscMunicipio     := FieldByName('DSC_MUNICIPIO').AsString;
                Result.DscChave         := FieldByName('DSC_CHAVE').AsString;
            end;
        except
            Result.Free;
            raise;
        end;
    finally
        Query.Free;
    end;
end;

function TfrmTela_Principal.BuscarOuInserirPedidoVendaNoBanco(
	CodIdEmpresa: Integer;
    CodIdLoja: Integer;
    WooPedido: TWooPedido;
	Cliente: TCliente
): TPedidoVenda;
var
	Query: TUniQuery;
	Pedido: TPedidoVenda;
    PedidoId: Int64;
begin
    Query  := nil;
	Pedido := nil;
    Result := nil;

	try
        Result := BuscarPedidoVendaNoBanco(
        	WooPedido.Id.ToString,
            CodIdEmpresa,
            CodIdLoja
        );

        if Assigned(Result) then
        begin
            OutputDebugString(PChar('Pedido encontrado no banco'));
            Exit(Result);
        end;

		Query := CriarQuery;

		with Query do
		begin
            try
            	SQL.Text :=
                  'INSERT INTO db_sgci.pedido_venda ( ' +
                  '	COD_ID_EMPRESA,' +
                  '	COD_ID_LOJA,' +
                  '	COD_ID_PEDIDO_SITE,' +
                  '	COD_ID_CLIENTE,' +
                  '	DAT_PEDIDO,' +
                  '	DAT_INCLUSAO,' +
                  '	NUM_STATUS_PEDIDO ' +
                  ') VALUES ( ' +
                  '	:COD_ID_EMPRESA,' +
                  '	:COD_ID_LOJA, ' +
                  '	:COD_ID_PEDIDO_SITE,' +
                  '	:COD_ID_CLIENTE, ' +
                  '	:DAT_PEDIDO, ' +
                  '	:DAT_INCLUSAO, ' +
                  '	:NUM_STATUS_PEDIDO' +
                  ')';

                ParamByName('COD_ID_EMPRESA').AsInteger    := CodIdEmpresa;
                ParamByName('COD_ID_LOJA').AsInteger       := CodIdLoja;
                ParamByName('COD_ID_PEDIDO_SITE').AsString := WooPedido.Id.ToString;
                ParamByName('COD_ID_CLIENTE').AsInteger    := Cliente.CodIdCliente;
                ParamByName('DAT_PEDIDO').AsDateTime       := ISO8601ToDate(WooPedido.DateCreated);
                ParamByName('DAT_INCLUSAO').AsDateTime     := Now;
                ParamByName('NUM_STATUS_PEDIDO').AsInteger := ChecarStatusDoPedido(WooPedido.Status);

                ExecSQL;

                SQL.Text := 'SELECT LAST_INSERT_ID() AS ID';
                Open;
                PedidoId := FieldByName('ID').AsLargeInt;

                Close;
                SQL.Text := 'SELECT * FROM db_sgci.pedido_venda WHERE COD_ID_PEDIDO = :ID';
                ParamByName('ID').AsLargeInt := PedidoId;
                Open;

                Result := SQLToPedidoVenda(Query);
            except
                Result.Free;
                raise;
            end;
		end;
	finally
		Query.Free;
	end;
end;

function TfrmTela_Principal.BuscarPedidoVendaNoBanco(
	CodIdPedidoSite: string;
	CodIdEmpresa: Integer;
	CodIdLoja: Integer
): TPedidoVenda;
var
    Query: TUniQuery;
begin
	Query := nil;
    Result := nil;

    try
        Query := CriarQuery;

        with Query do
        begin
            SQL.Text :=
            	'SELECT * FROM db_sgci.pedido_venda ' +
                'WHERE  COD_ID_EMPRESA      = :COD_ID_EMPRESA' +
                '	AND COD_ID_LOJA         = :COD_ID_LOJA' +
                '	AND COD_ID_PEDIDO_SITE  = :COD_ID_PEDIDO_SITE';

            ParamByName('COD_ID_EMPRESA').AsInteger    := CodIdEmpresa;
            ParamByName('COD_ID_LOJA').AsInteger       := CodIdLoja;
            ParamByName('COD_ID_PEDIDO_SITE').AsString := CodIdPedidoSite;

            Open;

            if Query.IsEmpty then
            begin
            	OutputDebugString(PChar('Pedido não foi encontrado no banco'));
            	Exit;
            end;

            Result := SQLToPedidoVenda(Query);
        end;
    finally
        Query.Free;
    end;
end;

function TfrmTela_Principal.SQLToPedidoVenda(Query: TUniQuery): TPedidoVenda;
begin
	Result := nil;

    try
    	Result := TPedidoVenda.Create;

        with Query do
        begin
        	Result.CodIdPedido        := FieldByName('COD_ID_PEDIDO').AsLargeInt;
        	Result.CodIdEmpresa       := FieldByName('COD_ID_EMPRESA').AsInteger;
            Result.CodIdLoja          := FieldByName('COD_ID_LOJA').AsInteger;
            Result.CodIdPedidoSite    := FieldByName('COD_ID_PEDIDO_SITE').AsString;
            Result.CodIdCliente       := FieldByName('COD_ID_CLIENTE').AsInteger;
            Result.DatPedido          := FieldByName('DAT_PEDIDO').AsDateTime ;
            Result.DatInclusao        := FieldByName('DAT_INCLUSAO').AsDateTime;
            Result.NumEntregaValor    := FieldByName('NUM_ENTREGA_VALOR').AsFloat;
            Result.NumStatusPedido    := FieldByName('NUM_STATUS_PEDIDO').AsInteger;
        end;
    except
        Result.Free;
        raise;
    end;
end;

function TfrmTela_Principal.ChecarStatusDoPedido(Status: string): Integer;
begin
    if (Status = 'pending') or
    	(Status = 'on-hold')
    then
    	Result := 0
    else if Status = 'processing' then
    	Result := 1
    else if Status = 'completed' then
    	Result := 2
    else
    	raise Exception.Create('Status do pedido não reconhecido');
end;

function TfrmTela_Principal.RetornarItensDoPedidoDeVenda(
    Itens: TArray<TLineItem>;
    CodIdEmpresa: Integer;
	CodIdLoja: Integer;
    CodIdPedido: Int64
): TArray<TPedidoVendaItem>;
var
    PedidoVendaItem: TPedidoVendaItem;
    Produto: TProduto;
begin
    SetLength(Result, 0);

    try
    	for var Item in Itens do
        begin
            Produto := nil;

        	try
            	Produto := BuscarProdutoNoBanco(
                    CodIdEmpresa,
                    CodIdLoja,
                    Item.ProductId.ToString,
                    Item.Sku.ToInt64
                );

                if not Assigned(Produto) then
                    raise Exception.Create(
                        Format(
                            '%s não é um produto cadastrado no sistema',
                            [Item.Name]
                        )
                    );

                PedidoVendaItem                  := TPedidoVendaItem.Create;
                PedidoVendaItem.CodIdEmpresa     := CodIdEmpresa;
                PedidoVendaItem.CodIdLoja        := CodIdLoja;
                PedidoVendaItem.CodIdPedido      := CodIdPedido;
                PedidoVendaItem.CodIdProduto     := Produto.CodIdProduto;
                PedidoVendaItem.CodIdSite 		 := Item.Id.ToString;
                PedidoVendaItem.CodProduto       := Produto.CodProduto;
                PedidoVendaItem.DscCompleta      := Produto.DscCompleta;
                PedidoVendaItem.NumValorUnitario := Produto.NumPrecoVarejo;
                PedidoVendaItem.NumQuantidade    := Item.Quantity;

                SalvarConteudoEmArquivo(TPath.Combine(
                    TPath.GetDocumentsPath, 'itens-pedido.txt'),
                    TJson.ObjectToJsonString(PedidoVendaItem)
                );

                SetLength(Result, Length(Result) + 1);
                Result[High(Result)] := PedidoVendaItem;
            finally
                Produto.Free;
            end;
        end;
    except
    	for var I := 0 to High(Result) do
        begin
        	if Assigned(Result[I]) then
            	Result[I].Free;
        end;
        raise;
    end;
end;

function TfrmTela_Principal.BuscarProdutoNoBanco(
	CodIdEmpresa: Integer;
	CodIdLoja: Integer;
    CodIdSite: string;
	SKU: Int64
): TProduto;
var
    Query: TUniQuery;
begin
    Query := nil;
    Result := NIL;

    try
        Query := CriarQuery;

        with Query do
        begin
            SQL.Text :=
             'SELECT pd.COD_ID_PRODUTO, ' +
             '	pd.COD_ID_EMPRESA, ' +
             '	pd.COD_ID_LOJA,' +
             '	pd.COD_PRODUTO,' +
             '	pd.COD_ID_SITE,' +
             '	pd.COD_BARRAS, ' +
             '	pd.COD_ID_GRADE, ' +
             '	pd.COD_ID_SECAO, ' +
             '	pd.DSC_COMPLETA, ' +
             '	pd.NUM_TIPO_PRODUTO, ' +
             '	pr.NUM_PRECO_VAREJO AS PRECO_VAREJO, ' +
             '	CASE WHEN pd.NUM_CONTROLA_ESTOQUE = 1 THEN ' +
             '		CASE WHEN lj.NUM_TIPO_ESTABELECIMENTO = 0 THEN ' +
             '			CASE WHEN emp.NUM_CAD_FILIAIS_UNIFICADO = 1 THEN ' +
             '				COALESCE(pd.NUM_ESTOQUE_INICIAL, 0.000) + ' +
             '				   COALESCE(db_sgci.fn_consulta_estoque_atual(pd.COD_ID_EMPRESA, ' +
             '						pd.COD_ID_LOJA, pd.COD_ID_PRODUTO), 0.00) ' +
             '			ELSE ' +
             '				COALESCE(e.NUM_ESTOQUE_INICIAL, 0.000) + ' +
             				'COALESCE(db_sgci.fn_consulta_estoque_atual(pd.COD_ID_EMPRESA, ' +
             					'pd.COD_ID_LOJA, pd.COD_ID_PRODUTO), 0.00) ' +
             '			END + ' +
             '			COALESCE(db_sgci.fn_consulta_estoque_composicao(pd.COD_ID_EMPRESA, ' +
             '				pd.COD_ID_LOJA, pd.COD_ID_PRODUTO), 0.00) ' +
             '		ELSE ' +
             '			CASE WHEN emp.NUM_CAD_FILIAIS_UNIFICADO = 1 THEN ' +
             '				COALESCE(pd.NUM_ESTOQUE_INI_PED, 0.000) + ' +
             '				COALESCE(db_sgci.fn_consulta_estoque_pedido(pd.COD_ID_EMPRESA, ' +
             '					pd.COD_ID_LOJA, pd.COD_ID_PRODUTO), 0.00) ' +
             '			ELSE ' +
             '				COALESCE(e.NUM_ESTOQUE_INI_PED, 0.000) + ' +
             '				COALESCE(db_sgci.fn_consulta_estoque_pedido(pd.COD_ID_EMPRESA, ' +
             '					pd.COD_ID_LOJA, pd.COD_ID_PRODUTO), 0.00) ' +
             '			END + ' +
             '			COALESCE(db_sgci.fn_consulta_estoque_composicao(pd.COD_ID_EMPRESA, ' +
             '				pd.COD_ID_LOJA, pd.COD_ID_PRODUTO), 0.00) ' +
             '		END ' +
             '	ELSE ' +
             '		0.000 ' +
             '	END AS ESTOQUE_ATUAL ' +
             'FROM db_sgci.produtos pd ' +
             'INNER JOIN db_sgci.precos pr ' +
             '	ON pd.COD_ID_PRODUTO  = pr.COD_ID_PRODUTO ' +
             '	AND pd.COD_ID_EMPRESA = pr.COD_ID_EMPRESA ' +
             '	AND pd.COD_ID_LOJA    = pr.COD_ID_LOJA ' +
             'LEFT JOIN db_sgci.estoques e ' +
             '	ON pd.COD_ID_PRODUTO  = e.COD_ID_PRODUTO ' +
             '	AND pd.COD_ID_EMPRESA = e.COD_ID_EMPRESA ' +
             '	AND pd.COD_ID_LOJA    = e.COD_ID_LOJA ' +
             'INNER JOIN db_sgci.empresas emp ' +
             '	ON emp.COD_ID_EMPRESA = pd.COD_ID_EMPRESA ' +
             'INNER JOIN db_sgci.lojas lj ' +
             '	ON lj.COD_ID_EMPRESA  = pd.COD_ID_EMPRESA ' +
             '	AND lj.COD_ID_LOJA    = pd.COD_ID_LOJA ' +
             'WHERE pd.COD_ID_EMPRESA = :COD_ID_EMPRESA ' +
             '	AND pd.COD_ID_LOJA    = :COD_ID_LOJA ' +
             '	AND pd.COD_ID_SITE    = :COD_ID_SITE' +
             '	AND pd.COD_PRODUTO    = :COD_PRODUTO';

            ParamByName('COD_ID_EMPRESA').AsInteger := CodIdEmpresa;
            ParamByName('COD_ID_LOJA').AsInteger := CodIdLoja;
            ParamByName('COD_ID_SITE').AsString := CodIdSite;
            ParamByName('COD_PRODUTO').AsLargeInt := SKU;

            Open;

            Result := TProduto.Create;

            try
                Result.CodIdEmpresa   := FieldByName('COD_ID_EMPRESA').AsInteger;
                Result.CodIdLoja      := FieldByName('COD_ID_LOJA').AsInteger;
                Result.CodIdProduto   := FieldByName('COD_ID_PRODUTO').AsInteger;
                Result.CodIdSite      := FieldByName('COD_ID_SITE').AsString;
                Result.CodProduto     := FieldByName('COD_PRODUTO').AsLargeInt;
                Result.DscCompleta    := FieldByName('DSC_COMPLETA').AsString;
                Result.NumPrecoVarejo := FieldByName('PRECO_VAREJO').AsCurrency;
                Result.NumEstqAtual   := FieldByName('ESTOQUE_ATUAL').AsFloat;
            except
                Result.Free;
                raise;
            end;
        end;
    finally
        Query.Free;
    end;
end;

procedure TfrmTela_Principal.SalvarProdutosDoPedido(ProdutosPedido: TArray<TPedidoVendaItem>);
var
    Query: TuniQuery;
    Valores: string;
begin
    Query := nil;

    try
        Query := CriarQuery;
        Valores := '';

        with Query do
        begin
            for var I := 0 to High(ProdutosPedido) do
            begin
                if (I > 0) then
                	Valores := Valores + ',';

                Valores := Valores + Format(
                    '( ' +
                    ':COD_ID_EMPRESA_%d, ' +
                    ':COD_ID_LOJA_%d, ' +
                    ':COD_ID_SITE_%d, ' +
                    ':COD_ID_PEDIDO_%d, ' +
                    ':DAT_INCLUSAO_%d, ' +
                    ':COD_ID_PRODUTO_%d, ' +
                    ':COD_PRODUTO_%d, ' +
                    ':DSC_COMPLETA_%d, ' +
                    ':NUM_VALOR_UNITARIO_%d, ' +
                    ':NUM_QUANTIDADE_%d' +
                    ' )',
                	[I, I, I, I, I, I, I, I, I, I]
                );
            end;

            SQL.Text :=
            	'INSERT INTO db_sgci.pedido_venda_itens ' +
                '( ' +
                '	COD_ID_EMPRESA,' +
    			'	COD_ID_LOJA,' +
                '	COD_ID_SITE,' +
    			'	COD_ID_PEDIDO,' +
                '	DAT_INCLUSAO,' +
                '	COD_ID_PRODUTO, ' +
                '	COD_PRODUTO, ' +
                '	DSC_COMPLETA, ' +
                '	NUM_VALOR_UNITARIO, ' +
                '	NUM_QUANTIDADE ' +
                ') ' +
                'VALUES ' + Valores;

            if Length(ProdutosPedido) = 0 then
            	raise Exception.Create('Pedido sem produtos');

        	for var I := 0 to High(ProdutosPedido) do
    		begin
                ParamByName('COD_ID_EMPRESA_' + I.ToString).AsInteger
                	:= ProdutosPedido[I].CodIdEmpresa;
                ParamByName('COD_ID_LOJA_' + I.ToString).AsInteger
                	:= ProdutosPedido[I].CodIdLoja;
                ParamByName('COD_ID_SITE_' + I.ToString).AsString
                    := ProdutosPedido[I].CodIdSite;
                ParamByName('COD_ID_PEDIDO_' + I.ToString).AsLargeInt
                	:= ProdutosPedido[I].CodIdPedido;
                ParamByName('DAT_INCLUSAO_' + I.ToString).AsDateTime
                	:= ProdutosPedido[I].DatInclusao;
                ParamByName('COD_ID_PRODUTO_' + I.ToString).AsLargeInt
                	:= ProdutosPedido[I].CodIdProduto;
                ParamByName('COD_PRODUTO_' + I.ToString).AsLargeInt
                	:= ProdutosPedido[I].CodProduto;
                ParamByName('DSC_COMPLETA_' + I.ToString).AsString
                	:= ProdutosPedido[I].DscCompleta;
                ParamByName('NUM_VALOR_UNITARIO_' + I.ToString).AsCurrency
                	:= ProdutosPedido[I].NumValorUnitario;
                ParamByName('NUM_QUANTIDADE_' + I.ToString).AsFloat
                	:= ProdutosPedido[I].NumQuantidade;
    		end;

            ExecSQL;
        end;
    finally
        Query.Free;
    end;
end;

function TfrmTela_Principal.BuscarOuAssociarFinalizadora(
    PaymentMethod: string;
    PaymentMethodTitle: string;
    CodIdEmpresa: Integer;
    CodIdLoja: Integer;
    CodIdCliente: Integer
): TFinalizadora;
var
    Finalizadoras: TArray<TFinalizadora>;
    FinalizadoraID: Integer;
begin
    Result := nil;
    Finalizadoras := nil;

    try
        Result := BuscarFinalizadoraPorCodIdSite(
            CodIdEmpresa,
            CodIdLoja,
            PaymentMethod
        );

        if not Assigned(Result) then
        begin
        	Finalizadoras := BuscarFinalizadorasDoBanco(
            	CodIdEmpresa,
            	CodIdLoja
        	);

            Result := AssociarFinalizadora(
            	PaymentMethod,
            	PaymentMethodTitle,
        		Finalizadoras
        	);
        end;

        if not Assigned(Result) then
        begin
            raise Exception.Create('Erro na associaç~çao da finalizadora');
        end;
    except
        Result.Free;
        raise;
    end;
end;

function TfrmTela_Principal.BuscarFinalizadoraPorCodIdSite(
    CodIdEmpresa: Integer;
    CodIdLoja: Integer;
	CodIdSite: string
): TFinalizadora;
var
    Query: TUniQuery;
begin
    Query := nil;
    Result := nil;

    try
        try
            Query := CriarQuery;

            Query.SQL.Text :=
                'SELECT * FROM db_sgci.finalizadoras WHERE ' +
                '	COD_ID_EMPRESA     = :COD_ID_EMPRESA ' +
                '	AND COD_ID_LOJA    = :COD_ID_LOJA ' +
                '	AND COD_ID_SITE    = :COD_ID_SITE';
            Query.Open;

            if Query.IsEmpty then
            begin
                OutputDebugString(PChar('Forma de pagamento do ecommerce ainda não foi associada'));
                Exit;
            end;

            Result := SQLToFinalizadora(Query);
        except
            Result.Free;
            raise;
        end;
    finally
    	Query.Free;
    end;
end;

function TfrmTela_Principal.BuscarFinalizadorasDoBanco(
	CodIdEmpresa: Integer;
	CodIdLoja: Integer
): TArray<TFinalizadora>;
var
    Query: TUniQuery;
    Finalizadora: TFinalizadora;
begin
	Query := nil;
    SetLength(Result, 0);

    try
        Query := CriarQuery;

        with Query do
        begin
            try
            	SQL.Text :=
                	'SELECT * FROM db_sgci.finalizadoras ' +
            		'WHERE  COD_ID_EMPRESA = :COD_ID_EMPRESA ' +
            		'	AND COD_ID_LOJA    = :COD_ID_LOJA';

                ParamByName('COD_ID_EMPRESA').AsInteger := CodIdEmpresa;
                ParamByName('COD_ID_LOJA').AsInteger    := CodIdLoja;
                Open;

                if isEmpty then
                	raise Exception.Create('Nenhuma finalizadora encontrda no banco!');

                while not Eof do
                begin
                    Finalizadora := SQLToFinalizadora(Query);
                    SetLength(Result, Length(Result) + 1);
                    Result[High(Result)] := Finalizadora;
                    Next;
                end;
            except
            	for var I := 0 to High(Result) do
                begin
                	if Assigned(Result[I]) then
                    	Result[I].Free;
                end;
                raise;
            end;
        end;
    finally
        Query.Free;
    end;
end;

function TfrmTela_Principal.AssociarFinalizadora(
    DescricaoPagamento: string;
    DescricaoPagamentoDetalhada: string;
    Finalizadoras: TArray<TFinalizadora>
): TFinalizadora;
var
    DescricaoAbreviada: string;
begin
    Result := nil;

    ShowMessage(
        'Payment Method: ' + UpperCase(RemoverAcentos(DescricaoPagamento)) + sLineBreak +
        'Payment Method Title: ' + UpperCase(RemoverAcentos(DescricaoPagamentoDetalhada))
    );

    if UpperCase(RemoverAcentos(DescricaoPagamento)) = 'COD'then
    begin
       DescricaoAbreviada := 'DINHEIRO';
    end
    else if UpperCase(RemoverAcentos(DescricaoPagamentoDetalhada)) = 'PIX' then
    begin
        DescricaoAbreviada := 'PIX';
    end
    else if UpperCase(RemoverAcentos(DescricaoPagamentoDetalhada)).Contains('CARTAO') then
    begin
    	DescricaoAbreviada := 'CARTAO' ;
    end
    else if UpperCase(RemoverAcentos(DescricaoPagamentoDetalhada)).Contains('BOLETO') then
    begin
        DescricaoAbreviada := 'BOLETO' ;
    end
    else
    begin
       raise Exception.Create('Forma de pagamento não é suportada!');
    end;

    try
    	for var I := 0 to High(Finalizadoras) do
        begin
        	if DescricaoAbreviada = UpperCase(RemoverAcentos(Finalizadoras[I].DscAbreviada))
            then
            begin
            	if(UpperCase(RemoverAcentos(Finalizadoras[I].DscAbreviada)) = 'PIX') and
                	(UpperCase(RemoverAcentos(Finalizadoras[I].DscCompleta)) <> 'PIX')
                then
                    continue;
                Result := Finalizadoras[I];
                Result.CodIdSite := DescricaoPagamento;
                break;
            end;
        end;
    except
        Result.Free;
        raise;
    end;
end;

function TfrmTela_Principal.SQLToFinalizadora(Query: TUniQuery): TFinalizadora;
begin
    Result := nil;

    try
    	Result := TFinalizadora.Create;

        with Query do
        begin
        	Result.CodIdFinalizadora := FieldByName('COD_ID_FINALIZADORA').AsInteger;
            Result.CodIdSite         := FieldByName('COD_ID_SITE').AsString;
            Result.CodIdEmpresa      := FieldByName('COD_ID_EMPRESA').AsInteger;
            Result.CodIdLoja         := FieldByName('COD_ID_LOJA').AsInteger;
            Result.CodIdCliente      := FieldByName('COD_ID_CLIENTE').AsInteger;
            Result.DscCompleta       := FieldByName('DSC_COMPLETA').AsString;
            Result.DscAbreviada      := FieldByName('DSC_ABREVIADA').AsString;
            Result.NumEspecie        := FieldByName('NUM_ESPECIE').AsInteger;
            Result.NumModalidade     := FieldByName('NUM_MODALIDADE').AsInteger;
        end;
    except
        Result.Free;
        raise;
    end;
end;

function TfrmTela_Principal.InserirPagamentoNoBanco(
    CodIdEmpresa: Integer;
    CodIdLoja: Integer;
    CodIdPedido: Int64;
	CodIdFinalizadora: Integer;
    DataPagamento: TDateTime;
    ValorPedido: Double
): TPedidoVendaPgtos;
var
    Query: TUniQuery;
    PagamentoId: Int64;
begin
	Query := nil;
    Result := nil;

    try
        Query := CriarQuery;

        with Query do
        begin
            SQL.Text :=
            'INSERT INTO db_sgci.pedido_venda_pgtos (' +
            '	COD_ID_EMPRESA,' +
            '	COD_ID_LOJA,' +
            '	COD_ID_PEDIDO,' +
            '	COD_ID_FINALIZADORA,' +
            '	DAT_PAGAMENTO,' +
            '	NUM_VALOR_PAGO,' +
            '	NUM_VALOR_PARCELA,' +
            '	NUM_PARCELAS,' +
            '	NUM_STATUS' +
            ' ) ' +
            'VALUES (' +
            '	:COD_ID_EMPRESA,' +
            '	:COD_ID_LOJA,' +
            '	:COD_ID_PEDIDO,' +
            '	:COD_ID_FINALIZADORA,' +
            '	:DAT_PAGAMENTO,' +
            '	:NUM_VALOR_PAGO,' +
            '	:NUM_VALOR_PARCELA,' +
            '	:NUM_PARCELAS,' +
            '	:NUM_STATUS' +
            ' ) ' +
            'ON DUPLICATE KEY UPDATE' +
            '	COD_ID_PAGAMENTO = LAST_INSERT_ID(COD_ID_PAGAMENTO)';

            ParamByName('COD_ID_EMPRESA').AsInteger      := CodIdEmpresa;
            ParamByName('COD_ID_LOJA').AsInteger         := CodIdLoja;
            ParamByName('COD_ID_PEDIDO').AsLargeInt      := CodIdPedido;
            ParamByName('COD_ID_FINALIZADORA').AsInteger := CodIdFinalizadora;
            ParamByName('DAT_PAGAMENTO').AsDateTime      := DataPagamento;
            ParamByName('NUM_VALOR_PARCELA').AsFloat     := ValorPedido;
            ParamByName('NUM_VALOR_PAGO').AsFloat        := ValorPedido;
//          Valor DEFAULT
            ParamByName('NUM_PARCELAS').AsInteger := 1;

//          Status temporário - Deve ser definido de acordo com a situação
//			do pagamento do pedido (Pago / Não Pago)
            ParamByName('NUM_STATUS').AsInteger := 1;
            ExecSQL;

            SQL.Text := 'SELECT LAST_INSERT_ID() AS ID';
            Open;
            PagamentoId := Query.FieldByName('ID').AsLargeInt;
            Close;

            SQL.Text := 'SELECT * FROM db_sgci.pedido_venda_pgtos WHERE COD_ID_PAGAMENTO = :ID';
            Query.ParamByName('ID').AsLargeInt := PagamentoId;
            Query.Open;
            Result := SQLToPagamentoDaVenda(Query);
        end;
    except
        Result.Free;
        raise;
    end;
end;

function TfrmTela_Principal.SQLToPagamentoDaVenda(Query: TUniQuery): TPedidoVendaPgtos;
begin
	Result := nil;

    try
    	Result := TPedidoVendaPgtos.Create;

        with Query do
        begin
        	Result.CodIdPagamento    := FieldByName('COD_ID_PAGAMENTO').AsLargeInt;
        	Result.CodIdEmpresa      := FieldByName('COD_ID_EMPRESA').AsInteger;
            Result.CodIdLoja         := FieldByName('COD_ID_LOJA').AsInteger;
            Result.CodIdPedido       := FieldByName('COD_ID_PEDIDO').AsInteger;
            Result.CodIdFinalizadora := FieldByName('COD_ID_FINALIZADORA').AsInteger;
            Result.NumValorPago      := FieldByName('NUM_VALOR_PAGO').AsFloat;
            Result.DatPagamento      := FieldByName('DAT_PAGAMENTO').AsDateTime;
            Result.NumStatus         := FieldByName('NUM_STATUS').AsInteger;
        end;
    except
        Result.Free;
        raise;
    end;
end;

procedure TfrmTela_Principal.SalvarParcelasDoPagamento(
	PedidoVenda: TPedidoVenda;
	Pagamento: TPedidoVendaPgtos
);
var
    Query: TUniQuery;
    ParcelaID: Int64;
begin
	Query := nil;

    try
        Query := CriarQuery;

        with Query do
        begin
        	SQL.Text :=
            	'INSERT INTO db_sgci.pedido_venda_pgtos_parcelas (' +
                '	COD_ID_PARCELA,' +
                '	COD_ID_EMPRESA, ' +
                '	COD_ID_LOJA, ' +
                '	COD_ID_PEDIDO, ' +
                '	COD_ID_PAGAMENTO, ' +
                '	COD_ID_CLIENTE, ' +
                '	COD_ID_FINALIZADORA, ' +
                '	DAT_LANCAMENTO, ' +
                '	NUM_PARCELAS, ' +
                '	NUM_VALOR_PRINCIPAL,' +
                '	NUM_VALOR_PARCELA ' +
                ') VALUES (' +
                '	:COD_ID_PARCELA,' +
                '	:COD_ID_EMPRESA, ' +
                '	:COD_ID_LOJA, ' +
                '	:COD_ID_PEDIDO, ' +
                '	:COD_ID_PAGAMENTO, ' +
                '	:COD_ID_CLIENTE, ' +
                '	:COD_ID_FINALIZADORA, ' +
                '	:DAT_LANCAMENTO, ' +
                '	:NUM_PARCELAS, ' +
                '	:NUM_VALOR_PRINCIPAL,' +
                '	:NUM_VALOR_PARCELA ' +
                ')';

                ParcelaID := (DateTimeToUnix(Now, False) * 1000)
                	+ Random(1000);
                ParamByNAME('COD_ID_PARCELA').AsLargeInt     := ParcelaID;
                ParamByName('COD_ID_EMPRESA').AsInteger      := PedidoVenda.CodIdEmpresa;
                ParamByName('COD_ID_LOJA').AsInteger         := PedidoVenda.CodIdLoja;
                ParamByName('COD_ID_PEDIDO').AsLargeInt      := PedidoVenda.CodIdPedido;
                ParamByName('COD_ID_PAGAMENTO').AsLargeInt   := Pagamento.CodIdPagamento;
                ParamByName('COD_ID_CLIENTE').AsInteger      := PedidoVenda.CodIdCliente;
                ParamByName('COD_ID_FINALIZADORA').AsInteger := Pagamento.CodIdFinalizadora;
                ParamByName('DAT_LANCAMENTO').AsDateTime     := Pagamento.datPagamento;

				// Valor de teste. Esse valor vai variar de acordo com
				// as informações que vêm do ecommerce
                ParamByName('NUM_PARCELAS').AsInteger      := 1;
                ParamByName('NUM_VALOR_PRINCIPAL').AsFloat := Pagamento.NumValorPago;
                ParamByName('NUM_VALOR_PARCELA').AsFloat   := Pagamento.NumValorPago;

                ExecSQL;

                SQL.Text := 'SELECT * FROM db_sgci.pedido_venda_pgtos_parcelas WHERE COD_ID_PARCELA = :ID';
                ParamByName('ID').AsLargeInt := ParcelaID;
                Open;
                SaveToXML(TPath.Combine(FFolderPath, 'parcela.xml'));
        end;
    finally
    	Query.Free;
    end;
end;
// Fim das funções para salvar pedido

procedure TfrmTela_Principal.OnFormDestroy(Sender: TObject);
begin
	if THorse.IsRunning then
    	THorse.StopListen;
end;

end.

