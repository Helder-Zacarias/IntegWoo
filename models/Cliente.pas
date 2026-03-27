unit Cliente;

interface

uses
  System.SysUtils;

type
  TCliente = class
  private
    FCOD_ID_CLIENTE: Integer;
    FCOD_ID_SITE: string;
    FCOD_ID_EMPRESA: Integer;
    FCOD_ID_LOJA: Integer;
    FCOD_CLIENTE: Integer;
    FDSC_NOME: string;
    FDSC_FANTASIA: string;
    FDSC_CPF_CNPJ: string;
    FDSC_EMAIL: string;
    FDSC_TELEFONE: string;
    FDSC_CELULAR: string;
    FDSC_ENDERECO: string;
    FDSC_NUMERO: string;
    FDSC_COMPLEMENTO: string;
    FDSC_BAIRRO: string;
    FDSC_CIDADE: string;
    FDSC_UF: string;
    FCOD_CEP: string;
    FNUM_STATUS: Integer;
    FDAT_INCLUSAO: TDateTime;

  public
    property CodIdCliente: Integer
    	read FCOD_ID_CLIENTE write FCOD_ID_CLIENTE;

    property CodIdSite: string
        read FCOD_ID_SITE write FCOD_ID_SITE;

    property CodIdEmpresa: Integer
    	read FCOD_ID_EMPRESA write FCOD_ID_EMPRESA;

    property CodIdLoja: Integer
    	read FCOD_ID_LOJA write FCOD_ID_LOJA;

    property CodCliente: Integer
    	read FCOD_CLIENTE write FCOD_CLIENTE;

    property DscNome: string
      read FDSC_NOME write FDSC_NOME;

    property DscFantasia: string
      read FDSC_FANTASIA write FDSC_FANTASIA;

    property DscCpfCnpj: string
      read FDSC_CPF_CNPJ write FDSC_CPF_CNPJ;

    property DscEmail: string
      read FDSC_EMAIL write FDSC_EMAIL;

    property DscTelefone: string
      read FDSC_TELEFONE write FDSC_TELEFONE;

    property DscCelular: string
      read FDSC_CELULAR write FDSC_CELULAR;

    property DscEndereco: string
      read FDSC_ENDERECO write FDSC_ENDERECO;

    property DscNumero: string
      read FDSC_NUMERO write FDSC_NUMERO;

    property DscComplemento: string
      read FDSC_COMPLEMENTO write FDSC_COMPLEMENTO;

    property DscBairro: string
      read FDSC_BAIRRO write FDSC_BAIRRO;

    property DscCidade: string
      read FDSC_CIDADE write FDSC_CIDADE;

    property DscUf: string
      read FDSC_UF write FDSC_UF;

    property CodCep: string
      read FCOD_CEP write FCOD_CEP;

    property NumStatus: Integer
    	read FNUM_STATUS write FNUM_STATUS;

    property DatInclusao: TDateTime
    	read FDAT_INCLUSAO write FDAT_INCLUSAO;
  end;

implementation

end.
