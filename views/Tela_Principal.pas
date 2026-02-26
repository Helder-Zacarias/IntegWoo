unit Tela_Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Uni, UniProvider,
  MySQLUniProvider, DBAccess, MemData, MemDS, Vcl.StdCtrls, Vcl.Buttons, System.IOUtils, REST.Json, Rest.Json.Types, WooProdutoResponse,
  System.Generics.Collections, System.JSON, WPImagemResponse, WooImagemRequest, WooProdutoRequest, System.IniFiles, AppConfig, Produto,
  Vcl.ExtCtrls, Tela_Envio_Produto, WooCategoriaRequest, Tela_Cadastro_Atributo, WooAtributoRequest, WooTermoAtributoRequest,
  WooAtributoResponse, CustomObjectMapper, FileWriter, WooCreateCategoriaRequest, RESTRequest4D, WooCategoriaResponse, Secao,
  WooProdutoCategoriaRequest, TrimTexto, ContentPrinter, ProdutoGrade;

type
  TfrmTela_Principal = class(TForm)
    MySQL: TMySQLUniProvider;
    Database: TUniConnection;
    sqlProdutos: TUniQuery;
    sqlImagens: TUniQuery;
    butReceberProdutos: TBitBtn;
    btnHamburguer: TButton;
    panelSide: TPanel;
    sqlGrades: TUniQuery;
    sqlProdutosMandala: TUniQuery;
    btnEnviarProdutosMandala: TBitBtn;
    procedure DatabaseConnectionLost(Sender: TObject; Component: TComponent;
      ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
    procedure butBuscarProdutosClick(Sender: TObject);
    function EnviarImagem(ImagePath: string): TWPImagemResponse;
    procedure btnHamburguerClick(Sender: TObject);
    procedure CriarTermosDoAtributo(Termos: TArray<string>; IdAtributo: Integer);
    procedure btnEnviarProdutosMandalaClick(Sender: TObject);
    procedure EnviarProduto(Produto: TWooProdutoRequest);
    function VerificarExistenciaDaCategoria(Categoria: string): TWooCategoriaResponse;
    function WooCommerceAPICall(Resource: string; Method: string; MensagemAposRetorno: string; Body: string = ''): TJSONValue;
    function BuscarSecaoNoBanco(CodIdSecao: Integer): TSecao;
    function CriarCategoria(Secao: TSecao): TWooCategoriaResponse;
    function BuscarAtributos: TObjectList<TWooAtributoResponse>;
    function CriarAtributos: TObjectList<TWooAtributoResponse>;
  private
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
    SelectGradesQuery := TUniQuery.Create(nil);

    try
        SelectGradesQuery.Connection := Database;
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

function TfrmTela_Principal.CriarAtributos: TObjectList<TWooAtributoResponse>;
var
    JSONResponse: TJSONValue;
    Atributos: TArray<TWooAtributoRequest>;
    AtributoRequest : TWooAtributoRequest;
    Payload: string;
    AtributoResponse: TWooAtributoResponse;
begin
	SetLength(Atributos, 2);
    AtributoRequest := TWooAtributoRequest.Create;

    Atributos[0] := TWooAtributoRequest.Create;
    Atributos[0].Name := 'Grade 1';

    Atributos[1] := TWooAtributoRequest.Create;
    Atributos[1].Name := 'Grade 2';

    Result := TObjectList<TWooAtributoResponse>.Create;

    try
    	for var Atributo in Atributos do
    	begin
            Payload := TJson.ObjectToJsonString(Atributo);
            JSONResponse := WooCommerceAPICall('products/attributes', 'POST', 'Atributos criados com sucesso', Payload);

            try
                AtributoResponse := TJson.JsonToObject<TWooAtributoResponse>(JSONResponse.ToString);
                Result.Add(AtributoResponse);
            finally
                JSONResponse.Free;
            end;
    	end;
    finally
        for var Atributo in Atributos do
            Atributo.Free;
    end;
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
        CategoriaRequest.Name := Secao.DscSecao;
    	RequestPayload := TJson.ObjectToJsonString(CategoriaRequest);
    	JSONResponse := WooCommerceAPICall('products/categories', 'POST', 'Categoria criada com sucesso!', RequestPayload);
    	CategoriaResponse := TJson.JsonToObject<TWooCategoriaResponse>(JSONResponse.ToJSON);
    finally
        CategoriaRequest.Free;
    end;

	Result := CategoriaResponse;
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

procedure TfrmTela_Principal.EnviarProduto(Produto: TWooProdutoRequest);
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
    SelectProdutosQuery: TUniQuery;
    CodIdEmpresa: Integer;
    CodIdLoja: Integer;
    CodIdProduto: Integer;
begin
//    SelectProdutosQuery := sqlProdutos;
	CodIdEmpresa :=  2433;
    CodIdLoja := 90;
    CodIdProduto := 4832698;
    SelectProdutosQuery := TUniQuery.Create(nil);
    SelectProdutosQuery.Connection := Database;
    SelectProdutosQuery.SQL.Text := 'SELECT * FROM db_sgci.produtos WHERE COD_ID_EMPRESA = :COD_ID_EMPRESA AND COD_ID_LOJA = :COD_ID_LOJA And COD_ID_PRODUTO = :COD_ID_PRODUTO';
    SelectProdutosQuery.ParamByName('COD_ID_EMPRESA').AsInteger := CodIdEmpresa;
    SelectProdutosQuery.ParamByName('COD_ID_LOJA').AsInteger := CodIdLoja;
    SelectProdutosQuery.ParamByName('COD_ID_PRODUTO').AsInteger := CodIdProduto;
    SelectProdutosQuery.Open;
    Atributos := nil;

    with SelectProdutosQuery do
    begin
//    	Close;
//        Connection:= Self.Database;
//        Open;

        ProdutoDB := nil;
        WooProdutoRequest := nil;
        Count := 0;

        try
        	while not SelectProdutosQuery.Eof do

            begin
                CodIdGrade := SelectProdutosQuery.FieldByName('COD_ID_GRADE');

                if CodIdGrade.IsNull then
                begin
                	TipoProduto := 'simple';
                    ShowMessage('Produto simples')
                end
                else
                begin
                	TipoProduto := 'variable';
                    ShowMessage('Produto variável');
                    Atributos := BuscarAtributos;
                end;

                ProdutoDB := ProdutoQueryToProduto(SelectProdutosQuery);

                PrintProduto(ProdutoDB);
                CriarAtributos;
//                BuscarGradesNoBanco(CodIdEmpresa, ProdutoDb.CodIdGrade, ProdutoDB.CodIdProduto);

//                Secao := BuscarSecaoNoBanco(ProdutoDB.CodIdSecao);
//                CategoriaResponse := VerificarExistenciaDaCategoria(Secao.DscSecao);
//
//                if not Assigned(CategoriaResponse) then
//                	CategoriaResponse := CriarCategoria(Secao);
//
//               	WooProdutoRequest := ProdutoToWooProdutoRequest(ProdutoDB, TipoProduto, CategoriaResponse.Id);
//
//                Inc(Count);
//                EnviarProduto(WooProdutoRequest);
                Next;
            end;
        finally
        	ProdutoDB.Free;
            WooProdutoRequest.Free;
            SelectProdutosQuery.Free;
        end;
    end;
end;

procedure TfrmTela_Principal.DatabaseConnectionLost(Sender: TObject; Component: TComponent;
  ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
begin
	RetryMode := rmReconnectExecute;
end;

end.
