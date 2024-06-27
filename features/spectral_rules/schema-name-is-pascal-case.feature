# language: nl
Functionaliteit: Een schema name is in Pascal case

    Achtergrond:
        Gegeven de spectral rule 'schema-names-pascal-case'

    Scenario: Naam schema component is Pascal case
        Gegeven de OpenAPI specificatie
        """
        openapi: 3.0.3
        components:
          schemas:
            PascalCaseComponent:
              type: object
        """
        Als de OpenAPI specificatie is gevalideerd met spectral
        Dan bevat spectral's resultaat geen validatie meldingen

    Scenario: Naam schema component is niet Pascal case
        Gegeven de OpenAPI specificatie
        """
        openapi: 3.0.3
        components:
          schemas:
            <schema naam>:
              type: object
        """
        Als de OpenAPI specificatie is gevalideerd met spectral
        Dan bevat spectral's resultaat de validatie melding "<schema naam> is niet PascalCase (UpperCamelCase): Object{} must match the pattern \"/^([A-Z][a-z0-9]+)+(_embedded|_links|_enum|_tabel)?$/\""

        Voorbeelden:
            | schema naam          |
            | camelCaseComponent   |
            | snake_case_component |
            | kebab-case-component |

    Scenario: Uitzondering schema component namen
        Gegeven de OpenAPI specificatie
        """
        openapi: 3.0.3
        components:
          schemas:
            <schema naam>:
              type: object
        """
        Als de OpenAPI specificatie is gevalideerd met spectral
        Dan bevat spectral's resultaat geen validatie meldingen

        Voorbeelden:
            | schema naam        |
            | Component_enum     |
            | Component_links    |
            | Component_embedded |
            | Component_tabel    |
