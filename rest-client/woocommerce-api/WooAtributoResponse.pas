unit WooAtributoResponse;

interface
uses
	Rest.Json.Types;
type TWooAtributoResponse = class
    private
        FId: Integer;
        FName: string;
    published
    	[JSONName('id')]
        property Id: Integer read FId write FId;

        [JSONName('name')]
        property Name: string read FName write FName;
end;
implementation

end.
