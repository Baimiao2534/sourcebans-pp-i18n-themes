> **Languages:** [English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文（台灣）](README.zh-TW.md) | [繁體中文（香港）](README.zh-HK.md) | [繁體中文（澳門）](README.zh-MO.md) | [日本語](README.ja.md) | [Deutsch](README.de.md) | [Français](README.fr.md) | [Русский](README.ru.md)

# SourceBans++ i18n Themes

Internationalization (i18n) theme packs for the [SourceBans++](https://github.com/sbpp/sourcebans-pp) 2.0.0+ web panel. Each theme is a fully localized drop-in replacement of the default theme, translated at the Smarty template layer without modifying any PHP files.

This project is an unofficial community-driven language extension for the official SourceBans++ project, designed for SourceMod server administrators who need localized management panels.

## Available Themes

| Code | Language | Theme Name |
|------|----------|------------|
| `en_US` | English (US) | SourceBans++ English (US) |
| `en_GB` | English (UK) | SourceBans++ English (UK) |
| `zh_CN` | 简体中文 | SourceBans++ 简体中文 |
| `zh_HK` | 繁體中文（香港） | SourceBans++ 繁體中文（香港） |
| `zh_MO` | 繁體中文（澳門） | SourceBans++ 繁體中文（澳門） |
| `zh_TW` | 繁體中文（台灣） | SourceBans++ 繁體中文（台灣） |
| `ja_JP` | 日本語 | SourceBans++ 日本語 |
| `de_DE` | Deutsch | SourceBans++ Deutsch |
| `fr_FR` | Français | SourceBans++ Français |
| `ru_RU` | Русский | SourceBans++ Русский |

More languages will be added in future releases.

## Installation

1. Download the latest [release ZIP](https://github.com/Baimiao2534/sourcebans-pp-i18n-themes/releases).
2. Extract the archive. You will get one folder per language (e.g. `zh_CN`, `ja_JP`).
3. Upload the folder(s) you need into the `themes/` directory of your SourceBans++ installation.
4. Log in to the admin panel, go to **Settings → Themes**, and select the desired language theme.

## Features

- Each theme contains 93 files, mirroring the default theme's structure exactly.
- All user-facing strings are translated via Smarty `{if/elseif}` conditional blocks at the template layer. No PHP modifications are required.
- Shared assets (JS, CSS, fonts, images) are identical to the default theme.
- Terminology is kept consistent across locales within the same language family (e.g., 简体中文 and 繁體中文 share consistent terminology with regional adaptations).

## Compatibility

- SourceBans++ 2.0.0 web panel (and later 2.0.x patch releases).
- PHP 8.5+ (as required by SourceBans++ 2.0.0).
- Smarty 5 (bundled with SourceBans++ 2.0.0).
- Web server with UTF-8 support (Apache or Nginx).

## License

This project is distributed under the [Elastic License 2.0](LICENSE), the same license used by SourceBans++.

## Author

**Baimiao2534**

- GitHub: [@Baimiao2534](https://github.com/Baimiao2534)

## Acknowledgements

- [SourceBans++ Dev Team](https://github.com/sbpp) for the original default theme and the SourceBans++ project.
- The Lucide icon library and the vendored fonts (Inter, JetBrains Mono) shipped with the default theme.
- All contributors who help improve and expand language support.
