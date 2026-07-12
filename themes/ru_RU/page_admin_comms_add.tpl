{*
    SourceBans++ 2026 — page_admin_comms_add.tpl

    "Add a block" form on the admin comms page. Bound to
    Sbpp\View\AdminCommsAddView; SmartyTemplateRule cross-checks
    referenced vars against that DTO.

    Variable contract matches the legacy default theme:
      - $permission_addban — gate; ADMIN_OWNER|ADMIN_ADD_BAN
        (precomputed in admin.comms.php via Perms::for($userbank)).
      - $prefill_steam     — server-side smart-default for the
        SteamID input, populated by `?p=admin&c=comms&steam=…`
        (used by the public servers list's right-click context
        menu's "Block comms" item; admin.comms.php allowlists
        STEAM_X:Y:Z / [U:1:N] / SteamID64 / IPv4 before this
        value reaches the template). Empty string when no smart
        default is on the URL. #1395.
      - $prefill_type      — 0 (no pre-selection) / 1 (Mute) /
        2 (Gag) / 3 (Silence). The form's first option (Mute)
        is the implicit native default when no `selected`
        attribute fires. #1395.

    Submission goes through sb.api.call(Actions.CommsAdd) — the same
    JSON action the legacy theme uses, see web/api/handlers/comms.php.

    #1420: pre-fix this template wired the submit button via
    `onclick="ProcessBan();"` against a global `ProcessBan` defined
    in admin.comms.php's tail script. That global walked the form
    via legacy MooTools `$('id')` selectors (still working via
    `sb.js`'s `global.$` shim) and emitted feedback through
    `sb.message.error`/`sb.message.show` — which paint into
    `#dialog-placement` / `#dialog-title` / `#dialog-content-text`,
    DOM ids the v2.0 chrome doesn't render anywhere. Net result:
    every error (including the "invalid SteamID" branch the
    reporter hit) silently no-op'd on the chrome side, leaving the
    operator with no notification. The replacement inline IIFE
    below mirrors `page_admin_bans_add.tpl`'s shape: native HTML
    validation first (browser-native popover for empty / wrong-
    shape inputs), then `sb.api.call(Actions.CommsAdd)`, then
    `window.SBPP.showToast` on error envelopes. The PHP-side
    handler (api_comms_add) is the load-bearing security gate
    (`preg_match` on the anchored regex BEFORE `SteamID::toSteam2`,
    see web/api/handlers/comms.php for the canonical shape); this
    client-side shape is UX.

    Testability hooks per the issue's "Testability hooks" rule:
      - data-testid="addcomm-<field>" on every input/select.
      - data-testid="addcomm-submit" / "addcomm-back" on buttons.
*}
{if not $permission_addban}
    <div class="card" data-testid="addcomm-denied">
        <div class="card__body">
            <h1 style="font-size:1.25rem;font-weight:600;margin:0">Доступ запрещён</h1>
            <p class="text-sm text-muted m-0 mt-2">У вас нет прав на добавление блокировок.</p>
        </div>
    </div>
{else}
    {* #1266 — outer `.p-6` keeps the 1.5rem page inset because
       `admin.comms.php` is a *single-section* page (simplified at
       #1239 — no `AdminTabs` call, no `.admin-sidebar-shell`
       wrapper), so this template is rendered directly under the
       chrome's `<main class="page">` which has no padding of its
       own. The `max-width: 48rem` form clamp keeps the form column
       from growing past a readable line length on wide viewports. *}
    <div class="p-6" style="max-width:48rem">
        <div class="mb-6">
            <h1 style="font-size:1.5rem;font-weight:600;margin:0">Добавить блокировку</h1>
            <p class="text-sm text-muted m-0 mt-2">Замьютить, загагать или заглушить игрока на всех подключённых серверах.</p>
        </div>

        <form id="addcomm-form" class="card p-6 space-y-4" onsubmit="return false;" data-testid="addcomm-form">
            <div>
                <label class="label" for="nickname">Никнейм</label>
                {* #1440: smart-default pre-fill via `?name=…` (paired
                   with `?steam=…`) — used by the public servers list's
                   right-click context menu's "Block comms" item.
                   admin.comms.php strips control chars + caps at 128
                   codepoints; Smarty auto-escape is the HTML-attribute
                   safety layer. *}
                <input type="text"
                       class="input"
                       id="nickname"
                       name="nickname"
                       autocomplete="off"
                       data-testid="addcomm-nickname"
                       value="{$prefill_name}"
                       placeholder="Отображаемое имя, как оно было в игре"
                       required>
                <input type="hidden" id="fromsub" value="">
                <div class="text-xs mt-2" id="nick.msg" style="color:var(--danger);display:none"></div>
            </div>

            <div>
                <label class="label" for="steam">Steam ID / ID сообщества</label>
                {* Smart-default SteamID via `?steam=…` (admin.comms.php
                   allowlists STEAM_X:Y:Z / [U:1:N] / SteamID64 / IPv4
                   before this value reaches the template, so the
                   auto-escape is the belt-and-braces). Used by the
                   public servers list's right-click context menu's
                   "Block comms" item — see web/scripts/server-context-menu.js
                   and admin.bans.php's mirror block. #1395 *}
                {* #1420: native `pattern` attribute mirrors the
                   client-side regex `page_admin_bans_add.tpl`'s IIFE
                   carries (`STEAM_[01]:[01]:\d+|\[U:1:\d+\]|\d{17}`)
                   so the browser surfaces a popover for empty / bad-
                   shape values before our submit handler runs.
                   `title` is what the browser reads aloud / shows in
                   the popover when the pattern fails — keep it short
                   and actionable. The `aria-describedby` ties the
                   help line below to the input for screen readers.
                   An `?steam=…` smart-default carrying an IPv4 will
                   land here too (admin.comms.php's allowlist is
                   intentionally symmetric with admin.bans.php's so
                   future menu changes touch one allowlist); the
                   pattern will reject it and the operator has to fix
                   the value before submission, which is the right
                   behaviour (comms can't block by IP). *}
                <input type="text"
                       class="input font-mono"
                       id="steam"
                       name="steam"
                       autocomplete="off"
                       data-testid="addcomm-steam"
                       value="{$prefill_steam}"
                       placeholder="STEAM_0:1:23498765"
                       pattern="STEAM_[01]:[01]:\d+|\[U:1:\d+\]|\d{17}"
                       title="Введите Steam ID (STEAM_0:1:23498765), Steam3 ID ([U:1:23498765]) или 17-значный SteamID64."
                       aria-describedby="addcomm-steam-help"
                       required>
                <p class="text-xs text-muted mt-1" id="addcomm-steam-help">
                    Допустимые форматы:
                    <code>STEAM_0:1:N</code>, <code>[U:1:N]</code> или 17-значный SteamID64.
                </p>
                <div class="text-xs mt-2" id="steam.msg" style="color:var(--danger);display:none"></div>
            </div>

            <div class="grid gap-4" style="grid-template-columns:1fr 1fr">
                <div>
                    <label class="label" for="type">Тип блокировки</label>
                    {* Smart-default Block type via `?type=…` (paired with
                       `?steam=…` — see admin.comms.php for the allowlist).
                       Valid values are 1 (Mute), 2 (Gag), 3 (Silence);
                       anything else (including the menu's `?type=0`
                       bridging value) lands `$prefill_type == 0` and the
                       browser defaults to the first option (Mute). #1395 *}
                    <select class="select" id="type" name="type" data-testid="addcomm-type">
                        <option value="1"{if $prefill_type == 1} selected{/if}>Мут (голос)</option>
                        <option value="2"{if $prefill_type == 2} selected{/if}>Гаг (чат)</option>
                        <option value="3"{if $prefill_type == 3} selected{/if}>Тишина (чат и голос)</option>
                    </select>
                </div>
                <div>
                    <label class="label" for="banlength">Срок блокировки</label>
                    <select class="select" id="banlength" name="banlength" data-testid="addcomm-length">
                        <option value="0">Постоянный</option>
                        <optgroup label="Минуты">
                            <option value="1">1 минута</option>
                            <option value="5">5 минут</option>
                            <option value="10">10 минут</option>
                            <option value="15">15 минут</option>
                            <option value="30">30 минут</option>
                            <option value="45">45 минут</option>
                        </optgroup>
                        <optgroup label="Часы">
                            <option value="60">1 час</option>
                            <option value="120">2 часа</option>
                            <option value="180">3 часа</option>
                            <option value="240">4 часа</option>
                            <option value="480">8 часов</option>
                            <option value="720">12 часов</option>
                        </optgroup>
                        <optgroup label="Дни">
                            <option value="1440">1 день</option>
                            <option value="2880">2 дня</option>
                            <option value="4320">3 дня</option>
                            <option value="5760">4 дня</option>
                            <option value="7200">5 дней</option>
                            <option value="8640">6 дней</option>
                        </optgroup>
                        <optgroup label="Недели">
                            <option value="10080">1 неделя</option>
                            <option value="20160">2 недели</option>
                            <option value="30240">3 недели</option>
                        </optgroup>
                        <optgroup label="Месяцы">
                            <option value="43200">1 месяц</option>
                            <option value="86400">2 месяца</option>
                            <option value="129600">3 месяца</option>
                            <option value="259200">6 месяцев</option>
                            <option value="518400">12 месяцев</option>
                        </optgroup>
                    </select>
                </div>
            </div>

            <div>
                <label class="label" for="listReason">Причина блокировки</label>
                {* #1420: `required` here is the native gate for "select a
                   reason" — paired with `value=""` on the placeholder
                   option, the browser refuses to submit the form when
                   the operator leaves the dropdown on "-- Select
                   reason --". `onchange="changeReason(...)"` toggles
                   the freeform textarea below for the "other" branch
                   (helper still defined inline in admin.comms.php's
                   tail script, rewritten to use vanilla DOM for
                   #1420). *}
                <select class="select"
                        id="listReason"
                        name="listReason"
                        data-testid="addcomm-reason"
                        onchange="changeReason(this[this.selectedIndex].value);"
                        required>
                    <option value="" selected>-- Выберите причину --</option>
                    <optgroup label="Нарушение">
                        <option value="Obscene language">Нецензурная лексика</option>
                        <option value="Insult players">Оскорбление игроков</option>
                        <option value="Admin disrespect">Неуважение к администратору</option>
                        <option value="Inappropriate Language">Неподходящий язык</option>
                        <option value="Trading">Торговля</option>
                        <option value="Spam in chat/voice">Спам</option>
                        <option value="Advertisement">Реклама</option>
                    </optgroup>
                    <option value="other">Другая причина</option>
                </select>
                <div id="dreason" class="mt-2" style="display:none">
                    <textarea class="textarea"
                              id="txtReason"
                              name="txtReason"
                              rows="4"
                              placeholder="Подробно объясните, почему наложена эта блокировка."
                              data-testid="addcomm-reason-custom"></textarea>
                </div>
                <div class="text-xs mt-2" id="reason.msg" style="color:var(--danger);display:none"></div>
            </div>

            <div class="flex justify-end gap-2" style="border-top:1px solid var(--border);padding-top:0.75rem">
                <button type="button"
                        class="btn btn--ghost"
                        data-testid="addcomm-back"
                        onclick="history.go(-1);">Назад</button>
                {* #1420: `data-action="addcomm-submit"` replaces the
                   legacy `onclick="ProcessBan();"` wiring (broken
                   under the v2.0 chrome — see the file docblock above
                   for the full rationale). The inline IIFE below
                   handles the click, native-validates the form, then
                   dispatches `Actions.CommsAdd` and surfaces errors
                   through `window.SBPP.showToast`. *}
                <button type="button"
                        class="btn btn--primary"
                        id="addcomm-submit"
                        data-testid="addcomm-submit"
                        data-action="addcomm-submit">
                    <i data-lucide="mic-off"></i> Добавить блокировку
                </button>
            </div>
        </form>
    </div>
{/if}
{* Inline action wiring — mirrors page_admin_bans_add.tpl's IIFE shape.
   Pre-#1420 the comms-add submit went through `onclick="ProcessBan();"`
   into a global defined in admin.comms.php, which emitted feedback
   through the legacy `sb.message.show` / `sb.message.error` helpers.
   Those helpers paint into `#dialog-placement` (a v1.x chrome element
   the v2.0 theme doesn't ship), so every error silently no-op'd —
   that's the "no notification on invalid SteamID" symptom the
   reporter hit. The new IIFE:
     1. Intercepts the click on `[data-action="addcomm-submit"]`.
     2. Runs the form's native `checkValidity()` — the browser
        surfaces a popover for empty / pattern-mismatch fields
        before our handler runs.
     3. On valid input, dispatches `Actions.CommsAdd` via sb.api.call.
     4. Surfaces success / error envelopes through `window.SBPP.showToast`
        (theme.js, the v2.0 chrome's toast surface), with `sb.message`
        as the graceful-degradation fallback for third-party themes
        that strip theme.js.
*}
{literal}
<script>
(function () {
    'use strict';
    function api() { return (window.sb && window.sb.api) || null; }
    function actions() { return window.Actions || null; }
    function $id(id) { return document.getElementById(id); }
    function setMsg(id, html) {
        var el = $id(id);
        if (!el) return;
        el.innerHTML = html || '';
        el.style.display = html ? 'block' : 'none';
    }
    function toast(kind, title, body) {
        var SBPP = window.SBPP;
        if (SBPP && typeof SBPP.showToast === 'function') {
            SBPP.showToast({
                kind: kind === 'red' ? 'error' : kind === 'green' ? 'success' : (kind || 'info'),
                title: title,
                body: body || ''
            });
            return;
        }
        if (window.sb && window.sb.message && window.sb.message[kind]) {
            window.sb.message[kind](title, body || '');
        }
    }
    /**
     * Flip the busy / loading state on a triggered action button. Calls
     * window.SBPP.setBusy when present (theme.js owns the spinner CSS
     * contract) and falls back to plain `disabled` so third-party themes
     * that strip theme.js still gate against double-clicks.
     */
    function setBusy(btn, busy) {
        if (!btn) return;
        var S = window.SBPP;
        if (S && typeof S.setBusy === 'function') S.setBusy(btn, busy);
        else btn.disabled = busy === undefined ? true : !!busy;
    }

    document.addEventListener('click', function (e) {
        var t = e.target;
        if (!t || !t.closest) return;
        var btn = t.closest('[data-action="addcomm-submit"]');
        if (!btn) return;
        e.preventDefault();

        var form = $id('addcomm-form');
        if (!form) return;

        // Native validation gate — the browser surfaces a popover for
        // empty / pattern-mismatch inputs (steam, nickname, listReason
        // all carry `required`; steam also carries `pattern`). This is
        // the load-bearing client-side check per AGENTS.md's "Native
        // HTML validation" rule; the server-side api_comms_add is the
        // load-bearing security gate, but a hostile / curl-driven
        // caller is not the common case. For real users the native
        // popover is the right first response — it points at the
        // offending input and surfaces a localised error string the
        // browser picked for the user's locale.
        if (typeof form.checkValidity === 'function' && !form.checkValidity()) {
            if (typeof form.reportValidity === 'function') form.reportValidity();
            return;
        }

        // Cross-field check: "other" reason needs a freeform body.
        // Native HTML can't express this (the textarea is conditional
        // on the parent select's value), so we mirror what the legacy
        // ProcessBan() did.
        var listReason = $id('listReason');
        var reason = listReason ? listReason.value : '';
        if (reason === 'other') {
            var txtReason = $id('txtReason');
            reason = txtReason ? txtReason.value.trim() : '';
            if (!reason) {
                setMsg('reason.msg', 'Опишите причину блокировки в текстовом поле.');
                if (txtReason && typeof txtReason.focus === 'function') txtReason.focus();
                return;
            }
        }
        setMsg('reason.msg', '');

        var a = api(), A = actions();
        if (!a || !A) return;
        setBusy(btn, true);
        a.call(A.CommsAdd, {
            nickname: $id('nickname').value,
            type: Number($id('type').value),
            steam: $id('steam').value,
            length: Number($id('banlength').value),
            reason: reason
        }).then(function (r) {
            if (r && r.ok && r.data && r.data.block) {
                // Success — keep the button busy (matches the legacy
                // shape) so the operator can't queue a second submit
                // while the iframe fires rcon at every server.
                var b = r.data.block;
                toast('success', 'Блокировка добавлена',
                    'Блокировка была успешно добавлена.');
                // The iframe is load-bearing — pages/admin.blockit.php
                // loops the enabled servers and fires `sc_fw_block`
                // via rcon for each one. Without it the DB row exists
                // but no live server learns about the gag/mute,
                // matching the bans/kickit shape one branch above.
                var iframe = document.createElement('iframe');
                iframe.id = 'srvkicker';
                iframe.style.display = 'none';
                iframe.src = 'pages/admin.blockit.php?check='
                    + encodeURIComponent(b.steam)
                    + '&type=' + encodeURIComponent(b.type)
                    + '&length=' + encodeURIComponent(b.length);
                document.body.appendChild(iframe);
                if (r.data.reload) {
                    setTimeout(function () {
                        window.location.href = window.location.href.replace(/#\^.*$/, '');
                    }, 2000);
                }
                return;
            }
            setBusy(btn, false);
            if (!r) return;
            if (r.redirect) return;
            if (r.ok === false) {
                var err = (r.error && r.error.message) || 'Неизвестная ошибка';
                toast('error', 'Блокировка НЕ добавлена', err);
                // Mirror the legacy inline message so screen readers
                // and tests anchored on the per-field `*.msg` div see
                // the error too.
                if (r.error && r.error.field === 'steam') setMsg('steam.msg', err);
                else if (r.error && r.error.field === 'nickname') setMsg('nick.msg', err);
                else if (r.error && r.error.field === 'reason') setMsg('reason.msg', err);
                return;
            }
            var data = r.data || {};
            if (data.reload) {
                setTimeout(function () {
                    window.location.href = window.location.href.replace(/#\^.*$/, '');
                }, 2000);
            }
        });
    });
})();
</script>
{/literal}
