unit Finalizadora;

interface
type
  TFinalizadora = class
  private
    FCOD_ID_FINALIZADORA: Integer;
    FCOD_ID_EMPRESA: Integer;
    FCOD_ID_LOJA: Integer;
    FCOD_ID_CONTA: Integer;
    FCOD_ID_COBRANCA: Integer;
    FCOD_ID_ADMINISTRADORA: Integer;
    FCOD_ID_POS: Integer;
    FCOD_ID_API: Integer;
    FCOD_ID_CLIENTE: Integer;
    FCOD_FINALIZADORA: Integer;
    FDSC_COMPLETA: string;
    FDSC_ABREVIADA: string;
    FCOD_ID_ADQUIRENTE: Integer;
    FCOD_ADQUIRENTE: Integer;
    FDSC_NOME_ADQUIRENTE: string;
    FDSC_CNPJ_ADQUIRENTE: string;
    FNUM_ESPECIE: Integer;
    FNUM_MODALIDADE: Integer;
    FNUM_TIPO_OPERACAO: Integer;
    FNUM_PONTO_SANGRIA: Double;
    FNUM_USA_TEF: Integer;
    FNUM_USA_API: Integer;
    FNUM_ABRE_GAVETA: Integer;
    FNUM_GERA_CARNE: Integer;
    FNUM_ENVIA_ECF: Integer;
    FNUM_ENVIA_PDV: Integer;
    FNUM_ENVIA_PDA: Integer;
    FNUM_ENVIA_SITE: Integer;
    FNUM_PEDIR_AUTORIZACAO: Integer;
    FNUM_EXIGE_PORTADOR: Integer;
    FNUM_SOLICITAR_DADOS_POS: Integer;
    FNUM_SOLICITAR_DADOS_CHEQUE: Integer;
    FNUM_MAX_PARCELAS: Integer;
    FNUM_TIPO_PARCELAMENTO: Integer;
    FNUM_PLANO_PARCELAMENTO: Integer;
    FNUM_JUROS_PARCELAMENTO: Double;
    FNUM_DIAS_CREDITO: Integer;
    FNUM_GERA_COMISSAO: Integer;
    FNUM_FATOR_COMISSAO: Double;
    FDSC_CHAVE: string;
    FNUM_SINCRONIZADO: Integer;
    FNUM_MODIFICADO: Integer;
    FNUM_STATUS: Integer;

  public
    property CodIdFinalizadora: Integer read FCOD_ID_FINALIZADORA write FCOD_ID_FINALIZADORA;
    property CodIdEmpresa: Integer read FCOD_ID_EMPRESA write FCOD_ID_EMPRESA;
    property CodIdLoja: Integer read FCOD_ID_LOJA write FCOD_ID_LOJA;
    property CodIdConta: Integer read FCOD_ID_CONTA write FCOD_ID_CONTA;
    property CodIdCobranca: Integer read FCOD_ID_COBRANCA write FCOD_ID_COBRANCA;
    property CodIdAdministradora: Integer read FCOD_ID_ADMINISTRADORA write FCOD_ID_ADMINISTRADORA;
    property CodIdPos: Integer read FCOD_ID_POS write FCOD_ID_POS;
    property CodIdApi: Integer read FCOD_ID_API write FCOD_ID_API;
    property CodIdCliente: Integer read FCOD_ID_CLIENTE write FCOD_ID_CLIENTE;
    property CodFinalizadora: Integer read FCOD_FINALIZADORA write FCOD_FINALIZADORA;
    property DscCompleta: string read FDSC_COMPLETA write FDSC_COMPLETA;
    property DscAbreviada: string read FDSC_ABREVIADA write FDSC_ABREVIADA;
    property CodIdAdquirente: Integer read FCOD_ID_ADQUIRENTE write FCOD_ID_ADQUIRENTE;
    property CodAdquirente: Integer read FCOD_ADQUIRENTE write FCOD_ADQUIRENTE;
    property DscNomeAdquirente: string read FDSC_NOME_ADQUIRENTE write FDSC_NOME_ADQUIRENTE;
    property DscCnpjAdquirente: string read FDSC_CNPJ_ADQUIRENTE write FDSC_CNPJ_ADQUIRENTE;
    property NumEspecie: Integer read FNUM_ESPECIE write FNUM_ESPECIE;
    property NumModalidade: Integer read FNUM_MODALIDADE write FNUM_MODALIDADE;
    property NumTipoOperacao: Integer read FNUM_TIPO_OPERACAO write FNUM_TIPO_OPERACAO;
    property NumPontoSangria: Double read FNUM_PONTO_SANGRIA write FNUM_PONTO_SANGRIA;
    property NumUsaTef: Integer read FNUM_USA_TEF write FNUM_USA_TEF;
    property NumUsaApi: Integer read FNUM_USA_API write FNUM_USA_API;
    property NumAbreGaveta: Integer read FNUM_ABRE_GAVETA write FNUM_ABRE_GAVETA;
    property NumGeraCarne: Integer read FNUM_GERA_CARNE write FNUM_GERA_CARNE;
    property NumEnviaEcf: Integer read FNUM_ENVIA_ECF write FNUM_ENVIA_ECF;
    property NumEnviaPdv: Integer read FNUM_ENVIA_PDV write FNUM_ENVIA_PDV;
    property NumEnviaPda: Integer read FNUM_ENVIA_PDA write FNUM_ENVIA_PDA;
    property NumEnviaSite: Integer read FNUM_ENVIA_SITE write FNUM_ENVIA_SITE;
    property NumPedirAutorizacao: Integer read FNUM_PEDIR_AUTORIZACAO write FNUM_PEDIR_AUTORIZACAO;
    property NumExigePortador: Integer read FNUM_EXIGE_PORTADOR write FNUM_EXIGE_PORTADOR;
    property NumSolicitarDadosPos: Integer read FNUM_SOLICITAR_DADOS_POS write FNUM_SOLICITAR_DADOS_POS;
    property NumSolicitarDadosCheque: Integer read FNUM_SOLICITAR_DADOS_CHEQUE write FNUM_SOLICITAR_DADOS_CHEQUE;
    property NumMaxParcelas: Integer read FNUM_MAX_PARCELAS write FNUM_MAX_PARCELAS;
    property NumTipoParcelamento: Integer read FNUM_TIPO_PARCELAMENTO write FNUM_TIPO_PARCELAMENTO;
    property NumPlanoParcelamento: Integer read FNUM_PLANO_PARCELAMENTO write FNUM_PLANO_PARCELAMENTO;
    property NumJurosParcelamento: Double read FNUM_JUROS_PARCELAMENTO write FNUM_JUROS_PARCELAMENTO;
    property NumDiasCredito: Integer read FNUM_DIAS_CREDITO write FNUM_DIAS_CREDITO;
    property NumGeraComissao: Integer read FNUM_GERA_COMISSAO write FNUM_GERA_COMISSAO;
    property NumFatorComissao: Double read FNUM_FATOR_COMISSAO write FNUM_FATOR_COMISSAO;
    property DscChave: string read FDSC_CHAVE write FDSC_CHAVE;
    property NumSincronizado: Integer read FNUM_SINCRONIZADO write FNUM_SINCRONIZADO;
    property NumModificado: Integer read FNUM_MODIFICADO write FNUM_MODIFICADO;
    property NumStatus: Integer read FNUM_STATUS write FNUM_STATUS;
  end;
implementation

end.
