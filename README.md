# VaultOfWonders

Application iOS de simulation d'ouverture de packs de cartes, développée en SwiftUI selon l'architecture **MVVM** (Model-View-ViewModel).

---

## Aperçu

VaultOfWonders permet à l'utilisateur d'ouvrir des packs de cartes virtuels. Chaque ouverture révèle 3 cartes de raretés aléatoires, avec des probabilités de drop différentes selon la rareté. Les cartes obtenues sont ajoutées à une collection persistante.

---

## Prérequis

- Xcode 16 ou supérieur
- iOS 17 ou supérieur
- Swift 5

---

## Architecture

Le projet suit le pattern **MVVM** (Model-View-ViewModel) :

| Couche | Rôle |
|---|---|
| **Model** | Définit les données brutes du jeu |
| **ViewModel** | Contient la logique métier et l'état de l'interface |
| **View** | Affiche les données, ne contient aucune logique |

```
VaultOfWonders/
├── Models/
│   └── Rarity.swift
├── ViewModels/
│   ├── CollectionViewModel.swift
│   └── HomeViewModel.swift
├── Views/
│   ├── RootView.swift
│   ├── HomeView.swift
│   ├── CollectionView.swift
│   ├── ChanceView.swift
│   └── Components/
│       ├── TabBarView.swift
│       └── PackOpeningView.swift
├── Utils/
│   ├── VideoPlayerView.swift
│   ├── GIFImageView.swift
│   ├── SVGAnimationView.swift
│   └── Constants.swift
└── VaultOfWondersApp.swift
```

---

## Fonctionnement général

```
Utilisateur appuie "Ouvrir"
  → HomeViewModel tire 3 raretés aléatoires
  → Animation : coffre s'ouvre (vidéo MP4), cartes apparaissent une par une
  → Utilisateur appuie "Recevoir"
  → Les cartes sont sauvegardées dans la collection (UserDefaults)
  → CollectionView se met à jour automatiquement
```

---

## Description des fichiers

### Point d'entrée

#### `VaultOfWondersApp.swift`
Point de démarrage de l'application (`@main`). Instancie le `CollectionViewModel` une seule fois et le rend accessible à toutes les vues via `.environmentObject()`. Lance `RootView` comme vue initiale.

---

### Models

#### `Models/Rarity.swift`

Définit la structure de données fondamentale du jeu.

**`struct Rarity`**
Représente une rareté de carte.
| Propriété | Type | Description |
|---|---|---|
| `id` | `UUID` | Identifiant unique (requis par `Identifiable`) |
| `name` | `String` | Nom affiché ("Commune", "Rare"...) |
| `percent` | `Int` | Probabilité de drop en % |
| `color` | `Color` | Couleur associée à la rareté |

**`allRarities`**
Tableau global des 5 raretés disponibles :
| Rareté | Probabilité | Couleur |
|---|---|---|
| Commune | 50% | Gris |
| Rare | 30% | Rouge |
| Épique | 15% | Violet |
| Légendaire | 4% | Orange |
| Mythique | 1% | Cyan |

**`func drawRarity() -> Rarity`**
Simule un tirage aléatoire. Tire un nombre entre 1 et 100 et le compare aux probabilités cumulées pour retourner la rareté correspondante.

---

### ViewModels

#### `ViewModels/CollectionViewModel.swift`

Gère l'état de la collection de l'utilisateur. Hérite de `ObservableObject` — toute modification de `counts` déclenche automatiquement une mise à jour de l'interface.

**Propriétés**
| Propriété | Type | Description |
|---|---|---|
| `counts` | `[String: Int]` | Nombre de cartes possédées par rareté |
| `key` | `String` | Clé UserDefaults pour la persistance |

**Méthodes**
| Méthode | Description |
|---|---|
| `init()` | Charge les données sauvegardées depuis `UserDefaults` |
| `add(cards: [Rarity])` | Incrémente le compteur de chaque rareté reçue et sauvegarde |
| `count(for: Rarity) -> Int` | Retourne le nombre de cartes possédées pour une rareté donnée |

---

#### `ViewModels/HomeViewModel.swift`

Gère toute la logique d'ouverture de pack et l'état de l'animation. Hérite de `ObservableObject`.

**Propriétés publiées**
| Propriété | Type | Description |
|---|---|---|
| `showPopup` | `Bool` | Indique si l'overlay d'ouverture est visible |
| `showCards` | `Bool` | Indique si les cartes tirées sont affichées |
| `drawnCards` | `[Rarity]` | Les 3 cartes tirées lors de l'ouverture |
| `showButton` | `Bool` | Indique si le bouton "Recevoir" est visible |

**Méthodes**
| Méthode | Description |
|---|---|
| `openPack()` | Tire 3 raretés, les trie, puis déclenche la séquence d'animation via des délais asynchrones |
| `collectCards(into: CollectionViewModel)` | Envoie les cartes au CollectionViewModel et réinitialise tous les états |

