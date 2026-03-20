unit Tela_Principal;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.IOUtils, System.NetEncoding,
  System.Generics.Collections, System.JSON, System.IniFiles, System.Threading, System.DateUtils,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Data.DB, Uni, UniProvider, MySQLUniProvider, DBAccess, MemData, MemDS,
  REST.Json, Rest.Json.Types, RESTRequest4D,
  Horse,
  AppConfig, Tela_Envio_Produto, Tela_Cadastro_Atributo,
  FileWriter, TransformadorDeTexto, ContentPrinter, CustomObjectMapper, FormatadorDocumentos,
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
    procedure OnFormDestroy(Sender: TObject);
    procedure DatabaseConnectionLost(Sender: TObject; Component: TComponent;
      ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
    procedure btnHamburguerClick(Sender: TObject);
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
    procedure RegistrarRotas;
    procedure HorseAPISalvarPedido(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    function ChecarBodyDoWebHook(ReqBody: string): Boolean;
    function BuscarOuInserirClienteNoBanco(Billing: TBilling; CodIdEmpresa: Integer;
    	CodIdLoja: Integer): TCliente;
    function BuscarMunicipio(Municipio: string): TMunicipio;
    function SalvarPedidoNoBanco(CodIdEmpresa: Integer; CodIdLoja: Integer;
    	WooPedido: TWooPedido; Cliente: TCliente): TPedidoVenda;
    function SQLToPedidoVenda(Query: TUniQuery): TPedidoVenda;
    function WooPedidoToPedidoVenda(CodIdEmpresa: Integer; CodIdLoja: Integer;
    	WooPedido: TWooPedido; IdCliente: Integer): TPedidoVenda;
    function RetornarItensDoPedidoDeVenda(Itens: TArray<TLineItem>; CodIdEmpresa: Integer;
    	CodIdLoja: Integer; CodIdPedido: Int64): TArray<TPedidoVendaItem>;
    function BuscarProdutoNoBanco(CodIdEmpresa: Integer; CodIdLoja: Integer;
    	Descricao: String): TProduto;
    procedure SalvarProdutosDoPedido(ProdutosPedido: TArray<TPedidoVendaItem>);
    function BuscarOuInserirFinalizadora(PaymentMethod: string; PaymentMethodTitle: string;
    	CodIdEmpresa: Integer; CodIdLoja: Integer; CodIdCliente: Integer): TFinalizadora;
    function BuscarFinalizadorasDoBanco(PaymentMethodTtile: string; CodIdEmpresa: Integer;
    	CodIdLoja: Integer): TFinalizadora;
    function SQLToFinalizadora(Query: TUniQuery): TFinalizadora;
    function InserirPagamentoNoBanco(CodIdEmpresa: Integer; CodIdLoja: Integer;
    	CodIdPedido: Int64; CodIdFinalizadora: Integer;
        DataPagamento: TDateTime; ValorPedido: Double): TPedidoVendaPgtos;
    procedure HorseAPIAtualizarProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  private
    FSQLProdutosBase: string;
    FSQLImagensBase: string;
    FTabelasVariacao: TArray<string>;
    FFolderPath: string;
    const
        HORSE_PORT = 9000;
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

// Início das funções para salvar pedido
procedure TfrmTela_Principal.HorseAPISalvarPedido(
	Req: THorseRequest;
    Res: THorseResponse;
	Next: TProc
);
var
    CodIdEmpresa: string;
    CodIdLoja: string;
    Conexao: TUniConnection;
    Cliente: TCliente;
    ProdutosPedido: TArray<TPedidoVendaItem>;
    Finalizadora: TFinalizadora;
    WooPedido: TWooPedido;
    PedidoRetornado: TPedidoVenda;
begin
    Cliente := nil;
    Finalizadora := nil;
    WooPedido := nil;
    PedidoRetornado := nil;
    Conexao := nil;

	try
        CodIdEmpresa := Req.Params
            .Field('codIdEmpresa')
            .Required(True)
            .RequiredMessage('"codIdEmpresa" não foi recebido na URL da requisição').AsString;

        CodIdLoja := Req.Params
            .Field('codIdLoja')
            .Required(True)
            .RequiredMessage('"codIdLoja" não foi recebido na URL da requisição').AsString;

        ChecarBodyDoWebHook(Req.Body);
        WooPedido := TJSON.JsonToObject<TWooPedido>(Req.Body);

        Conexao := Database;

        try
            Conexao.StartTransaction;

            Cliente := BuscarOuInserirClienteNoBanco(
                WooPedido.Billing,
                CodIdEmpresa.ToInteger,
                CodIdLoja.ToInteger
            );

            PedidoRetornado := SalvarPedidoNoBanco(
            	CodIdEmpresa.ToInteger,
                CodIdLoja.ToInteger,
                WooPedido,
                Cliente
            );

            ProdutosPedido := RetornarItensDoPedidoDeVenda(
                WooPedido.LineItems,
                CodIdEmpresa.ToInteger,
                CodIdLoja.ToInteger,
                PedidoRetornado.CodIdPedido
            );

            SalvarProdutosDoPedido(ProdutosPedido);

            Finalizadora := BuscarOuInserirFinalizadora(
                WooPedido.PaymentMethod,
                WooPedido.PaymentMethodTitle,
                CodIdEmpresa.ToInteger,
                CodIdLoja.ToInteger,
                Cliente.CodIdCliente
            );

            InserirPagamentoNoBanco(
            	CodIdEmpresa.ToInteger,
                CodIdLoja.ToInteger,
                PedidoRetornado.CodIdPedido,
                Finalizadora.CodIdFinalizadora,
                PedidoRetornado.DatPedido,
                PedidoRetornado.NumEntregaValor
            );

            Conexao.Commit;

            SalvarConteudoEmArquivo(
                TPath.Combine(TPath.GetDocumentsPath, 'PEDIDO-WOOCOMMERCE.txt'),
                TJson.ObjectToJsonString(WooPedido)
            );

            Res.Status(THTTPStatus.Created).Send('Pedido criado com sucesso!');
        except
            on E: Exception do
            begin
                Res.Status(THTTPStatus.InternalServerError).Send('Erro ao salvar pedido!\n');
                if Conexao.InTransaction then
                	Conexao.Rollback;
            end;
        end;
	finally
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

	try
    	Municipio := BuscarMunicipio(Billing.City);

        if not Assigned(Municipio) then
            raise Exception.Create('Município não encontrado');

		Query.SQL.Text :=
            'INSERT INTO db_sgci.clientes ( ' +
            '    COD_ID_EMPRESA, ' +
            '    COD_ID_LOJA, ' +
            '    NUM_TIPO, ' +
            '    NUM_SEXO, ' +
            '    DSC_NOME, ' +
            '    DSC_ENDERECO, ' +
            '    DSC_NUMERO, ' +
            '    DSC_COMPLEMENTO, ' +
            '    DSC_BAIRRO, ' +
            '    COD_ID_UF, ' +
            '    COD_ID_MUNICIPIO, ' +
            '    DSC_CEP, ' +
            '    DSC_TELEFONE, ' +
            '    DSC_CELULAR, ' +
            '    DSC_CPF_CNPJ, ' +
            '    DSC_EMAIL, ' +
            '    DAT_NASCIMENTO, ' +
            '    DSC_IE, ' +
            '    DAT_CADASTRO ' +
            ') VALUES ( ' +
            '    :COD_ID_EMPRESA, ' +
            '    :COD_ID_LOJA, ' +
            '    :NUM_TIPO, ' +
            '    :NUM_SEXO, ' +
            '    :DSC_NOME, ' +
            '    :DSC_ENDERECO, ' +
            '    :DSC_NUMERO, ' +
            '    :DSC_COMPLEMENTO, ' +
            '    :DSC_BAIRRO, ' +
            '    :COD_ID_UF, ' +
            '    :COD_ID_MUNICIPIO, ' +
            '    :DSC_CEP, ' +
            '    :DSC_TELEFONE, ' +
            '    :DSC_CELULAR, ' +
            '    :DSC_CPF_CNPJ, ' +
            '    :DSC_EMAIL, ' +
            '    :DAT_NASCIMENTO, ' +
            '    :DSC_IE, ' +
            '    NOW() ' +
            ') ON DUPLICATE KEY UPDATE ' +
            '    COD_CLIENTE = LAST_INSERT_ID(COD_CLIENTE)';

        Query.ParamByName('COD_ID_EMPRESA').AsInteger := CodIdEmpresa;
        Query.ParamByName('COD_ID_LOJA').AsInteger := CodIdLoja;

        if Billing.PersonType = 'F' then
        begin
        	Query.ParamByName('NUM_TIPO').AsInteger := 0;
        	Query.ParamByName('DSC_CPF_CNPJ').AsString := FormatarCPF(Billing.Cpf);
        end
        else
        begin
            Query.ParamByName('NUM_TIPO').AsInteger := 1;
            Query.ParamByName('DSC_CPF_CNPJ').AsString := FormatarCNPJ(Billing.Cnpj);
        end;

        if Billing.Gender = 'F' then
        	Query.ParamByName('NUM_SEXO').AsInteger := 0
        else if Billing.Gender = 'M' then
        	Query.ParamByName('NUM_SEXO').AsInteger := 1
        else
        	Query.ParamByName('NUM_SEXO').Clear;

        Query.ParamByName('DSC_NOME').AsString :=
        Trim(Billing.FirstName + ' ' + Billing.LastName);

        Query.ParamByName('DSC_ENDERECO').AsString := Billing.Address1;
        Query.ParamByName('DSC_NUMERO').AsString := Billing.Number;
        Query.ParamByName('DSC_COMPLEMENTO').AsString := Billing.Address2;
        Query.ParamByName('DSC_BAIRRO').AsString := Billing.Neighborhood;
        Query.ParamByName('DSC_CEP').AsString := Billing.Postcode;

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

        Query.SQL.Text := 'SELECT * FROM db_sgci.clientes WHERE COD_CLIENTE = :ID';
        Query.ParamByName('ID').AsInteger := ClienteID;
        Query.Open;

        Result := TCliente.Create;
        Result.CodIdCliente := ClienteID;
        Result.CodIdEmpresa := Query.FieldByName('COD_ID_EMPRESA').AsInteger;
        Result.CodIdLoja    := Query.FieldByName('COD_ID_LOJA').AsInteger;
        Result.CodCliente   := Query.FieldByName('COD_CLIENTE').AsInteger;
        Result.DscNome      := Query.FieldByName('DSC_NOME').AsString;
        Result.DscCpfCnpj   := Query.FieldByName('DSC_CPF_CNPJ').AsString;
        Result.DscEmail     := Query.FieldByName('DSC_EMAIL').AsString;
        Result.DscTelefone  := Query.FieldByName('DSC_TELEFONE').AsString;
        Result.DscCelular   := Query.FieldByName('DSC_CELULAR').AsString;
        Result.DscEndereco     := Query.FieldByName('DSC_ENDERECO').AsString;
        Result.DscNumero       := Query.FieldByName('DSC_NUMERO').AsString;
        Result.DscComplemento  := Query.FieldByName('DSC_COMPLEMENTO').AsString;
        Result.DscBairro       := Query.FieldByName('DSC_BAIRRO').AsString;
        Result.CodCep          := Query.FieldByName('DSC_CEP').AsString;
        Result.DatInclusao  := Query.FieldByName('DAT_CADASTRO').AsDateTime;
	finally
    	Query.Free;
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

            	Result := TMunicipio.Create;
                Result.CodIdMunicipio := FieldByName('COD_ID_MUNICIPIO').AsInteger;
                Result.CodIdUf := FieldByName('COD_ID_UF').AsInteger;
                Result.CodUf := FieldByName('COD_UF').AsInteger;
                Result.CodMunicipioIbge := FieldByName('COD_MUNICIPIO_IBGE').AsInteger;
                Result.DscMunicipio := FieldByName('DSC_MUNICIPIO').AsString;
                Result.DscChave := FieldByName('DSC_CHAVE').AsString;
            end;
        except
            Result.Free;
            raise;
        end;
    finally
        Query.Free;
    end;
end;

function TfrmTela_Principal.SalvarPedidoNoBanco(
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
    Query := nil;
	Pedido := nil;
    Result := nil;

	try
    	Pedido := WooPedidoToPedidoVenda(
            CodIdEmpresa,
            CodIdLoja,
            WooPedido,
            Cliente.CodIdCliente
        );

        ShowMessage('Após conversão a pedido de venda');

		Query := CriarQuery;

		with Query do
		begin
            try
            	SQL.Text :=
                  'INSERT INTO db_sgci.pedido_venda ( ' +
                  '  COD_ID_EMPRESA, ' +
                  '  COD_ID_LOJA, ' +
                  '  COD_ID_CLIENTE, ' +
//                  '  COD_IDENTIFICADOR, ' +
                  '  DAT_PEDIDO, ' +
                  '  DAT_INCLUSAO, ' +
//                  '  DSC_ENTREGA_NOME, ' +
//                  '  DSC_ENTREGA_ENDERECO, ' +
//                  '  DSC_ENTREGA_TELEFONE, ' +
//                  '  DSC_ENTREGA_CELULAR, ' +
//                  '  NUM_VALOR_DESCONTO, ' +
                  '  NUM_ENTREGA_VALOR ' +
//                  '  NUM_STATUS_PEDIDO, ' +
//                  '  NUM_STATUS_PRODUCAO, ' +
//                  '  DSC_OBSERVACOES ' +
                  ') VALUES ( ' +
                  '  :COD_ID_EMPRESA, ' +
                  '  :COD_ID_LOJA, ' +
                  '  :COD_ID_CLIENTE, ' +
//                  '  :COD_IDENTIFICADOR, ' +
                  '  :DAT_PEDIDO, ' +
                  '  :DAT_INCLUSAO, ' +
//                  '  :DSC_ENTREGA_NOME, ' +
//                  '  :DSC_ENTREGA_ENDERECO, ' +
//                  '  :DSC_ENTREGA_TELEFONE, ' +
//                  '  :DSC_ENTREGA_CELULAR, ' +
//                  '  :NUM_VALOR_DESCONTO, ' +
                  '  :NUM_ENTREGA_VALOR ' +
//                  '  :NUM_STATUS_PEDIDO, ' +
//                  '  :NUM_STATUS_PRODUCAO, ' +
//                  '  :DSC_OBSERVACOES ' +
                  ')';

                ParamByName('COD_ID_EMPRESA').AsInteger := Pedido.CodIdEmpresa;
                ParamByName('COD_ID_LOJA').AsInteger := Pedido.CodIdLoja;
                ParamByName('COD_ID_CLIENTE').AsInteger := Pedido.CodIdCliente;
//                ParamByName('COD_IDENTIFICADOR').AsString := Pedido.CodIdentificador;
                ParamByName('DAT_PEDIDO').AsDateTime := Pedido.DatPedido;
                ParamByName('DAT_INCLUSAO').AsDateTime := Now;
//                ParamByName('DSC_ENTREGA_NOME').AsString := Pedido.DscEntregaNome;
//                ParamByName('DSC_ENTREGA_ENDERECO').AsString := Pedido.DscEntregaEndereco;
//                ParamByName('DSC_ENTREGA_TELEFONE').AsString := Pedido.DscEntregaTelefone;
//                ParamByName('DSC_ENTREGA_CELULAR').AsString := Pedido.DscEntregaCelular;
//                ParamByName('NUM_VALOR_DESCONTO').AsFloat := Pedido.NumValorDesconto;
                ParamByName('NUM_ENTREGA_VALOR').AsFloat := Pedido.NumEntregaValor;
//                ParamByName('NUM_STATUS_PEDIDO').AsInteger := Pedido.NumStatusPedido;
//                ParamByName('NUM_STATUS_PRODUCAO').AsInteger := Pedido.NumStatusProducao;
//                ParamByName('DSC_OBSERVACOES').AsString := Pedido.DscObservacoes;

                ExecSQL;

                ShowMessage('Após inserção do pedido');

                SQL.Text := 'SELECT LAST_INSERT_ID() AS ID';
                Open;
                PedidoId := FieldByName('ID').AsLargeInt;

                Close;
                SQL.Text := 'SELECT * FROM db_sgci.pedido_venda WHERE COD_ID_PEDIDO = :ID';
                ParamByName('ID').AsLargeInt := PedidoId;
                Open;

                Result := SQLToPedidoVenda(Query);

                ShowMessage('Após converter sql em pedido de venda');
            except
                Result.Free;
                raise;
            end;
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
//            Result.CodIdentificador   := FieldByName('COD_IDENTIFICADOR').AsString;
            Result.CodIdCliente       := FieldByName('COD_ID_CLIENTE').AsInteger;
            Result.DatPedido          := FieldByName('DAT_PEDIDO').AsDateTime ;
            Result.DatInclusao        := FieldByName('DAT_INCLUSAO').AsDateTime;
//            Result.DscEntregaNome     := FieldByName('DSC_ENTREGA_NOME').AsString;
//            Result.DscEntregaEndereco := FieldByName('DSC_ENTREGA_ENDERECO').AsString;
//            Result.DscEntregaTelefone := FieldByName('DSC_ENTREGA_TELEFONE').AsString;
//            Result.DscEntregaCelular  := FieldByName('DSC_ENTREGA_CELULAR').AsString;
//            Result.DscObservacoes     := FieldByName('DSC_OBSERVACOES').AsString;
//            Result.NumValorDesconto   := FieldByName('NUM_VALOR_DESCONTO').AsFloat;
            Result.NumEntregaValor    := FieldByName('NUM_ENTREGA_VALOR').AsFloat;
//            Result.NumStatusPedido    := FieldByName('NUM_STATUS_PEDIDO').AsInteger;
//            Result.NumValorDesconto   := FieldByName('NUM_VALOR_DESCONTO').AsFloat;
        end;
    except
        Result.Free;
        raise;
    end;
end;

function TfrmTela_Principal.WooPedidoToPedidoVenda(
    CodIdEmpresa: Integer;
    CodIdLoja: Integer;
    WooPedido: TWooPedido;
    IdCliente: Integer
): TPedidoVenda;
var
    LSettings: TFormatSettings;
begin
    Result := nil;
    LSettings := TFormatSettings.Invariant; // Força padrão internacional (ponto)

    try
        Result := TPedidoVenda.Create;
        Result.CodIdEmpresa := CodIdEmpresa;
        Result.CodIdLoja := CodIdLoja;
        Result.CodIdCliente := IdCliente;
        Result.CodIdWooCommerce := WooPedido.Id;
        Result.DatPedido := ISO8601ToDate(WooPedido.DateCreated);
        Result.DatInclusao := ISO8601ToDate(WooPedido.DateCreated);
        Result.NumEntregaValor := StrToFloat(WooPedido.Total, LSettings);
        ShowMessage('VALOR: ' + Result.NumEntregaValor.ToString)
    except
        Result.Free;
        raise;
    end;
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
            	Produto := BuscarProdutoNoBanco(CodIdEmpresa, CodIdLoja, Item.Name);

                if not Assigned(Produto) then
                    raise Exception.Create(
                        Format(
                            '%S não é um produto cadastrado no sistema',
                            [Item.Name]
                        )
                    );

                PedidoVendaItem := TPedidoVendaItem.Create;
                PedidoVendaItem.CodIdEmpresa := CodIdEmpresa;
                PedidoVendaItem.CodIdLoja := CodIdLoja;
                PedidoVendaItem.CodIdPedido := CodIdPedido;
                PedidoVendaItem.CodIdProduto := Produto.CodIdProduto;
                PedidoVendaItem.CodProduto := Produto.CodProduto;
                PedidoVendaItem.DscCompleta := Produto.DscCompleta;
                PedidoVendaItem.NumValorUnitario := Produto.NumPrecoVarejo;
                PedidoVendaItem.NumQuantidade := Item.Quantity;

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
	Descricao: String
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
             '	pd.COD_ID_LOJA, ' +
             '	pd.COD_PRODUTO, ' +
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
             '	ON pd.COD_ID_PRODUTO = pr.COD_ID_PRODUTO ' +
             '	AND pd.COD_ID_EMPRESA = pr.COD_ID_EMPRESA ' +
             '	AND pd.COD_ID_LOJA = pr.COD_ID_LOJA ' +
             'LEFT JOIN db_sgci.estoques e ' +
             '	ON pd.COD_ID_PRODUTO = e.COD_ID_PRODUTO ' +
             '	AND pd.COD_ID_EMPRESA = e.COD_ID_EMPRESA ' +
             '	AND pd.COD_ID_LOJA = e.COD_ID_LOJA ' +
             'INNER JOIN db_sgci.empresas emp ' +
             '	ON emp.COD_ID_EMPRESA = pd.COD_ID_EMPRESA ' +
             'INNER JOIN db_sgci.lojas lj ' +
             '	ON lj.COD_ID_EMPRESA = pd.COD_ID_EMPRESA ' +
             '	AND lj.COD_ID_LOJA = pd.COD_ID_LOJA ' +
             'WHERE pd.COD_ID_EMPRESA = :COD_ID_EMPRESA ' +
             '	AND pd.COD_ID_LOJA = :COD_ID_LOJA ' +
             '	AND pd.DSC_COMPLETA = :DSC_COMPLETA';

            ParamByName('COD_ID_EMPRESA').AsInteger := CodIdEmpresa;
            ParamByName('COD_ID_LOJA').AsInteger := CodIdLoja;
            ParamByName('DSC_COMPLETA').AsString := Descricao;

            Open;

            Result := TProduto.Create;

            try
                Result.CodIdEmpresa := FieldByName('COD_ID_EMPRESA').AsInteger;
                Result.CodIdLoja := FieldByName('COD_ID_LOJA').AsInteger;
                Result.CodIdProduto := FieldByName('COD_ID_PRODUTO').AsInteger;
                Result.CodProduto := FieldByName('COD_PRODUTO').AsLargeInt;
                Result.DscCompleta := FieldByName('DSC_COMPLETA').AsString;
                Result.NumPrecoVarejo := FieldByName('PRECO_VAREJO').AsCurrency;
                Result.NumEstqAtual := FieldByName('ESTOQUE_ATUAL').AsFloat;
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
                    '(' +
                    '	:COD_ID_EMPRESA_%d,' +
                    '	:COD_ID_LOJA_%d,' +
                    '	:COD_ID_PEDIDO_%d,' +
                    '	:DAT_INCLUSAO_%d,' +
                    '	:COD_ID_PRODUTO_%d, ' +
                    '	:COD_PRODUTO_%d, ' +
                    '	:DSC_COMPLETA_%d, ' +
                    '	:NUM_VALOR_UNITARIO_%d, ' +
                    '	:NUM_QUANTIDADE_%d' +
                    ' )',
                	[I, I, I, I, I, I, I, I, I]
                );
            end;

            SQL.Text :=
            	'INSERT INTO db_sgci.pedido_venda_itens ' +
                '( ' +
                '	COD_ID_EMPRESA,' +
    			'	COD_ID_LOJA,' +
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

function TfrmTela_Principal.BuscarOuInserirFinalizadora(
    PaymentMethod: string;
    PaymentMethodTitle: string;
    CodIdEmpresa: Integer;
    CodIdLoja: Integer;
    CodIdCliente: Integer
): TFinalizadora;
var
    Query: TUniQuery;
    FinalizadoraID: Integer;
begin
    Query := nil;
    Result := nil;

    try
        Result := BuscarFinalizadorasDoBanco(
            PaymentMethodTitle,
            CodIdEmpresa,
            CodIdLoja
        );

        if Assigned(Result) then
        	Exit(Result);

        Query := CriarQuery;

        with Query do
        begin
            SQL.Text :=
                'INSERT INTO db_sgci.finalizadoras (' +
                '	COD_ID_EMPRESA,' +
                '	COD_ID_LOJA,' +
                '	COD_ID_CLIENTE,' +
                '	DSC_COMPLETA,' +
                '	DSC_ABREVIADA,' +
                '	NUM_ESPECIE,' +
                '	NUM_MODALIDADE ' +
                ')' +
                'VALUES (' +
                '	:COD_ID_EMPRESA,' +
                '	:COD_ID_LOJA,' +
                '	:COD_ID_CLIENTE,' +
                '	:DSC_COMPLETA,' +
                '	:DSC_ABREVIADA,' +
                '	:NUM_ESPECIE,' +
                '	:NUM_MODALIDADE ' +
                ') ' +
                'ON DUPLICATE KEY UPDATE ' +
                '	COD_ID_FINALIZADORA = LAST_INSERT_ID(COD_ID_FINALIZADORA)';

            ParamByName('COD_ID_EMPRESA').AsInteger := CodIdEmpresa;
            ParamByName('COD_ID_LOJA').AsInteger := CodIdLoja;
            ParamByName('COD_ID_CLIENTE').AsInteger := CodIdCliente;
            ParamByName('DSC_COMPLETA').AsString:= PaymentMethodTitle;

            if LowerCase(RemoverAcentos(PaymentMethodTitle))
            	.Contains('dinheiro') then
            begin
               ParamByName('NUM_ESPECIE').AsInteger := 0;
               ParamByName('DSC_ABREVIADA').AsString := 'DINHEIRO';
               ParamByName('NUM_MODALIDADE').AsInteger := 0;
            end
            else if LowerCase(RemoverAcentos(PaymentMethodTitle))
            	.Contains('cheque') then
            begin
                ParamByName('NUM_ESPECIE').AsInteger := 1;
                ParamByName('DSC_ABREVIADA').AsString := 'CHEQUE';
                ParamByName('NUM_MODALIDADE').AsInteger := 0;
            end
            else if LowerCase(RemoverAcentos(PaymentMethodTitle))
            	.Contains('cartao') then
            begin
                ParamByName('NUM_ESPECIE').AsInteger := 2;
                ParamByName('DSC_ABREVIADA').AsString := 'CARTAO';
                if LowerCase(RemoverAcentos(PaymentMethodTitle))
            		.Contains('credito')
                then
                	ParamByName('NUM_MODALIDADE').AsInteger := 0
                else
                   ParamByName('NUM_MODALIDADE').AsInteger := 1;
            end

            else if LowerCase(RemoverAcentos(PaymentMethodTitle))
            	.Contains('ticket') then
            begin
                ParamByName('NUM_ESPECIE').AsInteger := 3;
                ParamByName('DSC_ABREVIADA').AsString := 'TICKET ALIMENTAÇÃO/REF.';
                ParamByName('NUM_MODALIDADE').AsInteger := 0;
            end
            else if LowerCase(RemoverAcentos(PaymentMethodTitle))
            	.Contains('vale credito') then
            begin
            	ParamByName('NUM_ESPECIE').AsInteger := 4;
                ParamByName('DSC_ABREVIADA').AsString := 'VALE CRÉDITO';
                ParamByName('NUM_MODALIDADE').AsInteger := 0;
            end
            else if LowerCase(RemoverAcentos(PaymentMethodTitle))
            	.Contains('crediario') then
            begin
                ParamByName('NUM_ESPECIE').AsInteger := 5;
                ParamByName('DSC_ABREVIADA').AsString := 'CREDIARIO';
                ParamByName('NUM_MODALIDADE').AsInteger := 0;
            end
            else if LowerCase(RemoverAcentos(PaymentMethodTitle))
            	.Contains('convenio') then
            begin
            	ParamByName('NUM_ESPECIE').AsInteger := 6;
                ParamByName('DSC_ABREVIADA').AsString := 'CONVENIO';
                ParamByName('NUM_MODALIDADE').AsInteger := 0;
            end
            else if LowerCase(RemoverAcentos(PaymentMethodTitle))
            	.Contains('boleto') then
            begin
            	ParamByName('NUM_ESPECIE').AsInteger := 7;
                ParamByName('DSC_ABREVIADA').AsString := 'BOLETO';
                ParamByName('NUM_MODALIDADE').AsInteger := 0;
            end
            else if LowerCase(RemoverAcentos(PaymentMethodTitle))
            	.Contains('transferencia') then
            begin
            	ParamByName('NUM_ESPECIE').AsInteger := 8;
                ParamByName('DSC_ABREVIADA').AsString := 'DEPóSITO/TRANSFERÊNCIA';
                ParamByName('NUM_MODALIDADE').AsInteger := 0;
            end
            else if LowerCase(RemoverAcentos(PaymentMethodTitle))
            	.Contains('pix') then
            begin
            	ParamByName('NUM_ESPECIE').AsInteger := 10;
                ParamByName('DSC_ABREVIADA').AsString := 'PIX';
                ParamByName('NUM_MODALIDADE').AsInteger := 1;
            end
            else if LowerCase(RemoverAcentos(PaymentMethodTitle))
            	.Contains('carteira digital') then
            begin
                ParamByName('NUM_ESPECIE').AsInteger := 11;
                ParamByName('DSC_ABREVIADA').AsString := 'CARTEIRA DIGITAL';
                ParamByName('NUM_MODALIDADE').AsInteger := 0;
            end
            else
            begin
            	ParamByName('NUM_ESPECIE').AsInteger := 9;
                ParamByName('DSC_ABREVIADA').AsString := 'OUTRAS';
                ParamByName('NUM_MODALIDADE').AsInteger := 0;
            end;

            ExecSQL;
            SQL.Text := 'SELECT LAST_INSERT_ID() AS ID';
          	Open;
          	FinalizadoraID := Query.FieldByName('ID').AsInteger;
          	Close;

            SQL.Text := 'SELECT * FROM db_sgci.finalizadoras WHERE COD_ID_FINALIZADORA = :ID';
            ParamByName('ID').AsInteger := FinalizadoraID;
            Open;

            Result := SQLToFinalizadora(Query);
        end;
    finally
    	Query.Free;
    end;
end;

function TfrmTela_Principal.BuscarFinalizadorasDoBanco(
    PaymentMethodTtile: string;
    CodIdEmpresa: Integer;
    CodIdLoja: Integer
): TFinalizadora;
var
    Query: TUniQuery;
    DscCompleta: string;
    DscAbreviada: string;
begin
    Query := nil;
    Result := nil;

    try
        Query := CriarQuery;
        Query.SQL.Text :=
            'SELECT * FROM db_sgci.finalizadoras ' +
            'WHERE COD_ID_EMPRESA = :COD_ID_EMPRESA ' +
            '	AND COD_ID_LOJA = :COD_ID_LOJA';
        Query.ParamByName('COD_ID_EMPRESA').AsInteger := CodIdEmpresa;
        Query.ParamByName('COD_ID_LOJA').AsInteger := CodIdLoja;
        Query.Open;

        while not Query.Eof do
        begin
            DscCompleta := Query.FieldByName('DSC_COMPLETA').AsString;
            DscAbreviada := Query.FieldByName('DSC_ABREVIADA').AsString;

            if LowerCase(RemoverAcentos(PaymentMethodTtile))
            	.Contains(LowerCase(RemoverAcentos(DscCompleta))) and
               LowerCase(RemoverAcentos(PaymentMethodTtile))
            	.Contains(LowerCase(RemoverAcentos(DscAbreviada)))
            then
            begin
            	ShowMessage('FINALIZADORA ENCONTRADA');
                Result := SQLToFinalizadora(Query);
            end;

            Query.Next;
        end;

    finally
        Query.Free;
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
            Result.CodIdEmpresa := FieldByName('COD_ID_EMPRESA').AsInteger;
            Result.CodIdLoja := FieldByName('COD_ID_LOJA').AsInteger;
            Result.CodIdCliente := FieldByName('COD_ID_CLIENTE').AsInteger;
            Result.DscCompleta := FieldByName('DSC_COMPLETA').AsString;
            Result.DscAbreviada := FieldByName('DSC_ABREVIADA').AsString;
            Result.NumEspecie := FieldByName('NUM_ESPECIE').AsInteger;
            Result.NumModalidade := FieldByName('NUM_MODALIDADE').AsInteger;
        end;

         ShowMessage(
         	'COD_ID_FINALIZADORA: ' + Result.CodIdFinalizadora.ToString + sLineBreak +
            'DSC_COMPLETA: ' + Result.DscCompleta + sLineBreak +
            'DSC_ABREVIADA:' + Result.DscAbreviada
         );
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
            '	NUM_STATUS' +
            ' ) ' +
            'VALUES (' +
            '	:COD_ID_EMPRESA,' +
            '	:COD_ID_LOJA,' +
            '	:COD_ID_PEDIDO,' +
            '	:COD_ID_FINALIZADORA,' +
            '	:DAT_PAGAMENTO,' +
            '	:NUM_VALOR_PAGO,' +
            '	:NUM_STATUS' +
            ' ) ' +
            'ON DUPLICATE KEY UPDATE' +
            '	COD_ID_PAGAMENTO = LAST_INSERT_ID(COD_ID_PAGAMENTO)';

            ParamByName('COD_ID_EMPRESA').AsInteger := CodIdEmpresa;
            ParamByName('COD_ID_LOJA').AsInteger := CodIdLoja;
            ParamByName('COD_ID_PEDIDO').AsLargeInt := CodIdPedido;
            ParamByName('COD_ID_FINALIZADORA').AsInteger := CodIdFinalizadora;
            ParamByName('DAT_PAGAMENTO').AsDateTime := DataPagamento;
            ParamByName('NUM_VALOR_PAGO').AsCurrency := ValorPedido;

//          Status temporário - Deve ser definido de acordo com a situação
//			do pagamento do pedido (Pago / Não Pago)
            ParamByName('NUM_STATUS').AsInteger := 0;

            ExecSQL;
        end;
    except
        Result.Free;
        raise;
    end;
end;
// Fim das funções para salvar pedido

procedure TfrmTela_Principal.HorseAPIAtualizarProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
	QuerySelect: TuniQuery;
    QueryUpdate: TUniQuery;
    ProdutoResposta: TWooProdutoResponse;
    ProdutoDB: TProduto;
begin
    QuerySelect := nil;
    QueryUpdate := nil;
    ProdutoResposta := nil;
    ProdutoDB := nil;

    try
    	try
        	if ChecarBodyDoWebhook(Req.Body) then
                SalvarConteudoEmArquivo(
                    TPath.Combine(TPath.GetDocumentsPath, 'produto-payload.txt'),
                    Req.Body
                 );
            ProdutoResposta :=  TJson.JsonToObject<TWooProdutoResponse>(Req.Body);


            frmTela_Principal.Database.StartTransaction;

            try
            	QuerySelect := frmTela_Principal.CriarQuery;
            	QuerySelect.SQL.Text :=
            	'SELECT * FROM db_sgci.produtos WHERE ' +
                    'COD_ID_EMPRESA = 2433 ' +
                    'AND COD_ID_LOJA = 90 ' +
                    'AND COD_PRODUTO = :SITE_SKU_PRODUTO';
                QuerySelect.ParamByName('SITE_SKU_PRODUTO').AsLargeInt :=  ProdutoResposta.Sku.ToInt64;
                QuerySelect.Open;

                if QuerySelect.IsEmpty then
                    raise Exception.Create(
                        Format(
                            'Não há produto cadastrado com o COD_PRODUTO %d',
                            [ProdutoResposta.Sku.ToInteger]
                        )
                    );

                ProdutoDB := ProdutoQueryToProduto(QuerySelect);
                ProdutoDB.DscCompleta := ProdutoResposta.Name;

                QueryUpdate := frmTela_Principal.CriarQuery;
                QueryUpdate.SQL.Text :=
                'UPDATE db_sgci.produtos ' +
                'SET DSC_COMPLETA = :DSC_COMPLETA WHERE ' +
                	'COD_ID_EMPRESA = 2433 ' +
                	'AND COD_ID_LOJA = 90 ' +
                    'AND COD_PRODUTO = :COD_PRODUTO';

                QueryUpdate.ParamByName('DSC_COMPLETA').AsString :=  ProdutoDB.DscCompleta;
                QueryUpdate.ParamByName('COD_PRODUTO').AsLargeInt :=  ProdutoDB.CodProduto;
                QueryUpdate.ExecSQL;

                 if QueryUpdate.RowsAffected = 0 then
                 	raise Exception.Create('Produto não foi atualizado');

                frmTela_Principal.Database.Commit;

                Res.Status(THTTPStatus.OK).Send('Produto atualizado com sucesso');
            except
               frmTela_Principal.Database.Rollback;
               raise;
            end;
    	except
    		on E: Exception do
        		Res.Status(THTTPStatus.InternalServerError).Send('Erro ao cadastrar usuário!\n' + E.Message);
    	end;
    finally
    	QueryUpdate.Free;
        ProdutoDB.Free;
    	QuerySelect.Free;
        ProdutoResposta.Free;
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

procedure TfrmTela_Principal.DatabaseConnectionLost(Sender: TObject; Component: TComponent;
  ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
begin
  RetryMode := rmReconnectExecute;
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

            SalvarConteudoEmArquivo(TPath.Combine(TPath.GetDocumentsPath, 'produto-por-sku.txt'), JSONArray.ToJSON);
        except
        	Result.Free;
            raise;
        end;
    finally
        JSONArray.Free;
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
  QueryProdutos: TUniQuery;
begin
    QueryProdutos := nil;

    try
        QueryProdutos := CriarQuery;

    	with QueryProdutos do
    	begin
        	SQL.Text :=
                'SELECT pd.COD_ID_PRODUTO, ' +
                'pd.COD_ID_EMPRESA, ' +
                'pd.COD_ID_LOJA, ' +
                'pd.COD_PRODUTO, ' +
                'pd.COD_BARRAS, ' +
                'pd.COD_ID_GRADE, ' +
                'pd.COD_ID_SECAO, ' +
                'pd.DSC_COMPLETA, ' +
                'pd.NUM_TIPO_PRODUTO, ' +
                'pr.NUM_PRECO_VAREJO AS PRECO_VAREJO, ' +
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
                    '0.000 ' +
                'END AS ESTOQUE_ATUAL ' +
                'FROM db_sgci.produtos pd ' +
                'INNER JOIN db_sgci.precos pr ' +
                    'ON pd.COD_ID_PRODUTO = pr.COD_ID_PRODUTO ' +
                    'AND pd.COD_ID_EMPRESA = pr.COD_ID_EMPRESA ' +
                    'AND pd.COD_ID_LOJA = pr.COD_ID_LOJA ' +
                'LEFT JOIN db_sgci.estoques e ' +
                    'ON pd.COD_ID_PRODUTO = e.COD_ID_PRODUTO ' +
                    'AND pd.COD_ID_EMPRESA = e.COD_ID_EMPRESA ' +
                    'AND pd.COD_ID_LOJA = e.COD_ID_LOJA ' +
                'INNER JOIN db_sgci.empresas emp ' +
                    'ON emp.COD_ID_EMPRESA = pd.COD_ID_EMPRESA ' +
                'INNER JOIN db_sgci.lojas lj ' +
                    'ON lj.COD_ID_EMPRESA = pd.COD_ID_EMPRESA ' +
                    'AND lj.COD_ID_LOJA = pd.COD_ID_LOJA ' +
                'WHERE pd.COD_ID_EMPRESA = 2433 ' +
                    'AND pd.COD_ID_LOJA = 90 ' +
                'LIMIT 5';
            Open;
            SaveToXML(TPath.Combine(TPath.GetDocumentsPath, 'produto-com-preco-e-estoque.xml'));

            while not Eof do
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
                    ProdutoDB := TProduto.Create;
                    ProdutoDB.CodIdProduto := FieldByName('COD_ID_PRODUTO').AsInteger;
                    ProdutoDB.CodIdEmpresa := FieldByName('COD_ID_EMPRESA').AsInteger;
                    ProdutoDB.CodIdLoja := FieldByName('COD_ID_LOJA').AsInteger;
                    ProdutoDB.CodProduto := FieldByName('COD_PRODUTO').AsLargeInt;
                    ProdutoDB.CodBarras := FieldByName('COD_BARRAS').AsString;
                    ProdutoDB.CodIdGrade := FieldByName('COD_ID_GRADE').AsInteger;
                    ProdutoDB.CodIdSecao := FieldByName('COD_ID_SECAO').AsInteger;
                    ProdutoDB.DscCompleta := FieldByName('DSC_COMPLETA').AsString;
                    ProdutoDB.NumTipoProduto := FieldByName('NUM_TIPO_PRODUTO').AsInteger;
                    ProdutoDB.NumPrecoVarejo := FieldByName('PRECO_VAREJO').AsCurrency;
                    ProdutoDB.NumEstqAtual := FieldByName('ESTOQUE_ATUAL').AsFloat;

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

procedure TfrmTela_Principal.OnFormDestroy(Sender: TObject);
begin
    if THorse.IsRunning then
    	THorse.StopListen;
end;

end.

