unit TransformadorData;

interface
  uses System.SysUtils, System.DateUtils;

  function ParseDataWoo(const ADataStr: string): TDateTime;
implementation
  function ParseDataWoo(const ADataStr: string): TDateTime;
var
  LFormatSettings: TFormatSettings;
begin
  Result := 0;
  if ADataStr.Trim.IsEmpty then Exit;

  // Tenta converter usando ISO8601 (O Delphi lida bem com '-' e 'T')
  try
    Result := ISO8601ToDate(ADataStr);
  except
    // Se falhar, tenta converter forçando o formato YYYY-MM-DD
    try
      LFormatSettings := TFormatSettings.Create;
      LFormatSettings.DateSeparator := '-';
      LFormatSettings.ShortDateFormat := 'yyyy-mm-dd';
      Result := StrToDateTime(ADataStr, LFormatSettings);
    except
      Result := 0;
    end;
  end;
end;
end.
