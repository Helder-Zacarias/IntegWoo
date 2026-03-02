unit Tela_Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Uni, UniProvider,
  MySQLUniProvider, DBAccess, MemData, MemDS, Vcl.StdCtrls, Vcl.Buttons, System.IOUtils, REST.Json, Rest.Json.Types, WooProdutoResponse,
  System.Generics.Collections, System.JSON, WPImagemResponse, WooImagemRequest, WooProdutoRequest, System.IniFiles, AppConfig, Produto,
  Vcl.ExtCtrls, Tela_Envio_Produto, WooCategoriaRequest, Tela_Cadastro_Atributo, WooAtributoRequest, WooTermoAtributoRequest,
  WooAtributoResponse, CustomObjectMapper, FileWriter, WooCreateCategoriaRequest, RESTRequest4D, WooCategoriaResponse, Secao,
  WooProdutoCategoriaRequest, TrimTexto, ContentPrinter, ProdutoGrade, WooImagemResponse, ProdutoImagem, System.Threading,
  Variacao, WooAtributosProdutoRequest;

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
    function WooCommerceAPICall(Resource: string; Method: string;
    	MensagemAposRetorno: string = ''; Body: string = ''): TJSONValue;
    function DownloadImage(ImageUrl: string = ''): TMemoryStream;
	function EnviarImagem(ListaImagens: TObjectList<TProdutoImagem>): TObjectList<TWPImagemResponse>;
    procedure EnviarProduto(Produto: TWooProdutoRequest);
    function CriarCategoria(Secao: TSecao): TWooCategoriaResponse;
    function EnviarAtributos: TObjectList<TWooAtributoResponse>;
    procedure CriarTermosDoBanco(Table: string; AtributoId: Integer);
    function VerificarExistenciaDaCategoria(Categoria: string): TWooCategoriaResponse;
    function BuscarAtributos: TObjectList<TWooAtributoResponse>;
    function BuscarSecaoNoBanco(CodIdEmpresa: Integer; CodIdSecao: Integer): TSecao;
    function BuscarImagemProdutoNoBanco(CodIdEmpresa: Integer; CodIdProduto: Integer): TObjectList<TProdutoImagem>;
    function CriarQuery: TUniQuery;
    function RetornarImagensRequest(CodIdProduto: Integer): TObjectList<TWooImagemRequest>;
    function ChecarERetornarJSONArray(JSONResponse: TJSONValue): TJSONArray;
    procedure FormCreate(Sender: TObject);
  private
    FSQLProdutosBase: string;
  	FSQLImagensBase: string;
    FCodIdProduto: Integer;
    function BuscarTermosProduto(CodIdEmpresa: Integer; CodIdGrade: Integer;
  CodIdProduto: Integer; Atributos: TObjectList<TWooAtributoResponse>): TDictionary<Integer, TArray<string>>;

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

function TfrmTela_Principal.ChecarERetornarJSONArray(JSONResponse: TJSONValue): TJSONArray;
begin
	if not (JSONResponse is TJSONArray) then
    	Exit;

    Result := JSONResponse as TJSONArray;
end;

procedure TfrmTela_Principal.FormCreate(Sender: TObject);
begin
	FSQLProdutosBase := sqlProdutos.SQL.Text;
    FSQLImagensBase := sqlImagens.SQL.Text;
    FCodIdProduto := 4832699;
end;

function TfrmTela_Principal.CriarQuery: TUniQuery;
begin
    Result := TUniQuery.Create(nil);
    Result.Connection := Database;
end;

procedure TfrmTela_Principal.btnHamburguerClick(Sender: TObject);
begin
    panelSide.Visible := not panelSide.Visible;
    btnHamburguer.BringToFront;
end;

