unit CustomObjectMapper;

interface
uses
    System.SysUtils, Produto, WooProdutoRequest, WooProdutoCategoriaRequest;

function ProdutoToWooProdutoRequest(Produto: TProduto; TipoProduto: string; CategoriaId: Integer): TWooProdutoRequest;

implementation
function ProdutoToWooProdutoRequest(Produto: TProduto; TipoProduto: string; CategoriaId: Integer): TWooProdutoRequest;
var
    ProdutoMapping: TWooProdutoRequest;
    ProdutoCategoria: TWooProdutoCategoriaRequest;
    Slug: string;
begin
    ProdutoCategoria := TWooProdutoCategoriaRequest.Create;
    ProdutoCategoria.Id := CategoriaId;

	ProdutoMapping := TWooProdutoRequest.Create;
    ProdutoMapping.Name := Produto.DscCompleta;
    ProdutoMapping.ShortDescription := Produto.DscAbreviada;
    ProdutoMapping.Sku := Produto.CodProduto;
    ProdutoMapping.RegularPrice := Produto.NumPrecoVarejo.ToString;
    ProdutoMapping.PType := TipoProduto;
    ProdutoMapping.AdicionarCategoria(ProdutoCategoria);

    Result := ProdutoMapping;
end;
end.
