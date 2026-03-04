unit WooVariacaoProdutoResponse;

interface
uses
	REST.Json.Types,
    System.Generics.Collections,
    WooAtributoVariacaoProduto;
type
    TWooVariacaoProdutoResponse = class
        private
        	FId: Integer;
            FAttributes: TArray<TWooAtributoVariacaoProduto>;
        public
            constructor Create;
            destructor Destroy; override;
            procedure AdicionarAtributo(AtributoVariacao: TWooAtributoVariacaoProduto);
        published
            [JSONName('id')]
            property Id: Integer read FId write FId;

            [JSONName('attributes')]
            property Attributes: TArray<TWooAtributoVariacaoProduto> read FAttributes write FAttributes;
    end;

implementation
    constructor TWooVariacaoProdutoResponse.Create;
    begin
        inherited;
        SetLength(FAttributes, 0);
    end;

    procedure TWooVariacaoProdutoResponse.AdicionarAtributo(AtributoVariacao: TWooAtributoVariacaoProduto);
    begin
       SetLength(FAttributes, Length(FAttributes) + 1);
       FAttributes[High(FAttributes)] := AtributoVariacao;
    end;

    destructor TWooVariacaoProdutoResponse.Destroy;
    begin
        for var Atributo in FAttributes do
            Atributo.Free;
        inherited;
    end;
end.
