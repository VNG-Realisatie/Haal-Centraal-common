# Design decisions HaalCentraal API's
Dit document beschrijft ontwerpkeuzes die gemaakt zijn voor het ontwerpen en specificeren van de API's binnen het programma HaalCentraal

## Naamgevingsconventie

Naamgevingsconventie is altijd zo duidelijk mogelijk te benoemen wat iets is.
Hoofdregel is altijd:
1. propertynamen moeten zoveel mogelijk zelfverklarend zijn (lezen van de description om de betekenis te begrijpen is liefst niet nodig)
2. propertynamen zijn zo kort als mogelijk om toch voldoende duidelijk en onderscheidend te zijn en niet langer dan daarvoor nodig

Hieronder staat een aantal algemene richtlijnen voor naamgeving van properties.
* Relaties (links naar gerelateerde resources): Kan de naam van de relatie hebben, of de naam van de gerelateerde resource, of beide, zodat in de context waarin deze is opgenomen duidelijk is waar de link betrekking op heeft.
  * Bijvoorbeeld:

    * woonplaats (resource "woonplaats")

    * ligtAanOpenbareRuimte (relatie "ligt aan" + gerelateerde resource "openbareRuimte")

    * hoofdAdres (relatie "hoofdAdres")

* Een property die 1 maal voorkomt wordt in enkelvoud benoemd. Property die als array gedefinieerd is wordt in meervoud benoemd.

* Identificatie: Wanneer een property (niet link of embedded) alleen de identificatie van de gerelateerde resource bevat, wordt naam van de resource plus het woord "identificatie"gebruikt.
Bijvoorbeeld maakt deel uit van + pand + identificatie = pandIdentificatie

* Parameters: Indien een parameter een element betreft dat geen onderdeel van de op te vragen resource is, maar onderdeel van een gerelateerde resource, een subresource of een gegevensgroep, dan wordt de elementnaam voorafgegaan door de betreffende resourcenaam of gegevensgroepnaam en vervolgens twee underscores.
  * Bijvoorbeeld:

    * ingeschrevenpersoon__burgerservicenummer

    * verblijfplaats__postcode

* Enumeratiewaarden : Er wordt naar gestreefd om enumeratiewaarden te ontdoen van spaties en byzondere tekens. Indien mogelijk worden spaties in enumeratiewaarden vervangen door underscores.

* Voor endpoints, url's en parameters worden alleen kleine letters toegepast.
* Voor componentnamen in het schema wordt UpperCamelCase toegepast
* Voor properties wordt lowerCamelCase toegepast

* Schema componenten voor domeinwaarden en enumeraties krijgen vaste extensie
  Schema componenten voor dynamische domeinwaarden (referentielijsten zoals "Tabel 32 Nationaliteitentabel") en enumeraties krijgen respectievelijk extensie "\_tabel" en "\_enum".

## Descriptions als sibling van $Ref's

