{*
    SourceBans++ install wizard — step 2 (database details).
    Pair view: \Sbpp\View\Install\InstallDatabaseView (web/includes/View/Install/InstallDatabaseView.php).
    Page handler: web/install/pages/page.2.php.
*}
{include file="install/_chrome.tpl"}

<p class="lead">
    輸入您的 MySQL 或 MariaDB 連接資訊。請先在您的主機控制台
    （phpMyAdmin、cPanel「MySQL Databases」）中建立資料庫，
    然後帶著憑證回到這裡。
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
        <h2>資料庫連接</h2>
        <div class="install-grid">
            <div>
                <label class="label" for="install-database-server">主機名稱</label>
                <input class="input"
                       id="install-database-server"
                       name="server"
                       type="text"
                       value="{$val_server}"
                       placeholder="localhost"
                       data-testid="install-database-server"
                       required>
                <p class="text-xs text-muted">在共享主機上通常為 <code>localhost</code>。</p>
            </div>

            <div>
                <label class="label" for="install-database-port">連接埠</label>
                <input class="input"
                       id="install-database-port"
                       name="port"
                       type="number"
                       min="1"
                       max="65535"
                       value="{$val_port}"
                       data-testid="install-database-port"
                       required>
                <p class="text-xs text-muted">MySQL / MariaDB 的預設值為 <code>3306</code>。</p>
            </div>

            <div>
                <label class="label" for="install-database-username">使用者名稱</label>
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
                <label class="label" for="install-database-password">密碼</label>
                <input class="input"
                       id="install-database-password"
                       name="password"
                       type="password"
                       value="{$val_password}"
                       autocomplete="new-password"
                       data-testid="install-database-password">
                <p class="text-xs text-muted">如果您的資料庫使用者未設定密碼，請留空。</p>
            </div>

            <div>
                <label class="label" for="install-database-database">資料庫名稱</label>
                <input class="input"
                       id="install-database-database"
                       name="database"
                       type="text"
                       value="{$val_database}"
                       data-testid="install-database-database"
                       required>
                <p class="text-xs text-muted">必須已存在。由安裝精靈填入。</p>
            </div>

            <div>
                <label class="label" for="install-database-prefix">資料表前綴</label>
                <input class="input"
                       id="install-database-prefix"
                       name="prefix"
                       type="text"
                       value="{$val_prefix}"
                       maxlength="9"
                       pattern="[A-Za-z0-9_]+"
                       data-testid="install-database-prefix"
                       required>
                <p class="text-xs text-muted">最多 9 個字母 / 數字 / 底線。預設值：<code>sb</code>。</p>
            </div>
        </div>
    </div>

    <div class="install-section">
        <h2>選用：Steam 與管理員電子郵件</h2>
        <div class="install-grid">
            <div>
                <label class="label" for="install-database-apikey">Steam API 金鑰</label>
                <input class="input"
                       id="install-database-apikey"
                       name="apikey"
                       type="text"
                       value="{$val_apikey}"
                       data-testid="install-database-apikey">
                <p class="text-xs text-muted">
                    用於 Steam 個人資料查詢與 OpenID 登入。可從
                    <a href="https://steamcommunity.com/dev/apikey"
                       target="_blank" rel="noopener">steamcommunity.com</a>
                    取得。選用，日後可在<em>管理員&rarr;設定</em>中新增。
                </p>
            </div>

            <div>
                <label class="label" for="install-database-email">SourceBans 電子郵件</label>
                <input class="input"
                       id="install-database-email"
                       name="sb-email"
                       type="email"
                       value="{$val_email}"
                       data-testid="install-database-email">
                <p class="text-xs text-muted">
                    密碼重設與封禁通知的寄件地址。選用。
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
            繼續
        </button>
    </div>
</form>

{include file="install/_chrome_close.tpl"}
