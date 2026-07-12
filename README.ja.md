> **言語:** [English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文（台灣）](README.zh-TW.md) | [繁體中文（香港）](README.zh-HK.md) | [繁體中文（澳門）](README.zh-MO.md) | [日本語](README.ja.md) | [Deutsch](README.de.md) | [Français](README.fr.md) | [Русский](README.ru.md)

# SourceBans++ 多言語テーマ

[SourceBans++](https://github.com/sbpp/sourcebans-pp) 2.0.0+ ウェブパネル向けの国際化（i18n）テーマパックです。各テーマはデフォルトテーマの完全なローカライズ版であり、Smarty テンプレート層で翻訳され、PHP ファイルの変更は不要です。

本プロジェクトは SourceMod サーバー管理者向けの非公式コミュニティ駆動の言語拡張であり、ローカライズされた管理パネルを必要とするユーザー向けです。

## 利用可能なテーマ

| コード | 言語 | テーマ名 |
|--------|------|----------|
| `en_US` | 英語（米国） | SourceBans++ English (US) |
| `en_GB` | 英語（英国） | SourceBans++ English (UK) |
| `zh_CN` | 簡体字中国語 | SourceBans++ 简体中文 |
| `zh_HK` | 繁体字中国語（香港） | SourceBans++ 繁體中文（香港） |
| `zh_MO` | 繁体字中国語（マカオ） | SourceBans++ 繁體中文（澳門） |
| `zh_TW` | 繁体字中国語（台湾） | SourceBans++ 繁體中文（台灣） |
| `ja_JP` | 日本語 | SourceBans++ 日本語 |
| `de_DE` | ドイツ語 | SourceBans++ Deutsch |
| `fr_FR` | フランス語 | SourceBans++ Français |
| `ru_RU` | ロシア語 | SourceBans++ Русский |

今後のリリースでより多くの言語が追加される予定です。

## インストール方法

1. 最新の [リリース ZIP](https://github.com/Baimiao2534/sourcebans-pp-i18n-themes/releases) をダウンロードします。
2. アーカイブを展開すると、各言語のフォルダ（例：`ja_JP`、`zh_CN`）が作成されます。
3. 必要なフォルダを SourceBans++ インストール先の `themes/` ディレクトリにアップロードします。
4. 管理パネルにログインし、**設定 → テーマ** で目的の言語テーマを選択します。

## 特徴

- 各テーマは 93 個のファイルを含み、デフォルトテーマと構造が完全に一致します。
- すべてのユーザー向け文字列は Smarty `{if/elseif}` 条件ブロックでテンプレート層で翻訳されます。PHP の変更は不要です。
- 共有アセット（JS、CSS、フォント、画像）はデフォルトテーマと同一です。
- 用語は同じ言語ファミリー内で一貫性が保たれています（例：簡体字中国語と繁体字中国語は一貫した用語を共有し、地域的な調整のみ行われます）。

## 互換性

- SourceBans++ 2.0.0 ウェブパネル（および以降の 2.0.x パッチリリース）。
- PHP 8.5+（SourceBans++ 2.0.0 の要件）。
- Smarty 5（SourceBans++ 2.0.0 にバンドル）。
- UTF-8 をサポートするウェブサーバー（Apache または Nginx）。

## ライセンス

本プロジェクトは [Elastic License 2.0](LICENSE) ライセンスで配布されており、SourceBans++ と同じライセンスを使用しています。

## 作者

**Baimiao2534**

- GitHub: [@Baimiao2534](https://github.com/Baimiao2534)

## 謝辞

- [SourceBans++ Dev Team](https://github.com/sbpp) による元のデフォルトテーマおよび SourceBans++ プロジェクト。
- Lucide アイコンライブラリおよびデフォルトテーマに同梱のフォント（Inter、JetBrains Mono）。
- 言語サポートの改善と拡充に協力してくださるすべての貢献者。
