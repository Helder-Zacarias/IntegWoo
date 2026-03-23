unit PedidoVenda;

interface

uses
  System.SysUtils;

type
	TPedidoVenda = class
    private
    	COD_ID_PEDIDO: Int64;
        COD_ID_EMPRESA: Integer;
        COD_ID_LOJA: Integer;
        COD_ID_LOJA_FILIAL: Integer;
        COD_ID_CAIXA: Integer;
        COD_ID_USUARIO: Integer;
        COD_ID_NFE: Int64;
        COD_ID_NATUREZA: Integer;
        COD_ID_VENDEDOR: Integer;
        COD_ID_CLIENTE: Integer;
        COD_IDENTIFICADOR: string;
        COD_ID_PEDIDO_PV: Int64;
        NUM_PV_DAV: Int64;
        NUM_FICHA_MESA: Integer;
        COD_OPERACAO: Integer;
        DAT_PEDIDO: TDateTime;
        DAT_INCLUSAO: TDateTime;
        DAT_SINCRONIZACAO: TDateTime;
        DSC_NOME_PORTADOR: string;
        NUM_ENTREGA: Integer;
        COD_ID_ENTREGA: Int64;
        DSC_ENTREGA_NOME: string;
        DSC_ENTREGA_ENDERECO: string;
        DSC_ENTREGA_TELEFONE: string;
        DSC_ENTREGA_CELULAR: string;
        DSC_ENTREGA_OBS: string;
        NUM_ENTREGA_VALOR: Double;
        DAT_ENTREGA: TDateTime;
        DSC_TIPO_DESCONTO: string;
        NUM_VALOR_DESCONTO: Double;
        NUM_TAXA_SERVICO: Double;
        NUM_VALOR_COUVERT: Double;
        NUM_VALOR_TROCO: Double;
        COD_FINALIZADORA: Integer;
        NUM_PARCELAS: Integer;
        NUM_VALOR_DINHEIRO: Double;
        NUM_VALOR_CHEQUE: Double;
        NUM_PARCELAS_CHEQUE: Integer;
        NUM_VALOR_CARTAO: Double;
        NUM_PARCELAS_CARTAO: Integer;
        NUM_VALOR_PROMISSORIA: Double;
        NUM_PARCELAS_PROMISSORIA: Integer;
        NUM_VALOR_VALE_CREDITO: Double;
        COD_ID_VALE_CREDITO: Integer;
        DSC_OBSERVACOES: string;
        NUM_PEDIDO_WEB: Integer;
        NUM_VALIDADE_ORCAMENTO: Integer;
        NUM_INDC: Integer;
        NUM_INDC_PRESENCA: Integer;
        NUM_PBM: Integer;
        NUM_DEVOLUCAO: Integer;
        NUM_TIPO_PEDIDO: Integer;
        NUM_MODO_FATURAMENTO: Integer;
        NUM_TIPO_CONTA: Integer;
        NUM_TIPO_FATURAMENTO: Integer;
        NUM_STATUS_FINANCEIRO: Integer;
        NUM_STATUS_PRODUCAO: Integer;
        COD_ID_STATUS_ENTREGA: Integer;
        NUM_STATUS_PEDIDO: Integer;
        DSC_CHAVE: string;
    public
    	property CodIdPedido: Int64 read COD_ID_PEDIDO write COD_ID_PEDIDO;
        property CodIdEmpresa: Integer read COD_ID_EMPRESA write COD_ID_EMPRESA;
        property CodIdLoja: Integer read COD_ID_LOJA write COD_ID_LOJA;
        property CodIdLojaFilial: Integer read COD_ID_LOJA_FILIAL write COD_ID_LOJA_FILIAL;
        property CodIdCaixa: Integer read COD_ID_CAIXA write COD_ID_CAIXA;
        property CodIdUsuario: Integer read COD_ID_USUARIO write COD_ID_USUARIO;
        property CodIdNfe: Int64 read COD_ID_NFE write COD_ID_NFE;
        property CodIdNatureza: Integer read COD_ID_NATUREZA write COD_ID_NATUREZA;
        property CodIdVendedor: Integer read COD_ID_VENDEDOR write COD_ID_VENDEDOR;
        property CodIdCliente: Integer read COD_ID_CLIENTE write COD_ID_CLIENTE;
        property CodIdentificador: string read COD_IDENTIFICADOR write COD_IDENTIFICADOR;
        property CodIdPedidoPv: Int64 read COD_ID_PEDIDO_PV write COD_ID_PEDIDO_PV;
        property NumPvDav: Int64 read NUM_PV_DAV write NUM_PV_DAV;
        property NumFichaMesa: Integer read NUM_FICHA_MESA write NUM_FICHA_MESA;
        property CodOperacao: Integer read COD_OPERACAO write COD_OPERACAO;
        property DatPedido: TDateTime read DAT_PEDIDO write DAT_PEDIDO;
        property DatInclusao: TDateTime read DAT_INCLUSAO write DAT_INCLUSAO;
        property DatSincronizacao: TDateTime read DAT_SINCRONIZACAO write DAT_SINCRONIZACAO;
        property DscNomePortador: string read DSC_NOME_PORTADOR write DSC_NOME_PORTADOR;
        property NumEntrega: Integer read NUM_ENTREGA write NUM_ENTREGA;
        property CodIdEntrega: Int64 read COD_ID_ENTREGA write COD_ID_ENTREGA;
        property DscEntregaNome: string read DSC_ENTREGA_NOME write DSC_ENTREGA_NOME;
        property DscEntregaEndereco: string read DSC_ENTREGA_ENDERECO write DSC_ENTREGA_ENDERECO;
        property DscEntregaTelefone: string read DSC_ENTREGA_TELEFONE write DSC_ENTREGA_TELEFONE;
        property DscEntregaCelular: string read DSC_ENTREGA_CELULAR write DSC_ENTREGA_CELULAR;
        property DscEntregaObs: string read DSC_ENTREGA_OBS write DSC_ENTREGA_OBS;
        property NumEntregaValor: Double read NUM_ENTREGA_VALOR write NUM_ENTREGA_VALOR;
        property DatEntrega: TDateTime read DAT_ENTREGA write DAT_ENTREGA;
        property DscTipoDesconto: string read DSC_TIPO_DESCONTO write DSC_TIPO_DESCONTO;
        property NumValorDesconto: Double read NUM_VALOR_DESCONTO write NUM_VALOR_DESCONTO;
        property NumTaxaServico: Double read NUM_TAXA_SERVICO write NUM_TAXA_SERVICO;
        property NumValorCouvert: Double read NUM_VALOR_COUVERT write NUM_VALOR_COUVERT;
        property NumValorTroco: Double read NUM_VALOR_TROCO write NUM_VALOR_TROCO;
        property CodFinalizadora: Integer read COD_FINALIZADORA write COD_FINALIZADORA;
        property NumParcelas: Integer read NUM_PARCELAS write NUM_PARCELAS;
        property NumValorDinheiro: Double read NUM_VALOR_DINHEIRO write NUM_VALOR_DINHEIRO;
        property NumValorCheque: Double read NUM_VALOR_CHEQUE write NUM_VALOR_CHEQUE;
        property NumParcelasCheque: Integer read NUM_PARCELAS_CHEQUE write NUM_PARCELAS_CHEQUE;
        property NumValorCartao: Double read NUM_VALOR_CARTAO write NUM_VALOR_CARTAO;
        property NumParcelasCartao: Integer read NUM_PARCELAS_CARTAO write NUM_PARCELAS_CARTAO;
        property NumValorPromissoria: Double read NUM_VALOR_PROMISSORIA write NUM_VALOR_PROMISSORIA;
        property NumParcelasPromissoria: Integer read NUM_PARCELAS_PROMISSORIA write NUM_PARCELAS_PROMISSORIA;
        property NumValorValeCredito: Double read NUM_VALOR_VALE_CREDITO write NUM_VALOR_VALE_CREDITO;
        property CodIdValeCredito: Integer read COD_ID_VALE_CREDITO write COD_ID_VALE_CREDITO;
        property DscObservacoes: string read DSC_OBSERVACOES write DSC_OBSERVACOES;
        property NumPedidoWeb: Integer read NUM_PEDIDO_WEB write NUM_PEDIDO_WEB;
        property NumValidadeOrcamento: Integer read NUM_VALIDADE_ORCAMENTO write NUM_VALIDADE_ORCAMENTO;
        property NumIndc: Integer read NUM_INDC write NUM_INDC;
        property NumIndcPresenca: Integer read NUM_INDC_PRESENCA write NUM_INDC_PRESENCA;
        property NumPbm: Integer read NUM_PBM write NUM_PBM;
        property NumDevolucao: Integer read NUM_DEVOLUCAO write NUM_DEVOLUCAO;
        property NumTipoPedido: Integer read NUM_TIPO_PEDIDO write NUM_TIPO_PEDIDO;
        property NumModoFaturamento: Integer read NUM_MODO_FATURAMENTO write NUM_MODO_FATURAMENTO;
        property NumTipoConta: Integer read NUM_TIPO_CONTA write NUM_TIPO_CONTA;
        property NumTipoFaturamento: Integer read NUM_TIPO_FATURAMENTO write NUM_TIPO_FATURAMENTO;
        property NumStatusFinanceiro: Integer read NUM_STATUS_FINANCEIRO write NUM_STATUS_FINANCEIRO;
        property NumStatusProducao: Integer read NUM_STATUS_PRODUCAO write NUM_STATUS_PRODUCAO;
        property CodIdStatusEntrega: Integer read COD_ID_STATUS_ENTREGA write COD_ID_STATUS_ENTREGA;
        property NumStatusPedido: Integer read NUM_STATUS_PEDIDO write NUM_STATUS_PEDIDO;
        property DscChave: string read DSC_CHAVE write DSC_CHAVE;
  end;

implementation

end.
