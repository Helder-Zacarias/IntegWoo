unit WooVariacaoProdutoBatchRequest;

interface
uses
    System.Generics.Collections,
    REST.Json.Types,
    WooVariacaoProdutoRequest;
type
   TWooVariacaoProdutoBatchRequest = class
   private
   		FCreate: TArray<TWooVariacaoProdutoRequest>;
   public
        constructor Create;
        destructor Destroy; override;
        procedure AdicionarVariacao(Variacao: TWooVariacaoProdutoRequest);
   published
   		[JSONName('create')]
        property Variacoes: TArray<TWooVariacaoProdutoRequest> read FCreate write FCreate;
   end;
implementation
	constructor TWooVariacaoProdutoBatchRequest.Create;
    begin
        inherited Create;
        SetLength(FCreate, 0);
    end;

    destructor TWooVariacaoProdutoBatchRequest.Destroy;
    begin
        for var Variacao in FCreate do
        	Variacao.Free;
    end;

    procedure TWooVariacaoProdutoBatchRequest.AdicionarVariacao(Variacao: TWooVariacaoProdutoRequest);
    begin
        SetLength(FCreate, Length(FCreate) + 1);
        FCreate[High(FCreate)] := Variacao;
    end;
end.
