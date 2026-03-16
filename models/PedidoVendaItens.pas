unit PedidoVendaItens;

interface

uses
  System.SysUtils;

type
  TPedidoVendaItens = class
  private
    FCOD_ID_ITEM: Int64;
    FCOD_ID_COMPLEMENTO_ITEM: Int64;
    FCOD_ID_ITEM_PV: Int64;
    FCOD_ID_EMPRESA: Integer;
    FCOD_ID_LOJA: Integer;
    FCOD_ID_USUARIO: Integer;
    FCOD_ID_VENDEDOR: Integer;
    FCOD_ID_PEDIDO: Int64;
    FCOD_ID_DEPOSITO: Integer;
    FCOD_SOLICITACAO: string;
    FDSC_SOLICITACAO: string;
    FCOD_RESERVA: string;
    FDAT_INCLUSAO: TDateTime;
    FDAT_RESERVA: TDate;
    FDAT_ENTREGA: TDate;
    FNUM_ENTREGA: Integer;
    FDSC_PORTADOR_ENTREGA: string;
    FNUM_ITEM: Integer;
    FCOD_ID_PRODUTO: Integer;
    FCOD_PRODUTO: Int64;
    FCOD_INSUMOS: string;
    FDSC_COMPLETA: string;
    FDSC_SIGLA_UNIDADE: string;
    FNUM_VALOR_UNITARIO: Double;
    FNUM_VALOR_DESCONTO: Double;
    FNUM_VALOR_SEGURO: Double;
    FNUM_QUANTIDADE: Double;
    FNUM_QTDE_RESERVADA: Double;
    FNUM_QTDE_ENTREGUE: Double;
    FNUM_QTDE_ENTREGAR: Double;
    FDSC_OBSERVACOES: string;
    FNUM_FATURADO: Double;
    FNUM_IAT: Integer;
    FNUM_CONTABILIZA_PEDIDO: Integer;
    FNUM_INDC_ITEM: Integer;
    FNUM_STATUS_PRODUCAO: Integer;
    FNUM_STATUS_ITEM: Integer;
    FNUM_STS_STQ: Integer;
    FCOD_ITEM_WOOCOMMERCE: Int64;

  public

    property CodIdItem: Int64 read FCOD_ID_ITEM write FCOD_ID_ITEM;
    property CodIdComplementoItem: Int64 read FCOD_ID_COMPLEMENTO_ITEM write FCOD_ID_COMPLEMENTO_ITEM;
    property CodIdItemPv: Int64 read FCOD_ID_ITEM_PV write FCOD_ID_ITEM_PV;
    property CodIdEmpresa: Integer read FCOD_ID_EMPRESA write FCOD_ID_EMPRESA;
    property CodIdLoja: Integer read FCOD_ID_LOJA write FCOD_ID_LOJA;
    property CodIdUsuario: Integer read FCOD_ID_USUARIO write FCOD_ID_USUARIO;
    property CodIdVendedor: Integer read FCOD_ID_VENDEDOR write FCOD_ID_VENDEDOR;
    property CodIdPedido: Int64 read FCOD_ID_PEDIDO write FCOD_ID_PEDIDO;
    property CodIdDeposito: Integer read FCOD_ID_DEPOSITO write FCOD_ID_DEPOSITO;
    property CodSolicitacao: string read FCOD_SOLICITACAO write FCOD_SOLICITACAO;
    property DscSolicitacao: string read FDSC_SOLICITACAO write FDSC_SOLICITACAO;
    property CodReserva: string read FCOD_RESERVA write FCOD_RESERVA;
    property DatInclusao: TDateTime read FDAT_INCLUSAO write FDAT_INCLUSAO;
    property DatReserva: TDate read FDAT_RESERVA write FDAT_RESERVA;
    property DatEntrega: TDate read FDAT_ENTREGA write FDAT_ENTREGA;
    property NumEntrega: Integer read FNUM_ENTREGA write FNUM_ENTREGA;
    property DscPortadorEntrega: string read FDSC_PORTADOR_ENTREGA write FDSC_PORTADOR_ENTREGA;
    property NumItem: Integer read FNUM_ITEM write FNUM_ITEM;
    property CodIdProduto: Integer read FCOD_ID_PRODUTO write FCOD_ID_PRODUTO;
    property CodProduto: Int64 read FCOD_PRODUTO write FCOD_PRODUTO;
    property CodInsumos: string read FCOD_INSUMOS write FCOD_INSUMOS;
    property DscCompleta: string read FDSC_COMPLETA write FDSC_COMPLETA;
    property DscSiglaUnidade: string read FDSC_SIGLA_UNIDADE write FDSC_SIGLA_UNIDADE;
    property NumValorUnitario: Double read FNUM_VALOR_UNITARIO write FNUM_VALOR_UNITARIO;
    property NumValorDesconto: Double read FNUM_VALOR_DESCONTO write FNUM_VALOR_DESCONTO;
    property NumValorSeguro: Double read FNUM_VALOR_SEGURO write FNUM_VALOR_SEGURO;
    property NumQuantidade: Double read FNUM_QUANTIDADE write FNUM_QUANTIDADE;
    property NumQtdeReservada: Double read FNUM_QTDE_RESERVADA write FNUM_QTDE_RESERVADA;
    property NumQtdeEntregue: Double read FNUM_QTDE_ENTREGUE write FNUM_QTDE_ENTREGUE;
    property NumQtdeEntregar: Double read FNUM_QTDE_ENTREGAR write FNUM_QTDE_ENTREGAR;
    property DscObservacoes: string read FDSC_OBSERVACOES write FDSC_OBSERVACOES;
    property NumFaturado: Double read FNUM_FATURADO write FNUM_FATURADO;
    property NumIat: Integer read FNUM_IAT write FNUM_IAT;
    property NumContabilizaPedido: Integer read FNUM_CONTABILIZA_PEDIDO write FNUM_CONTABILIZA_PEDIDO;
    property NumIndcItem: Integer read FNUM_INDC_ITEM write FNUM_INDC_ITEM;
    property NumStatusProducao: Integer read FNUM_STATUS_PRODUCAO write FNUM_STATUS_PRODUCAO;
    property NumStatusItem: Integer read FNUM_STATUS_ITEM write FNUM_STATUS_ITEM;
    property NumStsStq: Integer read FNUM_STS_STQ write FNUM_STS_STQ;
    property FCodItemWooCommerce: Int64 read FCOD_ITEM_WOOCOMMERCE write FCOD_ITEM_WOOCOMMERCE;

  end;

implementation

end.
