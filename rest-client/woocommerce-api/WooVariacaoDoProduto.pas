unit WooVariacaoDoProduto;

interface
uses
    Rest.Json.Types, WooAtributoDaVariacao;
type
    TWooVariacaoDoProduto = class
    private
        FRegular_price: string;
        FAttributes: TArray<TWooAtributoDaVariacao>;
    public
    	constructor Create;
        destructor Destroy; override;
        procedure AdicionarAtributo(Atributo: TWooAtributoDaVariacao);
    published
    	[JSONName('regular_price')]
        property RegularPrice: string read FRegular_price write FRegular_price;

        [JSONNmae('attributes')]
        property Attributes: TArray<TWooAtributoDaVariacao> read FAttributes write FAttributes;
    end;
implementation
constructor TWooVariacaoDoProduto.Create;
begin
	inherited;
    setLength(FAttributes, 0);
end;
destructor TWooVariacaoDoProduto.Destroy;
var
    Atributo: TWooAtributoDaVariacao;
begin
	for Atributo in FAttributes do
       Atributo.Free;
    inherited;
end;
procedure  TWooVariacaoDoProduto.AdicionarAtributo(Atributo: TWooAtributoDaVariacao);
begin
    setLength(FAttributes, Length(FAttributes) + 1);
    FAttributes[High(FAttributes)] := Atributo;
end;

end.
