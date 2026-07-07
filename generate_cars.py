import random
import json
import os

random.seed(42)

# Modèles voitures (param : model, carroserire, puissancce min; puissance max , prix max en occas (avec de L'ia)
# Je vais remplacer plus tard avec de l'ia (API du chatgpt pour ajouter plus de modele au lieu d'avoir un sort de tbl)
MARQUES_MODELE = {
    "Renault": [
        ("Twingo", "citadine", (70, 95), 14000),
        ("Clio", "citadine", (75, 130), 17000),
        ("Captur", "SUV", (100, 160), 23000),
        ("Megane", "compacte", (115, 160), 25000),
        ("Kadjar", "SUV", (115, 150), 27000),
        ("Austral", "SUV", (130, 200), 33000),
        ("Arkana", "SUV coupe", (140, 160), 30000),
        ("Talisman", "berline", (150, 200), 32000),
    ],

    "Peugeot": [
        ("108", "citadine", (68, 82), 13000),
        ("208", "citadine", (75, 130), 18000),
        ("2008", "SUV", (100, 155), 23000),
        ("308", "compacte", (110, 180), 26000),
        ("3008", "SUV", (130, 225), 30000),
        ("508", "berline", (130, 225), 34000),
        ("5008", "SUV", (130, 180), 35000),
    ],

    "Citroen": [
        ("C1", "citadine", (68, 82), 13000),
        ("C3", "citadine", (83, 110), 17000),
        ("C3 Aircross", "SUV", (110, 130), 20000),
        ("C4", "compacte", (100, 155), 25000),
        ("C5 Aircross", "SUV", (130, 180), 29000),
        ("Berlingo", "familiale", (100, 130), 22000),
    ],

    "Volkswagen": [
        ("Up!", "citadine", (65, 90), 13000),
        ("Polo", "citadine", (80, 150), 19000),
        ("Golf", "compacte", (115, 245), 27000),
        ("T-Roc", "SUV", (115, 190), 27000),
        ("Tiguan", "SUV", (150, 245), 33000),
        ("Passat", "berline", (150, 190), 35000),
    ],

    "Toyota": [
        ("Aygo X", "citadine", (72, 72), 15000),
        ("Yaris", "citadine", (80, 130), 20000),
        ("Corolla", "compacte", (122, 196), 27000),
        ("C-HR", "SUV", (122, 184), 29000),
        ("RAV4", "SUV", (160, 222), 35000),
    ],

    "Dacia": [
        ("Sandero", "citadine", (65, 110), 11500),
        ("Duster", "SUV", (100, 150), 18000),
        ("Spring", "citadine", (45, 65), 17000),
        ("Jogger", "monospace", (100, 110), 18000),
    ],

    "Ford": [
        ("Fiesta", "citadine", (70, 140), 18000),
        ("Focus", "compacte", (95, 190), 24000),
        ("Puma", "SUV", (100, 155), 24000),
        ("Kuga", "SUV", (120, 225), 29000),
    ],

    "BMW": [
        ("Serie 1", "compacte", (116, 306), 29000),
        ("Serie 3", "berline", (150, 374), 44000),
        ("X1", "SUV", (136, 231), 36000),
        ("X3", "SUV", (150, 286), 46000),
    ],

    "Mercedes": [
        ("Classe A", "compacte", (116, 306), 32000),
        ("Classe C", "berline", (170, 408), 46000),
        ("GLA", "SUV", (136, 224), 38000),
        ("GLC", "SUV", (170, 367), 50000),
    ],

    "Audi": [
        ("A1", "citadine", (95, 200), 24000),
        ("A3", "compacte", (110, 310), 31000),
        ("Q2", "SUV", (116, 190), 29000),
        ("Q3", "SUV", (150, 300), 36000),
    ],

    "Fiat": [
        ("500", "citadine", (70, 118), 15000),
        ("Panda", "citadine", (69, 80), 13000),
        ("Tipo", "compacte", (95, 130), 18000),
    ],

    "Opel": [
        ("Corsa", "citadine", (75, 130), 17000),
        ("Astra", "compacte", (110, 180), 24000),
        ("Mokka", "SUV", (100, 155), 24000),
        ("Crossland", "SUV", (100, 130), 22000),
    ],

    "Nissan": [
        ("Micra", "citadine", (71, 117), 15000),
        ("Juke", "SUV", (114, 117), 22000),
        ("Qashqai", "SUV", (140, 158), 28000),
    ],

    "Hyundai": [
        ("i10", "citadine", (67, 84), 13000),
        ("i20", "citadine", (84, 120), 17000),
        ("Tucson", "SUV", (136, 265), 30000),
        ("Kona", "SUV", (120, 204), 25000),
    ],

    "Kia": [
        ("Picanto", "citadine", (67, 84), 13000),
        ("Rio", "citadine", (84, 120), 17000),
        ("Sportage", "SUV", (136, 265), 28000),
        ("Niro", "SUV", (105, 253), 29000),
    ],

    "Skoda": [
        ("Fabia", "citadine", (80, 150), 18000),
        ("Octavia", "compacte", (115, 245), 26000),
        ("Kamiq", "SUV", (95, 150), 22000),
        ("Karoq", "SUV", (115, 190), 26000),
    ],

    "Seat": [
        ("Ibiza", "citadine", (80, 150), 18000),
        ("Leon", "compacte", (110, 300), 25000),
        ("Arona", "SUV", (95, 150), 21000),
    ],

    "Mini": [
        ("Cooper", "citadine", (102, 231), 24000),
        ("Countryman", "SUV", (136, 306), 30000),
    ],

    "Volvo": [
        ("XC40", "SUV", (129, 300), 36000),
        ("XC60", "SUV", (150, 300), 46000),
        ("V60", "berline", (150, 300), 42000),
    ],

    "Suzuki": [
        ("Swift", "citadine", (83, 101), 16000),
        ("Vitara", "SUV", (102, 129), 21000),
    ],

    "Mazda": [
        ("Mazda2", "citadine", (75, 115), 17000),
        ("Mazda3", "compacte", (90, 180), 23000),
        ("CX-30", "SUV", (122, 186), 26000),
    ],

    "Honda": [
        ("Jazz", "citadine", (94, 109), 19000),
        ("Civic", "compacte", (126, 182), 27000),
        ("HR-V", "SUV", (105, 131), 26000),
    ],
}

