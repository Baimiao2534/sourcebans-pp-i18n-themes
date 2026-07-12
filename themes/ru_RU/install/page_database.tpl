{*
    SourceBans++ install wizard — step 2 (database details).
    Pair view: \Sbpp\View\Install\InstallDatabaseView (web/includes/View/Install/InstallDatabaseView.php).
    Page handler: web/install/pages/page.2.php.
*}
{include file="install/_chrome.tpl"}

<p class="lead">
    Введите данные подключения к MySQL или MariaDB. Сначала создайте базу данных
    в панели управления хостингом (phpMyAdmin, «MySQL Databases» в cPanel),
    затем вернитесь сюда с учётными данными.
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
        <h2>Подключение к базе данных</h2>
        <div class="install-grid">
            <div>
                <label class="label" for="install-database-server">Имя хоста</label>
                <input class="input"
                       id="install-database-server"
                       name="server"
                       type="text"
                       value="{$val_server}"
                       placeholder="localhost"
                       data-testid="install-database-server"
                       required>
                <p class="text-xs text-muted">На виртуальном хостинге обычно <code>localhost</code>.</p>
            </div>

            <div>
                <label class="label" for="install-database-port">Порт</label>
                <input class="input"
                       id="install-database-port"
                       name="port"
                       type="number"
                       min="1"
                       max="65535"
                       value="{$val_port}"
                       data-testid="install-database-port"
                       required>
                <p class="text-xs text-muted">По умолчанию для MySQL / MariaDB <code>3306</code>.</p>
            </div>

            <div>
                <label class="label" for="install-database-username">Имя пользователя</label>
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
                <label class="label" for="install-database-password">Пароль</label>
                <input class="input"
                       id="install-database-password"
                       name="password"
                       type="password"
                       value="{$val_password}"
                       autocomplete="new-password"
                       data-testid="install-database-password">
                <p class="text-xs text-muted">Оставьте пустым, если у пользователя БД нет пароля.</p>
            </div>

            <div>
                <label class="label" for="install-database-database">Имя базы данных</label>
                <input class="input"
                       id="install-database-database"
                       name="database"
                       type="text"
                       value="{$val_database}"
                       data-testid="install-database-database"
                       required>
                <p class="text-xs text-muted">Должна существовать заранее. Мастер заполнит её.</p>
            </div>

            <div>
                <label class="label" for="install-database-prefix">Префикс таблиц</label>
                <input class="input"
                       id="install-database-prefix"
                       name="prefix"
                       type="text"
                       value="{$val_prefix}"
                       maxlength="9"
                       pattern="[A-Za-z0-9_]+"
                       data-testid="install-database-prefix"
                       required>
                <p class="text-xs text-muted">До 9 букв / цифр / символов подчёркивания. По умолчанию: <code>sb</code>.</p>
            </div>
        </div>
    </div>

    <div class="install-section">
        <h2>Дополнительно: Steam и email администратора</h2>
        <div class="install-grid">
            <div>
                <label class="label" for="install-database-apikey">Ключ Steam API</label>
                <input class="input"
                       id="install-database-apikey"
                       name="apikey"
                       type="text"
                       value="{$val_apikey}"
                       data-testid="install-database-apikey">
                <p class="text-xs text-muted">
                    Используется для запросов профилей Steam и входа через OpenID. Получите ключ на
                    <a href="https://steamcommunity.com/dev/apikey"
                       target="_blank" rel="noopener">steamcommunity.com</a>.
                    Необязательно, можно добавить позже в <em>Администратор &rarr; Настройки</em>.
                </p>
            </div>

            <div>
                <label class="label" for="install-database-email">Email SourceBans</label>
                <input class="input"
                       id="install-database-email"
                       name="sb-email"
                       type="email"
                       value="{$val_email}"
                       data-testid="install-database-email">
                <p class="text-xs text-muted">
                    Адрес отправителя для сброса пароля и уведомлений о банах. Необязательно.
                </p>
            </div>
        </div>
    </div>

    <div class="install-actions">
        <a class="btn btn--ghost" href="?step=1" data-testid="install-database-back">
            Назад
        </a>
        <button class="btn btn--primary"
                type="submit"
                data-testid="install-database-continue">
            Продолжить
        </button>
    </div>
</form>

{include file="install/_chrome_close.tpl"}
