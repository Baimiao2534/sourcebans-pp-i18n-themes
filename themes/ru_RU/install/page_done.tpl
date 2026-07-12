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
    <strong>Установка завершена!</strong>
    Ваша панель SourceBans++ готова к использованию.
</div>

<div class="install-section">
    <h2>1. Удалите папку install/</h2>
    <p>
        В целях безопасности немедленно удалите каталог <code>install/</code>.
        Если оставить его доступным, любой пользователь сможет повторно запустить мастер
        для вашей рабочей базы данных.
    </p>
</div>

<div class="install-section">
    <h2>2. Добавьте SourceBans++ на ваш игровой сервер</h2>
    <p>
        Вставьте приведённый ниже фрагмент в
        <code>addons/sourcemod/configs/databases.cfg</code> на каждом
        игровом сервере, <strong>внутри</strong> блока
        <code>"Databases" {ldelim} ... {rdelim}</code>.
    </p>
    <pre class="install-code"
         data-testid="install-done-databases-cfg"><code>{$databases_cfg}</code></pre>

    {if $show_local_warning}
        <div class="install-alert install-alert--info"
             role="status"
             data-testid="install-done-local-warning"
             style="margin-top:0.75rem">
            Вы использовали <code>localhost</code> в качестве хоста базы данных. Это
            работает для панели, но игровым серверам на другой машине
            требуется маршрутизируемое имя хоста или IP. Измените значение
            <code>"host"</code> выше для этих серверов.
        </div>
    {/if}
</div>

{if !$config_writable}
    <div class="install-section">
        <h2>3. Сохраните config.php вручную</h2>
        <div class="install-alert install-alert--warn"
             role="alert"
             data-testid="install-done-config-warn"
             style="margin-bottom:0.75rem">
            <strong>Мастеру не удалось записать <code>config.php</code>.</strong>
            Скопируйте приведённый ниже фрагмент в этот файл в корне панели
            перед входом в систему.
        </div>
        <pre class="install-code"
             data-testid="install-done-config-text"><code>{$config_text}</code></pre>
    </div>
{/if}

<div class="install-section">
    <h2>{if $config_writable}3{else}4{/if}. Дополнительно: импорт AMXBans</h2>
    <p>
        Переходите с AMXBans? Следующий шаг скопирует ваши текущие баны
        в SourceBans++. Пропустите его, чтобы войти прямо сейчас.
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
            Импортировать AMXBans
        </button>
    </form>
    <a class="btn btn--primary"
       href="../"
       data-testid="install-done-finish">
        Открыть панель
    </a>
</div>

{include file="install/_chrome_close.tpl"}
