unit PedidoVendaPgtos;

interface

uses
	System.SysUtils;

type
	TPedidoVendaPgtos = class
    private
    	FCOD_ID_PAGAMENTO: Int64;
    	FCOD_ID_EMPRESA: Integer;
        FCOD_ID_LOJA: Integer;
        FCOD_ID_CAIXA: Integer;
        FCOD_ID_PEDIDO: Int64;
        FDAT_PAGAMENTO: TDateTime;
        FCOD_ID_FINALIZADORA: Integer;
        FCOD_FINALIZADORA: Integer;
        FDSC_FINALIZADORA: string;
        FNUM_PARCELAS: Integer;
        FNUM_ESPECIE: Integer;
        FCOD_ID_BANDEIRA: Int64;
        FDSC_BANDEIRA: string;
        FCOD_AUT_CARTAO: string;
        FCOD_NSU_CARTAO: string;
        FCOD_ID_CLIENTE: Integer;
        FCOD_ID_VALE_CREDITO: Integer;
        FNUM_VALOR_PAGO: Double;
        FNUM_VALOR_PARCELA: Double;
        FNUM_VALOR_TROCO: Double;
        FNUM_VALOR_COMISSAO: Double;
        FNUM_PODE_EXCLUIR: Integer;
        FDSC_OBSERVACOES: string;
        FNUM_INDC: Integer;
        FNUM_STATUS: Integer;

        public
        property CodIdPagamento: Int64 read FCOD_ID_PAGAMENTO write FCOD_ID_PAGAMENTO;
        property CodIdEmpresa: Integer read FCOD_ID_EMPRESA write FCOD_ID_EMPRESA;
        property CodIdLoja: Integer read FCOD_ID_LOJA write FCOD_ID_LOJA;
        property CodIdCaixa: Integer read FCOD_ID_CAIXA write FCOD_ID_CAIXA;
        property CodIdPedido: Int64 read FCOD_ID_PEDIDO write FCOD_ID_PEDIDO;
        property DatPagamento: TDateTime read FDAT_PAGAMENTO write FDAT_PAGAMENTO;
        property CodIdFinalizadora: Integer read FCOD_ID_FINALIZADORA write FCOD_ID_FINALIZADORA;
        property CodFinalizadora: Integer read FCOD_FINALIZADORA write FCOD_FINALIZADORA;
        property DscFinalizadora: string read FDSC_FINALIZADORA write FDSC_FINALIZADORA;
        property NumParcelas: Integer read FNUM_PARCELAS write FNUM_PARCELAS;
        property NumEspecie: Integer read FNUM_ESPECIE write FNUM_ESPECIE;
        property CodIdBandeira: Int64 read FCOD_ID_BANDEIRA write FCOD_ID_BANDEIRA;
        property DscBandeira: string read FDSC_BANDEIRA write FDSC_BANDEIRA;
        property CodAutCartao: string read FCOD_AUT_CARTAO write FCOD_AUT_CARTAO;
        property CodNsuCartao: string read FCOD_NSU_CARTAO write FCOD_NSU_CARTAO;
        property CodIdCliente: Integer read FCOD_ID_CLIENTE write FCOD_ID_CLIENTE;
        property CodIdValeCredito: Integer read FCOD_ID_VALE_CREDITO write FCOD_ID_VALE_CREDITO;
        property NumValorPago: Double read FNUM_VALOR_PAGO write FNUM_VALOR_PAGO;
        property NumValorParcela: Double read FNUM_VALOR_PARCELA write FNUM_VALOR_PARCELA;
        property NumValorTroco: Double read FNUM_VALOR_TROCO write FNUM_VALOR_TROCO;
        property NumValorComissao: Double read FNUM_VALOR_COMISSAO write FNUM_VALOR_COMISSAO;
        property NumPodeExcluir: Integer read FNUM_PODE_EXCLUIR write FNUM_PODE_EXCLUIR;
        property DscObservacoes: string read FDSC_OBSERVACOES write FDSC_OBSERVACOES;
        property NmIndc: Integer read FNUM_INDC write FNUM_INDC;
        property NumStatus: Integer read FNUM_STATUS write FNUM_STATUS;
end;

implementation

end.
