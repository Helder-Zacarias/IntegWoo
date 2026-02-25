unit TrimTexto;

interface
uses
	System.SysUtils;

function RemoverEspacos(Texto: string): string;

implementation
function RemoverEspacos(Texto: string): string;
begin
    Result := Trim(UpperCase(Texto));
end;
end.
