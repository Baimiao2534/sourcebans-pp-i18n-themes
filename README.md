# SourceBans++ i18n Themes

Internationalization theme packs for [SourceBans++](https://github.com/sbpp/sourcebans-pp) 2.0.0+ web panel. Each theme is a fully localized drop-in replacement of the default theme, translated at the Smarty template layer without modifying any PHP files.

## Available Themes

| Code | Language | Name |
|------|----------|------|
| `zh_CN` | Simplified Chinese | SourceBans++ 简体中文 |
| `zh_TW` | Traditional Chinese | SourceBans++ 繁體中文 |

More languages will be added in future releases.

## Installation

1. Download the latest [release ZIP](https://github.com/Baimiao2534/sourcebans-pp-i18n-themes/releases).
2. Extract the archive. You will get two folders: `zh_CN` and `zh_TW`.
3. Upload the folders you need into the `themes/` directory of your SourceBans++ installation.
4. Log in to the admin panel, go to **Settings → Themes**, and select the desired language theme.

## Features

- Each theme contains 93 files, mirroring the default theme's structure exactly.
- All user-facing strings are translated via Smarty `{if/elseif}` conditional blocks at the template layer. No PHP modifications are required.
- Shared assets (JS, CSS, fonts, images) are identical to the default theme.
- Terminology is kept consistent across locales (e.g., 服务器/伺服器, 设置/設定).

## Compatibility

- SourceBans++ 2.0.0 web panel (and later 2.0.x patch releases).
- PHP 8.1+ with Smarty 5.

## License

This project is distributed under the same license as SourceBans++. See the [SourceBans++ LICENSE](https://github.com/sbpp/sourcebans-pp/blob/master/LICENSE.txt) for details.

## Author

**Baimiao2534**

- GitHub: [@Baimiao2534](https://github.com/Baimiao2534)

## Acknowledgements

- [SourceBans++ Dev Team](https://github.com/sbpp) for the original default theme.
- The Lucide icon library and the vendored fonts (Inter, JetBrains Mono) shipped with the default theme.
