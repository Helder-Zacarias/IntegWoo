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
    function EnviarProduto(ProdutoRequest: TWooProdutoRequest; ProdutoRecebido: TWooProdutoResponse): TWooProdutoResponse;
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
    function BuscarProdutoPorSKU(SKU: string): TWooProdutoResponse;
    function BuscarProdutoNoBanco(CodIdEmpresa: Integer; CodIdLoja: Integer;
    	CodIdProduto: Integer): TProduto;
  private
    FSQLProdutosBase: string;
    FSQLImagensBase: string;
    FCodIdEmpresa: Integer;
    FCodIdLoja: Integer;
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
  FCodIdEmpresa := 2433;
  FCodIdLoja := 90;
  FCodIdProduto:= 3967904;
  // Para adicionar uma 3ª variação no futuro, basta incluir aqui — o resto do código se adapta automaticamente
  FTabelasVariacao := ['db_sgci.grades_variacao_1', 'db_sgci.grades_variacao_2'];
  FFolderPath := TPath.Combine(TPath.GetDocumentsPath, 'Ecommerce');
end;

// Atualmente, a função utiliza o código da empres,a o código da loja, e o
// código do produto para fazer a busca no banco. O código do produto será
// removido em produção, uma vez que vserá necessário enviar tods os produtos
// da empresa.
function TfrmTela_Principal.BuscarProdutoNoBanco(
    CodIdEmpresa: Integer;
    CodIdLoja: Integer;
    CodIdProduto: Integer
): TProduto;
var
	Query: TUniQuery;
    Produto: TProduto;
begin

    Query := nil;
    Result := nil;

	try
    	try
            Query := CriarQuery;
            with Query do
            begin

            	SQL.Text :=
                    'SELECT pd.COD_ID_PRODUTO, ' +
                    'pd.COD_ID_EMPRESA, ' +
                    'pd.COD_ID_LOJA, ' +
                    'pd.COD_PRODUTO, ' +
                    'pd.COD_BARRAS, '  +
                    'pd.COD_ID_GRADE, ' +
                    'pd.COD_ID_SECAO, ' +
                    'pd.DSC_COMPLETA, ' +
                    'pd.NUM_TIPO_PRODUTO, ' +
                    'pr.NUM_PRECO_VAREJO AS PRECO_VAREJO, ' +
                    'e.NUM_ESTQ_ATUAL AS ESTOQUE_ATUAL ' +
                    'FROM db_sgci.produtos pd ' +
                    'INNER JOIN db_sgci.precos pr ' +
                        'ON pd.COD_ID_PRODUTO = pr.COD_ID_PRODUTO ' +
                        'AND pd.COD_ID_EMPRESA = pr.COD_ID_EMPRESA ' +
                        'AND pd.COD_ID_LOJA = pr.COD_ID_LOJA ' +
                    'INNER JOIN db_sgci.estoques e ' +
                        'ON pd.COD_ID_PRODUTO = e.COD_ID_PRODUTO ' +
                        'AND pd.COD_ID_EMPRESA = e.COD_ID_EMPRESA ' +
                        'AND pd.COD_ID_LOJA = e.COD_ID_LOJA ' +
                    'WHERE pd.COD_ID_EMPRESA = :COD_ID_EMPRESA AND ' +
                    'pd.COD_ID_LOJA = :COD_ID_LOJA AND ' +
                    'pd.COD_ID_PRODUTO = :COD_ID_PRODUTO';

                ParamByName('COD_ID_EMPRESA').AsInteger := CodIdEmpresa;
                ParamByName('COD_ID_LOJA').AsInteger := CodIdLoja;
                ParamByName('COD_ID_PRODUTO').AsInteger := CodIdProduto;
                Open;
                SaveToXML(TPath.Combine(TPath.GetDocumentsPath, 'produt-com-preco-e-estoque.xml'));

                Result := TProduto.Create;

                Result.CodIdProduto := FieldByName('COD_ID_PRODUTO').AsInteger;
                Result.CodIdEmpresa := FieldByName('COD_ID_EMPRESA').AsInteger;
                Result.CodIdLoja := FieldByName('COD_ID_LOJA').AsInteger;
                Result.CodProduto := FieldByName('COD_PRODUTO').AsLargeInt;
                Result.CodBarras := FieldByName('COD_BARRAS').AsString;
                Result.CodIdGrade := FieldByName('COD_ID_GRADE').AsInteger;
                Result.CodIdSecao := FieldByName('COD_ID_SECAO').AsInteger;
                Result.DscCompleta := FieldByName('DSC_COMPLETA').AsString;
                Result.NumTipoProduto := FieldByName('NUM_TIPO_PRODUTO').AsInteger;
                Result.NumPrecoVarejo := FieldByName('PRECO_VAREJO').AsCurrency;
                Result.NumEstqAtual := FieldByName('ESTOQUE_ATUAL').AsFloat;
            end;
        except
            Result.Free;
            raise;
        end;
    finally
       Query.Free;
    end;
end;

