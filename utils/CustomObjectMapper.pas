unit CustomObjectMapper;

interface
uses
    System.SysUtils, Produto, WooProdutoRequest;

function ProdutoToWooProdutoRequest(Produto: TProduto; TipoProduto: string): TWooProdutoRequest;

implementation
function ProdutoToWooProdutoRequest(Produto: TProduto; TipoProduto: string): TWooProdutoRequest;
var
    ProdutoMapping: TWooProdutoRequest;
    Slug: string;
begin
	ProdutoMapping := TWooProdutoRequest.Create;
    ProdutoMapping.Name := Produto.DscCompleta;
    ProdutoMapping.ShortDescription := Produto.DscAbreviada;
    ProdutoMapping.Sku := Produto.CodProduto;
    ProdutoMapping.RegularPrice := Produto.NumPrecoVarejo.ToString;
    ProdutoMapping.PType := TipoProduto;

    Result := ProdutoMapping;
end;
end.
