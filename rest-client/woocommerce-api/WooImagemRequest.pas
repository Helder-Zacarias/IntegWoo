unit WooImagemRequest;

interface
uses
    REST.Json.Types;

type TWooImagemRequest = class
    private
       FId: Integer;
    published
    	[JSONName('id')]
        property Id: Integer read FId write Fid;
	end;
implementation

end.