PREMIUM_VOITURE = {"BMW", "Mercedes", "Audi", "Volvo"}  # "Mercedes-Benz" ne matchait jamais la cle "Mercedes"

# Finitions reelles par marque (un set n'a pas d'ordre/index, d'ou le bug :
# on utilise un dict de listes). Une meme finition n'existe pas forcement
# chez tous les constructeurs : "GT Line" est du Peugeot/Renault, pas du BMW.
FINITION_PAR_MARQUE = {
    "Renault": ["Evolution", "Techno", "Intens", "Equilibre", "Esprit Alpine"],
    "Peugeot": ["Active", "Allure", "GT", "GT Line"],
    "Citroen": ["You", "Plus", "Shine", "Max"],
    "Volkswagen": ["Life", "Style", "R-Line", "United"],
    "Toyota": ["Dynamic", "Design", "GR Sport"],
    "Dacia": ["Essential", "Expression", "Journey"],
    "Ford": ["Trend", "Titanium", "ST-Line"],
    "BMW": ["Business Design", "M Sport", "xLine", "Luxury Line"],
    "Mercedes": ["Business", "AMG Line", "Avantgarde"],
    "Audi": ["Business", "S line", "Design Luxe"],
    "Fiat": ["Pop", "Lounge", "Sport"],
    "Opel": ["Edition", "Elegance", "GS Line"],
    "Nissan": ["Acenta", "N-Connecta", "Tekna"],
    "Hyundai": ["Initia", "Intuitive", "Executive"],
    "Kia": ["Motion", "Active", "GT Line"],
    "Skoda": ["Ambition", "Style", "Sportline"],
    "Seat": ["Style", "FR", "Xcellence"],
    "Mini": ["Classic", "Sport", "Exclusive"],
    "Volvo": ["Core", "Plus", "Ultimate"],
    "Suzuki": ["Avantage", "Privilege"],
    "Mazda": ["Prime-Line", "Exclusive-Line", "Homura"],
    "Honda": ["Comfort", "Elegance", "Advance"],
}
FINITION_GENERIQUE = ["Confort", "Business", "Premium"]

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
    for nom_modele,body_type,(p_min,p_max),prix_neuf in modele:
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

            # Courbe calibree sur des prix reels d'occasion (Argus, LeBoncoin,
            # AutoScout24, juillet 2026) : une Clio 2022/60000km se vend
            # 11-14keur, une BMW X3 2022/45000km se vend 26-45keur.
            value_factor = max(0.35, 0.94 ** age)
            km_penalty = min(0.2, km / 400000)
            prix = prix_neuf * value_factor * (1 - km_penalty) * random.uniform(0.88, 1.05)
            prix = max(1500, round(prix / 100) * 100)

            finitions_dispo = FINITION_PAR_MARQUE.get(marque, FINITION_GENERIQUE)
            finition_idx = random.randint(0, len(finitions_dispo) - 1)
            finition = finitions_dispo[finition_idx]
            ratio_finition = finition_idx / max(1, len(finitions_dispo) - 1)
            if ratio_finition <= 0.34:
                options_pool = BASE_OPTIONS
            elif ratio_finition <= 0.67:
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

OUTPUT_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "cars_seed.json")
with open(OUTPUT_PATH, "w", encoding="utf-8") as f:
    json.dump(cars, f, ensure_ascii=False, indent=2)

print(f"Fichier ecrit: {OUTPUT_PATH}")