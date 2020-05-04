# language: nl

Functionaliteit: mogelijk onjuist
  Wanneer het attribuut, of een van de attributen of relaties waaruit een property is afgeleid in onderzoek is, wordt in het antwoord een property met dezelfde naam opgenomen binnen mogelijkOnjuist met de waarde true.

  Wanneer een groep attributen in onderzoek is, worden alle corresponderende properties van deze groep opgenomen in de groep in binnen mogelijkOnjuist met de waarde true.

  Wanneer een property wordt afgeleid vanuit een relatie, en die relatie is in onderzoek, maar het attribuut van het gerelateerde object is niet in onderzoek, dan wordt het corresponderende property opgenomen in mogelijkOnjuist met de waarde true.

  Wanneer een property wordt afgeleid vanuit een relatie, en die relatie is niet in onderzoek, maar het attribuut van het gerelateerde object is wel in onderzoek, dan wordt het corresponderende property opgenomen in mogelijkOnjuist met de waarde true.

  Een attribuut dat niet in onderzoek is, wordt niet in het antwoord in mogelijkOnjuist opgenomen, ook niet met de waarde false of null.

  
