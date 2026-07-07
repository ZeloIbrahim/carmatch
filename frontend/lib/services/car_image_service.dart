import 'dart:convert';
import 'package:http/http.dart' as http;

/// Recupere une photo reelle de la voiture via l'API publique de Wikimedia
class CarImageService {
  static final Map<String, String?> _cache = {};

  static Future<String?> getImageUrl(String marque, String modele) async {
    final cle = "$marque $modele";
    if (_cache.containsKey(cle)) return _cache[cle];

    final requete = Uri.parse(
      "https://commons.wikimedia.org/w/api.php"
      "?action=query"
      "&generator=search"
      "&gsrsearch=${Uri.encodeComponent('$marque $modele car')}"
      "&gsrnamespace=6"
      "&gsrlimit=1"
      "&prop=imageinfo"
      "&iiprop=url"
      "&iiurlwidth=500"
      "&format=json"
      "&origin=*",
    );

    try {
      final reponse = await http.get(requete).timeout(const Duration(seconds: 6));
      if (reponse.statusCode != 200) {
        _cache[cle] = null;
        return null;
      }

      final data = jsonDecode(reponse.body) as Map<String, dynamic>;
      final pages = data['query']?['pages'] as Map<String, dynamic>?;
      if (pages == null || pages.isEmpty) {
        _cache[cle] = null;
        return null;
      }

      final premierePage = pages.values.first as Map<String, dynamic>;
      final imageinfo = (premierePage['imageinfo'] as List?)?.first as Map<String, dynamic>?;
      final url = imageinfo?['thumburl'] as String? ?? imageinfo?['url'] as String?;

      _cache[cle] = url;
      return url;
    } catch (_) {
      // Pas de connexion, timeout, ou format inattendu : on retombe sur
      // l'illustration de secours cote widget, pas d'erreur affichee.
      _cache[cle] = null;
      return null;
    }
  }
}
