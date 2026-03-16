unit PedidoVenda;

interface

uses
  System.SysUtils;

type
  TPedidoVenda = class
  private
    FCOD_ID_PEDIDO: Int64;
    FCOD_ID_EMPRESA: Integer;
    FCOD_ID_LOJA: Integer;
    FCOD_ID_CLIENTE: Integer;
    FCOD_IDENTIFICADOR: string;
    FDAT_PEDIDO: TDateTime;
    FDAT_INCLUSAO: TDateTime;
    FDSC_ENTREGA_NOME: string;
    FDSC_ENTREGA_ENDERECO: string;
    FDSC_ENTREGA_TELEFONE: string;
    FDSC_ENTREGA_CELULAR: string;
    FNUM_VALOR_DESCONTO: Double;
    FNUM_ENTREGA_VALOR: Double;
    FNUM_STATUS_PEDIDO: Integer;
    FNUM_STATUS_PRODUCAO: Integer;
    FDSC_OBSERVACOES: string;

  public

    property CodIdPedido: Int64
      read FCOD_ID_PEDIDO write FCOD_ID_PEDIDO;

    property CodIdEmpresa: Integer
      read FCOD_ID_EMPRESA write FCOD_ID_EMPRESA;

    property CodIdLoja: Integer
      read FCOD_ID_LOJA write FCOD_ID_LOJA;

    property CodIdCliente: Integer
      read FCOD_ID_CLIENTE write FCOD_ID_CLIENTE;

    property CodIdentificador: string
      read FCOD_IDENTIFICADOR write FCOD_IDENTIFICADOR;

    property DatPedido: TDateTime
      read FDAT_PEDIDO write FDAT_PEDIDO;

    property DatInclusao: TDateTime
      read FDAT_INCLUSAO write FDAT_INCLUSAO;

    property DscEntregaNome: string
      read FDSC_ENTREGA_NOME write FDSC_ENTREGA_NOME;

    property DscEntregaEndereco: string
      read FDSC_ENTREGA_ENDERECO write FDSC_ENTREGA_ENDERECO;

    property DscEntregaTelefone: string
      read FDSC_ENTREGA_TELEFONE write FDSC_ENTREGA_TELEFONE;

    property DscEntregaCelular: string
      read FDSC_ENTREGA_CELULAR write FDSC_ENTREGA_CELULAR;

    property NumValorDesconto: Double
      read FNUM_VALOR_DESCONTO write FNUM_VALOR_DESCONTO;

    property NumEntregaValor: Double
      read FNUM_ENTREGA_VALOR write FNUM_ENTREGA_VALOR;

    property NumStatusPedido: Integer
      read FNUM_STATUS_PEDIDO write FNUM_STATUS_PEDIDO;

    property NumStatusProducao: Integer
      read FNUM_STATUS_PRODUCAO write FNUM_STATUS_PRODUCAO;

    property DscObservacoes: string
      read FDSC_OBSERVACOES write FDSC_OBSERVACOES;

  end;

implementation

end.
