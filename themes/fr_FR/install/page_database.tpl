{*
    SourceBans++ install wizard — step 2 (database details).
    Pair view: \Sbpp\View\Install\InstallDatabaseView (web/includes/View/Install/InstallDatabaseView.php).
    Page handler: web/install/pages/page.2.php.
*}
{include file="install/_chrome.tpl"}

<p class="lead">
    Saisissez vos paramètres de connexion MySQL ou MariaDB. Créez d'abord la base
    de données dans votre panneau d'hébergement (phpMyAdmin, cPanel « Bases de données
    MySQL »), puis revenez ici avec les identifiants.
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
        <h2>Connexion à la base de données</h2>
        <div class="install-grid">
            <div>
                <label class="label" for="install-database-server">Nom d'hôte</label>
                <input class="input"
                       id="install-database-server"
                       name="server"
                       type="text"
                       value="{$val_server}"
                       placeholder="localhost"
                       data-testid="install-database-server"
                       required>
                <p class="text-xs text-muted">Généralement <code>localhost</code> sur les hébergements mutualisés.</p>
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
                <p class="text-xs text-muted">Le port par défaut pour MySQL / MariaDB est <code>3306</code>.</p>
            </div>

            <div>
                <label class="label" for="install-database-username">Nom d'utilisateur</label>
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
                <label class="label" for="install-database-password">Mot de passe</label>
                <input class="input"
                       id="install-database-password"
                       name="password"
                       type="password"
                       value="{$val_password}"
                       autocomplete="new-password"
                       data-testid="install-database-password">
                <p class="text-xs text-muted">Laisser vide si votre utilisateur de base de données n'a pas de mot de passe.</p>
            </div>

            <div>
                <label class="label" for="install-database-database">Nom de la base de données</label>
                <input class="input"
                       id="install-database-database"
                       name="database"
                       type="text"
                       value="{$val_database}"
                       data-testid="install-database-database"
                       required>
                <p class="text-xs text-muted">Doit déjà exister. L'assistant la remplit.</p>
            </div>

            <div>
                <label class="label" for="install-database-prefix">Préfixe des tables</label>
                <input class="input"
                       id="install-database-prefix"
                       name="prefix"
                       type="text"
                       value="{$val_prefix}"
                       maxlength="9"
                       pattern="[A-Za-z0-9_]+"
                       data-testid="install-database-prefix"
                       required>
                <p class="text-xs text-muted">Jusqu'à 9 lettres / chiffres / tirets bas. Par défaut : <code>sb</code>.</p>
            </div>
        </div>
    </div>

    <div class="install-section">
        <h2>Facultatif : Steam &amp; e-mail administrateur</h2>
        <div class="install-grid">
            <div>
                <label class="label" for="install-database-apikey">Clé API Steam</label>
                <input class="input"
                       id="install-database-apikey"
                       name="apikey"
                       type="text"
                       value="{$val_apikey}"
                       data-testid="install-database-apikey">
                <p class="text-xs text-muted">
                    Utilisée pour les recherches de profil Steam et la connexion OpenID.
                    Obtenez-en une sur
                    <a href="https://steamcommunity.com/dev/apikey"
                       target="_blank" rel="noopener">steamcommunity.com</a>.
                    Facultatif, peut être ajouté plus tard dans <em>Administration &rarr; Paramètres</em>.
                </p>
            </div>

            <div>
                <label class="label" for="install-database-email">E-mail SourceBans</label>
                <input class="input"
                       id="install-database-email"
                       name="sb-email"
                       type="email"
                       value="{$val_email}"
                       data-testid="install-database-email">
                <p class="text-xs text-muted">
                    Adresse expéditeur pour les réinitialisations de mot de passe et les notifications de bannissement. Facultatif.
                </p>
            </div>
        </div>
    </div>

    <div class="install-actions">
        <a class="btn btn--ghost" href="?step=1" data-testid="install-database-back">
            Retour
        </a>
        <button class="btn btn--primary"
                type="submit"
                data-testid="install-database-continue">
            Continuer
        </button>
    </div>
</form>

{include file="install/_chrome_close.tpl"}
