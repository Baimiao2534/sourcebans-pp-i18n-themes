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
    <strong>Installation terminée !</strong>
    Votre panneau SourceBans++ est prêt à être utilisé.
</div>

<div class="install-section">
    <h2>1. Supprimez le dossier install/</h2>
    <p>
        Pour des raisons de sécurité, supprimez le répertoire <code>install/</code> maintenant.
        Le laisser accessible permettrait à quiconque de relancer l'assistant contre votre
        base de données en production.
    </p>
</div>

<div class="install-section">
    <h2>2. Ajoutez SourceBans++ à votre serveur de jeu</h2>
    <p>
        Collez l'extrait ci-dessous dans
        <code>addons/sourcemod/configs/databases.cfg</code> sur chaque
        serveur de jeu, <strong>à l'intérieur</strong> du bloc
        <code>"Databases" {ldelim} ... {rdelim}</code>.
    </p>
    <pre class="install-code"
         data-testid="install-done-databases-cfg"><code>{$databases_cfg}</code></pre>

    {if $show_local_warning}
        <div class="install-alert install-alert--info"
             role="status"
             data-testid="install-done-local-warning"
             style="margin-top:0.75rem">
            Vous avez utilisé <code>localhost</code> comme hôte de base de données. Cela
            fonctionne pour le panneau, mais les serveurs de jeu sur une autre machine
            ont besoin d'un nom d'hôte ou d'une IP routable. Mettez à jour la
            valeur <code>"host"</code> ci-dessus pour ceux-ci.
        </div>
    {/if}
</div>

{if !$config_writable}
    <div class="install-section">
        <h2>3. Enregistrez config.php manuellement</h2>
        <div class="install-alert install-alert--warn"
             role="alert"
             data-testid="install-done-config-warn"
             style="margin-bottom:0.75rem">
            <strong>L'assistant n'a pas pu écrire dans <code>config.php</code>.</strong>
            Copiez l'extrait ci-dessous dans le fichier à la racine du panneau
            avant de vous connecter.
        </div>
        <pre class="install-code"
             data-testid="install-done-config-text"><code>{$config_text}</code></pre>
    </div>
{/if}

<div class="install-section">
    <h2>{if $config_writable}3{else}4{/if}. Facultatif : importer AMXBans</h2>
    <p>
        Vous migrez depuis AMXBans ? L'étape suivante copie vos bannissements existants
        dans SourceBans++. Passez-la pour vous connecter maintenant.
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
            Importer AMXBans
        </button>
    </form>
    <a class="btn btn--primary"
       href="../"
       data-testid="install-done-finish">
        Ouvrir le panneau
    </a>
</div>

{include file="install/_chrome_close.tpl"}
