unit Produto;

interface

type TProduto = class
    private
        FCod_Id_Produto: Integer;
        FCod_Id_Empresa: Integer;
        FCod_Id_Loja: Integer;
        FCod_Produto: Int64;
        FCod_Barras: string;
        FCod_Id_Grade: Integer;
        FCod_Id_Secao: Integer;
        FDsc_Completa: string;
        FNum_Tipo_Produto: Integer;
        FNum_Preco_Varejo: Currency;
        FNum_Estq_Atual: Double;
        FSku: string;
        FCOD_ID_WOOCOMMERCE: Int64;
        FSTATUS_SINCRONIZADO_WOOCOMMERCE: Integer;
    public
        property CodIdProduto: Integer read FCod_Id_Produto write FCod_Id_Produto;
        property CodIdEmpresa: Integer read FCod_Id_Empresa write FCod_Id_Empresa;
        property CodIdLoja: Integer read FCod_Id_Loja write FCod_Id_Loja;
        property CodProduto: Int64 read FCod_Produto write FCod_Produto;
        property CodBarras: string read FCod_Barras write FCod_Barras;
        property CodIdGrade: Integer read FCod_Id_Grade write FCod_Id_Grade;
        property CodIdSecao: Integer read FCod_Id_Secao write FCod_Id_Secao;
        property DscCompleta: string read FDsc_Completa write FDsc_Completa;
        property NumTipoProduto: Integer read FNum_Tipo_Produto write FNum_Tipo_Produto;
        property NumPrecoVarejo: Currency read FNum_Preco_Varejo write FNum_Preco_Varejo;
        property NumEstqAtual: Double read FNum_Estq_Atual write FNum_Estq_Atual;
        property Sku: string read FSku write FSku;
        property FCodIdWooCommerce: Int64 read FCOD_ID_WOOCOMMERCE write FCOD_ID_WOOCOMMERCE;
        property FStatusSincronizadoWooCommerce: Integer read FSTATUS_SINCRONIZADO_WOOCOMMERCE write FSTATUS_SINCRONIZADO_WOOCOMMERCE;
	end;
implementation

end.
