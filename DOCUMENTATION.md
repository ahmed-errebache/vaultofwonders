# À quoi sert chaque fichier ?

Ce document explique simplement le rôle de chaque fichier du projet, sans entrer dans les détails techniques. Pour rappel, le principe du jeu : on clique sur un distributeur pour gagner des jetons, 10 jetons permettent d'ouvrir un coffre qui donne 3 cartes de raretés aléatoires, et ces cartes rejoignent une collection conservée d'une session à l'autre.

Le code est rangé en dossiers qui suivent une idée simple :

- **Models** : les données du jeu (qu'est-ce qu'une carte ?)
- **Services** : les savoir-faire de base (tirer une carte, sauvegarder des données)
- **ViewModels** : les règles du jeu (que se passe-t-il quand on clique ?)
- **Views** : ce qui s'affiche à l'écran
- **Utils** : des outils techniques réutilisables

---

## Point d'entrée

| Fichier | Rôle |
|---|---|
| `VaultOfWondersApp.swift` | Le point de départ de l'application. Il crée les « cerveaux » du jeu (jetons et collection) et les met à disposition de tous les écrans. C'est aussi lui qui comprend l'option `--reset` utilisée par les tests UI pour repartir de zéro. |

## Models — les données

| Fichier | Rôle |
|---|---|
| `Models/Rarity.swift` | Définit ce qu'est une rareté de carte : son nom (Commune, Rare, Épique, Légendaire, Mythique), sa couleur, son icône et sa probabilité d'être tirée. Contient aussi la règle qui transforme un nombre tiré entre 1 et 100 en une rareté. |

## Services — les savoir-faire de base

Ces fichiers suivent tous le même modèle : un « contrat » qui décrit ce qu'il faut savoir faire, une version réelle utilisée par l'application, et une version simplifiée utilisée par les tests.

| Fichier | Rôle |
|---|---|
| `Services/RarityDrawing.swift` | Sait tirer une carte. La version réelle tire au hasard ; la version de test renvoie des cartes choisies à l'avance, pour que les tests soient prévisibles. |
| `Services/TokenStore.swift` | Sait sauvegarder et recharger le nombre de jetons. La version réelle écrit sur l'appareil ; la version de test garde tout en mémoire. |
| `Services/CollectionStore.swift` | Même principe que le précédent, mais pour la collection de cartes. |

## ViewModels — les règles du jeu

| Fichier | Rôle |
|---|---|
| `ViewModels/TokenViewModel.swift` | Gère les jetons : en ajouter un à chaque clic sur le distributeur, vérifier qu'on en a assez pour un coffre (10), et les débiter au moment de l'achat. |
| `ViewModels/HomeViewModel.swift` | Gère l'ouverture d'un coffre : tirer les 3 cartes, les trier de la plus commune à la plus rare, orchestrer le déroulé de l'animation (apparition des cartes, retournement une par une, apparition du bouton « Recevoir »). |
| `ViewModels/CollectionViewModel.swift` | Gère la collection : compter les cartes possédées par rareté et y ajouter les cartes reçues. |

## Views — les écrans

| Fichier | Rôle |
|---|---|
| `Views/RootView.swift` | L'écran « chef d'orchestre » : il affiche l'onglet choisi dans la barre de navigation et, pendant une ouverture de coffre, superpose l'animation par-dessus tout le reste. |
| `Views/HomeView.swift` | L'accueil : le coffre, le compteur de jetons et le bouton « Ouvrir » (grisé tant qu'on n'a pas 10 jetons, avec un message indiquant combien il en manque). |
| `Views/MachineView.swift` | Le distributeur : un gros bouton qui rapporte un jeton par clic. Contient aussi le petit compteur de jetons réutilisé sur l'accueil. |
| `Views/ChanceView.swift` | L'écran d'information qui montre les 5 raretés et leurs probabilités. |
| `Views/CollectionView.swift` | La collection : combien de cartes de chaque rareté on possède. Les raretés jamais obtenues apparaissent en gris. |

