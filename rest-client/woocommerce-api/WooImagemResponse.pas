unit WooImagemResponse;

interface
uses
	REST.Json.Types;
type
    TWooImagemResponse = class
    private
        FId: Integer;
        FSrc: string;
    published
        [JSONName('id')]
        property Id: Integer read FId write FId;

        [JSONName('src')]
        property Src: string read FSrc write FSrc;
    end;
implementation

end.
