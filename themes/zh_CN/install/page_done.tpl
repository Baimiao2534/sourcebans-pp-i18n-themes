{*
    SourceBans++ install wizard — step 5 (success page).
    Pair view: \Sbpp\View\Install\InstallDoneView (web/includes/View/Install/InstallDoneView.php).
    Page handler: web/install/pages/page.5.php.

    Rendered after: config.php is written, data.sql is run, the admin
    row is created. From here the operator either (a) deletes the
    install/ folder and logs in, or (b) optionally imports AMXBans
    bans via step 6.
*}
{include file="install/_chrome.tpl"}

<div class="install-alert install-alert--ok"
     role="status"
     data-testid="install-done-success"
     style="margin-bottom:1.5rem">
    <strong>安装完成！</strong>
    您的 SourceBans++ 面板已可使用。
</div>

<div class="install-section">
    <h2>1. 删除 install/ 文件夹</h2>
    <p>
        为安全起见，请立即删除 <code>install/</code> 目录。
        若保留可访问状态，任何人都能针对您的线上数据库重新运行向导。
    </p>
</div>

<div class="install-section">
    <h2>2. 将 SourceBans++ 添加到您的游戏服务器</h2>
    <p>
        将下方代码片段粘贴到每个游戏服务器的
        <code>addons/sourcemod/configs/databases.cfg</code> 中，<strong>位于</strong>
        <code>"Databases" {ldelim} ... {rdelim}</code> 块之内。
    </p>
    <pre class="install-code"
         data-testid="install-done-databases-cfg"><code>{$databases_cfg}</code></pre>

    {if $show_local_warning}
        <div class="install-alert install-alert--info"
             role="status"
             data-testid="install-done-local-warning"
             style="margin-top:0.75rem">
            您使用了 <code>localhost</code> 作为数据库主机。这对面板可用，
            但其他机器上的游戏服务器需要可路由的主机名或 IP。
            请为这些服务器修改上方的 <code>"host"</code> 值。
        </div>
    {/if}
</div>

{if !$config_writable}
    <div class="install-section">
        <h2>3. 手动保存 config.php</h2>
        <div class="install-alert install-alert--warn"
             role="alert"
             data-testid="install-done-config-warn"
             style="margin-bottom:0.75rem">
            <strong>向导无法写入 <code>config.php</code>。</strong>
            请在登录前将下方代码片段复制到面板根目录的该文件中。
        </div>
        <pre class="install-code"
             data-testid="install-done-config-text"><code>{$config_text}</code></pre>
    </div>
{/if}

<div class="install-section">
    <h2>{if $config_writable}3{else}4{/if}. 可选: 导入 AMXBans</h2>
    <p>
        从 AMXBans 迁移？下一步会将您现有的封禁复制到
        SourceBans++。跳过此步骤可立即登录。
    </p>
</div>

<div class="install-actions">
    <form method="post" action="?step=6" style="display:inline">
        <input type="hidden" name="server"   value="{$val_server}">
        <input type="hidden" name="port"     value="{$val_port}">
        <input type="hidden" name="username" value="{$val_username}">
        <input type="hidden" name="password" value="{$val_password}">
        <input type="hidden" name="database" value="{$val_database}">
        <input type="hidden" name="prefix"   value="{$val_prefix}">
        <button class="btn btn--secondary"
                type="submit"
                data-testid="install-done-import">
            导入 AMXBans
        </button>
    </form>
    <a class="btn btn--primary"
       href="../"
       data-testid="install-done-finish">
        打开面板
    </a>
</div>

{include file="install/_chrome_close.tpl"}
