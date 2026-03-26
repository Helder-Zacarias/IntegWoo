unit TransformadorDeTexto;

interface
uses
	Winapi.Windows, System.SysUtils;

function NormalizarTexto(Texto: string): string;
function SubstituirEspacosPorTraco(Texto: string): string;
function RemoverAcentos(Texto: string): string;

implementation
function NormalizarTexto(Texto: string): string;
begin
    Result := Trim(UpperCase(Texto))
end;

function SubstituirEspacosPorTraco(Texto: string): string;
begin
    Texto  := StringReplace(Texto, ' ', '-', [rfReplaceAll]);
    Result := UpperCase(Texto);
end;

function RemoverAcentos(Texto: string): string;
var
	Normalizado: string;
    Len: Integer;
begin
	Len := NormalizeString(NormalizationD, PChar(Texto), Length(Texto), nil, 0);
    SetLength(Normalizado, Len);
    NormalizeString(NormalizationD, PChar(Texto), Length(Texto), PChar(Normalizado), Len);

    Result := '';
    for var C in Normalizado do
        begin
            if not CharInSet(C, [#768..#879]) then // Unicode combining marks
            Result := Result + C;
        end;
	end;
end.


