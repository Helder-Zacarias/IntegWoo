unit WooImagemResponse;

interface
uses
	REST.Json.Types;
type
    TWooImagemResponse = class
    private
        FId: string;
        FSrc: string;
    published
        [JSONName('id')]
        property Id: string read FId write FId;

        [JSONName('src')]
        property Src: string read FSrc write FSrc;
    end;
implementation

end.
