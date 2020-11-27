#language: nl
Functionaliteit: Definieer geen inline object als property voor een schema component

    Achtergrond:
        Gegeven de spectral rule 'property-of-object-type'

    Scenario: Schema component property is geen object type
        Gegeven de OpenAPI specificatie
        """
        openapi: 3.0.3
        components:
          schemas:
            PascalCaseComponent:
              type: object
              properties:
                property1:
                  type: string
        """
        Als de OpenAPI specificatie is gevalideerd met spectral
        Dan bevat spectral's resultaat geen validatie meldingen

    Scenario: Schema component property is een object type
        Gegeven de OpenAPI specificatie
        """
        openapi: 3.0.3
        components:
          schemas:
            PascalCaseComponent:
              type: object
              properties:
                property1:
                  type: object
                  properties:
                    property2:
                      type: string
        """
        Als de OpenAPI specificatie is gevalideerd met spectral
        Dan bevat spectral's resultaat de validatie melding "#/components/schemas/PascalCaseComponent/properties/property1/properties is gedefinieerd als een inline object. Definieer deze als een schema component en verwijs hiernaar met $ref"

    Scenario: Schema component property is een object type zonder 'type: object' specificatie
        Gegeven de OpenAPI specificatie
        """
        openapi: 3.0.3
        components:
          schemas:
            PascalCaseComponent:
              type: object
              properties:
                property1:
                  properties:
                    property2:
                      type: string
        """
        Als de OpenAPI specificatie is gevalideerd met spectral
        Dan bevat spectral's resultaat de validatie melding "#/components/schemas/PascalCaseComponent/properties/property1/properties is gedefinieerd als een inline object. Definieer deze als een schema component en verwijs hiernaar met $ref"
