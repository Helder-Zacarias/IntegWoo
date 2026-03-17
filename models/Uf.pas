unit Uf;

interface

uses
  System.SysUtils;

type
  TUf = class
  private
    FCOD_ID_UF: Integer;
    FCOD_UF_IBGE: Integer;
    FDSC_UF: string;
    FDSC_SIGLA_UF: string;
    FDSC_CHAVE: string;
  public
    property CodIdUf: Integer read FCOD_ID_UF write FCOD_ID_UF;
    property CodUfIbge: Integer read FCOD_UF_IBGE write FCOD_UF_IBGE;
    property DscUf: string read FDSC_UF write FDSC_UF;
    property DscSiglaUf: string read FDSC_SIGLA_UF write FDSC_SIGLA_UF;
    property DscChave: string read FDSC_CHAVE write FDSC_CHAVE;
  end;

implementation

end.
