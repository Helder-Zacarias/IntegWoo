unit WPImagemResponse;

interface
uses
	REST.Json.Types;
type TWPImagemResponse = class
	private
        FId: Integer;
        FSource_Url: String;
    published
        [JSONName('id')]
        property Id: Integer read FId write FId;

        [JSONName('source_url')]
        property SourceUrl : string read FSource_Url write FSource_Url;
    end;
implementation

end.
