const WEIGHTS = {
  marque: 15,
  carburant: 15,
  boite: 10,
  carrosserie: 15,
  couleur: 5,
  options: 20,
  recence: 10,
  kilometrage: 10,
};

function clamp(value, min = 0, max = 1) {
  return Math.max(min, Math.min(max, value));
}

function passeFiltresDurs(voiture, prefs) {
  if (prefs.budgetMax != null && voiture.prix > prefs.budgetMax) return false;
  if (prefs.budgetMin != null && voiture.prix < prefs.budgetMin) return false;
  if (prefs.anneeMin != null && voiture.annee < prefs.anneeMin) return false;
  if (prefs.anneeMax != null && voiture.annee > prefs.anneeMax) return false;
  if (prefs.kmMax != null && voiture.kilometrage > prefs.kmMax) return false;
  if (prefs.jeunePermis === true && !voiture.jeune_permis) return false;
  return true;
}

function scoreMarque(voiture, prefs) {
  const preferees = prefs.marques;
  if (!preferees || preferees.length === 0) return 1;
  return preferees.includes(voiture.marque) ? 1 : 0.2;
}

function scoreCarburant(voiture, prefs) {
  const preferes = prefs.carburants;
  if (!preferes || preferes.length === 0) return 1;
  return preferes.includes(voiture.carburant) ? 1 : 0;
}

function scoreBoite(voiture, prefs) {
  if (!prefs.boite || prefs.boite === "peu importe") return 1;
  return voiture.boite === prefs.boite ? 1 : 0.3;
}

function scoreCarrosserie(voiture, prefs) {
  const preferees = prefs.carrosseries;
  if (!preferees || preferees.length === 0) return 1;
  return preferees.includes(voiture.carrosserie) ? 1 : 0.2;
}

function scoreCouleur(voiture, prefs) {
  if (!prefs.couleur || prefs.couleur === "peu importe") return 1;
  return voiture.couleur === prefs.couleur ? 1 : 0.5;
}

function scoreOptions(voiture, prefs) {
  const souhaitees = prefs.optionsSouhaitees;
  if (!souhaitees || souhaitees.length === 0) return 1;
  const voitureOptions = Array.isArray(voiture.options) ? voiture.options : JSON.parse(voiture.options);
  const matchees = souhaitees.filter((opt) => voitureOptions.includes(opt));
  return matchees.length / souhaitees.length;
}

function scoreRecence(voiture, prefs) {
  const anneeMin = prefs.anneeMin ?? 2014;
  const anneeMax = prefs.anneeMax ?? new Date().getFullYear();
  if (anneeMax <= anneeMin) return 1;
  return clamp((voiture.annee - anneeMin) / (anneeMax - anneeMin));
}

function scoreKilometrage(voiture, prefs) {
  const kmMax = prefs.kmMax ?? 200000;
  if (kmMax <= 0) return 1;
  return clamp(1 - voiture.kilometrage / kmMax);
}

function calculerScore(voiture, prefs) {
  const scores = {
    marque: scoreMarque(voiture, prefs),
    carburant: scoreCarburant(voiture, prefs),
    boite: scoreBoite(voiture, prefs),
    carrosserie: scoreCarrosserie(voiture, prefs),
    couleur: scoreCouleur(voiture, prefs),
    options: scoreOptions(voiture, prefs),
    recence: scoreRecence(voiture, prefs),
    kilometrage: scoreKilometrage(voiture, prefs),
  };

  let total = 0;
  for (const [critere, poids] of Object.entries(WEIGHTS)) {
    total += poids * scores[critere];
  }
  return Math.round(total);
}

function recommanderVoitures(voitures, prefs, limit = 20) {
  const eligibles = voitures.filter((voiture) => passeFiltresDurs(voiture, prefs));

  const notees = eligibles.map((voiture) => ({
    ...voiture,
    options: Array.isArray(voiture.options) ? voiture.options : JSON.parse(voiture.options),
    score: calculerScore(voiture, prefs),
  }));

  notees.sort((a, b) => b.score - a.score);

  return notees.slice(0, limit);
}

module.exports = { recommanderVoitures, calculerScore, WEIGHTS };
