import 'package:flutter/material.dart';
import '../models/car.dart';
import '../services/car_image_service.dart';
import '../theme/app_theme.dart';

class CarImage extends StatelessWidget {
  final Car car;
  final double height;
  final BorderRadius borderRadius;

  const CarImage({
    super.key,
    required this.car,
    this.height = 130,
    this.borderRadius = const BorderRadius.vertical(top: Radius.circular(18)),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: FutureBuilder<String?>(
          future: CarImageService.getImageUrl(car.marque, car.modele),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _placeholder(loading: true);
            }
            final url = snapshot.data;
            if (url == null) {
              return _placeholder();
            }
            return Image.network(
              url,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return _placeholder(loading: true);
              },
              errorBuilder: (context, error, stack) => _placeholder(),
            );
          },
        ),
      ),
    );
  }

  Widget _placeholder({bool loading = false}) {
    final couleur = AppTheme.couleurVoiture(car.couleur);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [couleur.withOpacity(0.95), couleur.withOpacity(0.6)],
        ),
      ),
      child: Center(
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white70),
              )
            : Icon(
                AppTheme.iconeCarrosserie(car.carrosserie),
                size: 44,
                color: Colors.white.withOpacity(0.85),
              ),
      ),
    );
  }
}
