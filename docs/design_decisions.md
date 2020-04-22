# Design decisions HaalCentraal API's
Dit document beschrijft ontwerpkeuzes die gemaakt zijn voor het ontwerpen en specificeren van de API's binnen het programma HaalCentraal

## Richtlijnen voor naamgeving 

Onderstaande Design Decisions zijn een verbijzondering van paragraaf 6.1 van de [API Designrules Extensions](https://docs.geostandaarden.nl/api/API-Strategie-ext/#field-names-in-snake_case-camelcase-uppercamelcase-or-kebab-case). 

### DD1.1 Geef een zo duidelijk mogelijke naam
We benoemen altijd zo duidelijk mogelijk wat iets is. 

Hoofdregel is altijd:
1. propertynamen moeten zoveel mogelijk zelfverklarend zijn (lezen van de description om de betekenis te begrijpen is liefst niet nodig)
2. propertynamen zijn zo kort als mogelijk om toch voldoende duidelijk en onderscheidend te zijn en niet langer dan daarvoor nodig

### DD1.2 Namen van properties zijn in lowerCamelCase
Voor de namen van properties wordt lowerCamelCase toegepast.

### DD1.3 Schema componentnamen zijn in UpperCamelCase
Voor de namen van componenten in het schema wordt UpperCamelCase toegepast.

### DD1.4 Enumeraties-waarden bevatten geen spaties, speciale tekens en hoofdletters.
Enumeratiewaarden bevatten alleen kleine letters en underscores. Geen spaties, geen speciale tekens en geen hoofdletters.

_**Ratio**_

In sommige development-omgevingen leveren hoofdletters, spaties of speciale tekens in enumeratie-waarden een probleem op met code-genereren. 

### DD1.5 Namen van endpoints, url's en parameters bevatten alleen kleine letters
Voor de namen van endpoints, url's en parameters worden alleen kleine letters gebruikt. 

### DD1.6 Naamgeving van properties worden beïnvloed door de kardinaliteit
* Een property die 1 maal voorkomt wordt in enkelvoud benoemd. Een property die als array gedefinieerd is wordt in meervoud benoemd. 
* Als een relatie 1 keer kan voorkomen (kardinaliteit 0..1 of 1..1) dan wordt de naam van de resource in enkelvoud opgenomen; als de relatie meer dan 1 keer kan voorkomen (gedefinieerd als array), dan wordt de naam van de resource in meervoud opgenomen.

### DD1.7 Bij namen van relaties (links naar gerelateerde resources) gebruiken we in principe de naam van de betreffende resource als propertynaam voor de link
* Wanneer de gerelateerde resource één keer kan voorkomen wordt de resourcenaam omgezet naar enkelvoud. Wanneer de relatie meerdere keren kan voorkomen, wordt de resourcenaam in meervoud gebruikt.
* Bij gebruik van de resourcenaam als propertynaam wordt lowerCamelCase toegepast (zie DD1.2).
* Wanneer de resourcenaam niet voldoende beschrijvend is voor de betekenis van de relatie ("adres" is "verblijfplaats" van een persoon), of wanneer de resourcenaam niet onderscheidend is (ouders, partners en kinderen zijn allen relaties naar ingeschrevenpersonen) kan gekozen worden om bijvoorbeeld de relatienaam te gebruiken, of bijvoorbeeld de relatienaam gevolgd door de resourcenaam. Zo nodig wordt dit ingekort of aangepast om tot een bondige en duidelijke naam te komen.

  Bijvoorbeeld:

  * woonplaats (resource "woonplaatsen")

  * openbareRuimte (resource "openbareruimten")

  * verblijfplaats (resource "adressen")

  * kinderen (resource "ingeschrevenpersonen" en relatie "heeft kinderen")
  
### DD1.8 Namen van Identificatie properties zijn afhankelijk van het wel of niet voorkomen van sibling properties
Wanneer een relatie-property (niet link of embedded) alleen de identificatie van een gerelateerde resource bevat en geen andere properties, wordt als naam van de property de naam van de resource plus het woord 'Identificatie' gebruikt.

Bijvoorbeeld: _maakt deel uit van + pand + Identificatie = pandIdentificatie_

### DD1.9 Namen van parameters die geen onderdeel zijn van de op te vragen resource wijken af
Indien een parameter een element betreft dat geen onderdeel van de op te vragen resource is, maar onderdeel van een gerelateerde resource, een subresource of een gegevensgroep, dan wordt de elementnaam voorafgegaan door de betreffende resourcenaam of gegevensgroepnaam en vervolgens twee underscores.

Bijvoorbeeld: 
 
  * ingeschrevenpersoon__burgerservicenummer

  * verblijfplaats__postcode

### DD1.10 Naamgeving van enumeratiewaarden wordt ontdaan van spaties en bijzondere tekens
Er wordt naar gestreefd om enumeratiewaarden te ontdoen van spaties en bijzondere tekens. Indien mogelijk worden spaties in enumeratiewaarden vervangen door underscores.

### DD1.11 Schema componentnamen voor domeinwaarden en enumeraties krijgen een vaste extensie
Schema componenten voor dynamische domeinwaarden (referentielijsten zoals "Tabel 32 Nationaliteitentabel") en enumeraties krijgen respectievelijk extensie "\_tabel" en "\_enum".

### DD1.12 Redundantie in propertynamen wordt verwijderd. 
Dit is het geval wanneer in een propertynaam de gegevensgroepnaam of resourcenaam waar deze zich in bevindt wordt herhaald.

Bijvoorbeeld _verblijfstitelIngeschrevenNatuurlijkPersoon_ wordt _verblijfstitel_, _overlijdenIngeschrevenNatuurlijkPersoon_ wordt _overlijden_, _geboorteIngeschrevenNatuurlijkPersoon_ wordt _geboorte_, enz.

_**Ratio**_
* De namen zijn erg lang. Dit is niet bevorderlijk voor eenvoud van implementatie.
* Extensie "IngeschrevenNatuurlijkPersoon" is redundant, want het is al duidelijk dat het gaat over eigenschappen van een ingeschreven natuurlijk persoon.

## Enumeraties en dynamische lijsten

### DD2.1 Dynamische domeinwaarden worden in de response opgenomen met zowel de code als de omschrijving
Voor een element van een referentielijst-type, wordt in de response zowel de code als de omschrijving opgenomen. Dit betreft dynamische lijsten (tabellen) met een code en waarde, zoals "Tabel 32 Nationaliteitentabel".

_**Ratio**_

Garanderen dat verschillende systemen binnen en buiten de gemeente dezelfde (toestand) van de referentielijst kennen is duur, ingewikkeld en foutgevoelig.

### DD2.2 Dynamische domeinwaarden worden in de query-parameters met de code opgenomen
Voor een query-parameter waarin een entry uit een waardelijst of een landelijke tabel als selectie-criterium wordt gebruikt wordt de *code* van de entry gebruikt. 

### DD2.3 We gebruiken als enumeratiewaarden betekenisvolle waarden. 
Dus niet M en V, maar man en vrouw.

_**Ratio**_

Een developer moet bij het coderen begrijpen wat de code betekent, om fouten in de implementatie te voorkomen.

_**Kanttekening**_

De lengte van de enumeratiewaarden zal zoveel mogelijk beperkt moeten worden. 

## HAL, embedding en links

### DD3.1 Alleen gerelateerde resources uit dezelfde bron kunnen embed worden
Bijvoorbeeld in de resource van een ingeschreven natuurlijk persoon bij de BRP-bevraging kunnen de relaties partner(schap), ouders en kinderen embed worden opgenomen met gebruik van de expand-parameter. Dit betekent dat het mogelijk is in één aanroep de ingeschreven persoon te krijgen, met daarbij gegevens over de relaties met eventuele partner(s), ouders en kinderen.

Wanneer een gerelateerde resource expand wordt, wordt de gehele sub-resource teruggegeven, tenzij in de expand parameter alleen een deel van de gerelateerde resource gevraagd is.

Gegevens uit een andere bron/registratie (bijvoorbeeld het BAG-adres van een persoon) kunnen niet embed worden. Deze worden alleen als link opgenomen.

_**Ratio**_

We willen "tight coupling" met andere bronnen voorkomen. Over de domeinen heen wordt alleen met links verwezen. 

_**Kanttekening**_

Er zijn grofweg twee categoriën Hal-links waar we gebruik van maken. Links naar resources binnen het eigen domein en links naar resources die in een ander domein beheerd worden. Om discoverability te bereiken, worden voor beide categorieën de Hal-link opgenomen naar de gerelateerde resource. 

### DD3.2 We nemen geen (inverse) relaties uit een ander domein op
Vanuit andere registraties bestaan er relaties naar ingeschreven natuurlijk personen. Een persoon kan bijvoorbeeld zakelijk gerechtigde zijn van een Kadastraal object of functionaris zijn van een bedrijf.
Deze inverse relaties uit een andere bron worden niet opgenomen bij de ingeschreven natuurlijk persoon.
Wanneer er functionele behoefte is aan deze gegevens moeten deze bij de betreffende bron (bijvoorbeeld BRK of HR) worden opgevraagd.

_**Ratio**_

We bevragen gegevens bij de bron. Een bron kan alleen gegevens leveren die ze zelf heeft.

### DD3.3 Relaties kunnen maximaal één niveau diep worden embed
Door het gebruik van de parameter expand kunnen gerelateerde resources worden embed in het antwoord. Er is besloten dat relaties van de gerelateerde resource alleen als link worden opgenomen, deze worden zelf dus niet embed.

Bijvoorbeeld van een persoon kunnen de gegevens van de gerelateerde sub-resource huwelijk/geregistreerd partnerschap direct worden meegeladen. Daarin zitten alleen de gegevens van de relatie zoals die ook in betreffende categorie van LO GBA voorkomen, zoals ook de naam van de partner.
Wanneer echter de partner (ook) een ingeschreven persoon is, wordt alleen een hyperlink naar de resource van deze persoon opgenomen. De gegevens van deze ingeschreven persoon (de partner) mogen niet ook worden embed.

_**Ratio**_

Implementatie en gebruik eenvoudig houden. Er is geen functionele behoefte om diep gegevens te embedden.
Het opvragen van relaties is eenvoudig. Bij dieper embedden kan doelbinding een probleem worden. Bij dieper embedden kunnen er aan de provider-kant performanceproblemen ontstaan. 

### DD3.4 De identificatie van de gerelateerde resources worden opgenomen in de content van de opgevraagde resource
Voor developers die geen HAL links willen gebruiken wordt tevens de identificatie van de gerelateerde resource opgenomen in de content van de opgevraagde resource.

## Historie

### DD4.1 Historie wordt gesorteerd op geldigheid met het meest actuele resultaat bovenaan
Historie wordt aflopend gesorteerd op datum geldigheid (datumVan).

### DD4.2 Bij historie wordt alleen de actuele situatie van inOnderzoek getoond
Binnen de historie-endpoints wordt alleen de actuele situatie met betrekking tot "in Onderzoek" getoond. Er wordt geen historie getoond van de onderzoeken die in het verleden hebben plaatsgevonden.  

## Diversen

### DD5.1 Descriptions worden als sibling van $Ref's opgenomen

Waar in OAS3 een Description binnen een object naast een $ref niet toegestaan is (daar is geen enkele sibling geoorloofd) wordt deze in de draft van OAS3.1 wel toegestaan. Vooruitlopend op deze nieuwe versie is het binnen de HaalCentraal-specificaties geaccepteerd dat er binnen een object naast een $ref een Description wordt opgenomen. 
In OAS3 wordt er in deze gevallen een warning gegeven, aangezien dit soort descriptions echter binnen de geresolvde versie van het yaml bestand niet meer voorkomen wordt deze warning voor lief genomen. [Zie hier](https://github.com/OAI/OpenAPI-Specification/issues/2033) voor een toelichting.
Om er voor te zorgen dat er in OAS3 toch een description wordt getoond wordt deze opgenomen in de description van het schema component waar de property met de $ref in is opgenomen. Het wordt dus naar een niveau hoger getild.

### DD5.2 We maken hergebruik van yaml-componenten d.m.v. absolute links
Bij hergebruik van Yaml-componenten wordt gebruik gemaakt van absolute links zodat de openapi.yaml in alle editors onderhoudbaar is en dus iedereen die een bijdrage wil leveren een pull-request kan indienen. 

_**Ratio**_

We willen bijdragers tijdens het ontwikkeltraject niet dwingen om de file-structuuur van de provider-developer over te nemen. Dit leidt tot onnodige complexiteit op het ontkoppelpunt van provider en consumer tijdens het ontwikkeltraject. 

_**Kanttekening**_

Nu verwijzen de links nog naar de master-branch van Haal-centraal-common. Op het moment dat de specificaties van 1 van de API's definitief wordt zal ook de common geversioneerd moeten worden (d.m.v. een release op github) 

### DD5.3 Technische definities van properties alleen opnemen voor zover dat noodzakelijk is voor gebruik
Meestal volstaat het om in de definitie van properties in de response de _propertynaam, type, format, description_ en _example_ op te nemen.
We gebruiken daar niet de technische definities _pattern, minimum, maximum, minLength, maxLength, minItems_ en _required_, tenzij....
De technische definitie _title_ gebruiken we alleen wanneer de propertynaam afwijkt van de naam in het informatiemodel (en het informatiemodel bekend is bij veel gebruikers).
De technische definitie _enum_ gebruiken we wanneer (sommige/mogelijke) gebruikers de mogelijke waarden gebruiken in code/algoritmes en daarom moeten weten welke mogelijke waarden er zijn.  

### DD5.4 oneOf constructies worden niet gebruikt in de API-sepcificaties
Alhoewel de oneOf constructie een valide OAS3 constructie is levert deze bij het genereren van code problemen op.
Deze constructie wordt ontweken door twee mogelijke alternatieven. 
* De subtypes worden samengevoegd tot 1 object en er wordt een typeveld toegevoegd om te duiden welk subtype het betreft. Deze keuze is logisch als de subtypes grotendeels overlappen.
* De subtypes worden volledig opgenomen als property van een object. In het response is altijd maar 1 van deze properties gevuld. Deze keuze is logisch als de subtypes weing gemeenschappelijke properties hebben.

_**Ratio**_

Diverse code-generatoren gaan dus niet goed om met deze constructie en genereren foutieve code.

_**Kanttekening**_

Mochten code-generatoren in de toekomst wel goed met deze constructie om kunnen gaan dan is het het overwegen waard om deze constructie aan te passen bij de eerstvolgende major (breaking) change.

### DD5.5 Alleen gegevens vastgelegd in de bronregistratie van de provider van de API worden opgenomen
In de API worden alleen gegevens opgenomen die zijn vastgelegd in de bronregistratie van de provider van de API. Een van de consequenties daarvan is DD3.2 het niet embedden van resources uit een andere registratie. Een andere consequentie is het niet opnemen van kerngegevens. Dus de regel is halen bij de bron, een consequentie (toelichting of voorbeeld) is het niet opnemen van gemeentelijke kerngegevens en plusgegevens. 

_**Ratio**_

Het opnemen van gegevens uit een andere bron zorgt voor tight coupling met die andere bron.
Ook kan een bronsysteem niet zomaar gegevens uit een andere bron halen, zeker niet wanneer dat gegevens zijn waar autorisaties voor nodig zijn (zoals privacy gevoelige gegevens).
Tenslotte verhoogd het tevens moeten ontsluiten van gegevens uit andere bronnen de complexiteit nodeloos.

### DD5.6 De API filtert terug te geven gegevens op autorisatie van de organisatie
De API levert alleen gegevens terug waar de vragende organisatie voor geautoriseerd is.
Er worden geen aparte endpoints of resources gedefinieerd per autorisatieprofiel.

De bronhouder die gegevens ter beschikking stelt is verantwoordelijk voor het leveren van alleen gegevens waarvoor de juiste autorisatie bestaat. Bij de bronhouder gaat het om autorisatie op niveau van de vragende organisatie (gemeente).
De gemeente is er verantwoordelijk voor de resultaten van de API aanvraag te filteren op autorisatie van de betreffende gebruiker.

_**Ratio**_

Uitgangspunt in de architectuur is gedelegeerde autorisatie.

### DD5.7 De response heeft geen verplichte properties
Alle properties in de response worden in de Open API Specificaties gedefinieerd als optioneel, ook wanneer de betreffende attributen in het informatiemodel verplicht zijn.

_**Ratio**_

De hoeveelheid businesslogica in interface beperken. Zorgen dat zoveel mogelijk antwoord gegeven kan worden, ook wanneer een verwachte property geen waarde heeft. Het alternatief, het opnemen van de reden van geen waarde (zoals StUF:noValue) is dan niet nodig, wat het gebruik van de API eenvoudiger maakt.
Tevens compliceert het verplicht maken van elementen de toepassing van de "fields" en de "expand" parameters en het filteren van de terug te geven gegevens op autorisatie van de organisatie. 

### DD5.8 Actuele zoekresultaten worden niet gesorteerd
De API standaard schrijft niet voor hoe zoekresultaten in de API moeten worden gesorteerd. Wanneer de client behoefte heeft aan gesorteerde resultaten, moet zij de ontvangen resultaten zelf sorteren.
Dit betekent dat er in de berichtspecificaties geen gebruik gemaakt wordt van de _'sorteer'_ parameter.

### DD5.9 Properties die gebruik maken van Booleans worden alleen geretourneerd als de waarde 'true' is
In diverse situaties worden booleans opgenomen als er sprake is van indicatoren. Deze booleans worden alleen geretourneerd als de waarde van de boolean ook informatief is. Dit soort properties worden dus alleen opgenomen als de waarde van de Boolean 'true' is.
