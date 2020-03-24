# language: nl
Functionaliteit: URI templating
    Als API provider
    wil ik uri templating kunnen gebruiken
    zodat gelijksoortige links kunnen worden gerepresenteerd door één URI template

    Zoals gespecificeerd in RFC 6570 (https://tools.ietf.org/html/rfc6570):
    - Een URI template is een string die 0 of meer expressies bevat, waarmee een verzameling van URI's kan worden beschreven
    - Een expression is de tekst tussen een open accolade '{' en een sluit accolade '}' inclusief de accolade tekens
    - Expanden van een template is het vervangen van een expression door een waarde. De manier van expanden wordt bepaald door een optionele operator in de expression. Voor meer info zie: https://tools.ietf.org/html/rfc6570#section-2.2

    Op het moment van specificeren (18-03-2020) wordt in de Haal Centraal API's alleen de meest simpele 'Simple String Expansion' expression gebruikt,
    een {expression} wordt vervangen door een variabele

    De OpenAPI Specifications Server Object ondersteunt ook URI templating (https://swagger.io/specification/#serverObject).
    In de url property kunnen één of meerdere expressions worden gespecificeerd. De mogelijke waarden voor elke expression worden in de variables map gespecificeerd.
    In onderstaande scenario's wordt voor de Server objecten URI templating toegepast.

Abstract Scenario: samenstellen van een templated url
    Gegeven de OpenAPI specificatie met de volgende servers definitie
    """
    servers:
    - url: https://{hostname}/lvbag/api/haal-centraal-bag-bevragen/v{version}
      variables:
        hostname:
          default: 'api.kadaster.nl'
        versie:
          default: '1'
    """
    En de path om een adres te raadplegen: '/adressen/{adresidentificatie}'
    Als URI templating is toegepast voor een <type> adres url
    Dan is de templated url '<templated url>'

    Voorbeelden:
    | type     | templated url                                                                                    |
    | absoluut | https://{hostname}/lvbag/api/haal-centraal-bag-bevragen/v{version}/adressen/{adresidentificatie} |
    | relatief | /lvbag/api/haal-centraal-bag-bevragen/v{version}/adressen/{adresidentificatie}                   |

Scenario: expanden een templated url
    Gegeven een json response
    """
    {
        "_link": {
            adres: {
                "href": "<templated url>"
                "templated": true
            }
        },
        "adresidentificatie": "0163200000554956"
    }
    """
    En de OpenAPI specificatie met de volgende servers definitie
    """
    servers:
    - url: https://{hostname}/lvbag/api/haal-centraal-bag-bevragen/v{version}
      variables:
        hostname:
          default: 'api.kadaster.nl'
        versie:
          default: '1'
    """
    Als de templated adres url is ge-expand voor adresidentificatie '0163200000554956'
    Dan is de expanded url '<expanded url>'

    Voorbeelden:
    | templated url                                                                                    | expanded url                                                                              |
    | https://{hostname}/lvbag/api/haal-centraal-bag-bevragen/v{version}/adressen/{adresidentificatie} | https://api.kadaster.nl/lvbag/api/haal-centraal-bag-bevragen/v1/adressen/0163200000554956 |
    | /lvbag/api/haal-centraal-bag-bevragen/v{version}/adressen/{adresidentificatie}                   | /lvbag/api/haal-centraal-bag-bevragen/v1/adressen/0163200000554956                        |
