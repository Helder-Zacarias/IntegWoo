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
        FSku: string;
        FImages: TArray<TWooImagemRequest>;
        FCategories: TArray<TWooProdutoCategoriaRequest>;
        FVariations: TArray<TProductVariationsRequest>;
    public
        constructor Create;
        destructor Destroy; override;
        procedure AdicionarImagem(Imagem: TWooImagemRequest);
        procedure AdicionarCategoria(Categoria: TWooProdutoCategoriaRequest);
        procedure AdicionarVariacoes(Variacao: TProductVariationsRequest);
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
        property Sku: string read FSKU write FSku;

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

    procedure TWooProdutoRequest.AdicionarImagem(Imagem: TWooImagemRequest);
    begin
        SetLength(FImages, Length(FImages) + 1);
        FImages[High(FImages)] := Imagem;
    end;

    procedure TWooProdutoRequest.AdicionarCategoria(Categoria: TWooProdutoCategoriaRequest);
    begin
        SetLength(FCategories, Length(FCategories) + 1);
        FCategories[High(FCategories)] := Categoria;
    end;

    procedure TWooProdutoRequest.AdicionarVariacoes(Variacao: TProductVariationsRequest);
    begin
        SetLength(FVariations, Length(FVariations) + 1);
        FVariations[High(FVariations)] := Variacao;
    end;

    destructor TWooProdutoRequest.Destroy;
    begin
        for var Imagem in FImages do
            Imagem.Free;
        for var Categoria in FCategories do
            Categoria.Free;
        for var Variacao in FVariations do
            Variacao.Free;
      inherited;
    end;
end.
