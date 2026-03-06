unit ProdutoGrade;

interface
uses
    Variacao;
type
    TProdutoGrade = class
    private
        FVariacaoUm: TVariacao;
        FVariacaoDois:TVariacao;
        FNumPrecoUnitario: Currency;
        FNumEstoque: Integer;
    public
        constructor Create;
        destructor Destroy; override;
        property VariacaoUm: TVariacao read FVariacaoUm;
        property VariacaoDois: TVariacao read FVariacaoDois;
        property NumPrecoUnitario: Currency read FNumPrecoUnitario write FNumPrecoUnitario;
        property NumEstoque: Integer read FNumEstoque write FNumEstoque;
    end;
implementation
	constructor TProdutoGrade.Create;
    begin
        inherited Create;
        FVariacaoUm := TVariacao.Create;
        FVariacaoDois := TVariacao.Create;
    end;
    destructor TProdutoGrade.Destroy;
    begin
        FVariacaoUm.Free;
        FVariacaoDois.Free;
        inherited;
    end;
end.
