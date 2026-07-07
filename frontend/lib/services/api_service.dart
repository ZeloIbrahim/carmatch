import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/car.dart';
import '../models/filtres.dart';

class ApiService {
  static const String baseUrl = "http://localhost:3000";

  Future<Filtres> getFiltres() async {
    final response = await http.get(Uri.parse("$baseUrl/api/voitures/filters"));

    if (response.statusCode != 200) {
      throw Exception("Erreur lors du chargement des filtres (${response.statusCode})");
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return Filtres.fromJson(data);
  }

  Future<List<Car>> matchCars(Map<String, dynamic> preferences) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/voitures/match"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(preferences),
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur lors de la recherche (${response.statusCode})");
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> voitures = data['voitures'] ?? [];
    return voitures.map((v) => Car.fromJson(v as Map<String, dynamic>)).toList();
  }
}
