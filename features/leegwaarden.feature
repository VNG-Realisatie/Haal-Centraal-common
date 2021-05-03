# language: nl

Functionaliteit: Properties met leegwaarden worden niet opgenomen in het antwoord

    Scenario: De waarde van een gegeven is null
        Gegeven persoon met burgerservicenummer "999993653" heeft geen voorvoegsel
        Als de persoon wordt gevraagd met /ingeschrevenpersonen/999993653
        Dan bevat het antwoord geen property naam.voorvoegsel

    Scenario: Een array bevat nul items
        Gegeven op appartementsrecht met identificatie 22310827210003 rust geen enkele privaatrechtelijke beperking
        Als de onroerende zaak wordt gevraagd met /kadastraalonroerendezaken/22310827210003
        Dan bevat het antwoord geen property privaatrechtelijkeBeperkingIdentificaties

    Scenario: Een object heeft geen enkele property met een waarde die teruggegeven moet worden
        Gegeven persoon met burgerservicenummer "999993653" heeft voor object overlijden de volgende gegevens:
            | indicatieOverleden | false |
            | datum              | null  |
            | plaats             | null  |
            | land               | null  |
        Als de persoon wordt gevraagd met /ingeschrevenpersonen/999993653
        Dan bevat het antwoord geen property overlijden