{*
    SourceBans++ install wizard — step 3 (requirements check).
    Pair view: \Sbpp\View\Install\InstallRequirementsView (web/includes/View/Install/InstallRequirementsView.php).
    Page handler: web/install/pages/page.3.php.
*}
{include file="install/_chrome.tpl"}

<p class="lead">
    Проверка окружения перед подключением к базе данных.
    {if $errors > 0}
        <strong>{$errors} {if $errors == 1}блокирующая проблема{else}блокирующих проблем{/if}</strong>
        необходимо устранить перед продолжением.
    {elseif $warnings > 0}
        <strong>{$warnings} {if $warnings == 1}предупреждение{else}предупреждений{/if}</strong>.
        Вы можете продолжить, но некоторые функции могут не работать.
    {else}
        Всё в порядке.
    {/if}
</p>

{if $errors > 0}
    <div class="install-alert install-alert--error"
         role="alert"
         data-testid="install-requirements-blocked"
         style="margin-bottom:1.25rem">
        Устраните блокирующие проблемы, отмеченные красным ниже, затем нажмите
        <strong>Перепроверить</strong>.
    </div>
{elseif $warnings > 0}
    <div class="install-alert install-alert--warn"
         role="status"
         data-testid="install-requirements-warning"
         style="margin-bottom:1.25rem">
        Некоторые рекомендации не выполнены. Мастер может продолжить работу.
    </div>
{else}
    <div class="install-alert install-alert--ok"
         role="status"
         data-testid="install-requirements-ok"
         style="margin-bottom:1.25rem">
        Все проверки пройдены.
    </div>
{/if}

{foreach from=$groups item=group}
    <div class="install-section">
        <h2>{$group.title}</h2>
        <div class="card">
            <table class="install-table" data-testid="install-requirements-{$group.title|lower|replace:' ':'-'}">
                <thead>
                    <tr>
                        <th>Параметр</th>
                        <th>Требуется</th>
                        <th>Статус</th>
                        <th>Подробности</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$group.rows item=row}
                        <tr>
                            <td><strong>{$row.label}</strong></td>
                            <td>{$row.required}</td>
                            <td>
                                {if $row.status == 'ok'}
                                    <span class="install-pill install-pill--ok">ОК</span>
                                {elseif $row.status == 'warn'}
                                    <span class="install-pill install-pill--warn">Предупр.</span>
                                {else}
                                    <span class="install-pill install-pill--err">Ошибка</span>
                                {/if}
                            </td>
                            <td>{$row.detail}</td>
                        </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
    </div>
{/foreach}

<form method="post"
      action="?step=4"
      id="install-requirements-form"
      data-testid="install-requirements-form"
      autocomplete="off">
    <input type="hidden" name="server"   value="{$val_server}">
    <input type="hidden" name="port"     value="{$val_port}">
    <input type="hidden" name="username" value="{$val_username}">
    <input type="hidden" name="password" value="{$val_password}">
    <input type="hidden" name="database" value="{$val_database}">
    <input type="hidden" name="prefix"   value="{$val_prefix}">
    <input type="hidden" name="apikey"   value="{$val_apikey}">
    <input type="hidden" name="sb-email" value="{$val_email}">

    <div class="install-actions">
        <a class="btn btn--ghost" href="?step=2" data-testid="install-requirements-back">
            Назад
        </a>
        <button class="btn btn--secondary"
                type="button"
                data-testid="install-requirements-recheck"
                onclick="window.location.reload()">
            Перепроверить
        </button>
        {if $can_continue}
            <button class="btn btn--primary"
                    type="submit"
                    data-testid="install-requirements-continue">
                Продолжить
            </button>
        {else}
            <button class="btn btn--primary"
                    type="submit"
                    disabled
                    aria-disabled="true"
                    data-testid="install-requirements-continue">
                Устраните проблемы для продолжения
            </button>
        {/if}
    </div>
</form>

{include file="install/_chrome_close.tpl"}
