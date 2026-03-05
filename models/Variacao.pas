unit Variacao;

interface
type
    TVariacao = class
        private
        	FCod_Id_Variacao: Integer;
        	FDsc_Variacao: string;
        published
        	property CodIdVariacao: Integer read FCod_Id_Variacao write FCod_Id_Variacao;
            property DscVariacao: string read FDsc_Variacao write FDsc_Variacao;
    end;
implementation

end.
