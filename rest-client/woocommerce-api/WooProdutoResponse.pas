unit WooProdutoResponse;

interface

uses
    REST.Json.Types,
    WooImagemResponse;
type
    TWooProdutoResponse = class
    private
    	FName: string;
        FSlug: string;
        FType: string;
        FDescription: string;
        FShort_Description: string;
        FRegular_Price: string;
        FImages: TArray<TWooImagemResponse>;
    published
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

        [JSONName('regular_price')]
        property RegularPrice: string read FRegular_Price write FRegular_Price;

        [JsonName('images')]
        property Images: TArray<TWooImagemResponse> read FImages write FImages;
    end;
implementation

end.
