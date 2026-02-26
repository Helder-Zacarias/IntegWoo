unit ProdutoImagem;

interface
type
	TProdutoImagem = class
        private
            FCod_Id_Imagem: Int64;
            FCod_Id_Empresa: Integer;
            FCod_Id_Produto: Integer;
            FUrl_Imagem: string;
        public
            property CodIdImagem: Int64 read FCod_Id_Imagem write FCod_Id_Imagem;
            property CodIdEmpresa: Integer read FCod_Id_Empresa write FCod_Id_Empresa;
            property CodIdProduto: Integer read FCod_Id_Produto write FCod_Id_Produto;
            property UrlImagem: string read FUrl_Imagem write FUrl_Imagem;
    end;
implementation

end.
