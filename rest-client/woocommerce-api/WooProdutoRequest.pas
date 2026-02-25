unit WooProdutoRequest;

interface

uses
    REST.Json.Types,
    System.Generics.Collections,
    WooImagemRequest,
    WooProdutoCategoriaRequest,
    WooProductVariationsRequest;
type
	TWooProdutoRequest = class
    private
    	FName: string;
        FType: string;
        FDescription: string;
        FShort_description: string;
        FRegular_price: string;
        FSku: Int64;
        FImages: TArray<TWooImagemRequest>;
        FCategories: TArray<TWooProdutoCategoriaRequest>;
        FVariations: TArray<TProductVariationsRequest>;
    public
        constructor Create;
        destructor Destroy; override;
        procedure AdicionarCategoria(Categoria: TWooProdutoCategoriaRequest);
    published
        [JSONName('name')]
        property Name: string read FName write FName;

        [JSONName('type')]
        property PType: string read FType write FType;

        [JSONName('description')]
        property Description: string read FDescription write FDescription;

        [JSONName('short_description')]
        property ShortDescription: string read FShort_description write FShort_description;

        [JSONName('regular_price')]
        property RegularPrice: string read FRegular_price write FRegular_price;

        [JSONName('sku')]
        property Sku: Int64 read FSKU write FSku;

        [JSONName('images')]
        property Images: TArray<TWooImagemRequest> read FImages write FImages;

        [JSONName('categories')]
        property Categories: TArray<TWooProdutoCategoriaRequest> read FCategories write FCategories;

        [JSONName('variations')]
        property Variations: TArray<TProductVariationsRequest> read FVariations write FVariations;
   end;
implementation
    constructor TWooProdutoRequest.Create;
    begin
      inherited;
      SetLength(FImages, 0);
      SetLength(FCategories, 0);
      SetLength(FVariations, 0);
    end;

    procedure TWooProdutoRequest.AdicionarCategoria(Categoria: TWooProdutoCategoriaRequest);
    begin
        SetLength(FCategories, Length(FCategories) + 1);
        FCategories[High(FCategories)] := Categoria;
    end;

    destructor TWooProdutoRequest.Destroy;
    begin
        for var Img in FImages do
            Img.Free;
        for var Category in FCategories do
            Category.Free;
        for var Variation in FVariations do
            Variation.Free;
      inherited;
    end;
end.
