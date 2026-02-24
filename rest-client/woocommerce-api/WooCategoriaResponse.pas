unit WooCategoriaResponse;

interface
uses
    Rest.Json.Types;
type
	TWooCategoriaResponse = class
        private
            FId: Integer;
            FName: string;
            FSlug: string;
            FParent: Integer;
            FDescription: string;
        published
            [JSONName('id')]
        	property Id: Integer read FId write FId;

            [JSONName('name')]
            property Name: string read FName write FName;

            [JSONName('slug')]
            property Slug: string read FSlug write FSlug;

            [JSONName('parent')]
            property Parent: Integer read FParent write FParent;

            [JSONName('description')]
            property Description: string read FDescription write FDescription;
    end;
implementation

end.
