# language: nl
Functionaliteit: Een query parameter name is in Camel case

    Achtergrond:
        Gegeven de spectral rule 'query-parameter-names-camel-case'

    Abstract Scenario: Name property van query parameter component is Camel case
        Gegeven de OpenAPI specificatie
        """
        openapi: 3.0.3
        components:
          parameters:
            parameter1:
              name: <parameter name>
              in: query
        """
        Als de OpenAPI specificatie is gevalideerd met spectral
        Dan bevat spectral's resultaat geen validatie meldingen

        Voorbeelden:
          | parameter name |
          | datumVan       |
          | peildatum      |

    Abstract Scenario: Name property van query parameter component is niet Camel case
        Gegeven de OpenAPI specificatie
        """
        openapi: 3.0.3
        components:
          parameters:
            parameter1:
              name: <parameter name>
              in: query
        """
        Als de OpenAPI specificatie is gevalideerd met spectral
        Dan bevat spectral's resultaat de validatie melding "<parameter name> is niet camelCase: must be camel case"

        Voorbeelden:
          | parameter name        |
          | DatumVan              |
          | peil_datum            |
          | burger-service-nummer |

    Abstract Scenario: Name property van inline query parameter is Camel case
        Gegeven de OpenAPI specificatie
        """
        openapi: 3.0.3
        paths:
          /resource:
            get:
              parameters:
              - name: <parameter name>
                in: query
        """
        Als de OpenAPI specificatie is gevalideerd met spectral
        Dan bevat spectral's resultaat geen validatie meldingen

        Voorbeelden:
          | parameter name |
          | datumVan       |
          | peildatum      |

    Abstract Scenario: Name property van inline query parameter is niet Camel case
        Gegeven de OpenAPI specificatie
        """
        openapi: 3.0.3
        paths:
          /resource:
            get:
              parameters:
              - name: <parameter name>
                in: query
        """
        Als de OpenAPI specificatie is gevalideerd met spectral
        Dan bevat spectral's resultaat de validatie melding "<parameter name> is niet camelCase: must be camel case"

        Voorbeelden:
          | parameter name        |
          | DatumVan              |
          | peil_datum            |
          | burger-service-nummer |
