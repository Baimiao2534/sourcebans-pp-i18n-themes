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
    <strong>インストール完了！</strong>
    SourceBans++ パネルが使用可能になりました。
</div>

<div class="install-section">
    <h2>1. install/ フォルダーを削除</h2>
    <p>
        セキュリティのため、今すぐ <code>install/</code> ディレクトリを削除してください。
        アクセス可能なまま残しておくと、誰でも稼働中のデータベースに対してウィザードを再実行できてしまいます。
    </p>
</div>

<div class="install-section">
    <h2>2. ゲームサーバーに SourceBans++ を追加</h2>
    <p>
        以下のコードスニペットを各ゲームサーバーの
        <code>addons/sourcemod/configs/databases.cfg</code> の
        <code>"Databases" {ldelim} ... {rdelim}</code> ブロック<strong>内</strong>に貼り付けてください。
    </p>
    <pre class="install-code"
         data-testid="install-done-databases-cfg"><code>{$databases_cfg}</code></pre>

    {if $show_local_warning}
        <div class="install-alert install-alert--info"
             role="status"
             data-testid="install-done-local-warning"
             style="margin-top:0.75rem">
            データベースホストとして <code>localhost</code> を使用しました。
            これはパネルでは機能しますが、他のマシン上のゲームサーバーには
            ルーティング可能なホスト名または IP が必要です。
            それらのサーバーでは上記の <code>"host"</code> 値を変更してください。
        </div>
    {/if}
</div>

{if !$config_writable}
    <div class="install-section">
        <h2>3. config.php を手動で保存</h2>
        <div class="install-alert install-alert--warn"
             role="alert"
             data-testid="install-done-config-warn"
             style="margin-bottom:0.75rem">
            <strong>ウィザードが <code>config.php</code> に書き込めませんでした。</strong>
            ログイン前に、以下のコードスニペットをパネルルートのファイルにコピーしてください。
        </div>
        <pre class="install-code"
             data-testid="install-done-config-text"><code>{$config_text}</code></pre>
    </div>
{/if}

<div class="install-section">
    <h2>{if $config_writable}3{else}4{/if}. オプション: AMXBans からインポート</h2>
    <p>
        AMXBans から移行しますか？次のステップで既存の BAN を
        SourceBans++ にコピーします。スキップして今すぐログインできます。
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
            AMXBans からインポート
        </button>
    </form>
    <a class="btn btn--primary"
       href="../"
       data-testid="install-done-finish">
        パネルを開く
    </a>
</div>

{include file="install/_chrome_close.tpl"}
