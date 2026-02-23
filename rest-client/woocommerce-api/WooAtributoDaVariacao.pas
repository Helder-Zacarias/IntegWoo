unit WooAtributoDaVariacao;

interface
uses
    Rest.Json.Types;
type
    TWooAtributoDaVariacao = class
    private
    	FId: Integer;
        FOption: string;
    published
    	[JSONName('id')]
        property Id: Integer read FId write FId;

        [JSONName('option')]
        property Option: string read FOption write FOption;
    end;
implementation

end.
