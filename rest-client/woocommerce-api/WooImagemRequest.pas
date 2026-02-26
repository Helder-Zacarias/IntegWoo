unit WooImagemRequest;

interface
uses
    REST.Json.Types;

type TWooImagemRequest = class
    private
       FId: Integer;
       FSrc: string;
    published
    	[JSONName('id')]
        property Id: Integer read FId write Fid;

        [JSONName('src')]
        property Src: string read FSrc write FSrc;
	end;
implementation

end.
