const express = require("express");
const db = require("../db");
const { recommanderVoitures } = require("../matching");

const router = express.Router();

router.get("/filters", (req, res) => {
  const marques = db.prepare("SELECT DISTINCT marque FROM voiture ORDER BY marque").all().map((r) => r.marque);
  const carburants = db.prepare("SELECT DISTINCT carburant FROM voiture ORDER BY carburant").all().map((r) => r.carburant);
  const carrosseries = db.prepare("SELECT DISTINCT carrosserie FROM voiture ORDER BY carrosserie").all().map((r) => r.carrosserie);
  const couleurs = db.prepare("SELECT DISTINCT couleur FROM voiture ORDER BY couleur").all().map((r) => r.couleur);
  const bornes = db.prepare(
    "SELECT MIN(prix) AS prixMin, MAX(prix) AS prixMax, MIN(annee) AS anneeMin, MAX(annee) AS anneeMax FROM voiture"
  ).get();

  res.json({ marques, carburants, carrosseries, couleurs, bornes });
});


router.post("/match", (req, res) => {
  const prefs = req.body || {};
  const allVoiture = db.prepare("SELECT * FROM voiture").all();

  const resultats = recommanderVoitures(allVoiture, prefs, prefs.limit || 20);

  res.json({
    total_correspondances: resultats.length,
    voitures: resultats,
  });
});

router.get("/:id", (req, res) => {
  const car = db.prepare("SELECT * FROM voiture WHERE id = ?").get(req.params.id);
  if (!car) return res.status(404).json({ erreur: "Voiture introuvable" });
  car.options = JSON.parse(car.options);
  res.json(car);
});

module.exports = router;