function TfrmTela_Principal.WooCommerceAPICall(
    Resource: string;
    Method:string;
    MensagemAposRetorno: string = '';
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

     if (not Assigned(Response)) then
     	Exit;

    if Response.StatusCode in [200, 201] then
    begin
    	if (not MensagemAposRetorno.IsEmpty) then
        	ShowMessage(MensagemAposRetorno);
    end
    else
        raise(Exception.Create('Requisição falhou. ' + Response.StatusCode.ToString + ': ' + Response.Content));

    Result := TJSONObject.ParseJSONValue(Response.Content);
end;

procedure TfrmTela_Principal.butBuscarProdutosClick(Sender: TObject);

begin
    TTask.Run(
        procedure
        var
            JSONResponse: TJSONValue;
        begin
        	JSONResponse := nil;

            try
    			JSONResponse := WooCommerceAPICall('products', 'GET');

                WriteContentToFile(TPath.Combine(TPath.GetDocumentsPath, 'produtos.txt'), JSONResponse.ToJSON);

                TThread.Queue(
                    nil,
                    procedure
                    begin
                        ShowMessage('Produtos retornados com sucesso!');
                    end
                );
    		finally
         		JSONResponse.Free;
    		end;
        end
    );
end;

function TfrmTela_Principal.BuscarTermosProduto(CodIdEmpresa: Integer; CodIdGrade: Integer;
  CodIdProduto: Integer; Atributos: TObjectList<TWooAtributoResponse>): TDictionary<Integer, TArray<string>>;
var
    SelectGradesQuery: TUniQuery;
    TabelasVariacao: TArray<string>;
    Indice: Integer;
    GV: string;
    ListaTermos: TList<string>;
begin
    Result := TDictionary<Integer, TArray<string>>.Create;
    SelectGradesQuery := CriarQuery;

    SetLength(TabelasVariacao, 2);
    TabelasVariacao[0] := 'db_sgci.grades_variacao_1';
    TabelasVariacao[1] := 'db_sgci.grades_variacao_2';

    try
        for Indice := 0 to High(TabelasVariacao) do
        begin
            GV := TabelasVariacao[Indice];
        	SelectGradesQuery.SQL.Text := 'SELECT DISTINCT ' + GV + '.DSC_VARIACAO ' + sLineBreak +
            	'FROM db_sgci.produtos_grades pg ' + sLineBreak +
                'JOIN ' + GV + ' ON pg.COD_ID_GRADE = ' + GV + '.COD_ID_GRADE ' + sLineBreak +
                'WHERE pg.COD_ID_EMPRESA = :COD_ID_EMPRESA AND ' + sLineBreak +
                'pg.COD_ID_GRADE = :COD_ID_GRADE AND ' + sLineBreak + 'pg.COD_ID_PRODUTO = :COD_ID_PRODUTO';
            SelectGradesQuery.ParamByName('COD_ID_EMPRESA').AsInteger := CodIdEmpresa;
            SelectGradesQuery.ParamByName('COD_ID_GRADE').AsInteger := CodIdGrade;
            SelectGradesQuery.ParamByName('COD_ID_PRODUTO').AsInteger := CodIdProduto;
            SelectGradesQuery.Open;

            ListaTermos := TList<string>.Create;

            try
            	while not SelectGradesQuery.Eof do
            	begin
                    ListaTermos.Add(SelectGradesQuery.FieldByName('DSC_VARIACAO').AsString);
                    SelectGradesQuery.Next;
            	end;

                Result.Add(Atributos[Indice].Id, ListaTermos.ToArray);

            	SelectGradesQuery.SaveToXML(TPath.Combine(TPath.GetDocumentsPath, 'variacao1.xml'));

            	SelectGradesQuery.Close;
            finally
            	ListaTermos.Free;
            end;
        end;
    finally
        SelectGradesQuery.Free;
    end;
end;

function TfrmTela_Principal.BuscarAtributos: TObjectList<TWooAtributoResponse>;
var
    JSONResponse: TJSONValue;
    JSONArray: TJSONArray;
begin
	Result := nil;
    JSONResponse := nil;

     try
        JSONResponse := WooCommerceAPICall('products/attributes', 'GET', 'Atributos retornados com sucesso');
        JSONArray := ChecarERetornarJSONArray(JSONResponse);

    	WriteContentToFile(TPath.Combine(TPath.GetDocumentsPath, 'busca-atributos.txt'), JSONArray.ToString);

     	Result := TObjectList<TWooAtributoResponse>.Create(True);

     	for var Response in JSONArray do
            Result.Add(TJson.JsonToObject<TWooAtributoResponse>(Response.ToString));
     finally
        JsonResponse.Free;
     end;
end;

function TfrmTela_Principal.EnviarAtributos: TObjectList<TWooAtributoResponse>;
var
    JSONResponse: TJSONValue;
    Atributos: TArray<TWooAtributoRequest>;
    Payload: string;
    AtributoResponse: TWooAtributoResponse;
    Count: Integer;
begin
	Result := BuscarAtributos;

    if (not Assigned(Result)) or (Result.IsEmpty) then
    begin
    	SetLength(Atributos, 2);

        Atributos[0] := TWooAtributoRequest.Create;
        Atributos[0].Name := 'Grade 1';

        Atributos[1] := TWooAtributoRequest.Create;
        Atributos[1].Name := 'Grade 2';

        ShowMessage('Tamanho de atributos array: ' + Length(Atributos).ToString);

        Count := 1;

        JSONResponse := nil;

        try
            Result := TObjectList<TWooAtributoResponse>.Create;

        	for var Atributo in Atributos do
            begin
            	Payload := TJson.ObjectToJsonString(Atributo);
                ShowMessage('Atributo: ' + Payload);
                JSONResponse := WooCommerceAPICall('products/attributes', 'POST', 'Atributo criado com sucesso', Payload);

                try
                	AtributoResponse := TJson.JsonToObject<TWooAtributoResponse>(JSONResponse.ToString);
                    Result.Add(AtributoResponse);
                    CriarTermosDoBanco('db_sgci.grades_variacao_' + Count.ToString, AtributoResponse.Id);
                    Inc(Count);
                finally
                	JSONResponse.Free;
            	end;
    		end;
        finally
        	for var Atributo in Atributos do
            	Atributo.Free;
        end;
    end
    else
        ShowMessage('Atributos já existem no WooCommerce!');
    ShowMessage('Tamanho atributos response: ' + Result.Count.ToString);
end;

procedure TfrmTela_Principal.CriarTermosDoBanco(Table: string; AtributoId: Integer);
var
	SelectVariacaoQuery: TUniQuery;
    SQLText: string;
    JSONResponse: TJSONValue;
    Termo: TWooTermoAtributoRequest;
    Count: Integer;
begin
    SQLText := 'SELECT DISTINCT DSC_VARIACAO FROM ' + Table;
    SelectVariacaoQuery := CriarQuery;
    Count := 1;

    try
        SelectVariacaoQuery.SQL.Text := SQLText;
        SelectVariacaoQuery.Open;
        SelectVariacaoQuery.SaveToXML('C:\Users\HELDER\Desktop\RESPONSE-DELPHI\' + Table + '_descricao.xml');

        while (not SelectVariacaoQuery.Eof) and (Count <= 5) do
        begin
            try
                Termo := TWooTermoAtributoRequest.Create;
            	Termo.Name := SelectVariacaoQuery.FieldByName('DSC_VARIACAO').AsString;

                JSONResponse := WooCommerceAPICall(
                    '/products/attributes/' + AtributoId.ToString + '/terms',
                    'POST',
                    'Termo criado com sucesso!',
                    TJson.ObjectToJsonString(Termo)
                );

                SelectVariacaoQuery.Next;
                Inc(Count);
            finally
                JSONResponse.Free;
                Termo.Free;
            end;
        end;
    finally
    	SelectVariacaoQuery.Free;
    end;
end;

function TfrmTela_Principal.BuscarSecaoNoBanco(CodIdEmpresa: Integer; CodIdSecao: Integer) : TSecao;
var
    SelectSecaoQuery: TUniQuery;
begin
	SelectSecaoQuery := CriarQuery;
    Result := TSecao.Create;

    try
    	SelectSecaoQuery.SQL.Text := 'SELECT * FROM db_sgci.secoes ' +sLineBreak +
        	'WHERE COD_ID_EMPRESA = :COD_ID_EMPRESA AND COD_ID_SECAO = :COD_ID_SECAO LIMIT 10';
        SelectSecaoQuery.ParamByName('COD_ID_EMPRESA').AsInteger := CodIdEmpresa;
        SelectSecaoQuery.ParamByName('COD_ID_SECAO').AsInteger := CodIdSecao;
    	SelectSecaoQuery.Open;

        if not SelectSecaoQuery.Eof then
        begin
            Result.CodIdSecao := SelectSecaoQuery.FieldByName('COD_ID_SECAO').AsInteger;
            Result.DscSecao := SelectSecaoQuery.FieldByName('DSC_SECAO').AsString;
        end;
    finally
       SelectSecaoQuery.Free;
    end;
end;

function TfrmTela_Principal.VerificarExistenciaDaCategoria(Categoria: string): TWooCategoriaResponse;
var
	JSONResponse: TJSONValue;
    CategoriasJSONArray: TJSONArray;
    CategoriaRetornada: string;
begin
	Result := nil;
    JSONResponse := nil;

    try
        JSONResponse := WooCommerceAPICall('products/categories', 'GET', 'Categorias retornadas com sucesso!');
    	CategoriasJSONArray := ChecarERetornarJSONArray(JSONResponse);

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
        JSONResponse.Free;
    end;

end;

function TfrmTela_Principal.CriarCategoria(Secao: TSecao): TWooCategoriaResponse;
var
    RequestPayload: string;
    JSONResponse: TJSONValue;
    CategoriaRequest: TWooCategoriaRequest;
begin
    Result := nil;
    CategoriaRequest := TWooCategoriaRequest.Create;

    try
        CategoriaRequest.Name := Secao.DscSecao;
    	RequestPayload := TJson.ObjectToJsonString(CategoriaRequest);
        JSONResponse := WooCommerceAPICall('products/categories', 'POST', 'Categoria criada com sucesso!', RequestPayload);

        try
    		Result := TJson.JsonToObject<TWooCategoriaResponse>(JSONResponse.ToJSON);
        finally
            JSONResponse.Free;
        end;

    finally
        CategoriaRequest.Free;
    end;
end;

function TfrmTela_Principal.BuscarImagemProdutoNoBanco(CodIdEmpresa: Integer; CodIdProduto: Integer): TObjectList<TProdutoImagem>;
var
    Query: TUniQuery;
    Count: Integer;
    ListaImagens: TObjectList<TProdutoImagem>;
    ProdutoImagem: TProdutoImagem;
begin
    Query := CriarQuery;
    ListaImagens := TObjectList<TProdutoImagem>.Create(True);

    try
        try
        	Query.SQL.Text := 'SELECT pi.COD_ID_IMAGEM, pi.COD_ID_EMPRESA, pi.COD_ID_PRODUTO, pi.URL_IMAGEM ' + sLineBreak +
                'FROM db_sgci.produtos_imagens pi ' + sLineBreak +
                'WHERE COD_ID_EMPRESA = :COD_ID_EMPRESA AND ' + sLineBreak +
                'COD_ID_PRODUTO = :COD_ID_PRODUTO';

            Query.ParamByName('COD_ID_EMPRESA').AsInteger := CodIdEmpresa;
            Query.ParamByName('COD_ID_PRODUTO').AsInteger := CodIdProduto;
            Query.SaveToXML('C:\Users\HELDER\Desktop\RESPONSE-DELPHI\unico-produto-imagem.xml');
            Query.Open;

            while not Query.Eof do
            begin
                ProdutoImagem := ProdutoImagemQueryToProdutoImagem(Query);
                ListaImagens.Add(ProdutoImagem);
                Query.Next;
            end;

        	Result := ListaImagens;
        except
            ListaImagens.Free;
            raise;
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
    Response := TRequest.New.BaseURL(ImageUrl).Accept('*/*').Get;

    if Response.StatusCode <> 200 then
      raise Exception.Create('Erro ao baixar imagem: ' + Response.StatusText);

    Result.LoadFromStream(Response.ContentStream);
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

        	for var ImagemResponse in ListaImagensResponse do
                ListaImagensRequest.Add(WPImagemResponseToWooImagemRequest(ImagemResponse));
            Result := ListaImagensRequest;
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
                raise(Exception.Create('Upload de imagem falhou!'));

            ImagemResponse := TJson.JsonToObject<TWPImagemResponse>(iRes.Content);
            Result.Add(ImagemResponse);
            ShowMessage('Upload de imagem bem sucedido');
        finally
        	Stream.Free;
    	end;
    end;
end;

procedure TfrmTela_Principal.EnviarProduto(Produto: TWooProdutoRequest);
var
    JSONString: string;
    JSONResponse: TJSONValue;
begin
    JSONString := TJSON.ObjectToJsonString(Produto);

    try
    	JSONResponse := WooCommerceAPICall('products', 'POST', 'Produto cadastrado com sucesso', JSONString);
    	WriteContentToFile('C:\Users\HELDER\Desktop\RESPONSE-DELPHI\WOOCOMMERCE-PAYLOADS\PRODUTO-JSON.TXT ', JSONResponse.ToJSON);
    finally
       JSONResponse.Free;
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
    TermosAtributo: TArray<string>;
    TermosProduto: TDictionary<Integer, TArray<string>>;
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

        try
           if FieldByName('COD_ID_GRADE').IsNull then
                TipoProduto := 'simple'
            else
            begin
                TipoProduto := 'variable';
                Atributos := EnviarAtributos;
            end;

            ProdutoDB := ProdutoQueryToProduto(sqlProdutos);
            ListaImagensRequest := RetornarImagensRequest(ProdutoDB.CodIdProduto);
            TermosProduto := BuscarTermosProduto(ProdutoDB.CodIdEmpresa, ProdutoDb.CodIdGrade, ProdutoDB.CodIdProduto, Atributos);
            Secao := BuscarSecaoNoBanco(ProdutoDB.CodIdEmpresa, ProdutoDB.CodIdSecao);
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
        end;
	end;
end;

procedure TfrmTela_Principal.DatabaseConnectionLost(Sender: TObject; Component: TComponent;
  ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
begin
	RetryMode := rmReconnectExecute;
end;

end.