## Views/Components — les briques des écrans

| Fichier | Rôle |
|---|---|
| `Views/Components/TabBarView.swift` | La barre d'onglets en bas de l'écran (Chances, Accueil, Distributeur, Collection). |
| `Views/Components/PackOpeningView.swift` | L'animation d'ouverture : le coffre en vidéo, les 3 cartes qui apparaissent puis se retournent une à une, et le bouton « Recevoir ». |
| `Views/Components/RarityCardView.swift` | Le dessin d'une carte : sa face colorée, son dos avec un point d'interrogation, et l'effet de retournement. Les cartes rares ont un reflet brillant. |
| `Views/Components/StackedCardsView.swift` | Le petit visuel de deux cartes empilées, utilisé dans les écrans Chances et Collection. |
| `Views/Components/ChestVideoView.swift` | La vidéo du coffre, avec un réglage d'affichage pour qu'elle s'intègre bien en mode clair comme en mode sombre. |

## Utils — les outils techniques

| Fichier | Rôle |
|---|---|
| `Utils/VideoPlayerView.swift` | L'outil qui permet d'afficher et de contrôler une vidéo (lecture, pause, retour au début) dans l'interface. |

## Ressources

| Fichier | Rôle |
|---|---|
| `images/money.mp4` | La vidéo du coffre qui s'ouvre. |
| `Assets.xcassets` | Les ressources graphiques de l'application (icône, couleurs). |

---

## Les tests

### Tests unitaires (`VaultOfWondersTests/`)

Ils vérifient les règles du jeu en mémoire, sans afficher d'écran. Rapides, ils testent chaque « cerveau » séparément en remplaçant le hasard et la sauvegarde par des versions contrôlées.

| Fichier | Ce qu'il vérifie |
|---|---|
| `RarityTests.swift` | Les probabilités totalisent bien 100 %, chaque nombre tiré donne la bonne rareté, et seules Légendaire et Mythique sont « spéciales ». |
| `TokenViewModelTests.swift` | Les jetons s'accumulent clic par clic, le coffre coûte bien 10 jetons, impossible de payer sans en avoir assez, et le solde survit à un redémarrage. |
| `HomeViewModelTests.swift` | L'ouverture tire bien 3 cartes, les trie dans le bon ordre, les révèle une par une sans dépasser, et « Recevoir » range tout et remet l'écran à zéro. |
| `CollectionViewModelTests.swift` | Les cartes reçues sont bien comptées, s'additionnent au fil des ouvertures, et la collection survit à un redémarrage. |

### Tests UI (`VaultOfWondersUITests/`)

Ils lancent la vraie application dans le simulateur et la manipulent comme un utilisateur : cliquer, naviguer entre les onglets, lire ce qui est affiché. Plus lents, ils vérifient les grands parcours de jeu de bout en bout.

| Fichier | Ce qu'il vérifie |
|---|---|
| `VaultOfWondersUITests.swift` | Les 5 scénarios : l'app démarre à 0 jeton avec le coffre verrouillé ; un clic sur le distributeur rapporte un jeton ; le coffre se débloque à 10 jetons ; le parcours complet (gagner 10 jetons → ouvrir → recevoir → 3 cartes en collection) ; et les jetons sont conservés après un redémarrage de l'app. |
| `VaultOfWondersUITestsLaunchTests.swift` | Un test généré par Xcode qui lance simplement l'app et prend une capture d'écran du démarrage. |

---

## Autres fichiers

| Fichier | Rôle |
|---|---|
| `README.md` | La présentation générale du projet. |
| `.gitignore` | La liste des fichiers que git ne doit pas suivre (fichiers personnels d'Xcode, fichiers système macOS, dossiers de compilation). |
| `VaultOfWonders.xcodeproj` | Le fichier de projet d'Xcode : il décrit comment assembler l'application (géré par Xcode, on ne l'édite pas à la main). |
