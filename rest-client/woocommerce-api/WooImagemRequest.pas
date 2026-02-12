unit WooImagemRequest;

interface
uses
    REST.Json.Types;

type TWooImagemRequest = class
    private
       FId: string;
    published
    	[JSONName('id')]
        property Id: string read FId write Fid;
	end;
implementation

end.
