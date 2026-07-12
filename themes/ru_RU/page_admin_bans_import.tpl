{*
    SourceBans++ 2026 — page_admin_bans_import.tpl
    Bound to Sbpp\View\AdminBansImportView (validated by SmartyTemplateRule).

    "Import bans" tab on the admin bans page. The form posts to
    `?p=admin&c=bans` with action=importBans; the multipart upload is
    handled inline by web/pages/admin.bans.php which scans the uploaded
    `banned_user.cfg` / `banned_ip.cfg` and inserts each line.

    `$extreq` is true when PHP can reach Steam community pages from
    server-side (i.e. allow_url_fopen + no safe_mode). When false the
    "Get Names" checkbox is shown disabled and the submit-time tooltip
    explains why.
*}
{if NOT $permission_import}
    <div class="card" data-testid="banimport-denied">
        <div class="card__body">
            <h1 style="font-size:1.25rem;font-weight:600;margin:0">Доступ запрещён</h1>
            <p class="text-sm text-muted m-0 mt-2">У вас нет прав на импорт банов.</p>
        </div>
    </div>
{else}
    <section class="p-6" data-testid="banimport-section" style="max-width:48rem">
        <div class="mb-6">
            <h1 style="font-size:1.5rem;font-weight:600;margin:0">Импорт банов</h1>
            <p class="text-sm text-muted m-0 mt-2">
                Загрузите файл <code class="font-mono">banned_user.cfg</code> или
                <code class="font-mono">banned_ip.cfg</code> для массового импорта
                существующих банов в SourceBans.
            </p>
        </div>
        <form id="banimport-form"
              class="card p-6 space-y-4"
              method="post"
              action="?p=admin&c=bans"
              enctype="multipart/form-data"
              data-testid="banimport-form">
            {csrf_field}
            <input type="hidden" name="action" value="importBans">

            <div>
                <label class="label" for="importFile">Файл банов</label>
                <div class="file-input">
                    <label class="btn btn--secondary">
                        <input type="file"
                               id="importFile"
                               name="importFile"
                               accept=".cfg,.txt"
                               required
                               data-testid="banimport-file"
                               data-file-input
                               hidden>
                        <i data-lucide="upload" style="width:14px;height:14px"></i>
                        Выбрать файл&hellip;
                    </label>
                    <span class="text-muted text-sm" data-file-name>Файл не выбран</span>
                </div>
                <div class="text-xs mt-2" id="file.msg" style="color:var(--danger);display:none"></div>
            </div>

            <label class="flex items-center gap-2 p-2"
                   style="border:1px solid var(--border);border-radius:var(--radius-md);{if !$extreq}opacity:0.55;cursor:not-allowed;{/if}">
                <input type="checkbox"
                       id="friendsname"
                       name="friendsname"
                       data-testid="banimport-friendsname"
                       {if !$extreq}disabled{/if}>
                <div>
                    <span class="text-sm font-medium">Получать имена игроков из Steam Community</span>
                    <div class="text-xs text-muted">
                        {if $extreq}
                            Запрашивает каждый Community ID онлайн во время импорта
                            (работает только с <code class="font-mono">banned_user.cfg</code>).
                        {else}
                            Отключено, так как на сервере недоступно
                            <code class="font-mono">allow_url_fopen</code>.
                        {/if}
                    </div>
                </div>
            </label>

            <div class="flex justify-end gap-2"
                 style="border-top:1px solid var(--border);padding-top:0.75rem">
                <button type="button"
                        class="btn btn--ghost"
                        id="iback"
                        data-testid="banimport-back"
                        onclick="history.go(-1);">Назад</button>
                <button type="submit"
                        class="btn btn--primary"
                        id="iban"
                        data-testid="banimport-submit">
                    Импортировать баны
                </button>
            </div>
        </form>
    </section>
{/if}
