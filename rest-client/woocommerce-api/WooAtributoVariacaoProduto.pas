unit WooAtributoVariacaoProduto;

interface
uses
    REST.Json.Types;
type
   TWooAtributoVariacaoProduto = class
   private
        FId: Integer;
        FName: string;
        FOption: string;
   published
        [JSONName('id')]
        property Id: Integer read FId write FId;

        [JSONName('name')]
        property Name: string read FName write FName;

        [JSONName('option')]
        property Option: string read FOption write FOption;
   end;
implementation

end.
