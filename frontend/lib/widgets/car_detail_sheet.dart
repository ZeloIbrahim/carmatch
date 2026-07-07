import 'package:flutter/material.dart';
import '../models/car.dart';
import '../theme/app_theme.dart';
import 'car_image.dart';
import 'score_gauge.dart';

void showCarDetails(BuildContext context, Car car) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => _CarDetailSheet(car: car),
  );
}

class _CarDetailSheet extends StatelessWidget {
  final Car car;

  const _CarDetailSheet({required this.car});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.beton,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.zero,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 6),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.brouillard.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Stack(
                children: [
                  CarImage(
                    car: car,
                    height: 220,
                    borderRadius: BorderRadius.zero,
                  ),
                  Positioned(
                    top: 14,
                    right: 14,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.asphalte.withOpacity(0.55),
                        shape: BoxShape.circle,
                      ),
                      child: ScoreGauge(score: car.score, size: 56),
                    ),
                  ),
                  if (car.eligibleJeunePermis)
                    Positioned(
                      top: 14,
                      left: 14,
                      child: _badge("JEUNE PERMIS ELIGIBLE"),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${car.marque} ${car.modele}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blancPhare,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      car.finition,
                      style: const TextStyle(fontSize: 15, color: AppColors.brouillard),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      "${car.prix} €",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ignition,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _sectionTitre("CARACTÉRISTIQUES"),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _specTile(Icons.calendar_today, "Année", "${car.annee}"),
                        _specTile(Icons.speed, "Kilométrage", "${_formatKm(car.kilometrage)} km"),
                        _specTile(Icons.local_gas_station, "Carburant", car.carburant),
                        _specTile(Icons.settings, "Boîte", car.boite),
                        _specTile(Icons.bolt, "Puissance", "${car.puissanceCh} ch"),
                        _specTile(Icons.palette, "Couleur", car.couleur),
                        _specTile(Icons.directions_car, "Carrosserie", car.carrosserie),
                      ],
                    ),
                    if (car.options.isNotEmpty) ...[
                      const SizedBox(height: 22),
                      _sectionTitre("ÉQUIPEMENTS"),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: car.options
                            .map((o) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.betonClair,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    o,
                                    style: const TextStyle(fontSize: 13, color: AppColors.blancPhare),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatKm(int km) {
    final s = km.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write(" ");
      buffer.write(s[i]);
    }
    return buffer.toString();
  }

  Widget _sectionTitre(String texte) {
    return Text(
      texte,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.ignition,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _specTile(IconData icon, String label, String valeur) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.betonClair,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.ignition),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, color: AppColors.brouillard)),
                Text(
                  valeur,
                  style: const TextStyle(fontSize: 13, color: AppColors.blancPhare, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String texte) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.vertEligible,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texte,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }
}
