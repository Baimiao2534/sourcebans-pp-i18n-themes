{*
    SourceBans++ install wizard — step 2 (database details).
    Pair view: \Sbpp\View\Install\InstallDatabaseView (web/includes/View/Install/InstallDatabaseView.php).
    Page handler: web/install/pages/page.2.php.
*}
{include file="install/_chrome.tpl"}

<p class="lead">
    MySQL または MariaDB の接続情報を入力してください。まずホスティングコントロールパネル
    （phpMyAdmin、cPanel の「MySQL Databases」）でデータベースを作成し、
    認証情報を持ってここに戻ってください。
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
        <h2>データベース接続</h2>
        <div class="install-grid">
            <div>
                <label class="label" for="install-database-server">ホスト名</label>
                <input class="input"
                       id="install-database-server"
                       name="server"
                       type="text"
                       value="{$val_server}"
                       placeholder="localhost"
                       data-testid="install-database-server"
                       required>
                <p class="text-xs text-muted">共有ホスティングでは通常 <code>localhost</code> です。</p>
            </div>

            <div>
                <label class="label" for="install-database-port">ポート</label>
                <input class="input"
                       id="install-database-port"
                       name="port"
                       type="number"
                       min="1"
                       max="65535"
                       value="{$val_port}"
                       data-testid="install-database-port"
                       required>
                <p class="text-xs text-muted">MySQL / MariaDB のデフォルトは <code>3306</code> です。</p>
            </div>

            <div>
                <label class="label" for="install-database-username">ユーザー名</label>
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
                <label class="label" for="install-database-password">パスワード</label>
                <input class="input"
                       id="install-database-password"
                       name="password"
                       type="password"
                       value="{$val_password}"
                       autocomplete="new-password"
                       data-testid="install-database-password">
                <p class="text-xs text-muted">データベースユーザーにパスワードが設定されていない場合は空のままにしてください。</p>
            </div>

            <div>
                <label class="label" for="install-database-database">データベース名</label>
                <input class="input"
                       id="install-database-database"
                       name="database"
                       type="text"
                       value="{$val_database}"
                       data-testid="install-database-database"
                       required>
                <p class="text-xs text-muted">既に存在している必要があります。ウィザードがデータベースにデータを投入します。</p>
            </div>

            <div>
                <label class="label" for="install-database-prefix">テーブルプレフィックス</label>
                <input class="input"
                       id="install-database-prefix"
                       name="prefix"
                       type="text"
                       value="{$val_prefix}"
                       maxlength="9"
                       pattern="[A-Za-z0-9_]+"
                       data-testid="install-database-prefix"
                       required>
                <p class="text-xs text-muted">最大9文字の英数字 / アンダースコア。デフォルト: <code>sb</code>。</p>
            </div>
        </div>
    </div>

    <div class="install-section">
        <h2>オプション: Steam &amp; 管理者メール</h2>
        <div class="install-grid">
            <div>
                <label class="label" for="install-database-apikey">Steam API キー</label>
                <input class="input"
                       id="install-database-apikey"
                       name="apikey"
                       type="text"
                       value="{$val_apikey}"
                       data-testid="install-database-apikey">
                <p class="text-xs text-muted">
                    Steam プロフィールの照会と OpenID ログインに使用されます。
                    <a href="https://steamcommunity.com/dev/apikey"
                       target="_blank" rel="noopener">steamcommunity.com</a>
                    から取得できます。オプションで、後で<em>管理者 &rarr; 設定</em>で追加できます。
                </p>
            </div>

            <div>
                <label class="label" for="install-database-email">SourceBans メール</label>
                <input class="input"
                       id="install-database-email"
                       name="sb-email"
                       type="email"
                       value="{$val_email}"
                       data-testid="install-database-email">
                <p class="text-xs text-muted">
                    パスワードリセットや BAN 通知の送信元アドレスです。オプションです。
                </p>
            </div>
        </div>
    </div>

    <div class="install-actions">
        <a class="btn btn--ghost" href="?step=1" data-testid="install-database-back">
            戻る
        </a>
        <button class="btn btn--primary"
                type="submit"
                data-testid="install-database-continue">
            続行
        </button>
    </div>
</form>

{include file="install/_chrome_close.tpl"}
