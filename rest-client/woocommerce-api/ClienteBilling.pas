unit ClienteBilling;

interface

uses
  Rest.Json.Types;

type
  TClienteBilling = class
  private
    FFirstName: string;
    FLastName: string;
    FCompany: string;
    FAddress1: string;
    FAddress2: string;
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
    property FirstName: string read FFirstName write FFirstName;

    [JSONName('last_name')]
    property LastName: string read FLastName write FLastName;

    [JSONName('company')]
    property Company: string read FCompany write FCompany;

    [JSONName('address_1')]
    property Address1: string read FAddress1 write FAddress1;

    [JSONName('address_2')]
    property Address2: string read FAddress2 write FAddress2;

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

implementation

end.
