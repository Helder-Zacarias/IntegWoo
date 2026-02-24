unit WooCreateCategoriaRequest;

interface
uses
	Rest.Json.Types;
type
    TWooCreateCategoriaRequest = class
        private
        	FName: string;
//       Adicionar campo para imagem
        published
            [JSONName('name')]
            property Name: string read FName write FName;
    end;
implementation

end.
