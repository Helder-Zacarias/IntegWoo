unit WooAtributoProduto;

interface
uses
    Rest.Json.Types;
type TWooAtributoProduto = class
    private
    	FId: Integer;
    	FName: string;
        FVariation: Boolean;
        FOptions: TArray<string>;
    published
    	[JSONName('id')]
        property Id: Integer read FId write FId;

    	[JSONName('name')]
        property Name: string read FName write FName;

        [JSONName('variation')]
        property Variation: Boolean read FVariation write FVariation;

        [JSONName('options')]
        property Options: TArray<string> read FOptions write FOptions;
end;
implementation
end.
