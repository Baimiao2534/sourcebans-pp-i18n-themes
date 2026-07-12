> **語言：** [English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文（台灣）](README.zh-TW.md) | [繁體中文（香港）](README.zh-HK.md) | [繁體中文（澳門）](README.zh-MO.md) | [日本語](README.ja.md) | [Deutsch](README.de.md) | [Français](README.fr.md) | [Русский](README.ru.md)

# SourceBans++ 多語言主題

[SourceBans++](https://github.com/sbpp/sourcebans-pp) 2.0.0+ 網面板的多語言（i18n）主題包。每個主題都是預設主題的完整本地化替代版本，在 Smarty 模板層進行翻譯，無需修改任何 PHP 檔案。

本專案是為 SourceMod 伺服器管理員提供的非官方社群驅動語言擴充，面向需要本地化管理面板的使用者。

## 可用主題

| 代碼 | 語言 | 主題名稱 |
|------|------|----------|
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

後續版本將增加更多語言支援。

## 安裝方法

1. 下載最新版的 [發行版 ZIP 包](https://github.com/Baimiao2534/sourcebans-pp-i18n-themes/releases)。
2. 解壓縮後會得到每種語言對應的資料夾（如 `zh_HK`、`ja_JP`）。
3. 將您需要的資料夾上傳到 SourceBans++ 安裝目錄的 `themes/` 資料夾下。
4. 登入管理後台，進入 **設定 → 主題**，選擇對應的語言主題即可。

## 特性

- 每個主題包含 93 個檔案，與預設主題結構完全一致。
- 所有使用者可見文字透過 Smarty `{if/elseif}` 條件區塊在模板層翻譯，未修改任何 PHP 檔案。
- 共享資源（JS、CSS、字體、圖片）與預設主題完全一致。
- 術語在同一語系內保持一致（如簡體中文和繁體中文共享一致的術語，僅做地區性調整）。

## 相容性

- SourceBans++ 2.0.0 網面板（及後續 2.0.x 修補程式版本）。
- PHP 8.5+（SourceBans++ 2.0.0 要求）。
- Smarty 5（隨 SourceBans++ 2.0.0 內建）。
- 支援 UTF-8 的網頁伺服器（Apache 或 Nginx）。

## 授權條款

本專案使用 [Elastic License 2.0](LICENSE) 授權條款，與 SourceBans++ 保持一致。

## 作者

**Baimiao2534**

- GitHub: [@Baimiao2534](https://github.com/Baimiao2534)

## 致謝

- [SourceBans++ Dev Team](https://github.com/sbpp) 提供原始預設主題和 SourceBans++ 專案。
- Lucide 圖示庫以及預設主題內附的字體（Inter、JetBrains Mono）。
- 所有幫助改進和擴充語言支援的貢獻者。
