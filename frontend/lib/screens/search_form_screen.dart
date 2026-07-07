import 'package:flutter/material.dart';
import '../models/filtres.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import 'results_screen.dart';

class SearchFormScreen extends StatefulWidget {
  const SearchFormScreen({super.key});

  @override
  State<SearchFormScreen> createState() => _SearchFormScreenState();
}

class _SearchFormScreenState extends State<SearchFormScreen> {
  final ApiService _api = ApiService();

  bool _loadingFiltres = true;
  String? _erreurChargement;
  Filtres? _filtres;

  RangeValues _budgetRange = const RangeValues(0, 30000);
  RangeValues _anneeRange = const RangeValues(2014, 2024);
  double _kmMax = 150000;

  final Set<String> _marquesSelectionnees = {};
  final Set<String> _carburantsSelectionnes = {};
  final Set<String> _carrosseriesSelectionnees = {};
  final Set<String> _optionsSelectionnees = {};

  String _boiteSelectionnee = "peu importe";
  String _couleurSelectionnee = "peu importe";
  bool _jeunePermis = false;
  bool _recherche = false;

  @override
  void initState() {
    super.initState();
    _chargerFiltres();
  }

  Future<void> _chargerFiltres() async {
    setState(() {
      _loadingFiltres = true;
      _erreurChargement = null;
    });
    try {
      final filtres = await _api.getFiltres();
      setState(() {
        _filtres = filtres;
        _budgetRange = RangeValues(filtres.prixMin.toDouble(), filtres.prixMax.toDouble());
        _anneeRange = RangeValues(filtres.anneeMin.toDouble(), filtres.anneeMax.toDouble());
        _loadingFiltres = false;
      });
    } catch (e) {
      setState(() {
        _erreurChargement =
            "Impossible de contacter le serveur.\nVerifie que le backend tourne bien (npm start).\n\n$e";
        _loadingFiltres = false;
      });
    }
  }

