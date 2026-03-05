unit WooProdutoRequest;

interface

uses
    REST.Json.Types,
    System.Generics.Collections,
    WooImagemRequest,
    WooProdutoCategoriaRequest,
    WooAtributosProdutoRequest;
type
	TWooProdutoRequest = class
    private
    	FName: string;
        FType: string;
        FDescription: string;
        FShort_description: string;
        FRegular_price: string;
        FSku: string;
        FManage_stock: Boolean;
        FStock_quantity: Integer;
        FStock_status: string;
        FImages: TArray<TWooImagemRequest>;
        FCategories: TArray<TWooProdutoCategoriaRequest>;
        FAttributes: TArray<TWooAtributosProdutoRequest>;
    public
        constructor Create;
        destructor Destroy; override;
        procedure AdicionarImagem(Imagem: TWooImagemRequest);
        procedure AdicionarAtributo(Atributo: TWooAtributosProdutoRequest);
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
        property Sku: string read FSKU write FSku;

        [JSONName('manage_stock')]
        property ManageStock: Boolean read FManage_stock write FManage_stock;

        [JSONName('stock_quantity')]
        property StockQuantity: Integer read FStock_quantity write FStock_quantity;

        [JSONName('stock_status')]
        property StockStatus: string read FStock_status write FStock_status;

        [JSONName('images')]
        property Images: TArray<TWooImagemRequest> read FImages write FImages;

        [JSONName('categories')]
        property Categories: TArray<TWooProdutoCategoriaRequest> read FCategories write FCategories;

        [JSONName('attributes')]
        property Atributes: TArray<TWooAtributosProdutoRequest> read FAttributes write FAttributes;
   end;
implementation
    constructor TWooProdutoRequest.Create;
    begin
      inherited;
      FManage_stock := True;
      FStock_quantity := 100;
      FStock_status := 'instock';

      SetLength(FImages, 0);
      SetLength(FCategories, 0);
      SetLength(FAttributes, 0);
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

    procedure TWooProdutoRequest.AdicionarAtributo(Atributo: TWooAtributosProdutoRequest);
    begin
        SetLength(FAttributes, Length(FAttributes) + 1);
        FAttributes[High(FAttributes)] := Atributo;
    end;

    destructor TWooProdutoRequest.Destroy;
    begin
        for var Imagem in FImages do
            Imagem.Free;
        for var Categoria in FCategories do
            Categoria.Free;
        for var Atributo in FAttributes do
            Atributo.Free;
      inherited;
    end;
end.
