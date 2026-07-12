{*
    SourceBans++ install wizard — step 4 (schema install).
    Pair view: \Sbpp\View\Install\InstallSchemaView (web/includes/View/Install/InstallSchemaView.php).
    Page handler: web/install/pages/page.4.php.
*}
{include file="install/_chrome.tpl"}

<p class="lead">
    Создание таблиц SourceBans++ в вашей базе данных
    <code>{$val_database}</code> (кодировка <code>{$charset}</code>).
</p>

{if $success}
    <div class="install-alert install-alert--ok"
         role="status"
         data-testid="install-schema-success">
        Создано <strong>{$tables_created}</strong> {if $tables_created == 1}таблица{else}таблиц{/if}.
        Продолжите создание учётной записи администратора.
    </div>
{else}
    <div class="install-alert install-alert--error"
         role="alert"
         data-testid="install-schema-error">
        <strong>Не удалось создать схему.</strong>
        {$errors_text}
        Вернитесь к шагу базы данных и проверьте учётные данные
        и разрешения пользователя БД (CREATE, ALTER, INDEX, INSERT).
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
            К базе данных
        </a>
        {if $success}
            <button class="btn btn--primary"
                    type="submit"
                    data-testid="install-schema-continue">
                Продолжить
            </button>
        {else}
            <button class="btn btn--primary"
                    type="submit"
                    disabled
                    aria-disabled="true"
                    data-testid="install-schema-continue">
                Устраните ошибки для продолжения
            </button>
        {/if}
    </div>
</form>

{include file="install/_chrome_close.tpl"}
