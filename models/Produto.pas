unit Produto;

interface

type TProduto = class
    private
        FCod_Id_Produto: string;
        FCod_Produto: string;
        FCod_ID_Grade: Integer;
        FDsc_Completa: string;
        FDsc_Abreviada: string;
        FDsc_Observacoes: string;
        FDsc_Detalhes: string;
        FCod_Barras: string;
        FNum_Preco_Varejo: Currency;
        FSku: string;
    public
        property CodIdProduto: string read FCod_Id_Produto write FCod_Id_Produto;
        property CodProduto: string read FCod_Produto write FCod_Produto;
        property CodIdGrade: Integer read FCod_ID_Grade write FCod_ID_Grade;
        property DscCompleta: string read FDsc_Completa write FDsc_Completa;
        property DscAbreviada: string read FDsc_Abreviada write FDsc_Abreviada;
        property DscObservacoes: string read FDsc_Observacoes write FDsc_Observacoes;
        property DscDetalhes: string read FDsc_Detalhes write FDsc_Detalhes;
        property Cod_Barras: string read FCod_Barras write FCod_Barras;
        property Sku: string read FSku write FSku;
        property NumPrecoVarejo: Currency read FNum_Preco_Varejo write FNum_Preco_Varejo;
	end;
implementation

end.
