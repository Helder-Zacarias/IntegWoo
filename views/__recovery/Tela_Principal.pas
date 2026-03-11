unit Tela_Principal;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.IOUtils, System.NetEncoding,
  System.Generics.Collections, System.JSON, System.IniFiles, System.Threading,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Data.DB, Uni, UniProvider, MySQLUniProvider, DBAccess, MemData, MemDS,
  REST.Json, Rest.Json.Types, RESTRequest4D,
  AppConfig, Tela_Envio_Produto, Tela_Cadastro_Atributo,
  FileWriter, TrimTexto, ContentPrinter, CustomObjectMapper,
  Produto, ProdutoGrade, ProdutoImagem, Secao, Variacao,
  WooProdutoRequest, WooProdutoResponse,
  WPImagemResponse, WooImagemRequest, WooImagemResponse,
  WooCreateCategoriaRequest, WooCategoriaRequest, WooCategoriaResponse, WooProdutoCategoriaRequest,
  WooAtributoRequest, WooAtributoResponse,
  WooTermoAtributoRequest, WooTermoResponse,
  WooVariacaoProdutoResponse, WooVariacaoProdutoRequest, WooAtributoDaVariacao,
  WooAtributoProduto, WooVariacaoProdutoBatchRequest;

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
    function EnviarProduto(Produto: TWooProdutoRequest): TWooProdutoResponse;
    function CriarCategoria(Secao: TSecao): TWooCategoriaResponse;
    function EnviarTermos(Atributos: TObjectList<TWooAtributoResponse>; ProdutosGrade: TObjectList<TProdutoGrade>)
    	: TObjectDictionary<Integer, TObjectList<TWooTermoResponse>>;
    function BuscarCategorias(Secao: TSecao): TWooCategoriaResponse;
    function BuscarAtributos: TObjectList<TWooAtributoResponse>;
    function BuscarSecaoNoBanco(CodIdEmpresa: Integer; CodIdSecao: Integer): TSecao;
    function CriarQuery: TUniQuery;
    function RetornarImagensRequest(CodIdProduto: Integer): TObjectList<TWooImagemRequest>;
    function ChecarERetornarJSONArray(JSONResponse: TJSONValue): TJSONArray;
    procedure FormCreate(Sender: TObject);
    function CriarAtributos: TObjectList<TWooAtributoResponse>;
    function BuscarTermosNaApi(AtributoID: Integer): TObjectList<TWooTermoResponse>;
    function GetVariacoesDoProduto(ProdutoID: Integer): TObjectList<TWooVariacaoProdutoResponse>;
    procedure CriarVariacoesDoProduto(ProdutoResponse: TWooProdutoResponse; ProdutosGrade: TObjectList<TProdutoGrade>);
    function BuscarProdutosGrade(CodIdEmpresa: Integer; CodIdLoja: Integer; CodIdProduto: Integer
    ): TObjectList<TProdutoGrade>;
    function PostarTermoNaAPI(AtributoId: Integer; Termo: TWooTermoAtributoRequest): TWooTermoResponse;
    function FiltrarTermosRepetidos(Variacoes: TList<string>): TList<string>;
    function GerarListasDeVariacoesDosProdutosGrade(Atributos: TObjectList<TWooAtributoResponse>;
    	ProdutosGrade: TObjectList<TProdutoGrade>): TObjectDictionary<Integer, TObjectList<TWooTermoResponse>>;
    function GerarListaDeStringsDosTermosDaAPI(TermosAPI: TObjectList<TWooTermoResponse>):
    	TList<string>;
    function GerarSKUVariacao(DscProduto: string; VariacaoUm: string; VariacaoDois: string): string;
    function CriarProdutoGrade(Query: TUniQuery): TProdutoGrade;
  private
    FSQLProdutosBase: string;
  	FSQLImagensBase: string;
    FCodIdProduto: Integer;
    FTabelasVariacao: TArray<string>;
    FFolderPath: string;
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
    FCodIdProduto := 4832698;
    FTabelasVariacao := ['db_sgci.grades_variacao_1', 'db_sgci.grades_variacao_2'];
    FFolderPath := TPath.Combine(TPath.GetDocumentsPath, 'Ecommerce');
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
        .Timeout(1360000)
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
                    raise Exception.Create('Nenhuma Resposta da API do WooComemrce!');

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

