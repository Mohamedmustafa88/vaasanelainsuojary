# Vaasan Eläinsuoja ry: Adoptiosovellus

Verkkosovellus, jolla ihmiset voivat tutustua adoptoitaviin eläimiin ja jättää adoptiohakemuksen sähköisesti.

## Tiimi

| Nimi | Vastuualue |
|---|---|
| (projektipäällikkö) | Tietokanta, Docker, integraatio, dokumentaatio |
| Agor | Server A (eläin-API ja gateway) |
| Miina | Server B (adoptiopalvelin) |
| Zinedine | Frontend |

## Arkkitehtuuri

```
Frontend  ->  Server A (eläimet, gateway)  ->  Server B (adoptiot)
                        |                              |
                        +--------> PostgreSQL <--------+
```

- **Frontend**: eläinlista, yksityiskohtasivu + lomake, kiitos-sivu
- **Server A**: `GET /animals`, `GET /animals/:id`, `POST /animals/:id/adopt`
- **Server B**: `POST /adoptions` (tallentaa hakemuksen, päivittää eläimen statuksen)
- **PostgreSQL**: tauluina `animals` ja `adoptions`, alustetaan automaattisesti (`db/init.sql`)

Tarkempi rajapintakuvaus: [API.md](API.md)

## Asennus ja käynnistys

Vaatimukset: [Docker Desktop](https://www.docker.com/products/docker-desktop/) ja Git.

```bash
git clone https://github.com/Mohamedmustafa88/vaasanelainsuojary.git
cd vaasanelainsuojary
docker-compose up --build
```

Kun kontit ovat käynnissä:

| Palvelu | Osoite |
|---|---|
| Frontend | http://localhost:8080 |
| Server A | http://localhost:3000 |
| Tietokanta | localhost:5433 |

Pysäytys: `docker-compose down`
Tietokannan nollaus esimerkkidatalle: `docker-compose down -v` ja sen jälkeen `docker-compose up --build`.

## Tietokanta

**animals**: id, name, type (kissa/koira), age, breed, description, image_url, status (available/adopted)

**adoptions**: id, animal_id (viiteavain animals-tauluun), applicant_name, email, phone, message, created_at

Samaa eläintä ei voi adoptoida kahdesti: `adoptions.animal_id` on `UNIQUE`, ja Server B tarkistaa statuksen ennen tallennusta.

## Työskentely

- Viikon sprintit, tehtävät kanban-taulussa (GitHub Projects)
- Jokainen työskentelee omassa `feature/...`-branchissa ja tuo muutokset `main`iin pull requestilla
