unit WooAtributosProdutoRequest;

interface
uses
    REST.Json.Types,
    System.Generics.Collections;
type TWooAtributosProdutoRequest = class
    private
    	FId: Integer;
        FVisible: Boolean;
        FVariation: Boolean;
        FOptions: TArray<string>;
    published
        [JSONName('id')]
        property Id: Integer read FId write FId;

        [JSONName('visible')]
        property Visible: Boolean read FVisible write FVisible;

        [JSONName('variation')]
        property Variation: Boolean read FVariation write FVariation;

        [JSONName('options')]
        property Options: TArray<string> read FOptions write FOptions;
end;
implementation

end.
