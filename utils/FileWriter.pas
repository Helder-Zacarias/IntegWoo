unit FileWriter;

interface
uses
    System.Classes;
procedure SalvarConteudoEmArquivo(Filename: string; Content: string);

implementation

procedure SalvarConteudoEmArquivo(Filename: string; Content: string);
var
	FileWriter: TStringList;
begin
	FileWriter :=  TStringList.Create;

    try
    	FileWriter.Add(Content);
    	FileWriter.SaveToFile(FileName);
    finally
       FileWriter.Free;
    end;
end;
end.
