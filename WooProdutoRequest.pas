unit WooProdutoRequest;

interface

uses
    REST.Json.Types,
    System.Generics.Collections,
    WooImagemRequest;

type
	TWooProdutoRequest = class
    private
    	FName: string;
        FSlug: string;
        FDescription: string;
        FShort_description: string;
        FRegular_price: string;
        FImages: TArray<TWooImagemRequest>;
    public
        constructor Create;
        destructor Destroy; override;
    published
        [JSONName('name')]
        property Name: string read FName write FName;

        [JSONName('slug')]
        property Slug: string read FSlug write FSlug;

        [JSONName('description')]
        property Description: string read FDescription write FDescription;

        [JSONName('short_description')]
        property ShortDescription: string read FShort_description write FShort_description;

        [JSONName('regular_price')]
        property RegularPrice: string read FRegular_price write FRegular_price;

        [JSONName('images')]
        property Images: TArray<TWooImagemRequest> read FImages write FImages;
   end;
implementation
    constructor TWooProdutoRequest.Create;
    begin
      inherited;
      SetLength(FImages, 0);
    end;

    destructor TWooProdutoRequest.Destroy;
    begin
        for var Img in FImages do
            Img.Free;
      inherited;
    end;
end.
