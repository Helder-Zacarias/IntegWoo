unit Produto;

interface

type TProduto = class
    private
        FCod_Id_Produto: Integer;
        FCod_Id_Empresa: Integer;
        FCod_Id_Loja: Integer;
        FCod_Produto: Int64;
        FCod_Id_Grade: Integer;
        FCod_Id_Secao: Integer;
        FDsc_Completa: string;
        FCod_Barras: string;
        FNum_Preco_Varejo: Currency;
        FNum_Tipo_Produto: Integer;
        FNum_Estq_Atual: Integer;
        FSku: string;
    public
        property CodIdProduto: Integer read FCod_Id_Produto write FCod_Id_Produto;
        property CodIdEmpresa: Integer read FCod_Id_Empresa write FCod_Id_Empresa;
        property CodIdLoja: Integer read FCod_Id_Loja write FCod_Id_Loja;
        property CodProduto: Int64 read FCod_Produto write FCod_Produto;
        property CodIdGrade: Integer read FCod_Id_Grade write FCod_Id_Grade;
        property CodIdSecao: Integer read FCod_Id_Secao write FCod_Id_Secao;
        property DscCompleta: string read FDsc_Completa write FDsc_Completa;
        property Cod_Barras: string read FCod_Barras write FCod_Barras;
        property NumPrecoVarejo: Currency read FNum_Preco_Varejo write FNum_Preco_Varejo;
        property NumTipoProduto: Integer read FNum_Tipo_Produto write FNum_Tipo_Produto;
        property NumEstqAtual: Integer read FNum_Estq_Atual write FNum_Estq_Atual;
        property Sku: string read FSku write FSku;
	end;
implementation

end.
