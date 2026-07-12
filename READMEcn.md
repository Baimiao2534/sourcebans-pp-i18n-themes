# SourceBans++ i18n 多语言主题

[SourceBans++](https://github.com/sbpp/sourcebans-pp) 2.0.0+ 网页面板的多语言主题包。每个主题都是默认主题的完整本地化替代版本，在 Smarty 模板层进行翻译，无需修改任何 PHP 文件。

## 可用主题

| 代码 | 语言 | 名称 |
|------|------|------|
| `zh_CN` | 简体中文 | SourceBans++ 简体中文 |
| `zh_TW` | 繁体中文 | SourceBans++ 繁體中文 |

后续版本将增加更多语言支持。

## 安装方法

1. 下载最新版的 [发行版 ZIP 包](https://github.com/Baimiao2534/sourcebans-pp-i18n-themes/releases)。
2. 解压后会得到两个文件夹：`zh_CN` 和 `zh_TW`。
3. 将您需要的文件夹上传到 SourceBans++ 安装目录的 `themes/` 文件夹下。
4. 登录管理后台，进入 **设置 → 主题**，选择对应的中文主题即可。

## 特性

- 每个主题包含 93 个文件，与默认主题结构完全一致。
- 所有用户可见文本通过 Smarty `{if/elseif}` 条件块在模板层翻译，未修改任何 PHP 文件。
- 共享资源（JS、CSS、字体、图片）与默认主题完全一致。
- 术语在简繁体之间保持一致（如 服务器/伺服器、设置/設定）。

## 兼容性

- SourceBans++ 2.0.0 网页面板（及后续 2.0.x 补丁版本）。
- PHP 8.1+，Smarty 5。

## 许可证

本项目与 SourceBans++ 使用相同的许可证。详情请参阅 [SourceBans++ LICENSE](https://github.com/sbpp/sourcebans-pp/blob/master/LICENSE.txt)。

## 作者

**Baimiao2534**

- GitHub: [@Baimiao2534](https://github.com/Baimiao2534)

## 致谢

- [SourceBans++ Dev Team](https://github.com/sbpp) 提供原始默认主题。
- Lucide 图标库以及默认主题附带的字体（Inter、JetBrains Mono）。
