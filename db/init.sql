-- Vaasan Eläinsuoja ry: tietokannan alustus
-- Suoritetaan automaattisesti, kun Postgres-kontti käynnistyy ensimmäisen kerran.

CREATE TABLE IF NOT EXISTS animals (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    type        VARCHAR(10)  NOT NULL CHECK (type IN ('kissa', 'koira')),
    age         INTEGER      NOT NULL CHECK (age >= 0),
    breed       VARCHAR(100),
    description TEXT,
    image_url   TEXT,
    status      VARCHAR(20)  NOT NULL DEFAULT 'available'
                CHECK (status IN ('available', 'adopted'))
);

CREATE TABLE IF NOT EXISTS adoptions (
    id             SERIAL PRIMARY KEY,
    animal_id      INTEGER      NOT NULL REFERENCES animals(id),
    applicant_name VARCHAR(150) NOT NULL,
    email          VARCHAR(150) NOT NULL,
    phone          VARCHAR(50),
    message        TEXT,
    created_at     TIMESTAMP    NOT NULL DEFAULT NOW(),
    -- Sama eläin voidaan adoptoida vain kerran (tietokantatason suoja)
    CONSTRAINT unique_animal_adoption UNIQUE (animal_id)
);

INSERT INTO animals (name, type, age, breed, description, image_url, status) VALUES
('Misu',   'kissa', 2,  'Eurooppalainen lyhytkarva', 'Leikkisä ja utelias nuori kissa, joka tulee toimeen muiden kissojen kanssa.', NULL, 'available'),
('Rölli',  'koira', 4,  'Sekarotuinen',              'Energinen ja ystävällinen koira, joka rakastaa pitkiä lenkkejä ja uimista.', NULL, 'available'),
('Pörri',  'kissa', 7,  'Maine coon',                'Rauhallinen ja hellyydenkipeä aikuinen kissa. Viihtyy parhaiten sisäkissana.', NULL, 'available'),
('Aatu',   'koira', 1,  'Labradorinnoutaja',         'Nuori ja innokas pentu, joka tarvitsee aktiivisen kodin ja johdonmukaista koulutusta.', NULL, 'available'),
('Luna',   'kissa', 3,  'Siamilainen',               'Puheliasta ja sosiaalista sorttia. Haluaa olla aina perheen keskipisteenä.', NULL, 'available'),
('Rexi',   'koira', 8,  'Saksanpaimenkoira',         'Rauhallinen seniorikoira, jolla on paljon rakkautta annettavana. Sopii myös ensikertalaiselle.', NULL, 'available'),
('Tiikeri','kissa', 5,  'Norjalainen metsänkissa',   'Itsenäinen metsästäjä, joka kaipaa kotia, jossa pääsee ulkoilemaan turvallisesti.', NULL, 'available'),
('Milla',  'koira', 2,  'Villakoira',                'Älykäs ja oppivainen koira, joka tulee hyvin toimeen lasten kanssa.', NULL, 'available'),
('Vili',   'kissa', 1,  'Sekarotuinen',              'Pieni ja rohkea kissanpentu, joka on tottunut ihmisiin ja muihin eläimiin.', NULL, 'available'),
('Bruno',  'koira', 6,  'Bernhardinkoira',           'Lempeä jättiläinen, joka tarvitsee tilavan kodin ja paljon rapsutuksia.', NULL, 'available');
