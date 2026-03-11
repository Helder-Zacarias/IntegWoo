unit ProdutoGrade;

interface
uses
	System.Generics.Collections,
    Variacao;
type
    TProdutoGrade = class
    private
        FNumPrecoUnitario: Currency;
        FNumEstoque: Integer;
        FVariacoes: TObjectList<TVariacao>;
    public
        constructor Create;
        destructor Destroy; override;
        procedure AdicionarVariacao(CodIdVariacao: Integer; DscVariacao: string);
        property Variacoes: TObjectList<TVariacao> read FVariacoes;
        property NumPrecoUnitario: Currency read FNumPrecoUnitario write FNumPrecoUnitario;
        property NumEstoque: Integer read FNumEstoque write FNumEstoque;
    end;
implementation
constructor TProdutoGrade.Create;
begin
	inherited Create;
    FVariacoes := TObjectList<TVariacao>.Create(True);
end;

destructor TProdutoGrade.Destroy;
begin
	FVariacoes.Free;
	inherited;
end;

procedure TProdutoGrade.AdicionarVariacao(CodIdVariacao: Integer; DscVariacao: string);
var
	Variacao: TVariacao;
begin
    Variacao := TVariacao.Create;
    Variacao.CodIdVariacao := CodIdVariacao;
    Variacao.DscVariacao := DscVariacao;
	FVariacoes.Add(Variacao);
end;
end.
