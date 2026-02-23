unit WooTermoAtributoRequest;

interface
uses
	Rest.Json.Types;
type
    TWooTermoAtributoRequest = class
    private
    	FName: string;
    published
        [JSONName('name')]
        property Name: string read FName write FName;
    end;
implementation

end.