In OAS3 wordt er een warning gegeven als er naast een binnen een object een Description wordt opgenomen naast een $ref (Geen enkele Sibling is geoorloofd). In de draft van OAS3.1 is een description binnen een object naast een $ref wel geaccepteerd. Vooruitlopend op deze versie is het binnen de HaalCentraal-specificaties geaccepteerd dat er binnen een object naast een $ref een Description wordt opgenomen en wordt de warning voor lief genoment. [Zie hier](https://github.com/OAI/OpenAPI-Specification/issues/2033) voor toelichting.

## Hergebruik van yaml-componenten
Bij hergebruik van Yaml-componenten wordt gebruik gemaakt van absolute links zodat de openapi.yaml in alle editors onderhoudbaar is en dus iedereen die een bijdrage wil leveren een pull-request kan indienen.

*Ratio*
We willen bijdragers tijdens het ontwikkeltraject niet dwingen om de file-structuuur van de provider-developer over te nemen. dit leidt tot onnodige complexiteit op het ontkoppelpunt van provider en consumer tijdens het ontwikkeltraject.

*Kanttekening*
Nu verwijzen de links nog naar de master-branch van Haal-centraal-common. Op het moment dat de specificaties van 1 van de API's definitief wordt zal ook de common geversioneerd moeten worden (dmv een release op github)

## Toepassen van Patterns

Bij een specifieke bevragingen-API is het toepassen van Patterns beperkt tot de parameters.  

## Dynamische domeinwaarden worden in de response opgenomen met zowel de code als de omschrijving
Voor een element van een referentielijst-type, wordt in de response zowel de code als de omschrijving opgenomen. Dit betreft dynamische lijsten (tabellen) met een code en waarde, zoals "Tabel 32 Nationaliteitentabel" en "Tabel 36 Voorvoegselstabel".

*Ratio*
Garanderen dat verschillende systemen binnen en buiten de gemeente dezelfde (toestand) van de referentielijst kennen is duur, ingewikkeld en foutgevoelig.

*Kanttekening*
Als landelijk beheerde dynamische domeinwaarden ook daadwerkelijk landelijk beschikbaar gesteld worden (zoals de common groud gedachte wel beoogd) dan worden deze als resource ontsloten en dus als link (uri) opgenomen.


## Enumeraties worden in het bericht opgenomen als waarde.
In de API specificaties worden enumeratiewaarden opgenomen met de waarde, in de description wordt de bijbehorende code genoemd.

*Ratio*
Door direct de waarde in de enumeratie aan te bieden hoeft de consumer-developer niet eerst de enumeratie-code te vertalen naar de enumeratiewaarde.

*Kanttekening*
De lengte van de enumeratiewaarden zal zoveel mogelijk beperkt moeten worden.

## Enumeraties-waarden bevatten geen hoofdletters.
Enumeratiewaarden bevatten alleen kleine letters en underscores. Geen spaties, geen speciale tekenen en geen hoofletters.

*Ratio*
In sommige development-omgevingen leveren hoofletters, spaties of speciale tekens in enumeratie-waarden een probleem op met code-genereren.

## oneOf constructie wordt niet gebruikt in de API-sepcificaties.
Alhoewel de oneOf constructie een valide OAS3 constructie is levert deze bij het genereren van code problemen op.
Deze constructie wordt ontweken door twee mogelijke alternatieven.
* De subtypes worden samengevoegd tot 1 object en er wordt een typeveld toegevoegd om te duiden welk subtype het betreft. Deze keuze is logisch als de subtypes grotendeels overlappen.
* De subtypes worden volledig opgenomen als property van een object. In het response is altijd maar 1 van deze properties gevuld. Deze keuze is logisch als de subtypes weing gemeenschappelijke properties hebben.

*Ratio*
Diverse code-generatoren gaan dus niet goed om met deze constructie en genereren foutieve code.

*Kanttekening*
Mochten code-genratoren in de toekomst wel goed met deze constructie om kunnen gaan dan is het het overwegen waard om deze constructie aan te passen bij de eerstvolgende major (breaking) change.

## Gemeentelijke kerngegevens en plusgegevens worden niet opgenomen in de resource.
In de response worden alleen gegevens opgenomen die in de basisregistratie worden vastgelegd.

*Ratio*
Deze gegevens worden niet vastgelegd in een (voor alle gemeenten geldend) bronsysteem dat voor de bevraging geraadpleegd kan worden. Deze gegevens zijn dus (voorlopig) niet raadpleegbaar. Ook worden deze gegevens niet in alle gemeenten (op dezelfde manier) gebruikt.

## Alleen gerelateerde resources uit dezelfde bron kunnen embed worden
Bijvoorbeeld in de resource van een ingeschreven natuurlijk persoon bij de BRP-bevraging kunnen de relaties partner(schap), ouders en kinderen embed worden opgenomen met gebruik van de expand-parameter. Dit betekent dat het mogelijk is in één aanroep de ingeschreven persoon te krijgen, met daarbij gegevens over de relaties met eventuele partner(s), ouders en kinderen.

Wanneer een gerelateerde resource expand wordt, wordt de gehele sub-resource teruggegeven, tenzij in de expand parameter alleen een deel van de gerelateerde resource gevraagd is.

Gegevens uit een andere bron/registratie (bijvoorbeeld het BAG-adres van een persoon) kunnen niet embed worden.

*Ratio*
We willen "tight coupling" met andere bronnen voorkomen. Overd domeinen heen wordt alleen met links verwezen.

## We nemen geen (inverse) relaties uit een ander domein op
Vanuit andere registraties bestaan er relaties naar ingeschreven natuurlijk personen. Een persoon kan bijvoorbeeld zakelijk gerechtigde zijn van een Kadastraal object of functionaris zijn van een bedrijf.
Deze inverse relaties uit een andere bron worden niet opgenomen bij de ingeschreven natuurlijk persoon.
Wanneer er functionele behoefte is aan deze gegevens moeten deze bij de betreffende bron (bijvoorbeeld BRK of HR) worden opgevraagd.

*Ratio*
We bevragen gegevens bij de bron. Een bron kan alleen gegevens leveren die ze zelf heeft.

## Gebruik van expand=true wordt uitgesloten (JB: Deze is volgens mij achterhaald)
Voor het gebruik van de API is het gebruiken van expand=true om alle relaties embed te krijgen is niet toegestaan.

*Ratio*
Het embedded van gerelateerde resources moet bewust worden gebruikt.

*JB: Deze is vroeg in het traject opgenomen vanwege de toenmalige versie van de API-strategie. Aangezien wij maximaal 1 niveau diep embedden zal expand=tru geen enkel probleem opleveren. Ik stel voor deze design decision te laten vallen. *

## Relaties kunnen maximaal één niveau diep worden embed
Door het gebruik van de parameter expand kunnen gerelateerde resources worden embed in het antwoord. Relaties van de gerelateerde resource buiten het domein van de API worden alleen als link opgenomen, maar kunnen zelf niet embed worden.

Bijvoorbeeld van een persoon kunnen de gegevens van de gerelateerde sub-resource huwelijk/geregistreerd partnerschap direct worden meegeladen. Daarin zitten alleen de gegevens van de relatie zoals die ook in betreffende categorie van LO GBA voorkomen, zoals ook de naam van de partner.
Wanneer echter de partner (ook) een ingeschreven persoon is, wordt een hyperlink naar de resource van deze persoon opgenomen. De gegevens van deze ingeschreven persoon (de partner) kunnen echter niet ok worden embed.

*Ratio*
Implementatie en gebruik eenvoudig houden. Er is geen functionele behoefte om diep gegevens te embedded.
Het opvragen van relaties is eenvoudig. Bij dieper embedden kan doelbinding een probleem worden. Bij dieper embedden kunnen er aan provider-kan performance-problemen ontstaan.

## Namen van gegevensgroepen worden ingekort.
De benaming van componenten en properties die gebaseerd zijn op een informatiemodel worden waar nodig ingekort.

Bijvoorbeeld "verblijfstitelIngeschrevenNatuurlijkPersoon" wordt "verblijfstitel", "overlijdenIngeschrevenNatuurlijkPersoon" wordt "overlijden", "geboorteIngeschrevenNatuurlijkPersoon" wordt "geboorte", enz.

*Ratio*
* De namen zijn erg lang. Dit is niet bevorderlijk voor eenvoud van implementatie.
* Extensie "IngeschrevenNatuurlijkPersoon" is redundant, want het is al duidelijk dat het gaat over eigenschappen van een ingeschreven natuurlijk persoon.

## De API filtert terug te geven gegevens op autorisatie van de organisatie
De API levert alleen gegevens terug waar de vragende organisatie voor geautoriseerd is.
Er worden geen aparte endpoints of resources gedefinieerd per autorisatieprofiel.

De bronhouder die gegevens ter beschikking stelt is verantwoordelijk voor het leveren van alleen gegevens waarvoor de juiste autorisatie bestaat. Bij de bronhouder gaat het om autorisatie op niveau van de vragende organisatie (gemeente).
De gemeente is er verantwoordelijk voor de resultaten van de API aanvraag te filteren op autorisatie van de betreffende gebruiker.

*Ratio*

Uitgangspunt in de architectuur is gedelegeerde autorisatie.

## De response heeft geen verplichte properties
Alle properties in de response worden in de Open API Specificaties gedefinieerd als optioneel, ook wanneer de betreffende attributen in het informatiemodel verplicht zijn.

*Ratio*
De hoeveelheid businesslogica in interface beperken. Zorgen dat zoveel mogelijk antwoord gegeven kan worden, ook wanneer een verwachte property geen waarde heeft. Het alternatief, het opnemen van de reden van geen waarde (zoals StUF:noValue) is dan niet nodig, wat het gebruik van de API eenvoudiger maakt.
Tevens compliceert het verplicht maken van elementen de toepassing van de "fields" en de "expand" parameters.

## We gebruiken geen overerving van abstracte types in de API specificaties
Bijvoorbeeld ingeschreven natuurlijk persoon wordt in de schema's platgeslagen met bovenliggende types (subject, persoon, natuurlijk persoon).

*Ratio*
Zolang we niets doen met de abstracte types (subject, persoon, natuurlijk persoon), heeft het geen zin dit mee te nemen in de component schema's.

*Kanttekening*
Deze design decision is al lang geleden gemaakt. Meer recent hebben we uit technische hergebruik overwegingen abstracte types geïntroduceerd. Het is het overwegen waard om die technische keuzes te vergelijken met de keuzes uit de informatiemodellen en te controleren of daar uniformereing mogelijk en wenselijk is.

## Sortering voor actuele zoekresultaten worden niet gesorteerd
De API standaard schrijft niet voor hoe zoekresultaten in de API moeten worden gesorteerd. Wanneer de client behoefte heeft aan gesorteerde resultaten, moet zij de ontvangen resultaten zelf sorteren.

## Historie wordt gesorteerd op geldigheid met meest actuele resultaat bovenaan
Historie wordt aflopend gesorteerd op datum geldigheid (geldigVan).

## Historie elementen krijgen dezelfde naam en betekenis als in de NEN3610
beginGeldigheid en eindGeldigheid
Binnen de NEN standaard is er een keuze-mogelijkheid (datum en datumtijd) voor het formaat waarin de historie wordt bijgehouden. De Bron houdt geen tijd bij dus schrijven we het datum-formaat voor.

## Historie: inonderzoek wordt alleen actueel getoond
Binnen de historie-endpoints wordt alleen de actuele situatie met betrekking tot "in Onderzoek" getoond. Er wordt geen historie getoond van de onderzoeken die in het verleden hebben plaatsgevonden.  

## Toepassen van HAL-Links
Er zijn grofweg twee categoriën Hal-links waar we gebruik van maken. Links naar resources binnen het eigen domein en links naar resources die in een ander domein beheerd worden. Om discoverability te bereiken, worden voor beide categorieën de Hal-link opgenomen naar de gerelateerde resource.

## Identificatie van de gerelateerde resources worden opgenomen in de content van de opgevraagde resource
Voor developers die geen HAL links willen gebruiken wordt tevens de identificatie van de gerelateerde resource opgenomen.

## Gebruik van Booleans als indicatoren
In diverse situaties worden booleans opgenomen als er sprake is van indicatoren. Deze booleans worden alleen geretourneerd als de waarde van de boolean ook informatief is. De indicator wordt dus alleen opgenomen als de waarde vand de Boolean "true" is.

## Attributen die geen waarde of een boolean waarde ‘false’ hebben, worden niet geretourneerd door de API.
