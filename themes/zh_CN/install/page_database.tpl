{*
    SourceBans++ install wizard — step 2 (database details).
    Pair view: \Sbpp\View\Install\InstallDatabaseView (web/includes/View/Install/InstallDatabaseView.php).
    Page handler: web/install/pages/page.2.php.
*}
{include file="install/_chrome.tpl"}

<p class="lead">
    输入您的 MySQL 或 MariaDB 连接信息。请先在主机控制面板
    (phpMyAdmin、cPanel 的 "MySQL Databases") 中创建数据库，
    然后携带凭据返回此处。
</p>

{if $error !== ''}
    <div class="install-alert install-alert--error"
         role="alert"
         data-testid="install-database-error"
         style="margin-bottom:1.25rem">
        {$error}
    </div>
{/if}

<form method="post"
      action="?step=2"
      data-testid="install-database-form"
      autocomplete="off"
      novalidate>
    <input type="hidden" name="postd" value="1">

    <div class="install-section">
        <h2>数据库连接</h2>
        <div class="install-grid">
            <div>
                <label class="label" for="install-database-server">主机名</label>
                <input class="input"
                       id="install-database-server"
                       name="server"
                       type="text"
                       value="{$val_server}"
                       placeholder="localhost"
                       data-testid="install-database-server"
                       required>
                <p class="text-xs text-muted">共享主机上通常为 <code>localhost</code>。</p>
            </div>

            <div>
                <label class="label" for="install-database-port">端口</label>
                <input class="input"
                       id="install-database-port"
                       name="port"
                       type="number"
                       min="1"
                       max="65535"
                       value="{$val_port}"
                       data-testid="install-database-port"
                       required>
                <p class="text-xs text-muted">MySQL / MariaDB 默认为 <code>3306</code>。</p>
            </div>

            <div>
                <label class="label" for="install-database-username">用户名</label>
                <input class="input"
                       id="install-database-username"
                       name="username"
                       type="text"
                       value="{$val_username}"
                       autocomplete="username"
                       data-testid="install-database-username"
                       required>
            </div>

            <div>
                <label class="label" for="install-database-password">密码</label>
                <input class="input"
                       id="install-database-password"
                       name="password"
                       type="password"
                       value="{$val_password}"
                       autocomplete="new-password"
                       data-testid="install-database-password">
                <p class="text-xs text-muted">如果您的数据库用户未设置密码，请留空。</p>
            </div>

            <div>
                <label class="label" for="install-database-database">数据库名称</label>
                <input class="input"
                       id="install-database-database"
                       name="database"
                       type="text"
                       value="{$val_database}"
                       data-testid="install-database-database"
                       required>
                <p class="text-xs text-muted">必须已存在。向导会填充该数据库。</p>
            </div>

            <div>
                <label class="label" for="install-database-prefix">表前缀</label>
                <input class="input"
                       id="install-database-prefix"
                       name="prefix"
                       type="text"
                       value="{$val_prefix}"
                       maxlength="9"
                       pattern="[A-Za-z0-9_]+"
                       data-testid="install-database-prefix"
                       required>
                <p class="text-xs text-muted">最多 9 个字母 / 数字 / 下划线。默认: <code>sb</code>。</p>
            </div>
        </div>
    </div>

    <div class="install-section">
        <h2>可选: Steam &amp; 管理员邮箱</h2>
        <div class="install-grid">
            <div>
                <label class="label" for="install-database-apikey">Steam API 密钥</label>
                <input class="input"
                       id="install-database-apikey"
                       name="apikey"
                       type="text"
                       value="{$val_apikey}"
                       data-testid="install-database-apikey">
                <p class="text-xs text-muted">
                    用于 Steam 资料查询和 OpenID 登录。可从
                    <a href="https://steamcommunity.com/dev/apikey"
                       target="_blank" rel="noopener">steamcommunity.com</a>
                    获取。可选，可稍后在 <em>管理员 &rarr; 设置</em> 中添加。
                </p>
            </div>

            <div>
                <label class="label" for="install-database-email">SourceBans 邮箱</label>
                <input class="input"
                       id="install-database-email"
                       name="sb-email"
                       type="email"
                       value="{$val_email}"
                       data-testid="install-database-email">
                <p class="text-xs text-muted">
                    用于密码重置和封禁通知的发件人地址。可选。
                </p>
            </div>
        </div>
    </div>

    <div class="install-actions">
        <a class="btn btn--ghost" href="?step=1" data-testid="install-database-back">
            上一步
        </a>
        <button class="btn btn--primary"
                type="submit"
                data-testid="install-database-continue">
            继续
        </button>
    </div>
</form>

{include file="install/_chrome_close.tpl"}
