> **语言：** [English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文（台灣）](README.zh-TW.md) | [繁體中文（香港）](README.zh-HK.md) | [繁體中文（澳門）](README.zh-MO.md) | [日本語](README.ja.md) | [Deutsch](README.de.md) | [Français](README.fr.md) | [Русский](README.ru.md)

# SourceBans++ 多语言主题

[SourceBans++](https://github.com/sbpp/sourcebans-pp) 2.0.0+ 网页面板的多语言（i18n）主题包。每个主题都是默认主题的完整本地化替代版本，在 Smarty 模板层进行翻译，无需修改任何 PHP 文件。

本项目是为 SourceMod 服务器管理员提供的非官方社区驱动语言扩展，面向需要本地化管理面板的用户。

## 可用主题

| 代码 | 语言 | 主题名称 |
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

后续版本将增加更多语言支持。

## 安装方法

1. 下载最新版的 [发行版 ZIP 包](https://github.com/Baimiao2534/sourcebans-pp-i18n-themes/releases)。
2. 解压后会得到每种语言对应的文件夹（如 `zh_CN`、`ja_JP`）。
3. 将您需要的文件夹上传到 SourceBans++ 安装目录的 `themes/` 文件夹下。
4. 登录管理后台，进入 **设置 → 主题**，选择对应的语言主题即可。

## 特性

- 每个主题包含 93 个文件，与默认主题结构完全一致。
- 所有用户可见文本通过 Smarty `{if/elseif}` 条件块在模板层翻译，未修改任何 PHP 文件。
- 共享资源（JS、CSS、字体、图片）与默认主题完全一致。
- 术语在同一语系内保持一致（如简体中文和繁體中文共享一致的术语，仅做地区性调整）。

## 兼容性

- SourceBans++ 2.0.0 网页面板（及后续 2.0.x 补丁版本）。
- PHP 8.5+（SourceBans++ 2.0.0 要求）。
- Smarty 5（随 SourceBans++ 2.0.0 内置）。
- 支持 UTF-8 的 Web 服务器（Apache 或 Nginx）。

## 许可证

本项目使用 [Elastic License 2.0](LICENSE) 许可证，与 SourceBans++ 保持一致。

## 作者

**Baimiao2534**

- GitHub: [@Baimiao2534](https://github.com/Baimiao2534)

## 致谢

- [SourceBans++ Dev Team](https://github.com/sbpp) 提供原始默认主题和 SourceBans++ 项目。
- Lucide 图标库以及默认主题附带的字体（Inter、JetBrains Mono）。
- 所有帮助改进和扩展语言支持的贡献者。
