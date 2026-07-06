const path = require("path");
const fs = require("fs");
const { DatabaseSync } = require("node:sqlite");

const DB_PATH = path.join(__dirname, "carmatch.sqlite");
const SCHEMA_PATH = path.join(__dirname, "schema.sql");
const CARS_JSON_PATH = path.join(__dirname, "..", "data", "cars_seed.json");

function main() {
  // On repart d'une base propre a chaque seed
  if (fs.existsSync(DB_PATH)) fs.unlinkSync(DB_PATH);

  const db = new DatabaseSync(DB_PATH);

  console.log("Creation du schema...");
  const schema = fs.readFileSync(SCHEMA_PATH, "utf-8");
  db.exec(schema);

  console.log("Lecture du dataset...");
  const voitures = JSON.parse(fs.readFileSync(CARS_JSON_PATH, "utf-8"));

  const insert = db.prepare(`
    INSERT OR REPLACE INTO voiture (
      id, marque, modele, carrosserie, annee, kilometrage, prix,
      carburant, puissance_ch, boite, finition, couleur, options, jeune_permis
    ) VALUES (
      ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
    )
  `);

  db.exec("BEGIN");
  try {
    for (const voiture of voitures) {
      insert.run(
        voiture.id,
        voiture.marque,
        voiture.modele,
        voiture.carrosserie,
        voiture.annee,
        voiture.kilometrage,
        voiture.prix,
        voiture.carburant,
        voiture.puissance_ch,
        voiture.boite,
        voiture.finition,
        voiture.couleur,
        JSON.stringify(voiture.options),
        voiture.jeune_permis ? 1 : 0
      );
    }
    db.exec("COMMIT");
  } catch (err) {
    db.exec("ROLLBACK");
    throw err;
  }

  const count = db.prepare("SELECT COUNT(*) AS n FROM voiture").get();
  console.log(`Base alimentee: ${count.n} voitures inserees dans ${DB_PATH}`);

  db.close();
}

main();
