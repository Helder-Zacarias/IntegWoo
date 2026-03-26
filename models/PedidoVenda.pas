unit PedidoVenda;

interface

uses
  System.SysUtils;

type
	TPedidoVenda = class
    private
    	FCOD_ID_PEDIDO: Int64;
        FCOD_ID_PEDIDO_SITE: string;
        FCOD_ID_EMPRESA: Integer;
        FCOD_ID_LOJA: Integer;
        FCOD_ID_LOJA_FILIAL: Integer;
        FCOD_ID_CAIXA: Integer;
        FCOD_ID_USUARIO: Integer;
        FCOD_ID_NFE: Int64;
        FCOD_ID_NATUREZA: Integer;
        FCOD_ID_VENDEDOR: Integer;
        FCOD_ID_CLIENTE: Integer;
        FCOD_IDENTIFICADOR: string;
        FCOD_ID_PEDIDO_PV: Int64;
        FNUM_PV_DAV: Int64;
        FNUM_FICHA_MESA: Integer;
        FCOD_OPERACAO: Integer;
        FDAT_PEDIDO: TDateTime;
        FDAT_INCLUSAO: TDateTime;
        FDAT_SINCRONIZACAO: TDateTime;
        FDSC_NOME_PORTADOR: string;
        FNUM_ENTREGA: Integer;
        FCOD_ID_ENTREGA: Int64;
        FDSC_ENTREGA_NOME: string;
        FDSC_ENTREGA_ENDERECO: string;
        FDSC_ENTREGA_TELEFONE: string;
        FDSC_ENTREGA_CELULAR: string;
        FDSC_ENTREGA_OBS: string;
        FNUM_ENTREGA_VALOR: Double;
        FDAT_ENTREGA: TDateTime;
        FDSC_TIPO_DESCONTO: string;
        FNUM_VALOR_DESCONTO: Double;
        FNUM_TAXA_SERVICO: Double;
        FNUM_VALOR_COUVERT: Double;
        FNUM_VALOR_TROCO: Double;
        FCOD_FINALIZADORA: Integer;
        FNUM_PARCELAS: Integer;
        FNUM_VALOR_DINHEIRO: Double;
        FNUM_VALOR_CHEQUE: Double;
        FNUM_PARCELAS_CHEQUE: Integer;
        FNUM_VALOR_CARTAO: Double;
        FNUM_PARCELAS_CARTAO: Integer;
        FNUM_VALOR_PROMISSORIA: Double;
        FNUM_PARCELAS_PROMISSORIA: Integer;
        FNUM_VALOR_VALE_CREDITO: Double;
        FCOD_ID_VALE_CREDITO: Integer;
        FDSC_OBSERVACOES: string;
        FNUM_PEDIDO_WEB: Integer;
        FNUM_VALIDADE_ORCAMENTO: Integer;
        FNUM_INDC: Integer;
        FNUM_INDC_PRESENCA: Integer;
        FNUM_PBM: Integer;
        FNUM_DEVOLUCAO: Integer;
        FNUM_TIPO_PEDIDO: Integer;
        FNUM_MODO_FATURAMENTO: Integer;
        FNUM_TIPO_CONTA: Integer;
        FNUM_TIPO_FATURAMENTO: Integer;
        FNUM_STATUS_FINANCEIRO: Integer;
        FNUM_STATUS_PRODUCAO: Integer;
        FCOD_ID_STATUS_ENTREGA: Integer;
        FNUM_STATUS_PEDIDO: Integer;
        FDSC_CHAVE: string;
	public
    	property CodIdPedido: Int64 read FCOD_ID_PEDIDO write FCOD_ID_PEDIDO;
        property CodIdPedidoSite: string read FCOD_ID_PEDIDO_SITE write FCOD_ID_PEDIDO_SITE;
        property CodIdEmpresa: Integer read FCOD_ID_EMPRESA write FCOD_ID_EMPRESA;
        property CodIdLoja: Integer read FCOD_ID_LOJA write FCOD_ID_LOJA;
        property CodIdLojaFilial: Integer read FCOD_ID_LOJA_FILIAL write FCOD_ID_LOJA_FILIAL;
        property CodIdCaixa: Integer read FCOD_ID_CAIXA write FCOD_ID_CAIXA;
        property CodIdUsuario: Integer read FCOD_ID_USUARIO write FCOD_ID_USUARIO;
        property CodIdNfe: Int64 read FCOD_ID_NFE write FCOD_ID_NFE;
        property CodIdNatureza: Integer read FCOD_ID_NATUREZA write FCOD_ID_NATUREZA;
        property CodIdVendedor: Integer read FCOD_ID_VENDEDOR write FCOD_ID_VENDEDOR;
        property CodIdCliente: Integer read FCOD_ID_CLIENTE write FCOD_ID_CLIENTE;
        property CodIdentificador: string read FCOD_IDENTIFICADOR write FCOD_IDENTIFICADOR;
        property CodIdPedidoPv: Int64 read FCOD_ID_PEDIDO_PV write FCOD_ID_PEDIDO_PV;
        property NumPvDav: Int64 read FNUM_PV_DAV write FNUM_PV_DAV;
        property NumFichaMesa: Integer read FNUM_FICHA_MESA write FNUM_FICHA_MESA;
        property CodOperacao: Integer read FCOD_OPERACAO write FCOD_OPERACAO;
        property DatPedido: TDateTime read FDAT_PEDIDO write FDAT_PEDIDO;
        property DatInclusao: TDateTime read FDAT_INCLUSAO write FDAT_INCLUSAO;
        property DatSincronizacao: TDateTime read FDAT_SINCRONIZACAO write FDAT_SINCRONIZACAO;
        property DscNomePortador: string read FDSC_NOME_PORTADOR write FDSC_NOME_PORTADOR;
        property NumEntrega: Integer read FNUM_ENTREGA write FNUM_ENTREGA;
        property CodIdEntrega: Int64 read FCOD_ID_ENTREGA write FCOD_ID_ENTREGA;
        property DscEntregaNome: string read FDSC_ENTREGA_NOME write FDSC_ENTREGA_NOME;
        property DscEntregaEndereco: string read FDSC_ENTREGA_ENDERECO write FDSC_ENTREGA_ENDERECO;
        property DscEntregaTelefone: string read FDSC_ENTREGA_TELEFONE write FDSC_ENTREGA_TELEFONE;
        property DscEntregaCelular: string read FDSC_ENTREGA_CELULAR write FDSC_ENTREGA_CELULAR;
        property DscEntregaObs: string read FDSC_ENTREGA_OBS write FDSC_ENTREGA_OBS;
        property NumEntregaValor: Double read FNUM_ENTREGA_VALOR write FNUM_ENTREGA_VALOR;
        property DatEntrega: TDateTime read FDAT_ENTREGA write FDAT_ENTREGA;
        property DscTipoDesconto: string read FDSC_TIPO_DESCONTO write FDSC_TIPO_DESCONTO;
        property NumValorDesconto: Double read FNUM_VALOR_DESCONTO write FNUM_VALOR_DESCONTO;
        property NumTaxaServico: Double read FNUM_TAXA_SERVICO write FNUM_TAXA_SERVICO;
        property NumValorCouvert: Double read FNUM_VALOR_COUVERT write FNUM_VALOR_COUVERT;
        property NumValorTroco: Double read FNUM_VALOR_TROCO write FNUM_VALOR_TROCO;
        property CodFinalizadora: Integer read FCOD_FINALIZADORA write FCOD_FINALIZADORA;
        property NumParcelas: Integer read FNUM_PARCELAS write FNUM_PARCELAS;
        property NumValorDinheiro: Double read FNUM_VALOR_DINHEIRO write FNUM_VALOR_DINHEIRO;
        property NumValorCheque: Double read FNUM_VALOR_CHEQUE write FNUM_VALOR_CHEQUE;
        property NumParcelasCheque: Integer read FNUM_PARCELAS_CHEQUE write FNUM_PARCELAS_CHEQUE;
        property NumValorCartao: Double read FNUM_VALOR_CARTAO write FNUM_VALOR_CARTAO;
        property NumParcelasCartao: Integer read FNUM_PARCELAS_CARTAO write FNUM_PARCELAS_CARTAO;
        property NumValorPromissoria: Double read FNUM_VALOR_PROMISSORIA write FNUM_VALOR_PROMISSORIA;
        property NumParcelasPromissoria: Integer read FNUM_PARCELAS_PROMISSORIA write FNUM_PARCELAS_PROMISSORIA;
        property NumValorValeCredito: Double read FNUM_VALOR_VALE_CREDITO write FNUM_VALOR_VALE_CREDITO;
        property CodIdValeCredito: Integer read FCOD_ID_VALE_CREDITO write FCOD_ID_VALE_CREDITO;
        property DscObservacoes: string read FDSC_OBSERVACOES write FDSC_OBSERVACOES;
        property NumPedidoWeb: Integer read FNUM_PEDIDO_WEB write FNUM_PEDIDO_WEB;
        property NumValidadeOrcamento: Integer read FNUM_VALIDADE_ORCAMENTO write FNUM_VALIDADE_ORCAMENTO;
        property NumIndc: Integer read FNUM_INDC write FNUM_INDC;
        property NumIndcPresenca: Integer read FNUM_INDC_PRESENCA write FNUM_INDC_PRESENCA;
        property NumPbm: Integer read FNUM_PBM write FNUM_PBM;
        property NumDevolucao: Integer read FNUM_DEVOLUCAO write FNUM_DEVOLUCAO;
        property NumTipoPedido: Integer read FNUM_TIPO_PEDIDO write FNUM_TIPO_PEDIDO;
        property NumModoFaturamento: Integer read FNUM_MODO_FATURAMENTO write FNUM_MODO_FATURAMENTO;
        property NumTipoConta: Integer read FNUM_TIPO_CONTA write FNUM_TIPO_CONTA;
        property NumTipoFaturamento: Integer read FNUM_TIPO_FATURAMENTO write FNUM_TIPO_FATURAMENTO;
        property NumStatusFinanceiro: Integer read FNUM_STATUS_FINANCEIRO write FNUM_STATUS_FINANCEIRO;
        property NumStatusProducao: Integer read FNUM_STATUS_PRODUCAO write FNUM_STATUS_PRODUCAO;
        property CodIdStatusEntrega: Integer read FCOD_ID_STATUS_ENTREGA write FCOD_ID_STATUS_ENTREGA;
        property NumStatusPedido: Integer read FNUM_STATUS_PEDIDO write FNUM_STATUS_PEDIDO;
        property DscChave: string read FDSC_CHAVE write FDSC_CHAVE;
	end;

implementation

end.
