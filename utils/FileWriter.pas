unit FileWriter;

interface
uses
    System.SysUtils, System.Classes;
procedure SalvarConteudoEmArquivo(Arquivo: string; Conteudo: string);

implementation

procedure SalvarConteudoEmArquivo(Arquivo: string; Conteudo: string);
var
	FileWriter: TStringList;
begin
	FileWriter :=  TStringList.Create;

    try
        if FileExists(Arquivo) then
        	FileWriter.LoadFromFile(Arquivo);

    	FileWriter.Add(Conteudo);
    	FileWriter.SaveToFile(Arquivo);
    finally
       FileWriter.Free;
    end;
end;
end.
