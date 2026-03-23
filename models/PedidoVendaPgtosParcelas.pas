unit PedidoVendaPgtosParcelas;

interface
type
	TPedidoVendaPgtosParcelas = class
    private
    	FCOD_ID_PARCELA: Int64;
        FCOD_ID_EMPRESA: Integer;
        FCOD_ID_LOJA: Integer;
        FCOD_ID_CAIXA: Integer;
        FCOD_ID_USUARIO: Integer;
        FCOD_ID_PEDIDO: Int64;
        FCOD_ID_PAGAMENTO: Int64;
        FCOD_ID_CLIENTE: Integer;
        FCOD_ID_PLANO: Integer;
        FCOD_ID_CENTRO: Integer;
        FDSC_NUM_DOCUMENTO: string;
        FDSC_NUM_PROMISSORIA: string;
        FCOD_CMC7: string;
        FCOD_ID_FINALIZADORA: Integer;
        FDAT_LANCAMENTO: TDateTime;
        FDAT_VENCIMENTO: TDate;
        FCOD_NSU_HOST: string;
        FCOD_NSU_CARTAO: string;
        FCOD_AUT_CARTAO: string;
        FCOD_ID_BANDEIRA: Int64;
        FDSC_BANDEIRA: string;
        FNUM_MODALIDADE: Integer;
        FNUM_PARCELA: Integer;
        FNUM_PARCELAS: Integer;
        FNUM_VALOR_PRINCIPAL: Double;
        FNUM_VALOR_PARCELA: Double;
        FNUM_INDC: Integer;
    public
        property CodIdParcela: Int64 read FCOD_ID_PARCELA write FCOD_ID_PARCELA;
        property CodIdEmpresa: Integer read FCOD_ID_EMPRESA write FCOD_ID_EMPRESA;
        property CodIdLoja: Integer read FCOD_ID_LOJA write FCOD_ID_LOJA;
        property CodIdCaixa: Integer read FCOD_ID_CAIXA write FCOD_ID_CAIXA;
        property CodIdUsuario: Integer read FCOD_ID_USUARIO write FCOD_ID_USUARIO;
        property CodIdPedido: Int64 read FCOD_ID_PEDIDO write FCOD_ID_PEDIDO;
        property CodIdPagamento: Int64 read FCOD_ID_PAGAMENTO write FCOD_ID_PAGAMENTO;
        property CodIdCliente: Integer read FCOD_ID_CLIENTE write FCOD_ID_CLIENTE;
        property CodIdPlano: Integer read FCOD_ID_PLANO write FCOD_ID_PLANO;
        property CodIdCentro: Integer read FCOD_ID_CENTRO write FCOD_ID_CENTRO;
        property DscNumDocumento: string read FDSC_NUM_DOCUMENTO write FDSC_NUM_DOCUMENTO;
        property DscNumPromissoria: string read FDSC_NUM_PROMISSORIA write FDSC_NUM_PROMISSORIA;
        property CodCmc7: string read FCOD_CMC7 write FCOD_CMC7;
        property CodIdFinalizadora: Integer read FCOD_ID_FINALIZADORA write FCOD_ID_FINALIZADORA;
        property DatLancamento: TDateTime read FDAT_LANCAMENTO write FDAT_LANCAMENTO;
        property DatVencimento: TDate read FDAT_VENCIMENTO write FDAT_VENCIMENTO;
        property CodNsuHost: string read FCOD_NSU_HOST write FCOD_NSU_HOST;
        property CodNsuCartao: string read FCOD_NSU_CARTAO write FCOD_NSU_CARTAO;
        property CodAutCartao: string read FCOD_AUT_CARTAO write FCOD_AUT_CARTAO;
        property CodIdBandeira: Int64 read FCOD_ID_BANDEIRA write FCOD_ID_BANDEIRA;
        property DscBandeira: string read FDSC_BANDEIRA write FDSC_BANDEIRA;
        property NumModalidade: Integer read FNUM_MODALIDADE write FNUM_MODALIDADE;
        property NumParcela: Integer read FNUM_PARCELA write FNUM_PARCELA;
        property NumParcelas: Integer read FNUM_PARCELAS write FNUM_PARCELAS;
        property NumValorPrincipal: Double read FNUM_VALOR_PRINCIPAL write FNUM_VALOR_PRINCIPAL;
        property NumValorParcela: Double read FNUM_VALOR_PARCELA write FNUM_VALOR_PARCELA;
        property NumIndc: Integer read FNUM_INDC write FNUM_INDC;
  end;
implementation

end.
