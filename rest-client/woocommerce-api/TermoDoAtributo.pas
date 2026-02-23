unit TermoDoAtributo;

interface
uses
	Rest.Json.Types;
type
    TSTermoDoAtributo = class
    private
    	FName: string;
    published
        [JSONName('name')]
        property Name: string read FName write FName;
    end;
implementation

end.
