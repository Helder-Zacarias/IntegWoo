unit FormatadorDocumentos;

interface
uses
    VCL.Dialogs;
    function FormatarCPF(const CPF: string): string;
    function FormatarCNPJ(const CNPJ: string): string;
implementation

function FormatarCPF(const CPF: string): string;
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

function FormatarCNPJ(const CNPJ: string): string;
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

end.
