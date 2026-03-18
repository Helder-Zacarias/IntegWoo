unit WooPedido;

interface

uses
  System.SysUtils, System.Classes, REST.Json.Types;

type

  // 🔹 MetaData
  TMetaData = class
  private
    FId: Integer;
    FKey: string;
    FValue: string;
  published
    [JSONName('id')]
    property Id: Integer read FId write FId;

    [JSONName('key')]
    property Key: string read FKey write FKey;

    [JSONName('value')]
    property Value: string read FValue write FValue;
  end;

  // 🔹 Image
  TImage = class
  private
    FId: string;
    FSrc: string;
  published
    [JSONName('id')]
    property Id: string read FId write FId;

    [JSONName('src')]
    property Src: string read FSrc write FSrc;
  end;

  // 🔹 Line Item
  TLineItem = class
  private
    FId: Integer;
    FName: string;
    FProduct_id: Integer;
    FQuantity: Integer;
    FTotal: string;
    FPrice: Double;
    FSku: string;
    FImage: TImage;
  published
    [JSONName('id')]
    property Id: Integer read FId write FId;

    [JSONName('name')]
    property Name: string read FName write FName;

    [JSONName('product_id')]
    property ProductId: Integer read FProduct_id write FProduct_id;

    [JSONName('quantity')]
    property Quantity: Integer read FQuantity write FQuantity;

    [JSONName('total')]
    property Total: string read FTotal write FTotal;

    [JSONName('price')]
    property Price: Double read FPrice write FPrice;

    [JSONName('sku')]
    property Sku: string read FSku write FSku;

    [JSONName('image')]
    property Image: TImage read FImage write FImage;
  end;

  // 🔹 Billing
type
  TBilling = class
  private
    FFirst_name: string;
    FLast_name: string;
    FCompany: string;
    FAddress_1: string;
    FAddress_2: string;
    FCity: string;
    FState: string;
    FPostcode: string;
    FCountry: string;
    FEmail: string;
    FPhone: string;
    FNumber: string;
    FNeighborhood: string;
    FPersonType: string;
    FCpf: string;
    FRg: string;
    FCnpj: string;
    FIe: string;
    FBirthdate: string;
    FGender: string;
    FCellphone: string;

  published
  	[JSONName('first_name')]
    property FirstName: string read FFirst_name write FFirst_name;

    [JSONName('last_name')]
    property LastName: string read FLast_name write FLast_name;

    [JSONName('company')]
    property Company: string read FCompany write FCompany;

    [JSONName('address_1')]
    property Address1: string read FAddress_1 write FAddress_1;

    [JSONName('address_2')]
    property Address2: string read FAddress_2 write FAddress_2;

    [JSONName('city')]
    property City: string read FCity write FCity;

    [JSONName('state')]
    property State: string read FState write FState;

    [JSONName('postcode')]
    property Postcode: string read FPostcode write FPostcode;

    [JSONName('country')]
    property Country: string read FCountry write FCountry;

    [JSONName('email')]
    property Email: string read FEmail write FEmail;

    [JSONName('phone')]
    property Phone: string read FPhone write FPhone;

    [JSONName('number')]
    property Number: string read FNumber write FNumber;

    [JSONName('neighborhood')]
    property Neighborhood: string read FNeighborhood write FNeighborhood;

    [JSONName('persontype')]
    property PersonType: string read FPersonType write FPersonType;

    [JSONName('cpf')]
    property Cpf: string read FCpf write FCpf;

    [JSONName('rg')]
    property Rg: string read FRg write FRg;

    [JSONName('cnpj')]
    property Cnpj: string read FCnpj write FCnpj;

    [JSONName('ie')]
    property Ie: string read FIe write FIe;

    [JSONName('birthdate')]
    property Birthdate: string read FBirthdate write FBirthdate;

    [JSONName('gender')]
    property Gender: string read FGender write FGender;

    [JSONName('cellphone')]
    property Cellphone: string read FCellphone write FCellphone;
  end;

  // 🔹 Shipping
  TShipping = class
  private
    FFirst_name: string;
    FLast_name: string;
    FAddress_1: string;
    FCity: string;
    FState: string;
    FPostcode: string;
    FPhone: string;
  published
    [JSONName('first_name')]
    property FirstName: string read FFirst_name write FFirst_name;

    [JSONName('last_name')]
    property LastName: string read FLast_name write FLast_name;

    [JSONName('address_1')]
    property Address1: string read FAddress_1 write FAddress_1;

    [JSONName('city')]
    property City: string read FCity write FCity;

    [JSONName('state')]
    property State: string read FState write FState;

    [JSONName('postcode')]
    property Postcode: string read FPostcode write FPostcode;

    [JSONName('phone')]
    property Phone: string read FPhone write FPhone;
  end;

  // 🔥 MAIN ORDER CLASS
  TWooPedido = class
  private
    FId: Integer;
    FStatus: string;
    FCurrency: string;
    FTotal: string;
    FCustomerId: Integer;
    FOrderKey: string;
    FDate_created: string;
    FBilling: TBilling;
    FShipping: TShipping;
    FLine_items: TArray<TLineItem>;
    FMeta_data: TArray<TMetaData>;
  published
    [JSONName('id')]
    property Id: Integer read FId write FId;

    [JSONName('status')]
    property Status: string read FStatus write FStatus;

    [JSONName('currency')]
    property Currency: string read FCurrency write FCurrency;

    [JSONName('total')]
    property Total: string read FTotal write FTotal;

    [JSONName('customer_id')]
    property CustomerId: Integer read FCustomerId write FCustomerId;

    [JSONName('order_key')]
    property OrderKey: string read FOrderKey write FOrderKey;

    [JSONName('date_created')]
    property DateCreated: string read FDate_created write FDate_created;

    [JSONName('billing')]
    property Billing: TBilling read FBilling write FBilling;

    [JSONName('shipping')]
    property Shipping: TShipping read FShipping write FShipping;

    [JSONName('line_items')]
    property LineItems: TArray<TLineItem> read FLine_items write FLine_items;

    [JSONName('meta_data')]
    property MetaData: TArray<TMetaData> read FMeta_data write FMeta_data;
  end;

implementation

end.
