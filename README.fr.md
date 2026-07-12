> **Langue :** [English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文（台灣）](README.zh-TW.md) | [繁體中文（香港）](README.zh-HK.md) | [繁體中文（澳門）](README.zh-MO.md) | [日本語](README.ja.md) | [Deutsch](README.de.md) | [Français](README.fr.md) | [Русский](README.ru.md)

# SourceBans++ Thèmes i18n

Packs de thèmes d'internationalisation (i18n) pour le panneau Web [SourceBans++](https://github.com/sbpp/sourcebans-pp) 2.0.0+. Chaque thème est un remplacement complet et localisé du thème par défaut, traduit au niveau du template Smarty sans modifier aucun fichier PHP.

Ce projet est une extension linguistique non officielle pilotée par la communauté, destinée aux administrateurs de serveurs SourceMod ayant besoin d'un panneau d'administration localisé.

## Thèmes disponibles

| Code | Langue | Nom du thème |
|------|--------|--------------|
| `en_US` | Anglais (États-Unis) | SourceBans++ English (US) |
| `en_GB` | Anglais (Royaume-Uni) | SourceBans++ English (UK) |
| `zh_CN` | Chinois simplifié | SourceBans++ 简体中文 |
| `zh_HK` | Chinois traditionnel (Hong Kong) | SourceBans++ 繁體中文（香港） |
| `zh_MO` | Chinois traditionnel (Macao) | SourceBans++ 繁體中文（澳門） |
| `zh_TW` | Chinois traditionnel (Taïwan) | SourceBans++ 繁體中文（台灣） |
| `ja_JP` | Japonais | SourceBans++ 日本語 |
| `de_DE` | Allemand | SourceBans++ Deutsch |
| `fr_FR` | Français | SourceBans++ Français |
| `ru_RU` | Russe | SourceBans++ Русский |

D'autres langues seront ajoutées dans les futures versions.

## Installation

1. Téléchargez la dernière [version ZIP](https://github.com/Baimiao2534/sourcebans-pp-i18n-themes/releases).
2. Extrayez l'archive. Vous obtiendrez un dossier par langue (par exemple `fr_FR`, `zh_CN`).
3. Téléversez le ou les dossiers dont vous avez besoin dans le répertoire `themes/` de votre installation SourceBans++.
4. Connectez-vous au panneau d'administration, allez dans **Paramètres → Thèmes** et sélectionnez le thème de langue souhaité.

## Caractéristiques

- Chaque thème contient 93 fichiers, reproduisant exactement la structure du thème par défaut.
- Toutes les chaînes visibles par l'utilisateur sont traduites via des blocs conditionnels Smarty `{if/elseif}` au niveau du template. Aucune modification PHP n'est nécessaire.
- Les ressources partagées (JS, CSS, polices, images) sont identiques à celles du thème par défaut.
- La terminologie reste cohérente au sein d'une même famille de langues (par exemple, le chinois simplifié et le chinois traditionnel partagent une terminologie cohérente avec des adaptations régionales).

## Compatibilité

- Panneau Web SourceBans++ 2.0.0 (et versions de correctif 2.0.x ultérieures).
- PHP 8.5+ (requis par SourceBans++ 2.0.0).
- Smarty 5 (inclus avec SourceBans++ 2.0.0).
- Serveur Web avec prise en charge UTF-8 (Apache ou Nginx).

## Licence

Ce projet est distribué sous la licence [Elastic License 2.0](LICENSE), la même licence que SourceBans++.

## Auteur

**Baimiao2534**

- GitHub : [@Baimiao2534](https://github.com/Baimiao2534)

## Remerciements

- [L'équipe de développement SourceBans++](https://github.com/sbpp) pour le thème par défaut original et le projet SourceBans++.
- La bibliothèque d'icônes Lucide et les polices fournies avec le thème par défaut (Inter, JetBrains Mono).
- Tous les contributeurs qui aident à améliorer et à étendre la prise en charge des langues.
