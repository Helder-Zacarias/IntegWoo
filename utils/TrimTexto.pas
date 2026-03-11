unit TrimTexto;

interface
uses
	System.SysUtils;

function RemoverEspacos(Texto: string): string;
function SubstituirEspacosPorTraco(Texto: string): string;

implementation
function RemoverEspacos(Texto: string): string;
begin
    Result := Trim(UpperCase(Texto))
end;

function SubstituirEspacosPorTraco(Texto: string): string;
begin
    Texto  := StringReplace(Texto, ' ', '-', [rfReplaceAll]);
    Result := UpperCase(Texto);
end;
end.
