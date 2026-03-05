unit WooProdutoResponse;

interface

uses
    REST.Json.Types,
    WooImagemResponse,
    WooAtributoProduto;
type
    TWooProdutoResponse = class
    private
    	FId: Integer;
    	FName: string;
        FSlug: string;
        FType: string;
        FDescription: string;
        FShort_Description: string;
        FSku: string;
        FRegular_Price: string;
        FImages: TArray<TWooImagemResponse>;
        FAttributes: TArray<TWooAtributoProduto>;
    published
        [JSONNmae('id')]
        property Id: Integer read FId write FId;

     	[JSONName('name')]
        property Name: string read FName write FName;

        [JSONName('slug')]
        property Slug: string read FSlug write FSlug;

        [JSONName('type')]
        property PType: string read FType write FType;

        [JSONName('description')]
        property Description: string read FDescription write FDescription;

        [JSONName('short_description')]
        property ShortDescription: string read FShort_Description write FShort_Description;

        [JSONName('sku')]
        property Sku: string read FSku write FSku;

        [JSONName('regular_price')]
        property RegularPrice: string read FRegular_Price write FRegular_Price;

        [JSONName('images')]
        property Images: TArray<TWooImagemResponse> read FImages write FImages;

        [JSONName('attributes')]
        property Attributes: TArray<TWooAtributoProduto> read FAttributes write FAttributes;
    end;
implementation

end.
