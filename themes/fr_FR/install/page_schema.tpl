{*
    SourceBans++ install wizard — step 4 (schema install).
    Pair view: \Sbpp\View\Install\InstallSchemaView (web/includes/View/Install/InstallSchemaView.php).
    Page handler: web/install/pages/page.4.php.
*}
{include file="install/_chrome.tpl"}

<p class="lead">
    Création des tables SourceBans++ dans votre base de données
    <code>{$val_database}</code> (charset <code>{$charset}</code>).
</p>

{if $success}
    <div class="install-alert install-alert--ok"
         role="status"
         data-testid="install-schema-success">
        <strong>{$tables_created}</strong> table{if $tables_created != 1}s{/if} créée{if $tables_created != 1}s{/if}.
        Continuez pour créer votre compte administrateur.
    </div>
{else}
    <div class="install-alert install-alert--error"
         role="alert"
         data-testid="install-schema-error">
        <strong>Échec de la création du schéma.</strong>
        {$errors_text}
        Revenez à l'étape de la base de données et vérifiez les
        identifiants et permissions de l'utilisateur (CREATE, ALTER, INDEX, INSERT).
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
            Retour à la base de données
        </a>
        {if $success}
            <button class="btn btn--primary"
                    type="submit"
                    data-testid="install-schema-continue">
                Continuer
            </button>
        {else}
            <button class="btn btn--primary"
                    type="submit"
                    disabled
                    aria-disabled="true"
                    data-testid="install-schema-continue">
                Corriger les erreurs pour continuer
            </button>
        {/if}
    </div>
</form>

{include file="install/_chrome_close.tpl"}