**Séquence de `openPack()`**
```
t+0.0s  → showPopup = true  (overlay s'ouvre, fond flouté)
t+2.0s  → showCards = true  (les 3 cartes apparaissent avec animation)
t+2.4s  → showButton = true (le bouton "Recevoir" apparaît en fondu)
```

---

### Views

#### `Views/RootView.swift`

Vue racine de l'application. Gère la navigation entre onglets et l'affichage de l'overlay d'ouverture de pack.

Structure en `ZStack` :
1. `VStack` contenant la vue de l'onglet actif + la `TabBarView`
2. Rectangle flouté (`.ultraThinMaterial`) affiché si `showPopup`
3. `PackOpeningView` affiché si `showPopup`

Crée le `HomeViewModel` via `@StateObject` et le transmet aux vues enfants.

---

#### `Views/HomeView.swift`

Écran d'accueil (onglet Accueil). Vue purement déclarative, sans logique.

Affiche :
- Le titre "Vault Of Wonders"
- La vidéo du coffre (en pause)
- Le bouton "Ouvrir" (déclenche `vm.openPack()`)

Reçoit le `HomeViewModel` en `@ObservedObject` depuis `RootView`.

---

#### `Views/CollectionView.swift`

Écran de collection (onglet Collection). Affiche une grille 2 colonnes de toutes les raretés.

Pour chaque rareté :
- **Possédée** (count > 0) : couleur vive, nombre affiché en gras
- **Non possédée** (count = 0) : grisé, ×0 affiché

Lit les données via `@EnvironmentObject var collectionVM: CollectionViewModel`.

---

#### `Views/ChanceView.swift`

Écran des probabilités (onglet Chances). Vue informative, aucune interaction.

Affiche chaque rareté avec son pourcentage de drop dans une grille 2 colonnes.

Composants internes privés :
- **`RarityCell`** : cellule individuelle (nom + % + icône cartes)
- **`StackedCards`** : représentation visuelle de deux cartes empilées

---

#### `Views/Components/TabBarView.swift`

Barre de navigation personnalisée en bas de l'écran (forme capsule).

Contient l'enum `AppTab` définissant les 3 onglets :
```swift
enum AppTab {
    case home
    case chance
    case collection
}
```

Reçoit `selectedTab` en `@Binding` depuis `RootView`. Chaque onglet change visuellement quand il est sélectionné (fond bleu + icône agrandie).

---

#### `Views/Components/PackOpeningView.swift`

Overlay d'animation affiché lors de l'ouverture d'un pack. S'affiche par-dessus tout l'écran.

Affiche :
- La vidéo du coffre en lecture (`isPlaying: true`)
- Les 3 cartes tirées avec animation d'apparition décalée
- Le bouton "Recevoir" (déclenche le callback `onCollect`)

Reçoit le `HomeViewModel` en `@ObservedObject` et un callback `onCollect: () -> Void` depuis `RootView`.

---

### Utils

#### `Utils/VideoPlayerView.swift`

Wrapper SwiftUI autour de `AVPlayer` pour la lecture de fichiers `.mp4`.

| Paramètre | Description |
|---|---|
| `name` | Nom du fichier vidéo (sans extension) |
| `isPlaying` | `true` pour lire, `false` pour mettre en pause et revenir au début |

La vidéo est muette (`isMuted = true`) et se redémarre depuis le début à chaque lecture.

---

#### `Utils/GIFImageView.swift`

Wrapper SwiftUI pour afficher des GIFs animés via `WKWebView`.

- **`GIFImageView`** : affiche le GIF en animation complète
- **`GIFFirstFrameView`** : affiche uniquement la première frame (image statique)

---

#### `Utils/SVGAnimationView.swift`

Wrapper SwiftUI pour afficher et contrôler des animations SVG via `WKWebView`.

| Paramètre | Description |
|---|---|
| `name` | Nom du fichier SVG (sans extension) |
| `isPlaying` | Contrôle si l'animation SVG est en lecture ou en pause |

Utilise JavaScript (`pauseAnimations()` / `unpauseAnimations()`) pour contrôler l'état de l'animation.

---

#### `Utils/Constants.swift`

Utilitaires globaux partagés.

- **`SafeAreaManager`** : singleton pour accéder aux marges de la safe area
- **Extension `UIDevice`** : propriétés statiques `isIPad` et `isIPhone` pour détecter le type d'appareil

---

## Persistance des données

La collection est sauvegardée dans `UserDefaults` sous la clé `"collection_counts"` au format `[String: Int]` (nom de rareté → nombre de cartes). Les données persistent entre les sessions.

---

## Assets

| Fichier | Usage |
|---|---|
| `money.mp4` | Animation du coffre qui s'ouvre |

---

## Auteurs

Projet réalisé dans le cadre d'un cours de développement iOS — IUT Saint-Dié-des-Vosges.
