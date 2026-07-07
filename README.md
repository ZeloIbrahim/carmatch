# CarMatch

Projet d'apprentissage realise en parallele d'un stage en developpement full-stack (Dart/Flutter et Node.js), avec pour objectif de monter en competences sur Dart avant de developper une application reelle pour une association.

CarMatch est un moteur de recommandation de voitures d'occasion : l'utilisateur renseigne ses criteres (budget, annee, kilometrage, marque, carburant, boite, carrosserie, couleur, options, eligibilite jeune permis) et l'application propose les vehicules les plus pertinents, classes par un score de correspondance.

## Contexte du projet

Etudiant en ingénieur en info en stage de developpement full-stack utilisant Dart/Flutter et Node.js. Ce projet a ete construit pour :

- Prendre en main Dart et Flutter, langage et framework non couverts par la formation initiale
- Pratiquer l'integration frontend/backend sur un cas concret plutot que des exercices isoles
- Servir de base d'experience avant la mission principale : le developpement d'une application pour une association

## Competences mises en oeuvre

**Dart / Flutter**
- Structuration d'une application multi-ecrans (StatefulWidget, gestion d'etat locale avec setState)
- Consommation d'API REST (package http, serialisation/deserialisation JSON)
- Composants graphiques personnalises (CustomPainter pour une jauge animee)
- Animations (AnimationController, transitions de page personnalisees)
- Mise en page responsive (GridView adaptatif selon la largeur d'ecran)
- Theming et design system (palette de couleurs, typographie via Google Fonts)

**Node.js / Backend**
- API REST avec Express (routage, middlewares, gestion des erreurs)
- Modelisation et requetage d'une base de donnees SQLite (module natif node:sqlite)
- Ecriture d'un script de seed (generation et insertion de donnees)
- Conception d'un algorithme de scoring pondere (filtres stricts + criteres souples)

**Transverse**
- Architecture full-stack (contrat d'API entre frontend et backend, gestion des environnements de test)
- Utilisation d'API externes tierces (Wikimedia Commons pour les visuels)
- Debogage cross-environnement (Windows / WSL / PowerShell)
- Gestion de projet avec Git/GitHub

## Fonctionnalites

- Formulaire de recherche par criteres multiples (budget, annee, kilometrage, marque, carburant, boite, carrosserie, couleur, options, jeune permis)
- Algorithme de scoring : les criteres essentiels (budget, annee, kilometrage, jeune permis) filtrent la liste, les criteres de preference (marque, carburant, couleur, options...) ponderent le classement sans exclure une voiture qui ne correspond pas a 100 pourcent
- Affichage des resultats en grille responsive avec photo (recherchee via l'API Wikimedia Commons, illustration de secours sinon)
- Fiche detail complete au clic sur une voiture (caracteristiques, equipements)
- Jeu de donnees genere proceduralement (630 vehicules, marques et modeles reels, prix calibres sur des donnees de marche reelles)

## Stack technique

| Couche      | Technologie                                   |
|-------------|------------------------------------------------|
| Frontend    | Flutter / Dart                                  |
| Backend     | Node.js, Express                                |
| Base de donnees | SQLite (module natif node:sqlite)           |
| Polices     | Google Fonts (Oswald, Inter)                    |
| Images      | API Wikimedia Commons                           |

## Structure du projet

```
carmatch/
├── backend/
│   ├── data/
│   │   └── cars_seed.json        # jeu de donnees (630 vehicules)
│   ├── db/
│   │   ├── schema.sql             # schema de la base SQLite
│   │   └── seed.js                # script de creation/remplissage de la base
│   ├── src/
│   │   ├── server.js              # point d'entree Express
│   │   ├── db.js                  # connexion SQLite
│   │   ├── matching.js            # algorithme de scoring
│   │   └── routes/
│   │       └── voitures.js        # routes de l'API
│   └── package.json
├── frontend/
│   ├── lib/
│   │   ├── main.dart
│   │   ├── models/                # Car, Filtres
│   │   ├── services/              # appels API backend + Wikimedia
│   │   ├── screens/                # formulaire, resultats
│   │   ├── widgets/                # carte voiture, jauge de score, etc.
│   │   └── theme/                  # palette et styles
│   ├── android/
│   ├── ios/
│   └── pubspec.yaml
├── generate_cars.py               # script de generation du jeu de donnees
└── README.md
```

## Tutoriel d'installation complet

Cette section detaille toutes les etapes necessaires pour faire fonctionner le projet de zero, y compris l'installation des outils requis.

### Prerequis a installer

**1. Node.js version 22.5 ou superieure**

Necessaire pour le module natif `node:sqlite` utilise par le backend (evite d'avoir a compiler une dependance native comme `better-sqlite3`).

Telechargement : https://nodejs.org

Verification :
```
node --version
```

**2. Flutter SDK**

Telechargement : https://docs.flutter.dev/get-started/install (choisir la version correspondant a l'OS)

- Decompresser l'archive dans un dossier simple, par exemple `C:\src\flutter` sous Windows
- Ajouter le sous-dossier `bin` au PATH systeme
- Redemarrer le terminal / VS Code apres modification du PATH
- Verifier l'installation :
```
flutter --version
flutter doctor
```
`flutter doctor` indique les elements manquants (Android Studio, Xcode, etc.). Pour un usage web/desktop uniquement, les avertissements lies au mobile peuvent etre ignores.

**3. Extension VS Code**

Dans VS Code, onglet Extensions, installer l'extension **Flutter** (l'extension **Dart** est installee automatiquement avec).

### Recuperation du projet

```
git clone <url-du-repo>
cd carmatch
```

### Installation et lancement du backend

```
cd backend
npm install
npm run seed
npm start
```

`npm install` recupere les dependances declarees dans `package.json` (`express`, `cors`). `npm run seed` cree la base SQLite et l'alimente avec les 630 vehicules du fichier `cars_seed.json`. `npm start` demarre l'API sur `http://localhost:3000`.

Pour regenerer un jeu de donnees different :
```
python generate_cars.py
```
puis copier le `cars_seed.json` produit dans `backend/data/` avant de relancer `npm run seed`.

### Installation et lancement du frontend

Le frontend depend de deux librairies externes qui ne sont pas incluses par defaut dans un projet Flutter : `http` (appels a l'API backend et a Wikimedia Commons) et `google_fonts` (typographie Oswald/Inter du theme).

Si elles ne sont pas deja presentes dans `pubspec.yaml`, les ajouter avec :
```
cd frontend
flutter pub add http
flutter pub add google_fonts
```

Puis recuperer l'ensemble des dependances et lancer l'application :
```
flutter pub get
flutter run -d chrome
```
## IMAGES 


<img width="800" height="978" alt="image" src="https://github.com/user-attachments/assets/4488246e-b2b2-4ca2-82df-eb7895979845" />

<img width="799" height="938" alt="image" src="https://github.com/user-attachments/assets/01aae74d-c998-4250-bc97-62d78eac778b" />


## Documentation de l'API

### GET /api/voitures/filters

Renvoie les valeurs disponibles pour construire les formulaires (marques, carburants, carrosseries, couleurs, bornes de prix et d'annee).

### POST /api/voitures/match

Corps de la requete (tous les champs sont optionnels) :
```json
{
  "budgetMin": 0,
  "budgetMax": 15000,
  "anneeMin": 2018,
  "anneeMax": 2024,
  "kmMax": 100000,
  "marques": ["Renault", "Peugeot"],
  "carburants": ["Essence"],
  "boite": "Manuelle",
  "carrosseries": ["citadine"],
  "couleur": "Bleu",
  "jeunePermis": true,
  "optionsSouhaitees": ["Climatisation", "GPS"],
  "limit": 20
}
```

Renvoie la liste des vehicules correspondants, triee par score de pertinence decroissant.

### GET /api/voitures/:id

Renvoie le detail d'un vehicule.

## Algorithme de scoring

Le classement des resultats repose sur deux niveaux :

1. **Filtres stricts** (eliminatoires) : budget, annee, kilometrage, eligibilite jeune permis. Un vehicule qui ne respecte pas ces criteres n'apparait pas dans les resultats.
2. **Criteres ponderes** (marque, carburant, boite, carrosserie, couleur, options, anciennete, kilometrage) : chaque critere recoit un poids et une note de 0 a 1 selon la correspondance avec les preferences. Le score final est la somme ponderee de ces notes, ramenee sur 100. Un vehicule qui ne correspond pas parfaitement a un critere de preference reste propose, mais redescend dans le classement.

## Ameliorations envisagees

- Authentification utilisateur et sauvegarde de recherches
- Systeme de favoris et comparateur entre plusieurs vehicules
- Deploiement du backend (Render, Railway) et du frontend web (GitHub Pages, Netlify)
- Elargissement du catalogue de marques et modeles
- Remplacement progressif du jeu de donnees genere par des donnees reelles

## Auteur
OZEL IBRAHIM 
