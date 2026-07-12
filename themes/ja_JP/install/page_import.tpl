{*
    SourceBans++ install wizard — step 6 (optional AMXBans import).
    Pair view: \Sbpp\View\Install\InstallImportView (web/includes/View/Install/InstallImportView.php).
    Page handler: web/install/pages/page.6.php.
*}
{include file="install/_chrome.tpl"}

<p class="lead">
    既存の AMXBans データベースから新しくインストールした
    SourceBans++ に BAN を移行します。インポート元の AMXBans インストールが
    ない場合はスキップしてください。
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
    AMXBans ゲームサーバーの <code>addons/amxmodx/configs/sql.cfg</code> を確認して、
    以下に入力するソース値を取得してください。
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
        <h2>AMXBans データベース接続</h2>
        <div class="install-grid">
            <div>
                <label class="label" for="install-amx-server">ホスト名</label>
                <input class="input"
                       id="install-amx-server"
                       name="amx_server"
                       type="text"
                       value="{$val_amx_server}"
                       placeholder="localhost"
                       data-testid="install-amx-server"
                       required>
                <p class="text-xs text-muted">共有ホスティングでは通常 <code>localhost</code> です。</p>
            </div>

            <div>
                <label class="label" for="install-amx-port">ポート</label>
                <input class="input"
                       id="install-amx-port"
                       name="amx_port"
                       type="number"
                       min="1"
                       max="65535"
                       value="{$val_amx_port}"
                       data-testid="install-amx-port"
                       required>
                <p class="text-xs text-muted">MySQL / MariaDB のデフォルトは <code>3306</code> です。</p>
            </div>

            <div>
                <label class="label" for="install-amx-username">ユーザー名</label>
                <input class="input"
                       id="install-amx-username"
                       name="amx_username"
                       type="text"
                       value="{$val_amx_username}"
                       autocomplete="username"
                       data-testid="install-amx-username"
                       required>
                <p class="text-xs text-muted">AMXBans テーブルを所有するデータベースユーザー（読み取り権限のみで十分です）。</p>
            </div>

            <div>
                <label class="label" for="install-amx-password">パスワード</label>
                <input class="input"
                       id="install-amx-password"
                       name="amx_password"
                       type="password"
                       autocomplete="new-password"
                       data-testid="install-amx-password">
                <p class="text-xs text-muted">AMXBans データベースユーザーにパスワードが設定されていない場合は空のままにしてください。</p>
            </div>

            <div>
                <label class="label" for="install-amx-database">データベース名</label>
                <input class="input"
                       id="install-amx-database"
                       name="amx_database"
                       type="text"
                       value="{$val_amx_database}"
                       data-testid="install-amx-database"
                       required>
                <p class="text-xs text-muted">BAN をインポートする AMXBans データベースです。</p>
            </div>

            <div>
                <label class="label" for="install-amx-prefix">テーブルプレフィックス</label>
                <input class="input"
                       id="install-amx-prefix"
                       name="amx_prefix"
                       type="text"
                       value="{$val_amx_prefix}"
                       maxlength="9"
                       pattern="[A-Za-z0-9_]+"
                       data-testid="install-amx-prefix"
                       required>
                <p class="text-xs text-muted">最大9文字の英数字 / アンダースコア。AMXBans のデフォルト: <code>amx</code>。</p>
            </div>
        </div>
    </div>

    <div class="install-actions">
        <a class="btn btn--ghost" href="?step=5" data-testid="install-import-back">
            戻る
        </a>
        <a class="btn btn--ghost" href="../" data-testid="install-import-skip">
            スキップ &amp; パネルを開く
        </a>
        <button class="btn btn--primary"
                type="submit"
                data-testid="install-import-run">
            BAN をインポート

        </button>
    </div>
</form>

{include file="install/_chrome_close.tpl"}
