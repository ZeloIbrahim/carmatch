import 'package:flutter/material.dart';
import '../models/car.dart';
import '../theme/app_theme.dart';
import '../widgets/car_card.dart';
import '../widgets/fade_slide_in.dart';

class ResultsScreen extends StatelessWidget {
  final List<Car> voitures;

  const ResultsScreen({super.key, required this.voitures});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.asphalte,
      appBar: AppBar(
        backgroundColor: AppColors.asphalte,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.blancPhare),
        title: Text(
          "${voitures.length} résultat${voitures.length > 1 ? 's' : ''}",
          style: const TextStyle(
            color: AppColors.blancPhare,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: voitures.isEmpty ? _buildVide(context) : _buildGrille(),
    );
  }

  Widget _buildVide(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 56, color: AppColors.brouillard),
            const SizedBox(height: 16),
            const Text(
              "Aucune voiture ne correspond a ces criteres",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.blancPhare, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              "Essaie d'elargir ton budget ou de retirer un filtre.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.brouillard),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.ignition,
                side: const BorderSide(color: AppColors.ignition),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text("Modifier mes critères"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrille() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 340,
        mainAxisExtent: 300,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: voitures.length,
      itemBuilder: (context, index) {
        return FadeSlideIn(
          index: index,
          child: CarCard(car: voitures[index]),
        );
      },
    );
  }
}
