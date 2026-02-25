unit Secao;

interface
type TSecao = class
    private
        FCod_Id_Secao: Integer;
        FDsc_Secao: string;
    public
    	property CodIdSecao: Integer read FCod_Id_Secao write FCod_Id_Secao;
        property DscSecao: string read FDsc_Secao write FDsc_Secao;
end;
implementation

end.
