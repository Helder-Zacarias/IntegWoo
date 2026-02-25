unit WooCategoriaRequest;

interface
uses
     REST.Json.Types;
type TWooCategoriaRequest = class
    private
        FName: string;
    published
        [JSONName('name')]
        property Name: string read FName write FName;
end;
implementation

end.