  Future<void> _lancerRecherche() async {
    setState(() => _recherche = true);

    final preferences = <String, dynamic>{
      "budgetMin": _budgetRange.start.round(),
      "budgetMax": _budgetRange.end.round(),
      "anneeMin": _anneeRange.start.round(),
      "anneeMax": _anneeRange.end.round(),
      "kmMax": _kmMax.round(),
      "jeunePermis": _jeunePermis,
      "limit": 30,
      if (_marquesSelectionnees.isNotEmpty) "marques": _marquesSelectionnees.toList(),
      if (_carburantsSelectionnes.isNotEmpty) "carburants": _carburantsSelectionnes.toList(),
      if (_carrosseriesSelectionnees.isNotEmpty) "carrosseries": _carrosseriesSelectionnees.toList(),
      if (_optionsSelectionnees.isNotEmpty) "optionsSouhaitees": _optionsSelectionnees.toList(),
      if (_boiteSelectionnee != "peu importe") "boite": _boiteSelectionnee,
      if (_couleurSelectionnee != "peu importe") "couleur": _couleurSelectionnee,
    };

    try {
      final resultats = await _api.matchCars(preferences);
      if (!mounted) return;
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, animation, __) => ResultsScreen(voitures: resultats),
          transitionsBuilder: (_, animation, __, child) {
            final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(curved),
                child: child,
              ),
            );
          },
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur pendant la recherche : $e"),
          backgroundColor: AppColors.rougeAlerte,
        ),
      );
    } finally {
      if (mounted) setState(() => _recherche = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.asphalte,
      body: SafeArea(
        child: _loadingFiltres
            ? const Center(child: CircularProgressIndicator(color: AppColors.ignition))
            : _erreurChargement != null
                ? _buildErreur()
                : _buildFormulaire(),
      ),
    );
  }

  Widget _buildErreur() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: AppColors.brouillard),
            const SizedBox(height: 12),
            Text(
              _erreurChargement!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.brouillard, fontSize: 13),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _chargerFiltres,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.ignition,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text("Réessayer"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormulaire() {
    final filtres = _filtres!;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
      children: [
        _heroHeader(),
        const SizedBox(height: 24),

        _sectionCard(
          icon: Icons.euro,
          titre: "BUDGET",
          valeur: "${_budgetRange.start.round()} € — ${_budgetRange.end.round()} €",
          child: _customRangeSlider(
            values: _budgetRange,
            min: filtres.prixMin.toDouble(),
            max: filtres.prixMax.toDouble(),
            divisions: 50,
            labels: RangeLabels("${_budgetRange.start.round()}€", "${_budgetRange.end.round()}€"),
            onChanged: (v) => setState(() => _budgetRange = v),
          ),
        ),

        _sectionCard(
          icon: Icons.calendar_today,
          titre: "ANNÉE",
          valeur: "${_anneeRange.start.round()} — ${_anneeRange.end.round()}",
          child: _customRangeSlider(
            values: _anneeRange,
            min: filtres.anneeMin.toDouble(),
            max: filtres.anneeMax.toDouble(),
            divisions: (filtres.anneeMax - filtres.anneeMin).clamp(1, 100),
            labels: RangeLabels(_anneeRange.start.round().toString(), _anneeRange.end.round().toString()),
            onChanged: (v) => setState(() => _anneeRange = v),
          ),
        ),

        _sectionCard(
          icon: Icons.speed,
          titre: "KILOMÉTRAGE MAX",
          valeur: "${_formatKm(_kmMax.round())} km",
          child: _customSlider(
            value: _kmMax,
            min: 0,
            max: 250000,
            divisions: 50,
            label: "${_formatKm(_kmMax.round())} km",
            onChanged: (v) => setState(() => _kmMax = v),
          ),
        ),

        _sectionCard(
          icon: Icons.directions_car,
          titre: "MARQUE",
          child: _buildChips(filtres.marques, _marquesSelectionnees),
        ),

        _sectionCard(
          icon: Icons.local_gas_station,
          titre: "CARBURANT",
          child: _buildChips(filtres.carburants, _carburantsSelectionnes),
        ),

        _sectionCard(
          icon: Icons.category,
          titre: "CARROSSERIE",
          child: _buildChips(filtres.carrosseries, _carrosseriesSelectionnees),
        ),

        _sectionCard(
          icon: Icons.settings,
          titre: "BOÎTE",
          child: _buildDropdown(
            value: _boiteSelectionnee,
            items: const ["peu importe", "Manuelle", "Automatique"],
            onChanged: (v) => setState(() => _boiteSelectionnee = v!),
          ),
        ),

        _sectionCard(
          icon: Icons.palette,
          titre: "COULEUR",
          child: _buildDropdown(
            value: _couleurSelectionnee,
            items: ["peu importe", ...filtres.couleurs],
            onChanged: (v) => setState(() => _couleurSelectionnee = v!),
          ),
        ),

        _sectionCard(
          icon: Icons.tune,
          titre: "OPTIONS",
          child: _buildChips(optionsDisponibles, _optionsSelectionnees),
        ),

        const SizedBox(height: 6),
        _jeunePermisToggle(),

        const SizedBox(height: 28),
        _ctaButton(),
      ],
    );
  }

  // ---------- Composants visuels ----------

  Widget _heroHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF23262E), AppColors.beton],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.ignition,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "CARMATCH",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ignition,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Trouve TA voiture",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: AppColors.blancPhare,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Règle tes critères, on s'occupe du classement.",
            style: TextStyle(fontSize: 13, color: AppColors.brouillard),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required IconData icon,
    required String titre,
    String? valeur,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.beton,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.ignition),
              const SizedBox(width: 8),
              Text(
                titre,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ignition,
                  letterSpacing: 1.2,
                ),
              ),
              if (valeur != null) ...[
                const Spacer(),
                Text(
                  valeur,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blancPhare,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }

  Widget _customRangeSlider({
    required RangeValues values,
    required double min,
    required double max,
    required int divisions,
    required RangeLabels labels,
    required ValueChanged<RangeValues> onChanged,
  }) {
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: AppColors.ignition,
        inactiveTrackColor: AppColors.betonClair,
        thumbColor: AppColors.ignition,
        overlayColor: AppColors.ignition.withOpacity(0.15),
        valueIndicatorColor: AppColors.ignition,
        valueIndicatorTextStyle: const TextStyle(color: Colors.white, fontSize: 12),
        rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 8),
      ),
      child: RangeSlider(
        values: values,
        min: min,
        max: max,
        divisions: divisions,
        labels: labels,
        onChanged: onChanged,
      ),
    );
  }

  Widget _customSlider({
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String label,
    required ValueChanged<double> onChanged,
  }) {
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: AppColors.ignition,
        inactiveTrackColor: AppColors.betonClair,
        thumbColor: AppColors.ignition,
        overlayColor: AppColors.ignition.withOpacity(0.15),
        valueIndicatorColor: AppColors.ignition,
        valueIndicatorTextStyle: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        label: label,
        onChanged: onChanged,
      ),
    );
  }

  Widget _jeunePermisToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: _jeunePermis ? AppColors.vertEligible.withOpacity(0.14) : AppColors.beton,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _jeunePermis ? AppColors.vertEligible : Colors.transparent,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.shield_outlined,
            color: _jeunePermis ? AppColors.vertEligible : AppColors.brouillard,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Jeune permis",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.blancPhare),
                ),
                const Text(
                  "N'afficher que les voitures ≤ 100 ch",
                  style: TextStyle(fontSize: 12, color: AppColors.brouillard),
                ),
              ],
            ),
          ),
          Switch(
            value: _jeunePermis,
            activeThumbColor: AppColors.vertEligible,
            activeTrackColor: AppColors.vertEligible.withOpacity(0.4),
            inactiveThumbColor: AppColors.brouillard,
            inactiveTrackColor: AppColors.betonClair,
            onChanged: (v) => setState(() => _jeunePermis = v),
          ),
        ],
      ),
    );
  }

  Widget _ctaButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _recherche ? null : _lancerRecherche,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ignition,
          disabledBackgroundColor: AppColors.ignition.withOpacity(0.5),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _recherche
              ? const SizedBox(
                  key: ValueKey("loading"),
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text(
                  "TROUVER MA VOITURE",
                  key: ValueKey("label"),
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0.5),
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

  Widget _buildChips(List<String> options, Set<String> selection) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final selectionne = selection.contains(option);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (selectionne) {
                selection.remove(option);
              } else {
                selection.add(option);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: selectionne ? AppColors.ignition : AppColors.betonClair,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              option,
              style: TextStyle(
                fontSize: 13,
                color: selectionne ? Colors.white : AppColors.blancPhare,
                fontWeight: selectionne ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.betonClair,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          initialValue: value,
          dropdownColor: AppColors.betonClair,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.brouillard),
          style: const TextStyle(color: AppColors.blancPhare, fontSize: 14),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          items: items
              .map((i) => DropdownMenuItem(
                    value: i,
                    child: Text(i, style: const TextStyle(color: AppColors.blancPhare)),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
