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

Scenario: versie in url
    Gegeven de link 'https://api.kadaster.nl/lvbag/api/haal-centraal-bag-bevragen/v1/adressen/0163200000554956'
    Als URI templating wordt toegepast voor de versie
    Dan is de template uri 'https://api.kadaster.nl/lvbag/api/haal-centraal-bag-bevragen/v{versie}/adressen/0163200000554956'

Abstract Scenario: path parameter
    Gegeven de link '<URI>'
    En in de link is 0163200000554956 de identificatie van een nummeraanduiding 
    Als URI templating wordt toegepast voor de nummeraanduidingidentificatie path parameter
    Dan is de template uri '<URI template>'

    Voorbeelden:
    | Omschrijving | URI                                                                                       | URI template                                                                                             |
    | Absoluut URL | https://api.kadaster.nl/lvbag/api/haal-centraal-bag-bevragen/v1/adressen/0163200000554956 | https://api.kadaster.nl/lvbag/api/haal-centraal-bag-bevragen/v1/adressen/{nummeraanduidingidentificatie} |
    | Relatief URL | /adressen/0163200000554956                                                                | /adressen/{nummeraanduidingidentificatie}                                                                |

Scenario: host name
    Gegeven de link 'https://api.kadaster.nl/lvbag/api/haal-centraal-bag-bevragen/v1/adressen/0163200000554956'
    Als URI templating wordt toegepast voor de host name
    Dan is de template uri 'https://{hostname}/lvbag/api/haal-centraal-bag-bevragen/v1/adressen/0163200000554956'

Scenario: meerdere expressions
    Gegeven de link 'https://api.kadaster.nl/lvbag/api/haal-centraal-bag-bevragen/v1/adressen/0163200000554956'
    Als URI templating wordt toegepast voor alle variabele delen
    Dan is de template uri 'https://{hostname}/lvbag/api/haal-centraal-bag-bevragen/v{versie}/adressen/{nummeraanduidingidentificatie}'
