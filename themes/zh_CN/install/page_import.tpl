{*
    SourceBans++ install wizard — step 6 (optional AMXBans import).
    Pair view: \Sbpp\View\Install\InstallImportView (web/includes/View/Install/InstallImportView.php).
    Page handler: web/install/pages/page.6.php.
*}
{include file="install/_chrome.tpl"}

<p class="lead">
    将封禁从现有的 AMXBans 数据库迁移到您新安装的
    SourceBans++。如果没有可导入的 AMXBans 安装，请跳过此步骤。
</p>

{*
    Issue #1335 m6: pre-fix this form had no field-level helper
    text — same fields as page 2's database form but without the
    "default for MySQL is 3306" / "usually localhost" hints. The
    AMXBans-specific top-of-form hint points operators at
    `addons/amxmodx/configs/sql.cfg` (the canonical source for
    these values on a SourceMod gameserver running AMXBans).
*}
<div class="install-alert install-alert--info"
     role="status"
     data-testid="install-import-source-hint"
     style="margin-bottom:1.25rem">
    请在您的 AMXBans 游戏服务器上查看 <code>addons/amxmodx/configs/sql.cfg</code>，
    以获取下方需要粘贴的源值。
</div>

{if $error !== ''}
    <div class="install-alert install-alert--error"
         role="alert"
         data-testid="install-import-error"
         style="margin-bottom:1.25rem">
        {$error}
    </div>
{/if}

{if $result_text !== ''}
    <div class="install-alert install-alert--ok"
         role="status"
         data-testid="install-import-result"
         style="margin-bottom:1.25rem">
        {* nofilter: $result_text is built by sbpp_install_amxbans_import in page.6.php from controlled status strings; never embeds raw user input. *}
        {$result_text nofilter}
    </div>
{/if}

<form method="post"
      action="?step=6"
      id="install-import-form"
      data-testid="install-import-form"
      autocomplete="off"
      novalidate>
    <input type="hidden" name="postd" value="1">
    <input type="hidden" name="server"   value="{$val_server}">
    <input type="hidden" name="port"     value="{$val_port}">
    <input type="hidden" name="username" value="{$val_username}">
    <input type="hidden" name="password" value="{$val_password}">
    <input type="hidden" name="database" value="{$val_database}">
    <input type="hidden" name="prefix"   value="{$val_prefix}">

    <div class="install-section">
        <h2>AMXBans 数据库连接</h2>
        <div class="install-grid">
            <div>
                <label class="label" for="install-amx-server">主机名</label>
                <input class="input"
                       id="install-amx-server"
                       name="amx_server"
                       type="text"
                       value="{$val_amx_server}"
                       placeholder="localhost"
                       data-testid="install-amx-server"
                       required>
                <p class="text-xs text-muted">共享主机上通常为 <code>localhost</code>。</p>
            </div>

            <div>
                <label class="label" for="install-amx-port">端口</label>
                <input class="input"
                       id="install-amx-port"
                       name="amx_port"
                       type="number"
                       min="1"
                       max="65535"
                       value="{$val_amx_port}"
                       data-testid="install-amx-port"
                       required>
                <p class="text-xs text-muted">MySQL / MariaDB 默认为 <code>3306</code>。</p>
            </div>

            <div>
                <label class="label" for="install-amx-username">用户名</label>
                <input class="input"
                       id="install-amx-username"
                       name="amx_username"
                       type="text"
                       value="{$val_amx_username}"
                       autocomplete="username"
                       data-testid="install-amx-username"
                       required>
                <p class="text-xs text-muted">拥有 AMXBans 表的数据库用户 (只需读取权限即可)。</p>
            </div>

            <div>
                <label class="label" for="install-amx-password">密码</label>
                <input class="input"
                       id="install-amx-password"
                       name="amx_password"
                       type="password"
                       autocomplete="new-password"
                       data-testid="install-amx-password">
                <p class="text-xs text-muted">如果您的 AMXBans 数据库用户未设置密码，请留空。</p>
            </div>

            <div>
                <label class="label" for="install-amx-database">数据库名称</label>
                <input class="input"
                       id="install-amx-database"
                       name="amx_database"
                       type="text"
                       value="{$val_amx_database}"
                       data-testid="install-amx-database"
                       required>
                <p class="text-xs text-muted">您要从中导入封禁的 AMXBans 数据库。</p>
            </div>

            <div>
                <label class="label" for="install-amx-prefix">表前缀</label>
                <input class="input"
                       id="install-amx-prefix"
                       name="amx_prefix"
                       type="text"
                       value="{$val_amx_prefix}"
                       maxlength="9"
                       pattern="[A-Za-z0-9_]+"
                       data-testid="install-amx-prefix"
                       required>
                <p class="text-xs text-muted">最多 9 个字母 / 数字 / 下划线。AMXBans 默认: <code>amx</code>。</p>
            </div>
        </div>
    </div>

    <div class="install-actions">
        <a class="btn btn--ghost" href="?step=5" data-testid="install-import-back">
            上一步
        </a>
        <a class="btn btn--ghost" href="../" data-testid="install-import-skip">
            跳过 &amp; 打开面板
        </a>
        <button class="btn btn--primary"
                type="submit"
                data-testid="install-import-run">
            导入封禁

        </button>
    </div>
</form>

{include file="install/_chrome_close.tpl"}
