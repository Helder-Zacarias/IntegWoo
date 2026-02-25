unit Tela_Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Uni, UniProvider,
  MySQLUniProvider, DBAccess, MemData, MemDS, Vcl.StdCtrls, Vcl.Buttons, System.IOUtils, REST.Json, Rest.Json.Types, WooProdutoResponse,
  System.Generics.Collections, System.JSON, WPImagemResponse, WooImagemRequest, WooProdutoRequest, System.IniFiles, AppConfig, Produto,
  Vcl.ExtCtrls, Tela_Envio_Produto, WooCategoriaRequest, Tela_Cadastro_Atributo, WooAtributoRequest, WooTermoAtributoRequest,
  WooAtributoResponse, CustomObjectMapper, FileWriter, WooCreateCategoriaRequest, RESTRequest4D, WooCategoriaResponse, Secao,
  WooProdutoCategoriaRequest, TrimTexto;

type
  TfrmTela_Principal = class(TForm)
    MySQL: TMySQLUniProvider;
    Database: TUniConnection;
    sqlProdutos: TUniQuery;
    sqlImagens: TUniQuery;
    butReceberProdutos: TBitBtn;
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
    procedure butBuscarProdutosClick(Sender: TObject);
    function EnviarImagem(ImagePath: string): TWPImagemResponse;
    procedure btnHamburguerClick(Sender: TObject);
    procedure btnTestarConexãoClick(Sender: TObject);
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
    function BuscarAtributos: TObjectList<TWooAtributoResponse>;
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
	JSONResponse: TJSONValue;
begin
    JSONResponse := WooCommerceAPICall('products/attributes', 'GET', 'Atributos retornados com sucesso!');
    WriteContentToFile('C:\Users\HELDER\Desktop\RESPONSE-DELPHI\ATRIBUTOS-PAYLOADS\atributos.txt', JSONResponse.ToJSON());
end;

procedure TfrmTela_Principal.btnBuscarCategoriasClick(Sender: TObject);
var
    JSONResponse: TJSONValue;
begin
    JSONResponse := WooCommerceAPICall('products/categories', 'GET', 'Categorias retornadas com sucesso');
    WriteContentToFile('C:\Users\HELDER\Desktop\RESPONSE-DELPHI\categorias.txt', JSONResponse.ToJSON());
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

function TfrmTela_Principal.BuscarAtributos: TObjectList<TWooAtributoResponse>;
var
    JSONResponse: TJSONValue;
    Atributos: TObjectList<TWooAtributoResponse>;
    Atributo: TWooAtributoResponse;
begin
    Atributos := TObjectList<TWooAtributoResponse>.Create;
    JSONResponse := WooCommerceAPICall('products/attributes', 'GET', 'Atributos retornados com sucesso');

    for var Response in JSONResponse as TJSONArray do
    begin
        Atributo := TJson.JsonToObject<TWooAtributoResponse>(Response.ToString);
        Atributos.Add(Atributo);
    end;

    Result := Atributos;
end;

function TfrmTela_Principal.BuscarSecaoNoBanco(CodIdSecao: Integer) : TSecao;
var
    SelectSecaoQuery: TUniQuery;
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

        if RemoverEspacos(Categoria) = RemoverEspacos(CategoriaRetornada) then
        begin
           CategoriaResponse := TJson.JsonToObject<TWooCategoriaResponse>(CategoriaJSON as TJSONObject);
           Break;
        end;
    end;

    Result := CategoriaResponse;
end;

function TfrmTela_Principal.CriarCategoria(Secao: TSecao): TWooCategoriaResponse;
var
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
    JSONString: string;
    JSONResponse: TJSONValue;
begin
    JSONString := TJSON.ObjectToJsonString(Produto);
    JSONResponse := WooCommerceAPICall('products', 'POST', 'Produto cadastrado com sucesso', JSONString);
    WriteContentToFile('C:\Users\HELDER\Desktop\RESPONSE-DELPHI\WOOCOMMERCE-PAYLOADS\PRODUTO-JSON.TXT ', JSONResponse.ToJSON);
end;

procedure TfrmTela_Principal.btnEnviarProdutosMandalaClick(Sender: TObject);
var
    ProdutoDB: TProduto;
    WooProdutoRequest: TWooProdutoRequest;
    CodIdGrade: TField;
    Count: Integer;
    TipoProduto: string;
    Secao: TSecao;
    CategoriaResponse: TWooCategoriaResponse;
    Atributos: TObjectList<TWooAtributoResponse>;
begin
    with sqlProdutosMandala do
    begin
    	Close;
        Connection:= Self.Database;
        Open;

        ProdutoDB := nil;
        WooProdutoRequest := nil;
        Count := 0;

        try
        	while (not sqlProdutosMandala.Eof) and (Count < 3) do

            begin
                CodIdGrade := sqlProdutosMandala.FindField('COD_ID_GRADE');

            	if (not Assigned(CodIdGrade)) or (CodIdGrade.IsNull) or (not CodIdGrade.AsInteger <> 0) then
                    TipoProduto := 'simple'
                else
                begin
                    TipoProduto := 'variable';
                end;

                ProdutoDB := ProdutoQueryToProduto(sqlProdutosMandala);

                Secao := BuscarSecaoNoBanco(ProdutoDB.CodIdSecao);
                CategoriaResponse := VerificarExistenciaDaCategoria(Secao.DscSecao);

                if not Assigned(CategoriaResponse) or (CategoriaResponse = nil) then
                	CategoriaResponse := CriarCategoria(Secao);

               	WooProdutoRequest := ProdutoToWooProdutoRequest(ProdutoDB, TipoProduto, CategoriaResponse.Id);

                Inc(Count);
                EnviarProdutoSimples(WooProdutoRequest);
                Next;
            end;
        finally
        	ProdutoDB.Free;
            WooProdutoRequest.Free;
        end;

    end;
end;

function TfrmTela_Principal.EnviarImagem(ImagePath: string): TWPImagemResponse;
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

procedure TfrmTela_Principal.btnTestarConexãoClick(Sender: TObject);
var
    SelectQuery:  TUniQuery;
begin
    try
        SelectQuery := TUniQuery.Create(nil);
        SelectQuery.Connection := Database;
        SelectQuery.SQL.Text := 'SELECT * FROM db_sgci.secoes WHERE COD_ID_EMPRESA = 1451';
        SelectQuery.Open;
        SelectQuery.SaveToXML('C:\Users\HELDER\Desktop\RESPONSE-DELPHI\DB_QUERIES\select-secoes-mandala.xml');
    finally
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
    JSONResponse: TJSONValue;
begin
    JSONResponse := WooCommerceAPICall('products', 'GET', 'Produtos retornados com sucesso!');
    WriteContentToFile('C:\Users\HELDER\Desktop\RESPONSE-DELPHI\produtos.txt', JSONResponse.ToJSON);
end;

procedure TfrmTela_Principal.DatabaseConnectionLost(Sender: TObject; Component: TComponent;
  ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
begin
	RetryMode := rmReconnectExecute;
end;

end.
