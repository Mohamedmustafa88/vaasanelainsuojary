# API-määrittely

Tämä on ryhmän yhteinen sopimus siitä, mitä palvelut lähettävät ja vastaanottavat.
Jos jotain muutetaan, päivitä tämä tiedosto ja kerro muille.

## Arkkitehtuuri

Frontend -> Server A (port 3000) -> Server B (port 3001) -> PostgreSQL

- Frontend puhuu vain Server A:lle.
- Server A hoitaa eläintiedot ja välittää adoptiohakemukset Server B:lle.
- Server B tallentaa hakemuksen ja merkitsee eläimen adoptoiduksi.

## Eläin-objekti

    {
      "id": 1,
      "name": "Misu",
      "type": "kissa",
      "age": 2,
      "breed": "Eurooppalainen lyhytkarva",
      "description": "Leikkisä ja utelias nuori kissa.",
      "image_url": null,
      "status": "available"
    }

- type: "kissa" tai "koira"
- status: "available" tai "adopted"
- image_url: voi olla null, jolloin frontend näyttää placeholder-kuvan

## Server A (port 3000)

### GET /animals
Palauttaa kaikki eläimet.
- 200 OK: lista eläin-objekteja

### GET /animals/:id
Palauttaa yhden eläimen.
- 200 OK: eläin-objekti
- 404 Not Found: { "error": "Eläintä ei löytynyt" }

### POST /animals/:id/adopt
Vastaanottaa adoptiohakemuksen frontendiltä ja välittää sen Server B:lle.

Pyyntö:

    {
      "applicant_name": "Matti Meikäläinen",
      "email": "matti@example.com",
      "phone": "0401234567",
      "message": "Meillä on iso piha ja kokemusta koirista."
    }

Pakolliset kentät: applicant_name, email.

Vastaukset:
- 201 Created: { "message": "Adoptiohakemus vastaanotettu", "adoption": { ... } }
- 400 Bad Request: puuttuvia pakollisia kenttiä
- 404 Not Found: eläintä ei ole
- 409 Conflict: eläin on jo adoptoitu, { "error": "Eläin on jo adoptoitu" }
- 502 Bad Gateway: Server B ei vastaa

## Server B (port 3001)

### POST /adoptions
Vastaanottaa hakemuksen Server A:lta, tallentaa sen ja päivittää eläimen statuksen
(available -> adopted). Tallennus ja statuksen päivitys tehdään samassa tietokantatransaktiossa.

Pyyntö:

    {
      "animal_id": 1,
      "applicant_name": "Matti Meikäläinen",
      "email": "matti@example.com",
      "phone": "0401234567",
      "message": "Meillä on iso piha."
    }

Vastaukset:
- 201 Created: luotu adoptio
- 400 Bad Request: puuttuvia kenttiä
- 404 Not Found: eläintä ei ole
- 409 Conflict: eläin on jo adoptoitu
