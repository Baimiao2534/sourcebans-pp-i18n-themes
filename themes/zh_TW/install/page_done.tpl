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
    <strong>安裝完成！</strong>
    您的 SourceBans++ 面板已可使用。
</div>

<div class="install-section">
    <h2>1. 刪除 install/ 資料夾</h2>
    <p>
        基於安全考量，請立即移除 <code>install/</code> 目錄。
        若保留可存取狀態，將允許任何人對您的線上資料庫重新執行安裝精靈。
    </p>
</div>

<div class="install-section">
    <h2>2. 將 SourceBans++ 加入您的遊戲伺服器</h2>
    <p>
        將下方的程式碼片段貼入每個遊戲伺服器的
        <code>addons/sourcemod/configs/databases.cfg</code> 中，
        <strong>位於</strong>
        <code>"Databases" {ldelim} ... {rdelim}</code> 區塊<strong>內</strong>。
    </p>
    <pre class="install-code"
         data-testid="install-done-databases-cfg"><code>{$databases_cfg}</code></pre>

    {if $show_local_warning}
        <div class="install-alert install-alert--info"
             role="status"
             data-testid="install-done-local-warning"
             style="margin-top:0.75rem">
            您使用了 <code>localhost</code> 作為資料庫主機。這對
            面板沒問題，但在另一台機器上的遊戲伺服器需要可路由的
            主機名稱或 IP。請為那些伺服器更新上方的
            <code>"host"</code> 值。
        </div>
    {/if}
</div>

{if !$config_writable}
    <div class="install-section">
        <h2>3. 手動儲存 config.php</h2>
        <div class="install-alert install-alert--warn"
             role="alert"
             data-testid="install-done-config-warn"
             style="margin-bottom:0.75rem">
            <strong>安裝精靈無法寫入 <code>config.php</code>。</strong>
            請在登入前將下方的程式碼片段複製到面板根目錄的檔案中。
        </div>
        <pre class="install-code"
             data-testid="install-done-config-text"><code>{$config_text}</code></pre>
    </div>
{/if}

<div class="install-section">
    <h2>{if $config_writable}3{else}4{/if}. 選用：匯入 AMXBans</h2>
    <p>
        從 AMXBans 遷移？下一步會將您現有的封禁複製到
        SourceBans++ 中。跳過此步驟即可立即登入。
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
            匯入 AMXBans
        </button>
    </form>
    <a class="btn btn--primary"
       href="../"
       data-testid="install-done-finish">
        開啟面板
    </a>
</div>

{include file="install/_chrome_close.tpl"}
