unit PedidoVendaPgtos;

interface

uses
  System.SysUtils;

type
  TPedidoVendaPgtos = class
  private
    FCOD_ID_PV_PGTO: Int64;
    FCOD_ID_PEDIDO: Int64;
    FCOD_ID_EMPRESA: Integer;
    FCOD_ID_LOJA: Integer;
    FCOD_ID_FORMA_PGTO: Integer;
    FCOD_ID_CONDICAO_PGTO: Integer;
    FCOD_ID_FINALIZADORA: Integer;
    FDAT_VENCIMENTO: TDate;
    FNUM_VALOR: Double;
    FNUM_PARCELA: Integer;
    FNUM_TOTAL_PARCELAS: Integer;
    FNUM_STATUS_PGTO: Integer;
    FDSC_OBSERVACOES: string;
    FDAT_INCLUSAO: TDateTime;

  public

    property CodIdPvPgto: Int64
      read FCOD_ID_PV_PGTO write FCOD_ID_PV_PGTO;

    property CodIdPedido: Int64
      read FCOD_ID_PEDIDO write FCOD_ID_PEDIDO;

    property CodIdEmpresa: Integer
      read FCOD_ID_EMPRESA write FCOD_ID_EMPRESA;

    property CodIdLoja: Integer
      read FCOD_ID_LOJA write FCOD_ID_LOJA;

    property CodIdFormaPgto: Integer
      read FCOD_ID_FORMA_PGTO write FCOD_ID_FORMA_PGTO;

    property CodIdCondicaoPgto: Integer
      read FCOD_ID_CONDICAO_PGTO write FCOD_ID_CONDICAO_PGTO;

    property CodIdFinalizadora: Integer
      read FCOD_ID_FINALIZADORA write FCOD_ID_FINALIZADORA;

    property DatVencimento: TDate
      read FDAT_VENCIMENTO write FDAT_VENCIMENTO;

    property NumValor: Double
      read FNUM_VALOR write FNUM_VALOR;

    property NumParcela: Integer
      read FNUM_PARCELA write FNUM_PARCELA;

    property NumTotalParcelas: Integer
      read FNUM_TOTAL_PARCELAS write FNUM_TOTAL_PARCELAS;

    property NumStatusPgto: Integer
      read FNUM_STATUS_PGTO write FNUM_STATUS_PGTO;

    property DscObservacoes: string
      read FDSC_OBSERVACOES write FDSC_OBSERVACOES;

    property DatInclusao: TDateTime
      read FDAT_INCLUSAO write FDAT_INCLUSAO;

  end;

implementation

end.
