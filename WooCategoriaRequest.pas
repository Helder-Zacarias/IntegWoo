unit WooCategoriaRequest;

interface
uses
     REST.Json.Types;
type TWooCategoriaRequest = class
    private
    	FId: string;
        FName: string;
        FSlug: string;
    published
    	[JSONName('id')]
        property Id: string read Fid write FId;

        [JSONName('name')]
        property Name: string read FName write FName;

        [JSONName('slug')]
        property Slug: string read FSlug write FSlug;
end;
implementation

end.
