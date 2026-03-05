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
   published
   		[JSONName('create')]
        property Variacoes: TArray<TWooVariacaoProdutoRequest> read FCreate write FCreate;
   end;
implementation
    
end.
