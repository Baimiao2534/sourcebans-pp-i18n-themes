{*
    SourceBans++ install wizard — step 6 (optional AMXBans import).
    Pair view: \Sbpp\View\Install\InstallImportView (web/includes/View/Install/InstallImportView.php).
    Page handler: web/install/pages/page.6.php.
*}
{include file="install/_chrome.tpl"}

<p class="lead">
    Migrieren Sie Banns aus einer bestehenden AMXBans-Datenbank in Ihre neue
    SourceBans++-Installation. Überspringen Sie diesen Schritt, wenn Sie keine
    AMXBans-Installation haben, aus der Sie importieren können.
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
    Prüfen Sie <code>addons/amxmodx/configs/sql.cfg</code> auf Ihrem
    AMXBans-Gameserver auf die Quellwerte, die Sie unten einfügen müssen.
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
        <h2>AMXBans-Datenbankverbindung</h2>
        <div class="install-grid">
            <div>
                <label class="label" for="install-amx-server">Hostname</label>
                <input class="input"
                       id="install-amx-server"
                       name="amx_server"
                       type="text"
                       value="{$val_amx_server}"
                       placeholder="localhost"
                       data-testid="install-amx-server"
                       required>
                <p class="text-xs text-muted">Bei Shared Hosting meist <code>localhost</code>.</p>
            </div>

            <div>
                <label class="label" for="install-amx-port">Port</label>
                <input class="input"
                       id="install-amx-port"
                       name="amx_port"
                       type="number"
                       min="1"
                       max="65535"
                       value="{$val_amx_port}"
                       data-testid="install-amx-port"
                       required>
                <p class="text-xs text-muted">Standard für MySQL / MariaDB ist <code>3306</code>.</p>
            </div>

            <div>
                <label class="label" for="install-amx-username">Benutzername</label>
                <input class="input"
                       id="install-amx-username"
                       name="amx_username"
                       type="text"
                       value="{$val_amx_username}"
                       autocomplete="username"
                       data-testid="install-amx-username"
                       required>
                <p class="text-xs text-muted">Der DB-Benutzer, dem die AMXBans-Tabellen gehören (Lesezugriff reicht aus).</p>
            </div>

            <div>
                <label class="label" for="install-amx-password">Passwort</label>
                <input class="input"
                       id="install-amx-password"
                       name="amx_password"
                       type="password"
                       autocomplete="new-password"
                       data-testid="install-amx-password">
                <p class="text-xs text-muted">Leer lassen, wenn Ihr AMXBans-DB-Benutzer kein Passwort hat.</p>
            </div>

            <div>
                <label class="label" for="install-amx-database">Datenbankname</label>
                <input class="input"
                       id="install-amx-database"
                       name="amx_database"
                       type="text"
                       value="{$val_amx_database}"
                       data-testid="install-amx-database"
                       required>
                <p class="text-xs text-muted">Die AMXBans-Datenbank, aus der Sie Banns importieren möchten.</p>
            </div>

            <div>
                <label class="label" for="install-amx-prefix">Tabellenpräfix</label>
                <input class="input"
                       id="install-amx-prefix"
                       name="amx_prefix"
                       type="text"
                       value="{$val_amx_prefix}"
                       maxlength="9"
                       pattern="[A-Za-z0-9_]+"
                       data-testid="install-amx-prefix"
                       required>
                <p class="text-xs text-muted">Bis zu 9 Buchstaben / Ziffern / Unterstriche. AMXBans-Standard: <code>amx</code>.</p>
            </div>
        </div>
    </div>

    <div class="install-actions">
        <a class="btn btn--ghost" href="?step=5" data-testid="install-import-back">
            Zurück
        </a>
        <a class="btn btn--ghost" href="../" data-testid="install-import-skip">
            Überspringen &amp; Panel öffnen
        </a>
        <button class="btn btn--primary"
                type="submit"
                data-testid="install-import-run">
            Banns importieren

        </button>
    </div>
</form>

{include file="install/_chrome_close.tpl"}
