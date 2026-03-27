unit TransformadorDeTexto;

interface
uses
	Winapi.Windows,
    System.SysUtils, System.Character, System.SysConst;

function NormalizarTexto(const Texto: string): string;
function SubstituirEspacosPorTraco(Texto: string): string;
function RemoverAcentos(const Texto: string): string;

implementation

function NormalizarTexto(const Texto: string): string;
begin
    Result := Trim(UpperCase(Texto))
end;

function SubstituirEspacosPorTraco(Texto: string): string;
begin
    Texto  := StringReplace(Texto, ' ', '-', [rfReplaceAll]);
    Result := UpperCase(Texto);
end;

function RemoverAcentos(const Texto: string): string;
const
  // Mapeamento expandido para cobrir casos comuns e especiais
  ComAcentos = 'ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ';
  SemAcentos = 'AAAAAAACEEEEIIIIDNOOOOOOUUUUYbsaaaaaaaceeeeiiiidnoooooouuuuyby';
var
  i, p: Integer;
begin
  Result := Texto;
  for i := 1 to Length(Result) do
  begin
    p := Pos(Result[i], ComAcentos);
    if p > 0 then
      Result[i] := SemAcentos[p];
  end;
end;

end.
