unit Produto;

interface

type TProduto = class
    private
        FCOD_ID_PRODUTO: Integer;
        FCOD_ID_SITE: string;
        FCOD_ID_EMPRESA: Integer;
        FCOD_ID_LOJA: Integer;
        FCOD_PRODUTO: Int64;
        FCOD_BARRAS: string;
        FCOD_ID_GRADE: Integer;
        FCOD_ID_SECAO: Integer;
        FDSC_COMPLETA: string;
        FNUM_TIPO_PRODUTO: Integer;
        FNUM_PRECO_VAREJO: Currency;
        FNUM_ESTQ_ATUAL: Double;
    public
        property CodIdProduto: Integer read FCOD_ID_PRODUTO write FCOD_ID_PRODUTO;
        property CodIdSite: string read FCOD_ID_SITE write FCOD_ID_SITE;
        property CodIdEmpresa: Integer read FCOD_ID_EMPRESA write FCOD_ID_EMPRESA;
        property CodIdLoja: Integer read FCOD_ID_LOJA write FCOD_ID_LOJA;
        property CodProduto: Int64 read FCOD_PRODUTO write FCOD_PRODUTO;
        property CodBarras: string read FCOD_BARRAS write FCOD_BARRAS;
        property CodIdGrade: Integer read FCOD_ID_GRADE write FCOD_ID_GRADE;
        property CodIdSecao: Integer read FCOD_ID_SECAO write FCOD_ID_SECAO;
        property DscCompleta: string read FDSC_COMPLETA write FDSC_COMPLETA;
        property NumTipoProduto: Integer read FNUM_TIPO_PRODUTO write FNUM_TIPO_PRODUTO;
        property NumPrecoVarejo: Currency read FNUM_PRECO_VAREJO write FNUM_PRECO_VAREJO;
        property NumEstqAtual: Double read FNUM_ESTQ_ATUAL write FNUM_ESTQ_ATUAL;
    end;
implementation

end.
