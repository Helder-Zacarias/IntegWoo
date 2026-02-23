unit WooAtributoRequest;

interface
uses
    Rest.Json.Types;
type
    TWooAtributoRequest = class
    private
        FName: string;
        FType: string;
        FOrder_by: string;
        FHas_archives: Boolean;
    public
    	constructor Create;
    published
        [JSONName('name')]
        property Name: string read FName write FName;

        [JSONName('type')]
        property AtributoType: string read FType write FType;

        [JSONName('order_by')]
        property OrderBy: string read FOrder_by write FOrder_by;

        [JSONName('has_archives')]
        property HasArchives: Boolean read FHas_archives write FHas_archives;
    end;
implementation
constructor TWooAtributoRequest.Create;
begin
    FType := 'select';
    FOrder_By := 'menu_order';
    FHas_archives := False;
end;
end.
