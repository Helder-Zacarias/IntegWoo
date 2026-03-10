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
    public
        constructor Create;
        procedure AdicionarTermo(Termo: string);
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
    constructor TWooAtributosProdutoRequest.Create;
    begin
        inherited Create;
        SetLength(FOptions, 0);
    end;

    procedure TWooAtributosProdutoRequest.AdicionarTermo(Termo: string);
    begin
        SetLength(FOptions, Length(FOptions) + 1);
        FOptions[High(FOptions)] := Termo;
    end;
end.
