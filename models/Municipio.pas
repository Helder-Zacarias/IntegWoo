unit Municipio;

interface

type
  TMunicipio = class
  private
    FCOD_ID_MUNICIPIO: Integer;
    FCOD_ID_UF: Integer;
    FCOD_UF: Integer;
    FCOD_MUNICIPIO_IBGE: Integer;
    FDSC_MUNICIPIO: string;
    FDSC_CHAVE: string;

  public
    property CodIdMunicipio: Integer read FCOD_ID_MUNICIPIO write FCOD_ID_MUNICIPIO;
    property CodIdUf: Integer read FCOD_ID_UF write FCOD_ID_UF;
    property CodUf: Integer read FCOD_UF write FCOD_UF;
    property CodMunicipioIbge: Integer read FCOD_MUNICIPIO_IBGE write FCOD_MUNICIPIO_IBGE;
    property DscMunicipio: string read FDSC_MUNICIPIO write FDSC_MUNICIPIO;
    property DscChave: string read FDSC_CHAVE write FDSC_CHAVE;
  end;

implementation

end.
