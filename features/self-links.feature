# language: nl

Functionaliteit: JSON HAL self links worden opgenomen in de response
  Bij self-link op het hoogste niveau van de response, dus _links.self.href is identiek aan de volledige url van het request, inclusief alle queryparameters. Een gebruiker moet hiermee de response aan de request kunnen koppelen. Deze kan dus niet templated zijn. Dit kan wel een relatieve link zijn.

  Een self link in een embedded resource of in een collectie, dus een link in _embedded..[*]._links.self.href is een url die verwijst naar de betreffende resource. Deze link kan templated zijn.

  Scenario: self link van een collectie
    Als ingeschreven personen gezocht worden met "/ingeschrevenpersonen?naam__geslachtsnaam=groen&geboorte__datum=1983-05-26&inclusiefoverledenpersonen=true&fields=naam,geboorte,overlijden"
    Dan eindigt attribuut "_links.self.href" op "/ingeschrevenpersonen?naam__geslachtsnaam=groen&geboorte__datum=1983-05-26&inclusiefoverledenpersonen=true&fields=naam,geboorte,overlijden"
    En komt attribuut "templated" niet voor in "_links.self"

  Scenario: self link van een resource in een collectie
    Als ingeschreven personen gezocht worden met "/ingeschrevenpersonen?naam__geslachtsnaam=groen&geboorte__datum=1983-05-26&inclusiefoverledenpersonen=true&fields=naam,geboorte,overlijden"
    Dan geldt voor elk van de gevonden _embedded.ingeschrevenpersonen dat attribuut _links.self.href de tekst "/ingeschrevenpersonen/" plus de waarde van attribuut burgerservicenummer in deze resource bevat
    En geldt voor elk van de gevonden _embedded.ingeschrevenpersonen dat attribuut _links.self.href niet "naam__geslachtsnaam=groen" bevat
    En geldt voor elk van de gevonden _embedded.ingeschrevenpersonen dat attribuut _links.self.href niet "geboorte__datum=1983-05-26" bevat
    En geldt voor elk van de gevonden _embedded.ingeschrevenpersonen dat attribuut _links.self.href niet "inclusiefoverledenpersonen" bevat
    En geldt voor elk van de gevonden _embedded.ingeschrevenpersonen dat attribuut _links.self.href niet "fields" bevat

  Scenario: self link van een resource
    Als ingeschreven persoon wordt geraadpleegd met "/ingeschrevenpersonen/999999023?fields=naam,geboorte,overlijden&expand=kinderen
    Dan eindigt attribuut "_links.self.href" met "/ingeschrevenpersonen/999999023?fields=naam,geboorte,overlijden&expand=kinderen"

  Scenario: self link van een embedded resource
    Gegeven de persoon met burgerservicenummer 999999023 heeft een actuele partner
    Als ingeschreven persoon wordt geraadpleegd met "/ingeschrevenpersonen/999999023?expand=partners.naam&fields=naam,geboorte,overlijden"
    Dan bevat het attribuut "_embedded.partners[0]._links.self.href" de tekst "/ingeschrevenpersonen/999999023/partners/"
    En bevat het attribuut "_embedded.partners[0]._links.self.href" niet "?"
    En bevat het attribuut "_embedded.partners[0]._links.self.href" niet "expand"
    En bevat het attribuut "_embedded.partners[0]._links.self.href" niet "fields"
    En eindigt het attribuut "_embedded.partners[0]._links.self.href" niet op "/"
