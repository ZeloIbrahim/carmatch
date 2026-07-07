import 'package:flutter/material.dart';
import '../models/car.dart';
import '../theme/app_theme.dart';
import 'car_image.dart';
import 'car_detail_sheet.dart';
import 'score_gauge.dart';

class CarCard extends StatefulWidget {
  final Car car;

  const CarCard({super.key, required this.car});

  @override
  State<CarCard> createState() => _CarCardState();
}

class _CarCardState extends State<CarCard> {
  double _scale = 1;

  void _setPressed(bool pressed) => setState(() => _scale = pressed ? 0.97 : 1);

  @override
  Widget build(BuildContext context) {
    final car = widget.car;

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      onTap: () => showCarDetails(context, car),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.beton,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 14, offset: const Offset(0, 6)),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  CarImage(car: car, height: 128),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: AppColors.asphalte.withOpacity(0.55),
                        shape: BoxShape.circle,
                      ),
                      child: ScoreGauge(score: car.score, size: 42),
                    ),
                  ),
                  if (car.eligibleJeunePermis)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.vertEligible,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "JEUNE PERMIS",
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${car.marque} ${car.modele}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blancPhare,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${car.annee} · ${_formatKm(car.kilometrage)} km",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: AppColors.brouillard),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _miniTag(Icons.local_gas_station, car.carburant),
                        const SizedBox(width: 6),
                        _miniTag(Icons.bolt, "${car.puissanceCh}ch"),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${car.prix} €",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blancPhare,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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

  Widget _miniTag(IconData icon, String label) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.betonClair,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 11, color: AppColors.brouillard),
            const SizedBox(width: 3),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10, color: AppColors.blancPhare),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
