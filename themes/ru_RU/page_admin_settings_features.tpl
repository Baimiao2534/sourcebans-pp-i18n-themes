{*
    SourceBans++ 2026 — page / page_admin_settings_features.tpl

    "Features" sub-tab on the admin Settings page. Pair:
    Sbpp\View\AdminFeaturesView + web/pages/admin.settings.php (which
    routes by ?section= and renders one View per request — see
    sibling page_admin_settings_settings.tpl for the rationale).

    #1259 — sidebar lifted into a shared partial: the inline
    `<nav>` block + `grid-template-columns:14rem 1fr` shell that
    used to wrap this template's content is now driven by
    `core/admin_sidebar.tpl` via `web/includes/View/AdminTabs.php`. The
    page handler (admin.settings.php) opens the shell BEFORE this
    template renders. See AGENTS.md "Sub-paged admin routes".

    #1256 — row anatomy aligned with Settings → Main
    (page_admin_settings_settings.tpl). Each toggle row is now
    `<div data-testid="setting-row" data-key="…"> <label
    class="flex items-center gap-2"><input><span class="text-sm
    font-medium"></span></label> <p
    class="settings-fieldset__help" id="…_help"
    data-testid="setting-help-…">…</p> </div>` — the label-pair
    shape Settings → Main uses for its inline checkboxes (e.g.
    `config.debug`), with the description copy promoted to a
    sibling `<p>` paragraph wired via `aria-describedby` so screen
    readers announce it as the input's description (the same wiring
    Settings → Main's auth/token-lifetime block — #1207 ADM-7 —
    uses for its number inputs). The pre-#1256 inline
    `style="border:…;border-radius:…"` was dropped: the outer
    `.card` is the only chrome now, and the per-row borders that
    painted the card-in-card double-bordered look are gone. Card
    body rhythm bumped from `space-y-3` to `space-y-4` to match
    Settings → Main's card-body spacing now that the rows have a
    sibling paragraph beneath the label-pair. The native checkbox
    paint is unified panel-wide via the global
    `input[type="checkbox"]` rule in
    `web/themes/default/css/theme.css` (also #1256).

    Variable contract (kept in sync by SmartyTemplateRule):
        Permission gates:
            $can_web_settings — gates the entire body.
            $can_owner — currently unused in this section but kept
                across all settings views for parity.
        Toggles: $export_public, $enable_kickit,
            $enable_groupbanning, $enable_friendsbanning,
            $enable_adminrehashing, $enable_steamlogin,
            $enable_normallogin, $enable_publiccomments.
        Steam Web API key probe: $steamapi (true when STEAMAPIKEY
            is defined and non-empty; gates Group/Friends banning
            inputs the same way the legacy theme did).

    Testability hooks:
        - Sidebar links: data-testid="admin-tab-<slug>" (#1259 — the
          legacy `settings-tab-<slug>` was renamed to the cross-page
          `admin-tab-<slug>` shape now that the chrome is shared with
          servers / mods / groups).
        - Each toggle row: data-testid="setting-row" + data-key="<key>".
        - Each help paragraph: data-testid="setting-help-<key>" (#1256).
        - Save button: data-testid="settings-save".

    #1266 — outer `.p-6` removed; the page inset lives on
    `.admin-sidebar-shell` so both grid columns share the same top y.
*}
<div>
    <div class="mb-6">
        <h1 style="font-size:var(--fs-2xl);font-weight:600;margin:0">Настройки</h1>
        <p class="text-sm text-muted m-0 mt-2">Дополнительные функции и интеграции.</p>
    </div>

    {if NOT $can_web_settings}
        <div class="card">
            <div class="card__body">
                <p class="text-muted">Доступ запрещён. Требуется <code>ADMIN_WEB_SETTINGS</code>.</p>
            </div>
        </div>
    {else}
                <form action="?p=admin&amp;c=settings&amp;section=features" method="post" class="space-y-4">
                    {csrf_field}
                    <input type="hidden" name="settingsGroup" value="features">

                    <div class="card">
                        <div class="card__header"><div><h3>Баны</h3><p>Публичный экспорт, KickIt, групповые / дружеские баны.</p></div></div>
                        <div class="card__body space-y-4">
                            <div data-testid="setting-row" data-key="config.exportpublic">
                                <label class="flex items-center gap-2">
                                    <input type="checkbox" id="export_public" name="export_public"{if $export_public} checked{/if} aria-describedby="export_public_help">
                                    <span class="text-sm font-medium">Публичный экспорт банов</span>
                                </label>
                                <p class="settings-fieldset__help" id="export_public_help" data-testid="setting-help-config.exportpublic">
                                    Позволяет неавторизованным посетителям загружать полный список банов.
                                </p>
                            </div>

                            <div data-testid="setting-row" data-key="config.enablekickit">
                                <label class="flex items-center gap-2">
                                    <input type="checkbox" id="enable_kickit" name="enable_kickit"{if $enable_kickit} checked{/if} aria-describedby="enable_kickit_help">
                                    <span class="text-sm font-medium">KickIt</span>
                                </label>
                                <p class="settings-fieldset__help" id="enable_kickit_help" data-testid="setting-help-config.enablekickit">
                                    Автоматический кик игрока при наложении бана.
                                </p>
                            </div>

                            <div data-testid="setting-row" data-key="config.enablegroupbanning">
                                <label class="flex items-center gap-2">
                                    <input type="checkbox" id="enable_groupbanning" name="enable_groupbanning"{if $enable_groupbanning} checked{/if}{if NOT $steamapi} disabled{/if} aria-describedby="enable_groupbanning_help">
                                    <span class="text-sm font-medium">Бан по Steam-группе</span>
                                </label>
                                <p class="settings-fieldset__help" id="enable_groupbanning_help" data-testid="setting-help-config.enablegroupbanning">
                                    Бан всех участников группы сообщества Steam.
                                    {if NOT $steamapi}<br><span style="color:var(--warning)">Требуется ключ Steam Web API в <code>config.php</code>.</span>{/if}
                                </p>
                            </div>

                            <div data-testid="setting-row" data-key="config.enablefriendsbanning">
                                <label class="flex items-center gap-2">
                                    <input type="checkbox" id="enable_friendsbanning" name="enable_friendsbanning"{if $enable_friendsbanning} checked{/if}{if NOT $steamapi} disabled{/if} aria-describedby="enable_friendsbanning_help">
                                    <span class="text-sm font-medium">Бан по друзьям Steam</span>
                                </label>
                                <p class="settings-fieldset__help" id="enable_friendsbanning_help" data-testid="setting-help-config.enablefriendsbanning">
                                    Бан всех друзей игрока в Steam.
                                    {if NOT $steamapi}<br><span style="color:var(--warning)">Требуется ключ Steam Web API в <code>config.php</code>.</span>{/if}
                                </p>
                            </div>

                            <div data-testid="setting-row" data-key="config.enableadminrehashing">
                                <label class="flex items-center gap-2">
                                    <input type="checkbox" id="enable_adminrehashing" name="enable_adminrehashing"{if $enable_adminrehashing} checked{/if} aria-describedby="enable_adminrehashing_help">
                                    <span class="text-sm font-medium">Автообновление администраторов</span>
                                </label>
                                <p class="settings-fieldset__help" id="enable_adminrehashing_help" data-testid="setting-help-config.enableadminrehashing">
                                    Немедленно применять изменения администраторов/групп на серверах.
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card__header"><div><h3>Вход</h3><p>Способы входа, доступные администраторам.</p></div></div>
                        <div class="card__body space-y-4">
                            <div data-testid="setting-row" data-key="config.enablesteamlogin">
                                <label class="flex items-center gap-2">
                                    <input type="checkbox" id="enable_steamlogin" name="enable_steamlogin"{if $enable_steamlogin} checked{/if} aria-describedby="enable_steamlogin_help">
                                    <span class="text-sm font-medium">Вход через Steam OpenID</span>
                                </label>
                                <p class="settings-fieldset__help" id="enable_steamlogin_help" data-testid="setting-help-config.enablesteamlogin">
                                    Показывать «Войти через Steam» на странице входа.
                                </p>
                            </div>

                            <div data-testid="setting-row" data-key="config.enablenormallogin">
                                <label class="flex items-center gap-2">
                                    <input type="checkbox" id="enable_normallogin" name="enable_normallogin"{if $enable_normallogin} checked{/if} aria-describedby="enable_normallogin_help">
                                    <span class="text-sm font-medium">Вход по имени пользователя и паролю</span>
                                </label>
                                <p class="settings-fieldset__help" id="enable_normallogin_help" data-testid="setting-help-config.enablenormallogin">
                                    Отключите, чтобы требовать вход через Steam для всех администраторов.
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card__header"><div><h3>Комментарии</h3><p>Видимость комментариев администраторов к банам / заявкам.</p></div></div>
                        <div class="card__body space-y-4">
                            <div data-testid="setting-row" data-key="config.enablepubliccomments">
                                <label class="flex items-center gap-2">
                                    <input type="checkbox" id="enable_publiccomments" name="enable_publiccomments"{if $enable_publiccomments} checked{/if} aria-describedby="enable_publiccomments_help">
                                    <span class="text-sm font-medium">Публичные комментарии администраторов</span>
                                </label>
                                <p class="settings-fieldset__help" id="enable_publiccomments_help" data-testid="setting-help-config.enablepubliccomments">
                                    Показывать комментарии администраторов к бану анонимным посетителям.
                                </p>
                            </div>
                        </div>
                    </div>

                    {*
                        #1126 — anonymous opt-out telemetry. Default-on; the
                        help paragraph below is the only in-panel disclosure
                        surface (no first-login modal — see issue body), so
                        the copy summarises every payload category and links
                        to the docs site's upgrade page for the operator-
                        facing field-by-field walkthrough. The wire-format
                        source of truth is the vendored schema lock file
                        (`web/includes/Telemetry/schema-1.lock.json`). Tone
                        is matter-of-fact; no marketing, no apology copy.

                        On opt-out (toggle 1 → 0), admin.settings.php's POST
                        handler clears `telemetry.instance_id` so a re-enable
                        mints a fresh ID and the Worker can't link the two
                        states. Enable / disable transitions are also audit-
                        logged once via `Log::add(LogType::Message, ...)`.
                    *}
                    <div class="card">
                        <div class="card__header"><div><h3>Конфиденциальность</h3><p>Анонимная телеметрия, помогающая нам планировать выпуски.</p></div></div>
                        <div class="card__body space-y-4">
                            <div data-testid="setting-row" data-key="telemetry.enabled">
                                <label class="flex items-center gap-2">
                                    <input type="checkbox" id="telemetry_enabled" name="telemetry_enabled"{if $telemetry_enabled} checked{/if} aria-describedby="telemetry_enabled_help">
                                    <span class="text-sm font-medium">Анонимная телеметрия</span>
                                </label>
                                <p class="settings-fieldset__help" id="telemetry_enabled_help" data-testid="setting-help-telemetry.enabled">
                                    Отправляет один анонимный ping в день с версией панели, семейством PHP / БД / ОС, подсчётами (администраторы, серверы, баны, коммуникации, заявки / протесты за 30 дней) и перечнем включённых функций. <strong>Не</strong> отправляются имена хостов, IP-адреса, имена администраторов, SteamID или причины банов. Случайный идентификатор установки включается, чтобы пинги можно было дедуплицировать.
                                    <a href="https://sbpp.github.io/updating/1-8-to-2-0/#anonymous-telemetry" target="_blank" rel="noopener noreferrer">Смотреть полный состав данных</a>.
                                    Отключение очищает случайный идентификатор; повторное включение создаёт новый.
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="flex items-center justify-end gap-2">
                        <button type="submit" class="btn btn--primary" data-testid="settings-save">
                            <i data-lucide="save"></i> Сохранить изменения
                        </button>
                    </div>
                </form>
    {/if}
</div>
