unit WooVariacaoProdutoRequest;

interface
uses
    REST.Json.Types,
    WooAtributoProduto;
type
   TWooVariacaoProdutoRequest = class
   private
        FName: string;
        FType: string;
        FAttributes: TArray<TWooAtributoProduto>;
   public
        constructor Create;
        destructor Destroy; override;
        procedure AdicionarAtributo(Atributo: TWooAtributoProduto);
   published
        property Name: string read FName write FName;
        property PType: string read FType write FType;
        property Attributes: TArray<TWooAtributoProduto> read FAttributes write FAttributes;
   end;
implementation
	constructor TWooVariacaoProdutoRequest.Create;
    begin
        inherited;
    	SetLength(FAttributes, 0);
    end;

    destructor TWooVariacaoProdutoRequest.Destroy;
    begin
        for var Atributo in FAttributes do
            Atributo.Free;
        inherited;
    end;

    procedure TWooVariacaoProdutoRequest.AdicionarAtributo(Atributo: TWooAtributoProduto);
    begin
        SetLength(FAttributes, Length(FAttributes) + 1);
        FAttributes[High(FAttributes)] := Atributo;
    end;
end.
