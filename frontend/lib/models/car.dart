class Car {
  final int id;
  final String marque;
  final String modele;
  final String carrosserie;
  final int annee;
  final int kilometrage;
  final int prix;
  final String carburant;
  final int puissanceCh;
  final String boite;
  final String finition;
  final String couleur;
  final List<String> options;
  final bool eligibleJeunePermis;
  final int score;

  Car({
    required this.id,
    required this.marque,
    required this.modele,
    required this.carrosserie,
    required this.annee,
    required this.kilometrage,
    required this.prix,
    required this.carburant,
    required this.puissanceCh,
    required this.boite,
    required this.finition,
    required this.couleur,
    required this.options,
    required this.eligibleJeunePermis,
    required this.score,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'] as int,
      marque: json['marque'] as String,
      modele: json['modele'] as String,
      carrosserie: json['carrosserie'] as String,
      annee: json['annee'] as int,
      kilometrage: json['kilometrage'] as int,
      prix: json['prix'] as int,
      carburant: json['carburant'] as String,
      puissanceCh: json['puissance_ch'] as int,
      boite: json['boite'] as String,
      finition: json['finition'] as String,
      couleur: json['couleur'] as String,
      options: List<String>.from(json['options'] ?? []),
      // SQLite renvoie 0/1, mais on gere aussi le cas bool au cas ou
      eligibleJeunePermis: json['jeune_permis'] == 1 ||
          json['jeune_permis'] == true,
      score: json['score'] as int? ?? 0,
    );
  }
}
