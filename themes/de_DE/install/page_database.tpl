{*
    SourceBans++ install wizard — step 2 (database details).
    Pair view: \Sbpp\View\Install\InstallDatabaseView (web/includes/View/Install/InstallDatabaseView.php).
    Page handler: web/install/pages/page.2.php.
*}
{include file="install/_chrome.tpl"}

<p class="lead">
    Geben Sie Ihre MySQL- oder MariaDB-Verbindungsdaten ein. Erstellen Sie die
    Datenbank zuerst in Ihrem Hosting-Kontrollpanel (phpMyAdmin, cPanel
    „MySQL Databases") und kehren Sie dann mit den Zugangsdaten hierher zurück.
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
        <h2>Datenbankverbindung</h2>
        <div class="install-grid">
            <div>
                <label class="label" for="install-database-server">Hostname</label>
                <input class="input"
                       id="install-database-server"
                       name="server"
                       type="text"
                       value="{$val_server}"
                       placeholder="localhost"
                       data-testid="install-database-server"
                       required>
                <p class="text-xs text-muted">Bei Shared Hosting meist <code>localhost</code>.</p>
            </div>

            <div>
                <label class="label" for="install-database-port">Port</label>
                <input class="input"
                       id="install-database-port"
                       name="port"
                       type="number"
                       min="1"
                       max="65535"
                       value="{$val_port}"
                       data-testid="install-database-port"
                       required>
                <p class="text-xs text-muted">Standard für MySQL / MariaDB ist <code>3306</code>.</p>
            </div>

            <div>
                <label class="label" for="install-database-username">Benutzername</label>
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
                <label class="label" for="install-database-password">Passwort</label>
                <input class="input"
                       id="install-database-password"
                       name="password"
                       type="password"
                       value="{$val_password}"
                       autocomplete="new-password"
                       data-testid="install-database-password">
                <p class="text-xs text-muted">Leer lassen, wenn Ihr DB-Benutzer kein Passwort hat.</p>
            </div>

            <div>
                <label class="label" for="install-database-database">Datenbankname</label>
                <input class="input"
                       id="install-database-database"
                       name="database"
                       type="text"
                       value="{$val_database}"
                       data-testid="install-database-database"
                       required>
                <p class="text-xs text-muted">Muss bereits existieren. Der Assistent füllt sie.</p>
            </div>

            <div>
                <label class="label" for="install-database-prefix">Tabellenpräfix</label>
                <input class="input"
                       id="install-database-prefix"
                       name="prefix"
                       type="text"
                       value="{$val_prefix}"
                       maxlength="9"
                       pattern="[A-Za-z0-9_]+"
                       data-testid="install-database-prefix"
                       required>
                <p class="text-xs text-muted">Bis zu 9 Buchstaben / Ziffern / Unterstriche. Standard: <code>sb</code>.</p>
            </div>
        </div>
    </div>

    <div class="install-section">
        <h2>Optional: Steam &amp; Admin-E-Mail</h2>
        <div class="install-grid">
            <div>
                <label class="label" for="install-database-apikey">Steam-API-Schlüssel</label>
                <input class="input"
                       id="install-database-apikey"
                       name="apikey"
                       type="text"
                       value="{$val_apikey}"
                       data-testid="install-database-apikey">
                <p class="text-xs text-muted">
                    Wird für Steam-Profilabfragen und OpenID-Login verwendet. Beziehen Sie
                    einen von
                    <a href="https://steamcommunity.com/dev/apikey"
                       target="_blank" rel="noopener">steamcommunity.com</a>.
                    Optional, kann später unter <em>Admin &rarr; Einstellungen</em> hinzugefügt werden.
                </p>
            </div>

            <div>
                <label class="label" for="install-database-email">SourceBans-E-Mail</label>
                <input class="input"
                       id="install-database-email"
                       name="sb-email"
                       type="email"
                       value="{$val_email}"
                       data-testid="install-database-email">
                <p class="text-xs text-muted">
                    Absenderadresse für Passwortzurücksetzungen und Bann-Benachrichtigungen. Optional.
                </p>
            </div>
        </div>
    </div>

    <div class="install-actions">
        <a class="btn btn--ghost" href="?step=1" data-testid="install-database-back">
            Zurück
        </a>
        <button class="btn btn--primary"
                type="submit"
                data-testid="install-database-continue">
            Weiter
        </button>
    </div>
</form>

{include file="install/_chrome_close.tpl"}
