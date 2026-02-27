unit Tela_Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Uni, UniProvider,
  MySQLUniProvider, DBAccess, MemData, MemDS, Vcl.StdCtrls, Vcl.Buttons, System.IOUtils, REST.Json, Rest.Json.Types, WooProdutoResponse,
  System.Generics.Collections, System.JSON, WPImagemResponse, WooImagemRequest, WooProdutoRequest, System.IniFiles, AppConfig, Produto,
  Vcl.ExtCtrls, Tela_Envio_Produto, WooCategoriaRequest, Tela_Cadastro_Atributo, WooAtributoRequest, WooTermoAtributoRequest,
  WooAtributoResponse, CustomObjectMapper, FileWriter, WooCreateCategoriaRequest, RESTRequest4D, WooCategoriaResponse, Secao,
  WooProdutoCategoriaRequest, TrimTexto, ContentPrinter, ProdutoGrade, WooImagemResponse, ProdutoImagem;

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
    procedure btnEnviarProdutosMandalaClick(Sender: TObject);
    function WooCommerceAPICall(Resource: string; Method: string; MensagemAposRetorno: string; Body: string = ''): TJSONValue;
    function DownloadImage(ImageUrl: string = ''): TMemoryStream;
	function EnviarImagem(ListaImagens: TObjectList<TProdutoImagem>): TObjectList<TWPImagemResponse>;
    procedure EnviarProduto(Produto: TWooProdutoRequest);
    function CriarCategoria(Secao: TSecao): TWooCategoriaResponse;
    function CriarAtributos: TObjectList<TWooAtributoResponse>;
    procedure CriarTermosDoBanco(Table: string; AtributoId: Integer);
    procedure CriarTermosDoAtributo(Termos: TArray<string>; IdAtributo: Integer);
    function VerificarExistenciaDaCategoria(Categoria: string): TWooCategoriaResponse;
    function BuscarAtributos: TObjectList<TWooAtributoResponse>;
    function BuscarSecaoNoBanco(CodIdEmpresa: Integer; CodIdSecao: Integer): TSecao;
    function BuscarImagemProdutoNoBanco(CodIdEmpresa: Integer; CodIdProduto: Integer): TObjectList<TProdutoImagem>;
    function CriarQuery: TUniQuery;
    function RetornarImagensRequest(CodIdProduto: Integer): TObjectList<TWooImagemRequest>;
    procedure FormCreate(Sender: TObject);
  private
    FSQLProdutosBase: string;
  	FSQLImagensBase: string;
    FCodIdProduto: Integer;
    function BuscarGradesNoBanco(CodIdEmpresa, CodIdGrade,
      CodIdProduto: Integer): TProdutoGrade;

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

procedure TfrmTela_Principal.butBuscarProdutosClick(Sender: TObject);
var
    JSONResponse: TJSONValue;
begin
    JSONResponse := WooCommerceAPICall('products', 'GET', 'Produtos retornados com sucesso!');
    WriteContentToFile('C:\Users\HELDER\Desktop\RESPONSE-DELPHI\produtos.txt', JSONResponse.ToJSON);
end;

function TfrmTela_Principal.BuscarGradesNoBanco(CodIdEmpresa, CodIdGrade,
  CodIdProduto: Integer): TProdutoGrade;
var
    SelectGradesQuery: TUniQuery;
begin
    SelectGradesQuery := CriarQuery;

    try
        SelectGradesQuery.SQL.Text := 'SELECT g.DSC_GRADE, gv1.DSC_VARIACAO, gv2.DSC_VARIACAO' + sLineBreak +
        	'FROM db_sgci.produtos_grades pg ' + sLineBreak +
            'JOIN db_sgci.grades g ' + sLineBreak +
            'ON pg.COD_ID_GRADE = g.COD_ID_GRADE ' + sLineBreak +
            'JOIN db_sgci.grades_variacao_1 gv1 ' + sLineBreak +
            'ON pg.COD_ID_GRADE = gv1.COD_ID_GRADE ' + sLineBreak +
            'JOIN db_sgci.grades_variacao_2 gv2 ' + sLineBreak +
            'ON pg.COD_ID_GRADE = gv2.COD_ID_GRADE ' + sLineBreak +
        	'WHERE pg.COD_ID_EMPRESA = :COD_ID_EMPRESA AND ' + sLineBreak +
            'pg.COD_ID_GRADE = :COD_ID_GRADE AND ' + sLineBreak +
            'pg.COD_ID_PRODUTO = :COD_ID_PRODUTO';
        SelectGradesQuery.ParamByName('COD_ID_EMPRESA').asInteger := CodIdEmpresa;
        SelectGradesQuery.ParamByName('COD_ID_GRADE').asInteger := CodIdGrade;
        SelectGradesQuery.ParamByName('COD_ID_PRODUTO').asInteger := CodIdProduto;
        SelectGradesQuery.Open;

        SelectGradesQuery.SaveToXML('C:\Users\HELDER\Desktop\RESPONSE-DELPHI\grades_join_with_grades.xml')
    finally
        SelectGradesQuery.Free;
    end;

    Result := nil;
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
               .Resource('products/attributes/' + IDAtributo.ToString + '/terms')
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

function TfrmTela_Principal.CriarAtributos: TObjectList<TWooAtributoResponse>;
var
    JSONResponse: TJSONValue;
    Atributos: TArray<TWooAtributoRequest>;
    AtributoRequest : TWooAtributoRequest;
    Payload: string;
    AtributoResponse: TWooAtributoResponse;
    Count: Integer;
