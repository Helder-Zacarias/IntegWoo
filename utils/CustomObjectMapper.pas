unit CustomObjectMapper;

interface
uses
	System.SysUtils, Produto, WooProdutoRequest, WooProdutoCategoriaRequest, Uni;

	function ProdutoToWooProdutoRequest(Produto: TProduto; TipoProduto: string; CategoriaId: Integer): TWooProdutoRequest;
	function ProdutoQueryToProduto(SelectProdutoQuery: TUniQuery): TProduto;

implementation
function ProdutoToWooProdutoRequest(Produto: TProduto; TipoProduto: string; CategoriaId: Integer): TWooProdutoRequest;
var
    ProdutoMapping: TWooProdutoRequest;
    ProdutoCategoria: TWooProdutoCategoriaRequest;
begin
    ProdutoCategoria := TWooProdutoCategoriaRequest.Create;
    ProdutoCategoria.Id := CategoriaId;

    ProdutoMapping := TWooProdutoRequest.Create;
    ProdutoMapping.Name := Produto.DscCompleta;
    ProdutoMapping.ShortDescription := Produto.DscAbreviada;
    ProdutoMapping.Sku := Produto.CodProduto.ToString;
    ProdutoMapping.RegularPrice := Produto.NumPrecoVarejo.ToString;
    ProdutoMapping.PType := TipoProduto;
    ProdutoMapping.AdicionarCategoria(ProdutoCategoria);

    Result := ProdutoMapping;
end;

function ProdutoQueryToProduto(SelectProdutoQuery: TUniQuery): TProduto;
var
	Produto: TProduto;
begin
	Produto := TProduto.Create;

    Produto.CodIdProduto := SelectProdutoQuery.FieldByName('COD_ID_PRODUTO').AsInteger;
    Produto.CodProduto := SelectProdutoQuery.FieldByName('COD_PRODUTO').AsLargeInt;
    Produto.CodIdGrade := SelectProdutoQuery.FieldByName('COD_ID_GRADE').AsInteger;
    Produto.CodIdSecao := SelectProdutoQuery.FieldByName('COD_ID_SECAO').AsInteger;
    Produto.NumPrecoVarejo := SelectProdutoQuery.FieldByName('NUM_PRECO_VAREJO').AsCurrency;
    Produto.DscCompleta := SelectProdutoQuery.FieldByName('DSC_COMPLETA').AsString;
    Produto.DscAbreviada := SelectProdutoQuery.FieldByName('DSC_ABREVIADA').AsString;
    Produto.DscObservacoes := SelectProdutoQuery.FieldByName('DSC_OBSERVACOES').AsString;
    Produto.DscDetalhes := SelectProdutoQuery.FieldByName('DSC_DETALHES').AsString;

    Result := Produto;
end;

end.
