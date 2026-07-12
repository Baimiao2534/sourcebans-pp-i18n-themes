> **Sprache:** [English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文（台灣）](README.zh-TW.md) | [繁體中文（香港）](README.zh-HK.md) | [繁體中文（澳門）](README.zh-MO.md) | [日本語](README.ja.md) | [Deutsch](README.de.md) | [Français](README.fr.md) | [Русский](README.ru.md)

# SourceBans++ i18n Themes

Internationalisierungs- (i18n-) Theme-Pakete für das [SourceBans++](https://github.com/sbpp/sourcebans-pp) 2.0.0+ Webpanel. Jedes Theme ist ein vollständig lokalisierte Drop-in-Ersatz des Standard-Themes, auf der Smarty-Template-Ebene übersetzt, ohne PHP-Dateien zu ändern.

Dieses Projekt ist eine inoffizielle, Community-gesteuerte Spracherweiterung für SourceMod-Serveradministratoren, die ein lokalisiertes Verwaltungspanel benötigen.

## Verfügbare Themes

| Code | Sprache | Theme-Name |
|------|---------|------------|
| `en_US` | Englisch (US) | SourceBans++ English (US) |
| `en_GB` | Englisch (UK) | SourceBans++ English (UK) |
| `zh_CN` | Vereinfachtes Chinesisch | SourceBans++ 简体中文 |
| `zh_HK` | Traditionelles Chinesisch (Hongkong) | SourceBans++ 繁體中文（香港） |
| `zh_MO` | Traditionelles Chinesisch (Macao) | SourceBans++ 繁體中文（澳門） |
| `zh_TW` | Traditionelles Chinesisch (Taiwan) | SourceBans++ 繁體中文（台灣） |
| `ja_JP` | Japanisch | SourceBans++ 日本語 |
| `de_DE` | Deutsch | SourceBans++ Deutsch |
| `fr_FR` | Französisch | SourceBans++ Français |
| `ru_RU` | Russisch | SourceBans++ Русский |

In zukünftigen Versionen werden weitere Sprachen hinzugefügt.

## Installation

1. Laden Sie das neueste [Release-ZIP-Archiv](https://github.com/Baimiao2534/sourcebans-pp-i18n-themes/releases) herunter.
2. Entpacken Sie das Archiv. Sie erhalten einen Ordner pro Sprache (z. B. `de_DE`, `zh_CN`).
3. Laden Sie den bzw. die gewünschten Ordner in das Verzeichnis `themes/` Ihrer SourceBans++-Installation hoch.
4. Melden Sie sich im Admin-Panel an, gehen Sie zu **Einstellungen → Themes** und wählen Sie das gewünschte Sprach-Theme aus.

## Funktionen

- Jedes Theme enthält 93 Dateien und spiegelt die Struktur des Standard-Themes exakt wider.
- Alle benutzerseitigen Zeichenketten werden über Smarty `{if/elseif}`-Bedingungsblöcke auf Template-Ebene übersetzt. PHP-Änderungen sind nicht erforderlich.
- Gemeinsame Assets (JS, CSS, Schriftarten, Bilder) sind mit dem Standard-Theme identisch.
- Die Terminologie wird innerhalb derselben Sprachfamilie konsistent gehalten (z. B. vereinfachtes und traditionelles Chinesisch teilen eine einheitliche Terminologie mit regionalen Anpassungen).

## Kompatibilität

- SourceBans++ 2.0.0 Webpanel (und spätere 2.0.x-Patch-Releases).
- PHP 8.5+ (wie von SourceBans++ 2.0.0 gefordert).
- Smarty 5 (mit SourceBans++ 2.0.0 gebündelt).
- Webserver mit UTF-8-Unterstützung (Apache oder Nginx).

## Lizenz

Dieses Projekt wird unter der [Elastic License 2.0](LICENSE) vertrieben, derselben Lizenz wie SourceBans++.

## Autor

**Baimiao2534**

- GitHub: [@Baimiao2534](https://github.com/Baimiao2534)

## Danksagung

- [SourceBans++ Dev Team](https://github.com/sbpp) für das Original-Standard-Theme und das SourceBans++-Projekt.
- Die Lucide-Icon-Bibliothek und die mitgelieferten Schriftarten (Inter, JetBrains Mono) des Standard-Themes.
- Alle Mitwirkenden, die zur Verbesserung und Erweiterung der Sprachunterstützung beitragen.
