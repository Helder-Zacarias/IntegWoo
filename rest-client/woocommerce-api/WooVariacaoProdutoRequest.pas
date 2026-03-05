unit WooVariacaoProdutoRequest;

interface
uses
    REST.Json.Types,
    WooAtributoDaVariacao;
type
   TWooVariacaoProdutoRequest = class
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

        [JSONName('attributes')]
        property Attributes: TArray<TWooAtributoDaVariacao> read FAttributes write FAttributes;
   end;
implementation
	constructor TWooVariacaoProdutoRequest.Create;
    begin
        inherited;
    	SetLength(FAttributes, 0);
    end;

    destructor TWooVariacaoProdutoRequest.Destroy;
    begin
        for var Atributo in FAttributes do
            Atributo.Free;
        inherited;
    end;

    procedure TWooVariacaoProdutoRequest.AdicionarAtributo(Atributo: TWooAtributoDaVariacao);
    begin
        SetLength(FAttributes, Length(FAttributes) + 1);
        FAttributes[High(FAttributes)] := Atributo;
    end;
end.
