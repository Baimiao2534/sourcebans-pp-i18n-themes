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
    <strong>Installation abgeschlossen!</strong>
    Ihr SourceBans++-Panel ist einsatzbereit.
</div>

<div class="install-section">
    <h2>1. Ordner install/ löschen</h2>
    <p>
        Entfernen Sie aus Sicherheitsgründen sofort das Verzeichnis <code>install/</code>.
        Wenn es zugänglich bleibt, kann jeder den Assistenten erneut gegen Ihre
        Live-Datenbank ausführen.
    </p>
</div>

<div class="install-section">
    <h2>2. SourceBans++ zu Ihrem Gameserver hinzufügen</h2>
    <p>
        Fügen Sie den folgenden Codeausschnitt in
        <code>addons/sourcemod/configs/databases.cfg</code> auf jedem
        Gameserver ein, <strong>innerhalb</strong> des
        <code>"Databases" {ldelim} ... {rdelim}</code>-Blocks.
    </p>
    <pre class="install-code"
         data-testid="install-done-databases-cfg"><code>{$databases_cfg}</code></pre>

    {if $show_local_warning}
        <div class="install-alert install-alert--info"
             role="status"
             data-testid="install-done-local-warning"
             style="margin-top:0.75rem">
            Sie haben <code>localhost</code> als Datenbankhost verwendet. Das
            funktioniert für das Panel, aber Gameserver auf einem anderen Rechner
            benötigen einen routingfähigen Hostnamen oder eine IP. Aktualisieren Sie
            den <code>"host"</code>-Wert oben für diese Server.
        </div>
    {/if}
</div>

{if !$config_writable}
    <div class="install-section">
        <h2>3. config.php manuell speichern</h2>
        <div class="install-alert install-alert--warn"
             role="alert"
             data-testid="install-done-config-warn"
             style="margin-bottom:0.75rem">
            <strong>Der Assistent konnte <code>config.php</code> nicht beschreiben.</strong>
            Kopieren Sie den folgenden Codeausschnitt in die Datei im
            Panel-Stammverzeichnis, bevor Sie sich anmelden.
        </div>
        <pre class="install-code"
             data-testid="install-done-config-text"><code>{$config_text}</code></pre>
    </div>
{/if}

<div class="install-section">
    <h2>{if $config_writable}3{else}4{/if}. Optional: AMXBans importieren</h2>
    <p>
        Migration von AMXBans? Der nächste Schritt kopiert Ihre vorhandenen Banns
        in SourceBans++. Überspringen Sie ihn, um sich jetzt anzumelden.
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
            AMXBans importieren
        </button>
    </form>
    <a class="btn btn--primary"
       href="../"
       data-testid="install-done-finish">
        Panel öffnen
    </a>
</div>

{include file="install/_chrome_close.tpl"}
