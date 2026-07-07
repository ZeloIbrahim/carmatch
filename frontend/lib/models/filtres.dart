class Filtres {
  final List<String> marques;
  final List<String> carburants;
  final List<String> carrosseries;
  final List<String> couleurs;
  final int prixMin;
  final int prixMax;
  final int anneeMin;
  final int anneeMax;

  Filtres({
    required this.marques,
    required this.carburants,
    required this.carrosseries,
    required this.couleurs,
    required this.prixMin,
    required this.prixMax,
    required this.anneeMin,
    required this.anneeMax,
  });

  factory Filtres.fromJson(Map<String, dynamic> json) {
    final bornes = json['bornes'] as Map<String, dynamic>;
    return Filtres(
      marques: List<String>.from(json['marques'] ?? []),
      carburants: List<String>.from(json['carburants'] ?? []),
      carrosseries: List<String>.from(json['carrosseries'] ?? []),
      couleurs: List<String>.from(json['couleurs'] ?? []),
      prixMin: bornes['prixMin'] as int,
      prixMax: bornes['prixMax'] as int,
      anneeMin: bornes['anneeMin'] as int,
      anneeMax: bornes['anneeMax'] as int,
    );
  }
}

// Options disponibles cote demo (le backend ne les renvoie pas via /filters,
// on les fixe ici en dur car elles correspondent au dataset genere)
const List<String> optionsDisponibles = [
  "Climatisation",
  "Bluetooth",
  "Vitres electriques",
  "GPS",
  "Regulateur de vitesse",
  "Camera de recul",
  "Sieges chauffants",
  "Toit ouvrant",
  "Jantes alliage 18",
  "Aide au stationnement",
  "Apple CarPlay / Android Auto",
];
