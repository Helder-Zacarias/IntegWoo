unit WooProdutoCategoriaRequest;

interface
uses
	Rest.Json.Types;
type
    TWooProdutoCategoriaRequest = class
    private
    	FId: Integer;
    published
    	[JSONName('id')]
        property Id: Integer read FId write FId;
    end;
implementation

end.