begin
	SetLength(Atributos, 2);
    AtributoRequest := TWooAtributoRequest.Create;

    Atributos[0] := TWooAtributoRequest.Create;
    Atributos[0].Name := 'Grade 1';

    Atributos[1] := TWooAtributoRequest.Create;
    Atributos[1].Name := 'Grade 2';

    Result := TObjectList<TWooAtributoResponse>.Create;
    Count := 1;

    try
    	for var Atributo in Atributos do
    	begin
            Payload := TJson.ObjectToJsonString(Atributo);
            JSONResponse := WooCommerceAPICall('products/attributes', 'POST', 'Atributos criados com sucesso', Payload);

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
end;

procedure TfrmTela_Principal.CriarTermosDoBanco(Table: string; AtributoId: Integer);
var
	SelectVariacaoQuery: TUniQuery;
    SQLText: string;
    Count: Integer;
    JSONResponse: TJSONValue;
    Termo: TWooTermoAtributoRequest;
begin
    ShowMessage('Table: ' + Table);
    SQLText := 'SELECT DSC_VARIACAO FROM ' + Table;
    SelectVariacaoQuery := CriarQuery;
    Count := 0;

    try
        SelectVariacaoQuery.SQL.Text := SQLText;
        SelectVariacaoQuery.Open;
        SelectVariacaoQuery.SaveToXML('C:\Users\HELDER\Desktop\RESPONSE-DELPHI\' + Table + '_descricao.xml');

        while (not SelectVariacaoQuery.Eof) and (Count < 2) do
        begin
            try
                Termo := TWooTermoAtributoRequest.Create;
            	Termo.Name := SelectVariacaoQuery.FieldByName('DSC_VARIACAO').AsString;

                ShowMessage('DSC_VARIACAO: ' + Termo.Name);

                JSONResponse := WooCommerceAPICall(
                    '/products/attributes/' + AtributoId.ToString + '/terms',
                    'POST',
                    'Termo criado com sucesso!',
                    TJson.ObjectToJsonString(Termo)
                );

                WriteContentToFile(
                    'C:\Users\HELDER\Desktop\RESPONSE-DELPHI\termo-' + Count.ToString + '.txt',
                    JSONResponse.ToString
                );

                Inc(Count);
                SelectVariacaoQuery.Next;
            finally
                JSONResponse.Free;
                Termo.Free;
            end;
        end;
    finally
    	SelectVariacaoQuery.Free;
    end;
end;

function TfrmTela_Principal.BuscarAtributos: TObjectList<TWooAtributoResponse>;
var
    JSONResponse: TJSONValue;
    Atributo: TWooAtributoResponse;
begin
    Result := TObjectList<TWooAtributoResponse>.Create;
    JSONResponse := WooCommerceAPICall('products/attributes', 'GET', 'Atributos retornados com sucesso');
    WriteContentToFile('C:\Users\HELDER\Desktop\RESPONSE-DELPHI\busca-atributos.txt', JSONResponse.ToString);

     try
     	for var Response in JSONResponse as TJSONArray do
        begin
            Atributo := TJson.JsonToObject<TWooAtributoResponse>(Response.ToString);
            Result.Add(Atributo);
        end;
     finally
        JsonResponse.Free;
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
	JSONValue: TJSONValue;
    CategoriasJSONArray: TJSONArray;
    CategoriaRetornada: string;
begin
	Result := nil;
    JSONValue := WooCommerceAPICall('products/categories', 'GET', 'Categorias retornadas com sucesso!');

    if not (JSONValue is TJSONArray) then
    	Exit;
    try
    	CategoriasJSONArray :=  TJSONArray(JSONValue);

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
        JSONValue.Free;
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
        	if not (JSONResponse is TJSONObject) then
        		Exit;
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

procedure TfrmTela_Principal.btnEnviarProdutosMandalaClick(Sender: TObject);
var
    ProdutoDB: TProduto;
    WooProdutoRequest: TWooProdutoRequest;
    TipoProduto: string;
    Secao: TSecao;
    CategoriaResponse: TWooCategoriaResponse;
    Atributos: TObjectList<TWooAtributoResponse>;
    ListaImagensRequest: TObjectList<TWooImagemRequest>;
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
//    	Atributos := nil;
        CategoriaResponse := nil;
        ListaImagensRequest := nil;
        Secao := nil;

        try
           if FieldByName('COD_ID_GRADE').IsNull then
                TipoProduto := 'simple'
            else
            begin
                TipoProduto := 'variable';
//                Atributos := BuscarAtributos;
            end;

//            if (not Assigned(Atributos)) or (Atributos.IsEmpty) then
//            begin
//                CriarAtributos;
//            end
//        	else
//            	ShowMessage('Erro na verificação da existência de atributos');

            ProdutoDB := ProdutoQueryToProduto(sqlProdutos);
            ListaImagensRequest := RetornarImagensRequest(ProdutoDB.CodIdProduto);
//            BuscarGradesNoBanco(ProdutoDB.CodIdEmpresa, ProdutoDb.CodIdGrade, ProdutoDB.CodIdProduto);
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
                ListaImagensRequest);

        	EnviarProduto(WooProdutoRequest);
        finally
        	WooProdutoRequest.Free;
            CategoriaResponse.Free;
            Secao.Free;
            ListaImagensRequest.Free;
            ProdutoDB.Free;
//            Atributos.Free;
        end;
	end;
end;

procedure TfrmTela_Principal.DatabaseConnectionLost(Sender: TObject; Component: TComponent;
  ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
begin
	RetryMode := rmReconnectExecute;
end;

end.
