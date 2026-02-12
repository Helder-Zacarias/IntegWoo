unit AppConfig;

interface
type TAppConfig = class
    private
    	class var FWordPressApiUrl: string;
        class var FWPUser: string;
        class var FWPPassword: string;
        class var FWooApiUrl: string;
        class var FConsumerKey: string;
        class var FConsumerSecret: string;
        class var FTestImagePath: string;
    public
        class procedure Load;
        class property WordPressApiUrl: string read FWordPressApiUrl;
        class property WPUser: string read FWPUser;
        class property WPPassword: string read FWPPassword;
        class property WooApiUrl: string read FWooApiUrl;
        class property ConsumerKey: string read FConsumerKey;
        class property ConsumerSecret: string read FConsumerSecret;
        class property TestImagePath: string read FTestImagePath;
end;
implementation
uses
    System.SysUtils,
  	System.IniFiles,
    Vcl.Dialogs;

class procedure TAppConfig.Load;
var
	Ini: TIniFile;
  	Path: string;
begin
	Path := ExtractFilePath(ParamStr(0)) + 'config.ini';

    if not FileExists(Path) then
    	raise Exception.Create('Config file not found: ' + Path);

    Ini := TIniFile.Create(Path);

    try
    	FWordPressApiUrl := Ini.ReadString('WordPress', 'API_URL', '');
        FWPUser := Ini.ReadString('WordPress', 'USER', '');
        FWPPassword := Ini.ReadString('WordPress', 'MEDIA_PASSWORD', '');

        FWooApiUrl := Ini.ReadString('WooCommerce', 'API_URL', '');
        FConsumerKey := Ini.ReadString('WooCommerce', 'CONSUMER_KEY', '');
        FConsumerSecret := Ini.ReadString('WooCommerce', 'CONSUMER_SECRET', '');
        FTestImagePath := Ini.ReadString('TestPaths', 'TEST_IMAGE_PATH', '');
    finally
        Ini.Free;
    end;
end;
end.
