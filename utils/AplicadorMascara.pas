unit AplicadorMascara;

interface
uses
    System.SysUtils, VCL.Dialogs;

function AplicarMascaraCPF(const CPF: string): string;
function AplicarMascaraCNPJ(const CNPJ: string): string;
function AplicarMascaraCEP(const CEP: string): string;
implementation

function AplicarMascaraCPF(const CPF: string): string;
var
  ApenasNumeros: string;
  I: Integer;
begin
  ApenasNumeros := '';

  // Remove tudo que não for número
  for I := 1 to Length(CPF) do
  begin
    if CPF[I] in ['0'..'9'] then
      ApenasNumeros := ApenasNumeros + CPF[I];
  end;

  // Verifica se tem 11 dígitos
  if Length(ApenasNumeros) <> 11 then
  begin
    Result := CPF; // retorna original se inválido
    Exit;
  end;

  // Aplica a máscara
  Result :=
    Copy(ApenasNumeros, 1, 3) + '.' +
    Copy(ApenasNumeros, 4, 3) + '.' +
    Copy(ApenasNumeros, 7, 3) + '-' +
    Copy(ApenasNumeros, 10, 2);
end;

function AplicarMascaraCNPJ(const CNPJ: string): string;
var
  ApenasNumeros: string;
  I: Integer;
begin
  ApenasNumeros := '';

  // Remove tudo que não for número
  for I := 1 to Length(CNPJ) do
  begin
    if CNPJ[I] in ['0'..'9'] then
      ApenasNumeros := ApenasNumeros + CNPJ[I];
  end;

  // Verifica se tem 14 dígitos
  if Length(ApenasNumeros) <> 14 then
  begin
    Result := CNPJ; // retorna original se inválido
    Exit;
  end;

  // Aplica a máscara
  Result :=
    Copy(ApenasNumeros, 1, 2) + '.' +
    Copy(ApenasNumeros, 3, 3) + '.' +
    Copy(ApenasNumeros, 6, 3) + '/' +
    Copy(ApenasNumeros, 9, 4) + '-' +
    Copy(ApenasNumeros, 13, 2);
end;

function AplicarMascaraCEP(const CEP: string): string;
var
  CepLimpo: string;
begin
  // Remove máscara existente
  CepLimpo := CEP.Replace('.', '').Replace('-', '').Trim;

  // Limita a 8 dígitos
  if Length(CepLimpo) > 8 then
    CepLimpo := Copy(CepLimpo, 1, 8);

  case Length(CepLimpo) of
    0..2:
      Result := CepLimpo;

    3..5:
      Result := Copy(CepLimpo, 1, 2) + '.' + Copy(CepLimpo, 3, Length(CepLimpo));

    6..8:
      Result := Copy(CepLimpo, 1, 2) + '.' +
                Copy(CepLimpo, 3, 3) + '-' +
                Copy(CepLimpo, 6, 3);
  else
    Result := CepLimpo;
  end;
end;

end.
