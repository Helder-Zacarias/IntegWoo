unit WooVariacaoProdutoRequest;

interface
uses
	System.DateUtils,
    REST.Json.Types,
    WooAtributoDaVariacao;
type
   TWooVariacaoProdutoRequest = class
   private
        FRegular_price: string;
        FStock_quantity: Integer;
        FSku: string;
        FAttributes: TArray<TWooAtributoDaVariacao>;
   public
        constructor Create;
        destructor Destroy; override;
        procedure AdicionarAtributo(AtributoId: Integer; Termo: string);
   published
        [JSONName('regular_price')]
        property RegularPrice: string read FRegular_price write FRegular_price;

        [JSONName('stock_quantity')]
        property StockQuantity: Integer read FStock_quantity write FStock_quantity;

        [JSONNmae('sku')]
        property Sku: string read FSku write FSku;

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

    procedure TWooVariacaoProdutoRequest.AdicionarAtributo(AtributoId: Integer; Termo: string);
    var
        Atributo: TWooAtributoDaVariacao;
    begin
        Atributo := TWooAtributoDaVariacao.Create;
        Atributo.Id := AtributoiD;
        Atributo.Option := Termo;
        SetLength(FAttributes, Length(FAttributes) + 1);
        FAttributes[High(FAttributes)] := Atributo;
    end;
end.
