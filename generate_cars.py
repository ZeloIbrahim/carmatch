import random
import json

random.seed(42)

# Modèles voitures (param : model, carroserire, puissancce min; puissance max , prix max en occas (avec de L'ia)
# Je vais remplacer plus tard avec de l'ia (API du chatgpt pour ajouter plus de modele au lieu d'avoir un sort de tbl)
MARQUES_MODELE = {
    "Renault": [
        ("Twingo", "citadine", (70, 95), 5750),
        ("Clio", "citadine", (75, 130), 7750),
        ("Captur", "SUV", (100, 160), 12000),
        ("Megane", "compacte", (115, 160), 10500),
        ("Kadjar", "SUV", (115, 150), 13500),
        ("Austral", "SUV", (130, 200), 25000),
        ("Arkana", "SUV coupe", (140, 160), 21500),
        ("Talisman", "berline", (150, 200), 14000),
    ],

    "Peugeot": [
        ("108", "citadine", (68, 82), 5750),
        ("208", "citadine", (75, 130), 9000),
        ("2008", "SUV", (100, 155), 12500),
        ("308", "compacte", (110, 180), 11750),
        ("3008", "SUV", (130, 225), 15250),
        ("508", "berline", (130, 225), 16500),
        ("5008", "SUV", (130, 180), 17500),
    ],

    "Citroen": [
        ("C1", "citadine", (68, 82), 5250),
        ("C3", "citadine", (83, 110), 7500),
        ("C3 Aircross", "SUV", (110, 130), 10500),
        ("C4", "compacte", (100, 155), 12250),
        ("C5 Aircross", "SUV", (130, 180), 16000),
        ("Berlingo", "familiale", (100, 130), 11750),
    ],

    "Volkswagen": [
        ("Up!", "citadine", (65, 90), 7500),
        ("Polo", "citadine", (80, 150), 10500),
        ("Golf", "compacte", (115, 245), 14000),
        ("T-Roc", "SUV", (115, 190), 18500),
        ("Tiguan", "SUV", (150, 245), 20000),
        ("Passat", "berline", (150, 190), 16000),
    ],

    "Toyota": [
        ("Aygo X", "citadine", (72, 72), 11500),
        ("Yaris", "citadine", (80, 130), 11500),
        ("Corolla", "compacte", (122, 196), 18000),
        ("C-HR", "SUV", (122, 184), 19500),
        ("RAV4", "SUV", (160, 222), 22500),
    ],

    "Dacia": [
        ("Sandero", "citadine", (65, 110), 6500),
        ("Duster", "SUV", (100, 150), 10750),
        ("Spring", "citadine", (45, 65), 10000),
        ("Jogger", "monospace", (100, 110), 14000),
    ],

    "Ford": [
        ("Fiesta", "citadine", (70, 140), 8250),
        ("Focus", "compacte", (95, 190), 10500),
        ("Puma", "SUV", (100, 155), 16500),
        ("Kuga", "SUV", (120, 225), 16000),
    ],

    "BMW": [
        ("Serie 1", "compacte", (116, 306), 15500),
        ("Serie 3", "berline", (150, 374), 20500),
        ("X1", "SUV", (136, 231), 20000),
        ("X3", "SUV", (150, 286), 25500),
    ],

    "Mercedes": [
        ("Classe A", "compacte", (116, 306), 20000),
        ("Classe C", "berline", (170, 408), 24000),
        ("GLA", "SUV", (136, 224), 22500),
        ("GLC", "SUV", (170, 367), 31500),
    ],

    "Audi": [
        ("A1", "citadine", (95, 200), 14000),
        ("A3", "compacte", (110, 310), 18000),
        ("Q2", "SUV", (116, 190), 20500),
        ("Q3", "SUV", (150, 300), 24000),
    ],

    "Fiat": [
        ("500", "citadine", (70, 118), 7500),
        ("Panda", "citadine", (69, 80), 6250),
        ("Tipo", "compacte", (95, 130), 8750),
    ],

    "Opel": [
        ("Corsa", "citadine", (75, 130), 8250),
        ("Astra", "compacte", (110, 180), 10750),
        ("Mokka", "SUV", (100, 155), 14000),
        ("Crossland", "SUV", (100, 130), 11500),
    ],

    "Nissan": [
        ("Micra", "citadine", (71, 117), 7500),
        ("Juke", "SUV", (114, 117), 11750),
        ("Qashqai", "SUV", (140, 158), 15250),
    ],

    "Hyundai": [
        ("i10", "citadine", (67, 84), 7250),
        ("i20", "citadine", (84, 120), 8750),
        ("Tucson", "SUV", (136, 265), 18000),
        ("Kona", "SUV", (120, 204), 16000),
    ],

    "Kia": [
        ("Picanto", "citadine", (67, 84), 7250),
        ("Rio", "citadine", (84, 120), 8750),
        ("Sportage", "SUV", (136, 265), 17500),
        ("Niro", "SUV", (105, 253), 18500),
    ],

    "Skoda": [
        ("Fabia", "citadine", (80, 150), 9250),
        ("Octavia", "compacte", (115, 245), 13000),
        ("Kamiq", "SUV", (95, 150), 14500),
        ("Karoq", "SUV", (115, 190), 16000),
    ],

    "Seat": [
        ("Ibiza", "citadine", (80, 150), 9250),
        ("Leon", "compacte", (110, 300), 13000),
        ("Arona", "SUV", (95, 150), 13500),
    ],

    "Mini": [
        ("Cooper", "citadine", (102, 231), 14000),
        ("Countryman", "SUV", (136, 306), 18000),
    ],

    "Volvo": [
        ("XC40", "SUV", (129, 300), 24000),
        ("XC60", "SUV", (150, 300), 29000),
        ("V60", "berline", (150, 300), 24000),
    ],

    "Suzuki": [
        ("Swift", "citadine", (83, 101), 8750),
        ("Vitara", "SUV", (102, 129), 12750),
    ],

    "Mazda": [
        ("Mazda2", "citadine", (75, 115), 8750),
        ("Mazda3", "compacte", (90, 180), 12500),
        ("CX-30", "SUV", (122, 186), 18000),
    ],

    "Honda": [
        ("Jazz", "citadine", (94, 109), 11250),
        ("Civic", "compacte", (126, 182), 16000),
        ("HR-V", "SUV", (105, 131), 15000),
    ],
}