function TfrmTela_Principal.BuscarTermosNaApi(AtributoID: Integer): TObjectList<TWooTermoResponse>;
var
    JSONResposta: TJSONValue;
    ListaTermosAPI: TJSONArray;
begin
    Result := TObjectList<TWooTermoResponse>.Create(True);
	JSONResposta := nil;

    try
    	try
        	JSONResposta := ChamadaAPIWooCommerce(
                'products/attributes/'
                    + AtributoId.ToString
                    + '/terms?per_page=100',
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

function TfrmTela_Principal.PostarTermoNaAPI(AtributoId: Integer; Termo: TWooTermoAtributoRequest): TWooTermoResponse;
var
	JSONResposta: TJSONValue;
begin
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

function TfrmTela_Principal.FiltrarTermosRepetidos(
	Variacoes: TList<string>
): TList<string>;
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

function TfrmTela_Principal.GerarListaDeStringsDosTermosDaAPI(
	TermosAPI: TObjectList<TWooTermoResponse>
): TList<string>;
begin
    for var Termo in TermosAPI do
        Result.Add(Termo.Name);
end;

function TfrmTela_Principal.GerarListasDeVariacoesDosProdutosGrade(
	Atributos: TObjectList<TWooAtributoResponse>;
    ProdutosGrade: TObjectList<TProdutoGrade>
): TObjectDictionary<Integer, TObjectList<TWooTermoResponse>>;
var
    VariacoesUm: TList<string>;
    ListaVariacoesUm: TList<string>;
    ListaResponseUm: TObjectList<TWooTermoResponse>;
    Termos: TObjectDictionary<Integer, TObjectList<TWooTermoResponse>>;
begin
    Result := TObjectDictionary<Integer, TObjectList<TWooTermoResponse>>.Create([doOwnsValues]);
    Termos := TObjectDictionary<Integer, TObjectList<TWooTermoResponse>>.Create([doOwnsValues]);

    for var Atributo in Atributos do
    begin
        Termos.Add(
            Atributo.Id,
            BuscarTermosNaApi(Atributo.Id)
        );
    end;

    VariacoesUm := TList<string>.Create;

    for var Produto in ProdutosGrade do
    begin

        VariacoesUm.Add(Produto.VariacaoUm.DscVariacao);
        VariacoesDois.Add(Produto.VariacaoDois.DscVariacao);
    end;

    VariacoesUm := FiltrarTermosRepetidos(VariacoesUm);
    ListaVariacoesUm := GerarListaDeStringsDosTermosDaAPI(TermosUm);

    for var Variacao in VariacoesUm do
    begin
        var Termo := TWooTermoAtributoRequest.Create;
        Termo.Name:= Variacao;

        if not ListaVariacoesUm.Contains(Termo.Name) then
        	TermosUm.Add(PostarTermoNaAPI(Atributos[0].Id, Termo));
    end;

    Result.Add(Atributos[0].Id, TermosUm);
    Result.Add(Atributos[1].Id, TermosDois)
end;

function TfrmTela_Principal.GetVariacoesDoProduto(ProdutoID: Integer): TObjectList<TWooVariacaoProdutoResponse>;
var
    JSONResposta: TJSONValue;
    VariacoesProdutoArray: TJSONArray;
begin
    Result := nil;
    JSONResposta := nil;

    try
    	JSONResposta := ChamadaAPIWooCommerce(
            'products/' + ProdutoID.ToString + '/variations',
            'GET',
            'Variações do produto ' +  ProdutoID.ToString + ' retornadas com sucesso'
    	);

    	VariacoesProdutoArray := ChecarERetornarJSONArray(JSONResposta);
        Result := TObjectList<TWooVariacaoProdutoResponse>.Create(True);

        try
        	for var VariacaoResponse in VariacoesProdutoArray do
            	Result.Add(TJson.JsonToObject<TWooVariacaoProdutoResponse>(VariacaoResponse.ToJSON));
        except
           Result.Free;
           raise;
        end;
    finally
       JSONResposta.Free;
    end;
end;

function TfrmTela_Principal.GerarSKUVariacao(
    DscProduto: string;
    VariacaoUm: string;
    VariacaoDois: string
): string;
begin
	Result := SubstituirEspacosPorTraco(
        DscProduto + ' ' +
        VariacaoUm +  ' ' +
        VariacaoDois
    );
end;

procedure TfrmTela_Principal.CriarVariacoesDoProduto(
	ProdutoResponse: TWooProdutoResponse;
	ProdutosGrade: TObjectList<TProdutoGrade>
);
var
    VariacaoProdutoRequest: TWooVariacaoProdutoRequest;
    BatchRequest: TWooVariacaoProdutoBatchRequest;
    RespostaAPI: TJSONValue;
    NumeroVariacao: Integer;
begin
	BatchRequest := nil;
    RespostaAPI := nil;
    NumeroVariacao := 1;

    try
        BatchRequest := TWooVariacaoProdutoBatchRequest.Create;

        for var Variacao in ProdutosGrade do
        begin
        	VariacaoProdutoRequest := TWooVariacaoProdutoRequest.Create;
            VariacaoProdutoRequest.RegularPrice := FormatFloat('0.00', Variacao.NumPrecoUnitario, TFormatSettings.Invariant);
            VariacaoProdutoRequest.StockQuantity := Variacao.NumEstoque;
            VariacaoProdutoRequest.AdicionarAtributo(
                ProdutoResponse.Attributes[0].Id,
                Variacao.VariacaoUm.DscVariacao
            );

            VariacaoProdutoRequest.AdicionarAtributo(
                ProdutoResponse.Attributes[1].Id,
                Variacao.VariacaoDois.DscVariacao
            );

            VariacaoProdutoRequest.Sku := GerarSKUVariacao(
                ProdutoResponse.Name,
                Variacao.VariacaoUm.DscVariacao,
                Variacao.VariacaoDois.DscVariacao
            );

            BatchRequest.AdicionarVariacao(VariacaoProdutoRequest);
            VariacaoProdutoRequest := nil;
            Inc(NumeroVariacao);
        end;

        RespostaAPI := ChamadaAPIWooCommerce(
            'products/' + ProdutoResponse.Id.ToString + '/variations/batch',
            'POST',
            'Variações do produto ' + ProdutoResponse.Name + ' criadas com sucesso'
            ,
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

function TfrmTela_Principal.CriarProdutoGrade(Query: TUniQuery): TProdutoGrade;
begin
    with Query do
    begin
    	Result := TProdutoGrade.Create;
        Result.NumPrecoUnitario := FieldByName('NUM_PRECO_UNITARIO').AsCurrency;
        Result.NumEstoque := FieldByName('NUM_ESTOQUE').AsInteger;

        if (not FieldByName('COD_ID_VAR_1').isNull) then
        begin
        	Result.AdicionarVariacao(
                FieldByName('COD_ID_VAR_1').AsInteger,
                FieldByName('DSC_VARIACAO').AsString
            );
        end;

        if (not FieldByName('COD_ID_VAR_2').isNull) then
        begin
            Result.AdicionarVariacao(
                FieldByName('COD_ID_VAR_2').AsInteger,
                FieldByName('DSC_VARIACAO_1').AsString
            );
        end;
    end;
end;

function TfrmTela_Principal.BuscarProdutosGrade(
    CodIdEmpresa: Integer;
    CodIdLoja: Integer;
	CodIdProduto: Integer
): TObjectList<TProdutoGrade>;
var
	Query: TUniQuery;
    IdLoja: Integer;
    ProdutoGrade: TProdutoGrade;
    JSONArray: TJSONArray;
begin
    Query := CriarQuery;
    Result := nil;
    JSONArray := TJSONArray.Create;

    try
    	with Query do
    	begin
            SQL.Add('SELECT');
            SQL.Add('   PG.COD_ID_PRD_GRD,');
            SQL.Add('   PG.COD_ID_EMPRESA,');
            SQL.Add('   PG.COD_ID_PRODUTO,');
            SQL.Add('   PG.COD_PRODUTO,');
            SQL.Add('   PG.COD_EAN_GTIN,');
            SQL.Add('   PG.COD_ID_VAR_1,');
            SQL.Add('   PG.COD_ID_VAR_2,');
            SQL.Add('   V1.DSC_VARIACAO,');
            SQL.Add('   V2.DSC_VARIACAO,');
            SQL.Add('   TRIM(CONCAT(P.DSC_COMPLETA, '' '', COALESCE(V1.DSC_VARIACAO,  ''''), '' '', COALESCE(V2.DSC_SIGLA, ''''))) AS DSC_PRODUTO,');
            SQL.Add('   COALESCE(PG.NUM_PRECO_UNITARIO, S.NUM_PRECO_VAREJO) AS NUM_PRECO_UNITARIO,');
            SQL.Add('   PG.NUM_ESTOQUE_INICIAL + SUM(COALESCE(E.NUM_QUANTIDADE, 0)) AS NUM_ESTOQUE');
            SQL.Add('FROM');
            SQL.Add('   db_sgci.produtos_grades PG');
            SQL.Add('LEFT JOIN db_sgci.produtos P ON');
            SQL.Add('   P.COD_ID_PRODUTO = PG.COD_ID_PRODUTO');
            SQL.Add('LEFT JOIN db_sgci.precos S ON');
            SQL.Add('   S.COD_ID_EMPRESA = P.COD_ID_EMPRESA AND');
            SQL.Add('   S.COD_ID_LOJA    = :COD_ID_LOJA AND');
            SQL.Add('   S.COD_ID_PRODUTO = P.COD_ID_PRODUTO');
            SQL.Add('INNER JOIN db_sgci.grades_variacao_1 V1 ON');
            SQL.Add('   V1.COD_ID_VARIACAO = PG.COD_ID_VAR_1 AND');
            SQL.Add('   V1.NUM_STATUS      = 1');
            SQL.Add('INNER JOIN db_sgci.grades_variacao_2 V2 ON');
            SQL.Add('   V2.COD_ID_VARIACAO = PG.COD_ID_VAR_2 AND');
            SQL.Add('   V2.NUM_STATUS      = 1');
            SQL.Add('LEFT JOIN db_sgci.estoques_grades E ON');
            SQL.Add('   E.COD_ID_PRD_GRD        = PG.COD_ID_PRD_GRD AND');
            SQL.Add('   COALESCE(E.NUM_INDC, 0) = 0');
            SQL.Add('WHERE');
            SQL.Add('   PG.COD_ID_EMPRESA = :COD_ID_EMPRESA AND');
            SQL.Add('   PG.COD_ID_PRODUTO = :COD_ID_PRODUTO');
            SQL.Add('GROUP BY');
            SQL.Add('   PG.COD_ID_PRD_GRD');
            SQL.Add('ORDER BY');
            SQL.Add('   V1.DSC_VARIACAO DESC,');
            SQL.Add('   V2.DSC_VARIACAO DESC');

            ParamByName('COD_ID_LOJA').AsInteger := CodIdLoja;
            ParamByName('COD_ID_EMPRESA').AsInteger := CodIdEmpresa;
            ParamByName('COD_ID_PRODUTO').AsInteger := CodIdProduto;
            Open;

            SaveToXML(TPath.Combine(FFolderPath, 'variacoes-preco-unitario.xml'));

            Result := TObjectList<TProdutoGrade>.Create(True);

            try
            	while not Eof do
            	begin
                    Result.Add(CriarProdutoGrade(Query));
                    JSONArray.AddElement(TJson.ObjectToJsonObject(ProdutoGrade));
                    Next;
            	end;

                SalvarConteudoEmArquivo(FFolderPath + 'array-produtos-grade.txt', JSONArray.ToString);

            except
                Result.Free;
                raise;
            end;
    	end;
    finally
     	JSONArray.Free;
        Query.Free;
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

        if SelectSecaoQuery.IsEmpty then
        	raise Exception.Create('Seção não encontrda no banco!');

        Result := TSecao.Create;
        Result.CodIdSecao := SelectSecaoQuery.FieldByName('COD_ID_SECAO').AsInteger;
        Result.DscSecao := SelectSecaoQuery.FieldByName('DSC_SECAO').AsString;
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
	Result := nil;
    JSONResposta := nil;
    Categoria := Secao.DscSecao;

    try
        JSONResposta := ChamadaAPIWooCommerce(
            'products/categories?search=' + TNetEncoding.URL.Encode(Categoria),
            'GET',
            'Categorias retornadas com sucesso!'
        );

    	CategoriasJSONArray := ChecarERetornarJSONArray(JSONResposta);

        if (CategoriasJSONArray = nil) or (CategoriasJSONArray.Count = 0) then
            Exit(CriarCategoria(Secao)) ;

        for var CategoriaJSON in CategoriasJSONArray do
        begin
            CategoriaRetornada := CategoriaJSON.GetValue<string>('name');

            if RemoverEspacos(Categoria) = RemoverEspacos(CategoriaRetornada) then
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
    Result := nil;
    JSONResposta := nil;
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
       raise;
    end;
end;

function TfrmTela_Principal.RetornarImagensRequest(CodIdProduto: Integer): TObjectList<TWooImagemRequest>;
var
	ListaImagens: TObjectList<TProdutoImagem>;
    ListaImagensResponse: TObjectList<TWPImagemResponse>;
    ListaImagensRequest: TObjectList<TWooImagemRequest>;
    CodIdEmpresa: Integer;
    ProdutoImagem: TProdutoImagem;
begin
    Result := nil;
    ListaImagens := nil;

	sqlImagens.Close;
    sqlImagens.SQL.Text := FSQLImagensBase;

    if sqlImagens.SQL.Text.Contains(':COD_ID_PRODUTO') = False then
    	sqlImagens.SQL.Add('AND COD_ID_PRODUTO = :COD_ID_PRODUTO');

    sqlImagens.ParamByName('COD_ID_PRODUTO').AsInteger := CodIdProduto;
    sqlImagens.Open;

    try
        ListaImagens := TObjectList<TProdutoImagem>.Create(True);

    	while not sqlImagens.Eof do
    	begin
        	if not Assigned(sqlImagens.FieldByName('URL_IMAGEM')) or (sqlImagens.FieldByName('URL_IMAGEM').IsNull) then
            begin
            	sqlImagens.Next;
                continue;
            end;

            ProdutoImagem := ProdutoImagemQueryToProdutoImagem(sqlImagens);
            ListaImagens.Add(ProdutoImagem);
            sqlImagens.Next;
        end;

        ListaImagensResponse := nil;

        try
        	ListaImagensResponse := EnviarImagem(ListaImagens);
        	ListaImagensRequest := TObjectList<TWooImagemRequest>.Create(True);

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

function TfrmTela_Principal.EnviarProduto(Produto: TWooProdutoRequest): TWooProdutoResponse;
var
    JSONString: string;
    JSONResposta: TJSONValue;
begin
	JSONResposta := nil;
    Result := nil;

    try
        try
        	JSONString := TJSON.ObjectToJsonString(Produto);

            JSONResposta := ChamadaAPIWooCommerce(
                'products',
                'POST',
                'Produto cadastrado com sucesso',
                JSONString
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
        	raise Exception.Create('Nenhum produto retornado pelo banco!');

        ProdutoDB := nil;
        WooProdutoRequest := nil;
    	Atributos := nil;
        CategoriaResponse := nil;
        ListaImagensRequest := nil;
        Secao := nil;
        TermosProduto := nil;
        WooProdutoResponse := nil;

        try
        	ProdutoDB := ProdutoQueryToProduto(sqlProdutos);

            if FieldByName('NUM_TIPO_PRODUTO').AsInteger <> 5 then
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

        	SalvarConteudoEmArquivo(
                TPath.Combine(TPath.GetDocumentsPath, 'produto-request-object.txt.'),
                TJson.ObjectToJsonString(WooProdutoRequest)
            );

        	WooProdutoResponse := EnviarProduto(WooProdutoRequest);

            if WooProdutoResponse.PType = 'variable' then
            	CriarVariacoesDoProduto(
                    WooProdutoResponse,
                    ProdutosGrade
                );
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

procedure TfrmTela_Principal.DatabaseConnectionLost(Sender: TObject; Component: TComponent;
  ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
begin
	RetryMode := rmReconnectExecute;
end;

end.
