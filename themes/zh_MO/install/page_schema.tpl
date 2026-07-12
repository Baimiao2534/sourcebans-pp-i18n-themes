{*
    SourceBans++ install wizard — step 4 (schema install).
    Pair view: \Sbpp\View\Install\InstallSchemaView (web/includes/View/Install/InstallSchemaView.php).
    Page handler: web/install/pages/page.4.php.
*}
{include file="install/_chrome.tpl"}

<p class="lead">
    正在您的資料庫 <code>{$val_database}</code> 中建立 SourceBans++ 資料表
    （字元集 <code>{$charset}</code>）。
</p>

{if $success}
    <div class="install-alert install-alert--ok"
         role="status"
         data-testid="install-schema-success">
        已建立 <strong>{$tables_created}</strong> 個資料表。
        請繼續建立您的管理員帳戶。
    </div>
{else}
    <div class="install-alert install-alert--error"
         role="alert"
         data-testid="install-schema-error">
        <strong>資料表結構建立失敗。</strong>
        {$errors_text}
        請返回資料庫步驟，檢查資料庫使用者的憑證與權限
        （CREATE、ALTER、INDEX、INSERT）。
    </div>
{/if}

<form method="post"
      action="?step=5"
      id="install-schema-form"
      data-testid="install-schema-form"
      autocomplete="off">
    <input type="hidden" name="server"   value="{$val_server}">
    <input type="hidden" name="port"     value="{$val_port}">
    <input type="hidden" name="username" value="{$val_username}">
    <input type="hidden" name="password" value="{$val_password}">
    <input type="hidden" name="database" value="{$val_database}">
    <input type="hidden" name="prefix"   value="{$val_prefix}">
    <input type="hidden" name="apikey"   value="{$val_apikey}">
    <input type="hidden" name="sb-email" value="{$val_email}">
    <input type="hidden" name="charset"  value="{$charset}">

    <div class="install-actions">
        <a class="btn btn--ghost" href="?step=2" data-testid="install-schema-back">
            返回資料庫
        </a>
        {if $success}
            <button class="btn btn--primary"
                    type="submit"
                    data-testid="install-schema-continue">
                繼續
            </button>
        {else}
            <button class="btn btn--primary"
                    type="submit"
                    disabled
                    aria-disabled="true"
                    data-testid="install-schema-continue">
                修復錯誤以繼續
            </button>
        {/if}
    </div>
</form>

{include file="install/_chrome_close.tpl"}
