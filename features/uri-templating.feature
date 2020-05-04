# language: nl
Functionaliteit: URI templating
    Als API provider
    wil ik uri templating kunnen gebruiken
    zodat grote aantallen links naar dezelfde API in de response kunnen worden gerepresenteerd door één URI template
    zodat ik geen url's naar externe API's hoeft te beheren

    Zoals gespecificeerd in RFC 6570 (https://tools.ietf.org/html/rfc6570):
    - Een URI template is een string die 0 of meer expressies bevat, waarmee een verzameling van URI's kan worden beschreven
    - Een expression is de tekst tussen een open accolade '{' en een sluit accolade '}' inclusief de accolade tekens
    - Expanden van een template is het vervangen van een expression door een waarde. De manier van expanden wordt bepaald door een optionele operator in de expression. Voor meer info zie: [Expressions](https://tools.ietf.org/html/rfc6570#section-2.2)

    Op het moment van specificeren (18-03-2020) wordt in de Haal Centraal API's alleen de meest simpele 'Simple String Expansion' expression gebruikt,
    een {expression} wordt vervangen door een variabele

    De OpenAPI Specifications Server Object ondersteunt ook URI templating. Zie [Server Object](https://swagger.io/specification/#serverObject).
    In de url property kunnen één of meerdere expressions worden gespecificeerd. De mogelijke waarden voor elke expression worden in de variables map gespecificeerd.
    In scenario 'url templating is toegepast in de server url' wordt voor de Server objecten URI templating toegepast.

    Afspraken:
    - gebruik {serverurl} als placeholder voor de server url van externe API url's
    - gebruik {propertynaam} als placeholder in een resource path.
      Propertynaam moet de naam zijn van een property van de resource of van een property van een gegevensgroep van de resource

  Scenario: url templating is toegepast in de server url
    Gegeven een OpenAPI specificatie met de volgende servers definitie
    """
    servers:
    - url: https://{domainname}/lvbag/api/haal-centraal-bag-bevragen/v{versie}
      variables:
        domainname:
          enum:
          - 'test.kadaster.nl'
          - 'www.kadaster.nl'
          default: 'www.kadaster.nl'
        versie:
          enum:
          - '1'
          - '2'
          default: '1'
    """
    Als een consumer de server url wil expanden voor versie 2 op de test omgeving
    Dan moet hij {domainname} vervangen met test.kadaster.nl
    En moet hij {versie} vervangen met 2
    En ziet de ge-expande server url er als volgt uit: https://test.kadaster.nl/lvbag/api/haal-centraal-bag-bevragen/v2

  Scenario: url templating toegepassen voor een externe API url
    Gegeven de resource path om een ingeschreven persoon te raadplegen is: /ingeschrevenpersonen/{burgerservicenummer}
    Als de provider URI templating wil toepassen voor de betreffende resource path
    Dan voegt hij {serverurl} aan het begin van de resource path
    En ziet de volgende HAL link er als volgt uit
    | templated | href                                                   |
    | true      | {serverurl}/ingeschrevenpersonen/{burgerservicenummer} |

  Abstract Scenario: url templating toepassen voor een resource path
    Gegeven de OpenAPI specificatie met de volgende servers definitie
    """
    servers:
    - url: https://{hostname}/lvbag/api/haal-centraal-bag-bevragen/v{versie}
      variables:
        hostname:
          default: 'www.kadaster.nl'
        versie:
          default: '1'
    """
    En de path om een adres te raadplegen: '/adressen/{adresidentificatie}'
    Als de provider URI templating voor een <type> adres url
    Dan bevat de response de volgende HAL link
    | templated | href            |
    | true      | <templated url> |
    En bevat de response een property met de naam adresidentificatie die moet worden gebruikt om de templated url te expanden

    Voorbeelden:
    | type     | templated url                                                                                   |
    | absoluut | https://{hostname}/lvbag/api/haal-centraal-bag-bevragen/v{versie}/adressen/{adresidentificatie} |
    | relatief | /lvbag/api/haal-centraal-bag-bevragen/v{versie}/adressen/{adresidentificatie}                   |

  Abstract Scenario: expanden van een templated url
    Gegeven een json response
    """
    {
      "_link": {
        adres: {
          "href": "<templated url>",
          "templated": true
        }
      },
      "adresidentificatie": "0163200000554956"
    }
    """
    En de OpenAPI specificatie met de volgende servers definitie
    """
    servers:
    - url: https://{hostname}/lvbag/api/haal-centraal-bag-bevragen/v{versie}
      variables:
        hostname:
          default: 'www.kadaster.nl'
        versie:
          default: '1'
    """
    Als de templated adres url is ge-expand voor adresidentificatie '0163200000554956'
    Dan is de ge-expande url '<expanded url>'

    Voorbeelden:
    | templated url                                                                                   | expanded url                                                                              |
    | https://{hostname}/lvbag/api/haal-centraal-bag-bevragen/v{versie}/adressen/{adresidentificatie} | https://api.kadaster.nl/lvbag/api/haal-centraal-bag-bevragen/v1/adressen/0163200000554956 |
    | /lvbag/api/haal-centraal-bag-bevragen/v{versie}/adressen/{adresidentificatie}                   | /lvbag/api/haal-centraal-bag-bevragen/v1/adressen/0163200000554956                        |