PREMIUM_VOITURE = {"BMW","Mercedes-Benz","Audi","Volvo"}
FINITION = {"Eco","Confort","Business","Sport"}
COULEUR = ["Blanc", "Noir", "Gris", "Bleu", "Rouge", "Beige", "Vert", "Marron"]
BASE_OPTIONS = ["Climatisation", "Bluetooth", "Vitres electriques"]
MID_OPTIONS = BASE_OPTIONS + ["GPS", "Regulateur de vitesse", "Camera de recul"]
HIGH_OPTIONS = MID_OPTIONS + ["Sieges chauffants", "Toit ouvrant", "Jantes alliage 18","Aide au stationnement", "CarPlay"]

FUEL_WEIGHTS = {
    "citadine": {"Essence": 0.55, "Diesel": 0.05, "Hybride": 0.15, "Electrique": 0.25},
    "compacte": {"Essence": 0.45, "Diesel": 0.25, "Hybride": 0.20, "Electrique": 0.10},
    "SUV": {"Essence": 0.35, "Diesel": 0.30, "Hybride": 0.25, "Electrique": 0.10},
    "SUV coupe": {"Essence": 0.35, "Diesel": 0.25, "Hybride": 0.30, "Electrique": 0.10},
    "berline": {"Essence": 0.30, "Diesel": 0.35, "Hybride": 0.25, "Electrique": 0.10},
    "monospace": {"Essence": 0.30, "Diesel": 0.50, "Hybride": 0.15, "Electrique": 0.05},
    "familiale": {"Essence": 0.25, "Diesel": 0.55, "Hybride": 0.15, "Electrique": 0.05},
}

ANNEE_CURRENT = 2026
VARIANT_PAR_MODELE = 7

cars = []
car_id = 1 # sert a attribuer un identifiant unique a chaque voiture.

for marque,modele in MARQUES_MODELE.items():
    for nom_modele,body_type,(p_min,p_max),prix_ocass in modele:
        for _ in range(VARIANT_PAR_MODELE): #plusieurs exemplaires d'un même modèle
             # Annee ponderee vers le recent
            annee = random.choices(
                range(2014, 2025),
                weights=[1, 1, 1.5, 1.5, 2, 2, 2.5, 3, 3, 3.5, 3.5],
            )[0]
            age = ANNEE_CURRENT - annee

            km_moyen_annee = random.randint(9000, 15000)
            km = max(500, age * km_moyen_annee + random.randint(-3000, 3000))

            fuel_weights = FUEL_WEIGHTS.get(body_type, FUEL_WEIGHTS["compacte"])
            carburant = random.choices(
                list(fuel_weights.keys()), weights=list(fuel_weights.values())
            )[0]

            puissance = random.randint(p_min, p_max) if p_min != p_max else p_min
            # Vehicules electriques : puissance equivalente ajustee legerement
            if carburant == "Electrique":
                puissance = max(45, int(puissance * 0.9))

            is_premium = marque in PREMIUM_VOITURE
            boite = random.choices(
                ["Manuelle", "Automatique"],
                weights=[0.3, 0.7] if is_premium else (
                    [0.45, 0.55] if body_type in ("SUV", "SUV coupe", "berline") else [0.7, 0.3]
                ),
            )[0]
            if carburant == "Electrique":
                boite = "Automatique"

            value_factor = max(0.25, 0.85 ** age)
            km_penalty = min(0.3, km / 300000)
            prix = prix_ocass * value_factor * (1 - km_penalty) * random.uniform(0.9, 1.15)
            prix = max(1500, round(prix / 100) * 100)

            finition_idx = random.randint(0, len(FINITION) - 1)
            finition = FINITION[finition_idx]
            if finition_idx <= 1:
                options_pool = BASE_OPTIONS
            elif finition_idx <= 2:
                options_pool = MID_OPTIONS
            else:
                options_pool = HIGH_OPTIONS
            nb_options = random.randint(max(1, len(options_pool) - 3), len(options_pool))
            options = random.sample(options_pool, min(nb_options, len(options_pool)))

            couleur = random.choice(COULEUR)

            cars.append({
                "id": car_id,
                "marque": marque,
                "modele": nom_modele,
                "carrosserie": body_type,
                "annee": annee,
                "kilometrage": km,
                "prix": int(prix),
                "carburant": carburant,
                "puissance_ch": puissance,
                "boite": boite,
                "finition": finition,
                "couleur": couleur,
                "options": options,
                "eligible_jeune_permis": puissance <= 100,
            })
            car_id += 1

print(f"Total voitures generees: {len(cars)}")

with open("/home/claude/carmatch/backend/data/cars_seed.json", "w", encoding="utf-8") as f:
    json.dump(cars, f, ensure_ascii=False, indent=2)

print("Fichier ecrit: cars_seed.json")