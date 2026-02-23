unit WooAtributoResponse;

interface
uses
	Rest.Json.Types;
type TWooAtributoResponse = class
    private
        FId: Integer;
        FName: string;
        FSlug: string;
    published
    	[JSONName('id')]
        property Id: Integer read FId write FId;

        [JSONName('name')]
        property Name: string read FName write FName;

        [JSONName('slug')]
        property Slug: string read Fslug write FSlug;
end;
implementation

end.
