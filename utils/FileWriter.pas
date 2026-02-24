unit FileWriter;

interface
uses
    System.Classes;
procedure WriteContentToFile(Filename: string; Content: string);

implementation

procedure WriteContentToFile(Filename: string; Content: string);
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
