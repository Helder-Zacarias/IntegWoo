unit Secao;

interface
type TSecao = class
    private
        FCod_Id_Secao: string;
        FDsc_Secao: string;
        FCod_Id_Site: string;
    public
    	property Cod_Id_Secao: string read FCod_Id_Secao write FCod_Id_Secao;
        property Dsc_Secao: string read FDsc_Secao write FDsc_Secao;
        property Cod_Id_Site: string read FCod_Id_Site write FCod_Id_Site;
end;
implementation

end.
