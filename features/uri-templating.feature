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

    Afspraken:
    - gebruik {serverurl} als placeholder voor de server url van externe API url's
    - gebruik {propertynaam} als placeholder in een resource path.
      Propertynaam moet de naam zijn van een property van de resource of van een property van een gegevensgroep van de resource

  Scenario: Verwijzing naar één externe Resource
    Gegeven een KadastraalOnroerendeZaak heeft een verwijzing naar een Adres met identificatie '0200200000003734'
    En een Adres is te bevragen bij de BAG API via endpoint '/adressen'
    Als een templated Hal link voor de Adres is gegenereerd
    Dan is de Hal link naar de Adres gelijk aan
    | href                                  | templated |
    | {serverurl}/adressen/0200200000003734 | true      |
  
  Scenario: Verwijzingen naar meerdere externe Resources van dezelfde soort
    Gegeven een KadastraalOnroerendeZaak heeft een verwijzing naar meerdere Adressen met identificaties '0518200000437093, 0518200000812475'
    En een Adres is te bevragen bij de BAG API via endpoint '/adressen'
    Als een templated Hal link voor de Adressen is gegenereerd
    Dan is de Hal link naar de Adressen gelijk aan
    | href                                       | templated |
    | {serverurl}/adressen/{adresidentificaties} | true      |
    En is er een 'adresidentificaties' property die de identificatie van de verwezen Adressen bevat

  Scenario: Verwijzing naar verschillende externe Resources
    Gegeven een ZakelijkGerechtigde heeft een verwijzing naar een Persoon
    | type                            | identificatie |
    | ingeschreven_natuurlijk_persoon | 123456789     |
    En een ZakelijkGerechtigde heeft een verwijzing naar een Persoon
    | type                                 | identificatie |
    | ingeschreven_niet_natuurlijk_persoon | 440650207     |
    En een Persoon van het type ingeschreven_natuurlijk_persoon is te bevragen bij de BRP API via de endpoint /ingeschrevenpersonen
    En een Persoon van het type ingeschreven_niet_natuurlijk_persoon is te bevragen bij de BRK via de endpoint /kadasternietnatuurlijkpersonen
    Als een templated Hal link voor de Personen is gegenereerd
    Dan is de Hal link naar de Persoon van het type ingeschreven_natuurlijk_persoon gelijk aan
    | href                                       | templated | title |
    | {serverurl}/ingeschrevenpersonen/123456789 | true      | BRP   |
    En is de Hal link naar de Persoon van het type ingeschreven_niet_natuurlijk_persoon gelijk aan
    | href                                       | templated | title |
    | {serverurl}/ingeschrevenpersonen/440650207 | true      | BRK   |

  Scenario: Expanden van een templated url
    Gegeven de json response fragment van een kadastraal onroerende KadastraalOnroerendeZaak
    """
    {
      "_link": {
        "adressen": {
          "href": "{serverurl}/adressen/{adresidentificaties}",
          "templated": true
        }
      },
      "adresidentificaties": [
        "0518200000437093",
        "0518200000812475"
      ]
    }
    """
    En de server url van de BAG API is gelijk aan 'https://api.bag.kadaster.nl/esd/huidigebevragingen/v1'
    Als de templated adressen url is ge-expand voor adresidentificatie '0518200000437093'
    Dan is de ge-expande url gelijk aan 'https://api.bag.kadaster.nl/esd/huidigebevragingen/v1/adressen/0518200000437093'