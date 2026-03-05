unit WooVariacaoProdutoRequest;

interface
uses
    REST.Json.Types,
    WooAtributoDaVariacao;
type
   TWooVariacaoProdutoRequest = class
   private
        FAttributes: TArray<TWooAtributoDaVariacao>;
   public
        constructor Create;
        destructor Destroy; override;
        procedure AdicionarAtributo(Atributo: TWooAtributoDaVariacao);
   published
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

    procedure TWooVariacaoProdutoRequest.AdicionarAtributo(Atributo: TWooAtributoDaVariacao);
    begin
        SetLength(FAttributes, Length(FAttributes) + 1);
        FAttributes[High(FAttributes)] := Atributo;
    end;
end.
