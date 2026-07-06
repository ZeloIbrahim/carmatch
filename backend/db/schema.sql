CREATE TABLE IF NOT EXISTS voiture (
    id INTEGER PRIMARY KEY ,
    marque TEXT NOT NULL , 
    modele TEXT NOT NULL,
    carrosserie TEXT NOT NULL,
    annee INTEGER NOT NULL,
    kilometrage INTEGER NOT NULL,
    prix INTEGER NOT NULL,
    carburant TEXT NOT NULL,
    puissance_ch INTEGER NOT NULL,
    boite TEXT NOT NULL,
    finition TEXT NOT NULL,
    couleur TEXT NOT NULL,
    options TEXT NOT NULL,
    jeune_permis INTEGER NOT NULL  -- 0 ou 1 
);
-- permet de retrouver rapidement les lignes sans parcourir toute la table
CREATE INDEX IF NOT EXISTS idx_voiture_marque ON voiture(marque);
CREATE INDEX IF NOT EXISTS idx_voiture_prix ON voiture(prix);
CREATE INDEX IF NOT EXISTS idx_voiture_annee ON voiture(annee);
CREATE INDEX IF NOT EXISTS idx_voiture_carburant ON voiture(carburant);

-- table utilisateur 
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    password_user TEXT NOT NULL ,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP -- pratique pour savoir a ql heure le compte a été crée

);

-- recherches sauvagardees (pour retrouver les criters plus tard)
CREATE TABLE IF NOT EXISTS saved_searches (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id     INTEGER NOT NULL REFERENCES users(id),
  nom         TEXT NOT NULL,
  criteres    TEXT NOT NULL,   -- JSON des preferences
  created_at  TEXT DEFAULT CURRENT_TIMESTAMP
);