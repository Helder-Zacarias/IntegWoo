unit Produto;

interface

type TProduto = class
    private
        FCod_Id_Produto: Integer;
        FDsc_Completa: string;
        FDsc_Abreviada: string;
        FDsc_Observacoes: string;
        FDsc_Detalhes: string;
    public
        property CodIdProduto: Integer read FCod_Id_Produto write FCod_Id_Produto;
        property DscCompleta: string read FDsc_Completa write FDsc_Completa;
        property DscAbreviada: string read FDsc_Abreviada write FDsc_Abreviada;
        property DscObservacoes: string read FDsc_Observacoes write FDsc_Observacoes;
        property DscDetalhes: string read FDsc_Detalhes write FDsc_Detalhes;
	end;
implementation

end.
