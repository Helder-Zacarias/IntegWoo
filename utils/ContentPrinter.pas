unit ContentPrinter;

interface
uses
    System.SysUtils, System.Classes,Produto, Vcl.Dialogs;
procedure PrintProduto(Produto: TProduto);
implementation
procedure PrintProduto(Produto: TProduto);
begin
    ShowMessage(
    	'COD_ID_PRODUTO: '  + Produto.CodIdProduto.ToString  +sLineBreak +
        'COD_ID_EMPRESA: ' + Produto.CodIdEmpresa.ToString + sLineBreak +
        'COD_PRODUTO: '  + Produto.CodProduto.ToString  + sLineBreak +
        'COD_ID_SECAO: '  + Produto.CodIdSecao.ToString  + sLineBreak +
        'COD_ID_GRADE: '  + Produto.CodIdGrade.ToString  + sLineBreak +
        'DSC_COMPLETA: ' + Produto.DscCompleta
    );
end;
end.
