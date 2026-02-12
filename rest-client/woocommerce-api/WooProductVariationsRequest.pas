unit WooProductVariationsRequest;

interface
uses
    REST.Json.Types,
    System.Generics.Collections;
type TProductVariationsRequest = class
    private
    	FName: string;
        FVisible: Boolean;
        FVariation: Boolean;
        FOptions: TArray<string>;
    published
        [JSONName('name')]
        property Name: string read FName write FName;

        [JSONName('visible')]
        property Visible: Boolean read FVisible write FVisible;

        [JSONName('variation')]
        property Variation: Boolean read FVariation write FVariation;

        [JSONName('options')]
         property Options: TArray<string> read FOptions write FOptions;
end;
implementation

end.
