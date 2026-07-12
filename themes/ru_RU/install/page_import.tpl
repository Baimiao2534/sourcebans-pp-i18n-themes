{*
    SourceBans++ install wizard — step 6 (optional AMXBans import).
    Pair view: \Sbpp\View\Install\InstallImportView (web/includes/View/Install/InstallImportView.php).
    Page handler: web/install/pages/page.6.php.
*}
{include file="install/_chrome.tpl"}

<p class="lead">
    Перенесите баны из существующей базы данных AMXBans в вашу новую
    установку SourceBans++. Пропустите этот шаг, если у вас нет
    установки AMXBans для импорта.
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
    Посмотрите <code>addons/amxmodx/configs/sql.cfg</code> на вашем
    игровом сервере AMXBans, чтобы получить исходные значения для вставки ниже.
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
        <h2>Подключение к базе данных AMXBans</h2>
        <div class="install-grid">
            <div>
                <label class="label" for="install-amx-server">Имя хоста</label>
                <input class="input"
                       id="install-amx-server"
                       name="amx_server"
                       type="text"
                       value="{$val_amx_server}"
                       placeholder="localhost"
                       data-testid="install-amx-server"
                       required>
                <p class="text-xs text-muted">На виртуальном хостинге обычно <code>localhost</code>.</p>
            </div>

            <div>
                <label class="label" for="install-amx-port">Порт</label>
                <input class="input"
                       id="install-amx-port"
                       name="amx_port"
                       type="number"
                       min="1"
                       max="65535"
                       value="{$val_amx_port}"
                       data-testid="install-amx-port"
                       required>
                <p class="text-xs text-muted">По умолчанию для MySQL / MariaDB <code>3306</code>.</p>
            </div>

            <div>
                <label class="label" for="install-amx-username">Имя пользователя</label>
                <input class="input"
                       id="install-amx-username"
                       name="amx_username"
                       type="text"
                       value="{$val_amx_username}"
                       autocomplete="username"
                       data-testid="install-amx-username"
                       required>
                <p class="text-xs text-muted">Пользователь БД, владеющий таблицами AMXBans (достаточно прав на чтение).</p>
            </div>

            <div>
                <label class="label" for="install-amx-password">Пароль</label>
                <input class="input"
                       id="install-amx-password"
                       name="amx_password"
                       type="password"
                       autocomplete="new-password"
                       data-testid="install-amx-password">
                <p class="text-xs text-muted">Оставьте пустым, если у пользователя БД AMXBans нет пароля.</p>
            </div>

            <div>
                <label class="label" for="install-amx-database">Имя базы данных</label>
                <input class="input"
                       id="install-amx-database"
                       name="amx_database"
                       type="text"
                       value="{$val_amx_database}"
                       data-testid="install-amx-database"
                       required>
                <p class="text-xs text-muted">База данных AMXBans, из которой вы хотите импортировать баны.</p>
            </div>

            <div>
                <label class="label" for="install-amx-prefix">Префикс таблиц</label>
                <input class="input"
                       id="install-amx-prefix"
                       name="amx_prefix"
                       type="text"
                       value="{$val_amx_prefix}"
                       maxlength="9"
                       pattern="[A-Za-z0-9_]+"
                       data-testid="install-amx-prefix"
                       required>
                <p class="text-xs text-muted">До 9 букв / цифр / символов подчёркивания. По умолчанию AMXBans: <code>amx</code>.</p>
            </div>
        </div>
    </div>

    <div class="install-actions">
        <a class="btn btn--ghost" href="?step=5" data-testid="install-import-back">
            Назад
        </a>
        <a class="btn btn--ghost" href="../" data-testid="install-import-skip">
            Пропустить &amp; открыть панель
        </a>
        <button class="btn btn--primary"
                type="submit"
                data-testid="install-import-run">
            Импортировать баны

        </button>
    </div>
</form>

{include file="install/_chrome_close.tpl"}
