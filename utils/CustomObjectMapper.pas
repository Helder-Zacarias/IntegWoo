unit CustomObjectMapper;

interface
uses
	System.SysUtils, System.Generics.Collections, Vcl.Dialogs, Uni,
    Produto, ProdutoImagem,
    WooProdutoRequest, WooImagemRequest, WPImagemResponse,
    WooProdutoCategoriaRequest,  WooAtributosProdutoRequest, WooAtributoResponse;

	function ProdutoToWooProdutoRequest(Produto: TProduto; TipoProduto: string;
    	 CategoriaId: Integer; ListaImagensProduto: TObjectList<TWooImagemRequest>;
         TermosProduto: TObjectDictionary<Integer, TList<string>>): TWooProdutoRequest;
	function ProdutoQueryToProduto(Query: TUniQuery): TProduto;
    function ProdutoImagemQueryToProdutoImagem(Query: TUniQuery): TProdutoImagem;
    function WPImagemResponseToWooImagemRequest(ImagemResponse: TWPImagemResponse): TWooImagemRequest;

implementation

function ProdutoToWooProdutoRequest(
    Produto: TProduto;
    TipoProduto: string;
    CategoriaId: Integer;
    ListaImagensProduto: TObjectList<TWooImagemRequest>;
    TermosProduto: TObjectDictionary<Integer, TList<string>>
): TWooProdutoRequest;
var
    ProdutoCategoria: TWooProdutoCategoriaRequest;
    Termo: TPair<Integer, TList<string>>;
    Atributo: TWooAtributosProdutoRequest;
begin
    ProdutoCategoria := TWooProdutoCategoriaRequest.Create;
    ProdutoCategoria.Id := CategoriaId;

    Result := TWooProdutoRequest.Create;
    Result.Name := Produto.DscCompleta;
    Result.Sku := Produto.CodProduto.ToString;
    if Produto.NumPrecoVarejo = 0 then
        Result.RegularPrice := IntToStr(999)
    else
    	Result.RegularPrice := Produto.NumPrecoVarejo.ToString;

    Result.PType := TipoProduto;
    Result.AdicionarCategoria(ProdutoCategoria);

    if Assigned(ListaImagensProduto) then
    begin
      for var ImagemProduto in ListaImagensProduto do
    	Result.AdicionarImagem(ImagemProduto);
    end;

    if Assigned(TermosProduto) then
    begin
        try
        	for Termo in TermosProduto do
        	begin
                Atributo := TWooAtributosProdutoRequest.Create;
                Atributo.Id := Termo.Key;
                Atributo.Options := Termo.Value.ToArray;
                Atributo.Visible := True;
                Atributo.Variation := True;
                Result.AdicionarAtributo(Atributo);
        	end;
        finally
        end;
    end;
end;

function ProdutoQueryToProduto(Query: TUniQuery): TProduto;
begin
	Result := TProduto.Create;

    Result.CodIdProduto := Query.FieldByName('COD_ID_PRODUTO').AsInteger;
    Result.CodIdEmpresa := Query.FieldByName('COD_ID_EMPRESA').AsInteger;
    Result.CodProduto := Query.FieldByName('COD_PRODUTO').AsLargeInt;
    Result.CodIdGrade := Query.FieldByName('COD_ID_GRADE').AsInteger;
    Result.CodIdSecao := Query.FieldByName('COD_ID_SECAO').AsInteger;
    Result.NumPrecoVarejo := Query.FieldByName('NUM_PRECO_VAREJO').AsCurrency;
    Result.DscCompleta := Query.FieldByName('DSC_COMPLETA').AsString;
    Result.DscAbreviada := Query.FieldByName('DSC_ABREVIADA').AsString;
    Result.DscObservacoes := Query.FieldByName('DSC_OBSERVACOES').AsString;
    Result.DscDetalhes := Query.FieldByName('DSC_DETALHES').AsString;
end;

function ProdutoImagemQueryToProdutoImagem(Query: TUniQuery): TProdutoImagem;
begin
    Result := TProdutoImagem.Create;
    Result.CodIdImagem := Query.FieldByName('COD_ID_IMAGEM').AsInteger;
    Result.CodIdEmpresa := Query.FieldByName('COD_ID_EMPRESA').AsInteger;
    Result.CodIdProduto := Query.FieldByName('COD_ID_PRODUTO').AsInteger;
    Result.UrlImagem := Query.FieldByName('URL_IMAGEM').AsString;
end;

function WPImagemResponseToWooImagemRequest(ImagemResponse: TWPImagemResponse): TWooImagemRequest;
begin
    Result := TWooImagemRequest.Create;
    Result.Id := ImagemResponse.Id;
end;
end.