function TfrmTela_Principal.BuscarProdutoPorSKU(SKU: string): TWooProdutoResponse;
var
    JSONArray: TJSONArray;
begin
    try
        JSONArray := nil;
        Result := nil;

        try
        	JSONArray := ChecarERetornarJSONArray(
                ChamadaAPIWooCommerce(
                    Format('products?sku=%s', [SKU]),
                    'GET'
                )
            );

            if JSONArray.Size > 1 then
                raise Exception.Create('Há mais de um produto com o mesmo SKU');

            for var Resposta in JSONArray AS TJSONArray do
            	Result := TJson.JsonToObject<TwooProdutoResponse>(Resposta.ToJSON);

            SalvarConteudoEmArquivo(TPath.Combine(TPath.GetDocumentsPath, 'produto-por-sku.txt'), JSONArray.ToJSON);
        except
        	Result.Free;
            raise;
        end;
    finally
        JSONArray.Free;
    end;
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
      ShowMessage(MensagemAposRetorno);
  end
  else
    raise Exception.Create('Requisição falhou. ' + Response.StatusCode.ToString + ': ' + Response.Content);

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
          raise Exception.Create('Nenhuma Resposta da API do WooCommerce!');

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

function TfrmTela_Principal.BuscarAtributos: TObjectList<TWooAtributoResponse>;
var
  JSONResposta: TJSONValue;
  JSONArray: TJSONArray;
begin
  Result       := nil;
  JSONResposta := nil;
  JSONArray    := nil;

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

function TfrmTela_Principal.FiltrarTermosRepetidos(Variacoes: TList<string>): TList<string>;
var
  TermosDistintos: TStringList;
begin
  Result          := TList<string>.Create;
  TermosDistintos := TStringList.Create;
  TermosDistintos.Sorted     := True;
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
  Result := TList<string>.Create;

  for var Termo in TermosAPI do
    Result.Add(Termo.Name);
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

function TfrmTela_Principal.EnviarTermos(
  Atributos: TObjectList<TWooAtributoResponse>;
  ProdutosGrade: TObjectList<TProdutoGrade>
): TObjectDictionary<Integer, TObjectList<TWooTermoResponse>>;
begin
  Result := GerarListasDeVariacoesDosProdutosGrade(Atributos, ProdutosGrade);
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
      'Variações do produto ' + ProdutoID.ToString + ' retornadas com sucesso'
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
      VariacaoProdutoRequest.RegularPrice  := FormatFloat('0.00', Grade.NumPrecoUnitario, TFormatSettings.Invariant);
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
    SelectSecaoQuery.SQL.Text := 'SELECT * FROM db_sgci.secoes ' + sLineBreak +
      'WHERE COD_ID_EMPRESA = :COD_ID_EMPRESA AND COD_ID_SECAO = :COD_ID_SECAO LIMIT 10';
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
  Result           := nil;
  JSONResposta     := nil;
  CategoriaRequest := nil;

  try
    CategoriaRequest      := TWooCategoriaRequest.Create;
    CategoriaRequest.Name := Secao.DscSecao;
    RequestPayload        := TJson.ObjectToJsonString(CategoriaRequest);

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
      raise Exception.Create('Requisição falhou: ' + Response.StatusText);

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
      if not Assigned(sqlImagens.FieldByName('URL_IMAGEM')) or sqlImagens.FieldByName('URL_IMAGEM').IsNull then
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
begin
	ProdutoDB := nil;
    WooProdutoRequest := nil;
    Atributos := nil;
    CategoriaResponse := nil;
    ListaImagensRequest := nil;
    Secao := nil;
    TermosProduto := nil;
    WooProdutoResponse := nil;
    ProdutosGrade := nil;

    try
    	ProdutoDB := BuscarProdutoNoBanco(
        	FCodIdEmpresa,
            FCodIdLoja,
            FCodIdProduto
      	);

        if not Assigned(ProdutoDB) then
        	raise Exception.Create(
            	Format('Não há nenhum produto na empresa %d loja %d com o id %d',
                [FCodIdEmpresa, FCodIdLoja, FCodIdProduto])
            );

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
            ShowMessage(
                'SKU do WooCommerce: ' + ProdutoRecebido.Sku + sLineBreak +
                'SKU Produto Request: ' + WooProdutoRequest.SKU
            );
            raise Exception.Create('SKU do produto diverge do código do produto no banco');
          end
          else
            ShowMessage('SKU OK');

          SalvarConteudoEmArquivo(
            TPath.Combine(TPath.GetDocumentsPath, 'produto-request-object.txt.'),
            TJson.ObjectToJsonString(WooProdutoRequest)
          );

          WooProdutoResponse := EnviarProduto(
              WooProdutoRequest,
              ProdutoRecebido
          );

          if WooProdutoResponse.PType = 'variable' then
            CriarVariacoesDoProduto(WooProdutoResponse, ProdutosGrade);
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

procedure TfrmTela_Principal.DatabaseConnectionLost(Sender: TObject; Component: TComponent;
  ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
begin
  RetryMode := rmReconnectExecute;
end;

end.

