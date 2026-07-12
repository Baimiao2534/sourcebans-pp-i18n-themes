{*
    SourceBans++ 2026 — page_youraccount.tpl

    Self-service account page. View: Sbpp\View\YourAccountView.

    Delimiters: standard `{ }`. The legacy default theme's
    `page_youraccount.tpl` used `-{ }-` (a SourceBans-1.x oddity). The
    redesign deliberately drops that override so the View doesn't have
    to carry a `View::DELIMITERS` exception; see the View's docblock
    for the rollout note. D1 deletes the legacy delimiter use entirely.

    Each form below is state-changing and submits via sb.api.call,
    which sends the CSRF token in the `X-CSRF-Token` header (see
    web/scripts/api.js). `{csrf_field}` is still included in every
    form so the markup follows the project-wide convention — it
    becomes a bonus belt-and-braces hidden input the dispatcher would
    accept as `params.csrf_token` even if a future submit path were
    to bypass the JS helper.

    The forms are wired by inline vanilla JS at the bottom of the page
    (no MooTools, no jQuery — only `sb.api.call(Actions.*)` and
    standard DOM APIs). Submit handlers preventDefault and call the
    Account* JSON actions registered in
    web/api/handlers/_register.php; on success the dispatcher already
    returns either an `Api::redirect` envelope (password change) or a
    `data.message` describing a success toast (server password / email
    change). Toasts go through window.SBPP.showToast (theme.js), with a
    sb.message.* fallback so the same JS still works if this page is
    ever rendered under the legacy default chrome.

    Test hooks: every input + submit button carries a stable
    `data-testid="account-<field>"` attribute matching the names
    listed in plan #1123 B20.
*}
<div class="p-6 space-y-6" style="max-width:64rem;margin:0 auto;width:100%">

    <header data-testid="account-header">
        <h1 style="font-size:var(--fs-2xl);font-weight:600;margin:0">Ваш аккаунт</h1>
        <p class="text-sm text-muted m-0 mt-2">Права, пароль, серверный пароль и email.</p>
    </header>

    {*
        Permissions card (#1207 ADM-9).

        Pre-fix shape: a single 30-item `<ul>` next to a "None" column
        for the SourceMod side — every permission shared the same
        visual weight, so "Add Bans" was indistinguishable from
        "Edit Groups" at a glance. Redesign:

          - **Web side**: rendered as `<section>` per category
            (`$web_permissions_grouped` is built by
            {@see Sbpp\View\PermissionCatalog::groupedDisplayFromMask}).
            Each `<section>` carries its own
            `data-testid="account-perm-cat-<key>"` so e2e specs can
            assert "the Bans category has at least one row" without
            depending on visible copy. Empty categories are filtered
            out by the helper, so the surface only paints buckets
            that have content.
          - **Server side**: stays a flat list — the SourceMod char
            flags top out at ~14 single-letter values with no
            natural category split, so a single column under the
            "SourceMod" heading still scans cleanly. Wrapped in the
            same `.permissions-group` chrome as the web side for
            visual consistency.

        Layout: `.permissions-grid` is a 1-column stack at <=1023px
        and a 2-column (web side) / 1-column (server side) grid at
        >=1024px; the web grid expands to 3 columns at >=1280px so a
        full-permission owner doesn't waste any horizontal real
        estate. See the matching block in `theme.css`. Tests anchor
        on `[data-testid="account-permissions"]` + the per-category
        ids, never on visible labels.
    *}
    <section class="card" data-testid="account-permissions">
        <div class="card__header">
            <div>
                <h3>Ваши права</h3>
                <p>Флаги, выданные вашему аккаунту администратора на данный момент.</p>
            </div>
        </div>
        <div class="card__body permissions-card__body">
            <div class="permissions-side permissions-side--web"
                 data-testid="account-permissions-web">
                <h4 class="permissions-side__heading">Веб</h4>
                {if $web_permissions_grouped}
                    <div class="permissions-grid permissions-grid--web">
                        {foreach from=$web_permissions_grouped item=group}
                            <section class="permissions-group"
                                     data-testid="account-perm-cat-{$group.key}"
                                     data-perm-cat="{$group.key}">
                                <h5 class="permissions-group__title">{$group.label}</h5>
                                <ul class="permissions-group__list">
                                    {foreach from=$group.perms item=permission}
                                        <li>{$permission}</li>
                                    {/foreach}
                                </ul>
                            </section>
                        {/foreach}
                    </div>
                {else}
                    <p class="permissions-empty"
                       data-testid="account-permissions-web-empty">
                        <em>Веб-права не выданы.</em>
                    </p>
                {/if}
            </div>
            <div class="permissions-side permissions-side--server"
                 data-testid="account-permissions-server">
                <h4 class="permissions-side__heading">SourceMod</h4>
                {if $server_permissions}
                    <div class="permissions-grid permissions-grid--server">
                        <section class="permissions-group"
                                 data-testid="account-perm-cat-server"
                                 data-perm-cat="server">
                            <h5 class="permissions-group__title">Флаги игрового сервера</h5>
                            <ul class="permissions-group__list">
                                {foreach from=$server_permissions item=permission}
                                    <li>{$permission}</li>
                                {/foreach}
                            </ul>
                        </section>
                    </div>
                {else}
                    <p class="permissions-empty"
                       data-testid="account-permissions-server-empty">
                        <em>Флаги SourceMod не выданы.</em>
                    </p>
                {/if}
            </div>
        </div>
    </section>

    {* -- Change password card ----------------------------------------- *}
    <section class="card" data-testid="account-change-password">
        <div class="card__header">
            <div>
                <h3>Сменить пароль</h3>
                <p>Минимум {$min_pass_len} символ{if $min_pass_len != 1}ов{/if}. После успешной смены вы будете разлогинены.</p>
            </div>
        </div>
        <div class="card__body">
            <form id="account-password-form"
                  class="space-y-4"
                  autocomplete="off"
                  novalidate
                  data-aid="{$user_aid}"
                  data-min-pass-len="{$min_pass_len}">
                {csrf_field}
                <div>
                    <label class="label" for="account-current-password">Текущий пароль</label>
                    <input class="input" type="password"
                           id="account-current-password"
                           name="current_password"
                           data-testid="account-current-password"
                           autocomplete="current-password" required>
                    <div id="account-current-password-msg" class="text-xs" style="color:var(--danger);display:none;margin-top:0.375rem"></div>
                </div>
                <div>
                    <label class="label" for="account-new-password">Новый пароль</label>
                    <input class="input" type="password"
                           id="account-new-password"
                           name="new_password"
                           data-testid="account-new-password"
                           minlength="{$min_pass_len}"
                           autocomplete="new-password" required>
                    <div id="account-new-password-msg" class="text-xs" style="color:var(--danger);display:none;margin-top:0.375rem"></div>
                </div>
                <div>
                    <label class="label" for="account-confirm-password">Подтвердите новый пароль</label>
                    <input class="input" type="password"
                           id="account-confirm-password"
                           name="confirm_password"
                           data-testid="account-confirm-password"
                           minlength="{$min_pass_len}"
                           autocomplete="new-password" required>
                    <div id="account-confirm-password-msg" class="text-xs" style="color:var(--danger);display:none;margin-top:0.375rem"></div>
                </div>
                <div class="flex justify-end gap-2">
                    <button class="btn btn--secondary" type="reset" data-testid="account-cancel">Отмена</button>
                    <button class="btn btn--primary" type="submit" data-testid="account-save">Сохранить</button>
                </div>
            </form>
        </div>
    </section>

    {* -- Server password card ----------------------------------------- *}
    <section class="card" data-testid="account-server-password">
        <div class="card__header">
            <div>
                <h3>Серверный пароль</h3>
                <p>Нужен на игровом сервере для использования прав администратора.
                    <a href="https://wiki.alliedmods.net/Adding_Admins_%28SourceMod%29#Passwords"
                       target="_blank" rel="noopener"
                       style="color:var(--accent);text-decoration:underline">Документация SourceMod</a>.</p>
            </div>
        </div>
        <div class="card__body">
            <form id="account-srv-password-form"
                  class="space-y-4"
                  autocomplete="off"
                  novalidate
                  data-aid="{$user_aid}"
                  data-min-pass-len="{$min_pass_len}"
                  data-srv-pw-set="{if $srvpwset}1{else}0{/if}">
                {csrf_field}
                {if $srvpwset}
                    <div>
                        <label class="label" for="account-current-srv-password">Текущий серверный пароль</label>
                        <input class="input" type="password"
                               id="account-current-srv-password"
                               name="current_srv_password"
                               data-testid="account-current-srv-password" required>
                        <div id="account-current-srv-password-msg" class="text-xs" style="color:var(--danger);display:none;margin-top:0.375rem"></div>
                    </div>
                {/if}
                <div>
                    <label class="label" for="account-new-srv-password">Новый серверный пароль</label>
                    <input class="input" type="password"
                           id="account-new-srv-password"
                           name="new_srv_password"
                           data-testid="account-new-srv-password"
                           minlength="{$min_pass_len}">
                    <div id="account-new-srv-password-msg" class="text-xs" style="color:var(--danger);display:none;margin-top:0.375rem"></div>
                </div>
                <div>
                    <label class="label" for="account-confirm-srv-password">Подтвердите новый серверный пароль</label>
                    <input class="input" type="password"
                           id="account-confirm-srv-password"
                           name="confirm_srv_password"
                           data-testid="account-confirm-srv-password"
                           minlength="{$min_pass_len}">
                    <div id="account-confirm-srv-password-msg" class="text-xs" style="color:var(--danger);display:none;margin-top:0.375rem"></div>
                </div>
                {if $srvpwset}
                    <label class="flex items-center gap-2 text-sm">
                        <input type="checkbox"
                               id="account-remove-srv-password"
                               name="remove_srv_password"
                               data-testid="account-remove-srv-password">
                        <span>Удалить существующий серверный пароль (очищает поле).</span>
                    </label>
                {/if}
                <div class="flex justify-end gap-2">
                    <button class="btn btn--secondary" type="reset" data-testid="account-srv-cancel">Отмена</button>
                    <button class="btn btn--primary" type="submit" data-testid="account-srv-save">Сохранить</button>
                </div>
            </form>
        </div>
    </section>

    {* -- Change email card -------------------------------------------- *}
    <section class="card" data-testid="account-change-email">
        <div class="card__header">
            <div>
                <h3>Сменить email</h3>
                <p>Текущий адрес:
                    {if $email}
                        <span class="font-mono text-sm" data-testid="account-current-email">{$email}</span>
                    {else}
                        <span class="text-sm text-muted" data-testid="account-current-email-empty">(не задан)</span>
                    {/if}
                </p>
            </div>
        </div>
        <div class="card__body">
            <form id="account-email-form"
                  class="space-y-4"
                  autocomplete="off"
                  novalidate
                  data-aid="{$user_aid}">
                {csrf_field}
                <div>
                    <label class="label" for="account-email-password">Пароль</label>
                    <input class="input" type="password"
                           id="account-email-password"
                           name="email_password"
                           data-testid="account-email-password"
                           autocomplete="current-password" required>
                    <div id="account-email-password-msg" class="text-xs" style="color:var(--danger);display:none;margin-top:0.375rem"></div>
                </div>
                <div>
                    <label class="label" for="account-email">Новый email</label>
                    <input class="input" type="email"
                           id="account-email"
                           name="email"
                           data-testid="account-email"
                           autocomplete="email" required>
                    <div id="account-email-msg" class="text-xs" style="color:var(--danger);display:none;margin-top:0.375rem"></div>
                </div>
                <div>
                    <label class="label" for="account-email-confirm">Подтвердите новый email</label>
                    <input class="input" type="email"
                           id="account-email-confirm"
                           name="email_confirm"
                           data-testid="account-email-confirm"
                           autocomplete="email" required>
                    <div id="account-email-confirm-msg" class="text-xs" style="color:var(--danger);display:none;margin-top:0.375rem"></div>
                </div>
                <div class="flex justify-end gap-2">
                    <button class="btn btn--secondary" type="reset" data-testid="account-email-cancel">Отмена</button>
                    <button class="btn btn--primary" type="submit" data-testid="account-email-save">Сохранить</button>
                </div>
            </form>
        </div>
    </section>

</div>

{*
    Inline vanilla-JS controllers for the three forms above. We
    deliberately keep the wiring inline (rather than adding a new file
    under web/themes/sbpp2026/js/) so this self-contained page stays
    self-contained — the script only runs when this template is on
    screen. `Actions.*` is the Action-name registry exported by the
    auto-generated web/scripts/api-contract.js (loaded by core/header.tpl).
*}
{literal}
<script>
(function () {
    'use strict';
    if (typeof sb === 'undefined' || !sb.api || typeof Actions === 'undefined') return;

    function setMsg(id, text) {
        var el = document.getElementById(id);
        if (!el) return;
        if (text) {
            el.textContent = text;
            el.style.display = 'block';
        } else {
            el.textContent = '';
            el.style.display = 'none';
        }
    }

    function val(id) {
        var el = document.getElementById(id);
        return el && 'value' in el ? String(el.value) : '';
    }

    function num(form, key, fallback) {
        var n = parseInt(form.dataset[key] || '', 10);
        return Number.isFinite(n) ? n : fallback;
    }

    function clearMsgs(prefix, fields) {
        fields.forEach(function (f) { setMsg(prefix + f + '-msg', ''); });
    }

    // Server-side ApiError `field` strings don't always match our DOM ids
    // (e.g. account.change_password throws field='current' but the input
    // is #account-current-password). Each form passes its own map; missing
    // keys fall through to the raw field name so newly added fields
    // surface *something* instead of silently no-opping.
    function showFieldError(prefix, err, fieldMap) {
        if (!err || !err.field) return false;
        var domId = (fieldMap && fieldMap[err.field]) || err.field;
        setMsg(prefix + domId + '-msg', err.message || 'Недопустимое значение.');
        return true;
    }

    // sbpp2026 doesn't ship #dialog-placement (that's a legacy default-theme
    // chrome element from core/title.tpl), so sb.message.show() silently
    // no-ops here. Prefer the theme's SBPP.showToast and fall back to
    // sb.message for callers that survive into the legacy theme.
    function showToast(kind, title, body) {
        if (window.SBPP && typeof window.SBPP.showToast === 'function') {
            window.SBPP.showToast({ kind: kind, title: title, body: body });
            return;
        }
        if (sb.message) {
            if (kind === 'success') sb.message.success(title, body);
            else sb.message.error(title, body);
        }
    }

    function flashSuccess(envelope) {
        if (!envelope || !envelope.ok || !envelope.data || !envelope.data.message) return;
        var m = envelope.data.message;
        showToast('success', m.title || 'Сохранено', m.body || '');
        if (m.redir) {
            // Short delay so the toast is visible before the same-page
            // refresh swaps in the new email / srv-password state.
            setTimeout(function () { window.location.href = m.redir; }, 1500);
        }
    }

    function flashFailure(envelope) {
        var msg = (envelope && envelope.error && envelope.error.message)
            ? envelope.error.message
            : 'Запрос не удался. Повторите попытку.';
        showToast('error', 'Ошибка', msg);
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

    // -- Change password ------------------------------------------------
    var pwForm = document.getElementById('account-password-form');
    if (pwForm) {
        pwForm.addEventListener('submit', function (ev) {
            ev.preventDefault();
            clearMsgs('account-', ['current-password', 'new-password', 'confirm-password']);

            var minLen = num(pwForm, 'minPassLen', 1);
            var current = val('account-current-password');
            var next    = val('account-new-password');
            var confirm = val('account-confirm-password');
            var aid     = parseInt(pwForm.dataset.aid || '0', 10);
            var bad = false;

            if (next.length < minLen) {
                setMsg('account-new-password-msg', 'Пароль должен содержать не менее ' + minLen + ' символов.');
                bad = true;
            }
            if (confirm !== next) {
                setMsg('account-confirm-password-msg', 'Пароли не совпадают.');
                bad = true;
            }
            if (current.length === 0) {
                setMsg('account-current-password-msg', 'Введите ваш текущий пароль.');
                bad = true;
            }
            if (bad) return;

            var pwBtn = pwForm.querySelector('[data-testid="account-save"]');
            setBusy(pwBtn, true);
            sb.api.call(Actions.AccountChangePassword, {
                aid: aid,
                old_password: current,
                new_password: next
            }).then(function (env) {
                // On success the dispatcher returns Api::redirect, which
                // api.js translates into `window.location.href = …`. The
                // .then still fires before navigation; bail before the
                // failure path mistakes the redirect envelope for an error.
                // Release the busy state on every non-navigating branch so
                // the operator can retry without a hard reload.
                if (env && env.ok) return;
                if (env && env.redirect) return;
                setBusy(pwBtn, false);
                if (showFieldError('account-', env && env.error, { current: 'current-password' })) return;
                flashFailure(env);
            });
        });
    }

    // -- Server password ------------------------------------------------
    var srvForm = document.getElementById('account-srv-password-form');
    if (srvForm) {
        srvForm.addEventListener('submit', function (ev) {
            ev.preventDefault();
            clearMsgs('account-', ['current-srv-password', 'new-srv-password', 'confirm-srv-password']);

            var minLen   = num(srvForm, 'minPassLen', 1);
            var hasExisting = srvForm.dataset.srvPwSet === '1';
            var aid      = parseInt(srvForm.dataset.aid || '0', 10);
            var current  = val('account-current-srv-password');
            var next     = val('account-new-srv-password');
            var confirm  = val('account-confirm-srv-password');
            var removeEl = document.getElementById('account-remove-srv-password');
            var remove   = !!(removeEl && 'checked' in removeEl && removeEl.checked);

            var srvBtn = srvForm.querySelector('[data-testid="account-srv-save"]');

            if (remove) {
                setBusy(srvBtn, true);
                sb.api.call(Actions.AccountChangeSrvPassword, {
                    aid: aid,
                    srv_password: 'NULL'
                }).then(function (env) {
                    setBusy(srvBtn, false);
                    if (env && env.ok) { flashSuccess(env); return; }
                    if (env && env.redirect) return;
                    flashFailure(env);
                });
                return;
            }

            var bad = false;
            if (next.length < minLen) {
                setMsg('account-new-srv-password-msg', 'Пароль должен содержать не менее ' + minLen + ' символов.');
                bad = true;
            }
            if (confirm !== next) {
                setMsg('account-confirm-srv-password-msg', 'Пароли не совпадают.');
                bad = true;
            }
            if (hasExisting && current.length === 0) {
                setMsg('account-current-srv-password-msg', 'Введите ваш текущий серверный пароль.');
                bad = true;
            }
            if (bad) return;

            function send() {
                sb.api.call(Actions.AccountChangeSrvPassword, {
                    aid: aid,
                    srv_password: next
                }).then(function (env) {
                    setBusy(srvBtn, false);
                    if (env && env.ok) { flashSuccess(env); return; }
                    if (env && env.redirect) return;
                    flashFailure(env);
                });
            }

            setBusy(srvBtn, true);
            if (hasExisting) {
                sb.api.call(Actions.AccountCheckSrvPassword, {
                    aid: aid,
                    password: current
                }).then(function (env) {
                    if (!env || !env.ok || !env.data) {
                        setBusy(srvBtn, false);
                        flashFailure(env);
                        return;
                    }
                    if (!env.data.matches) {
                        setBusy(srvBtn, false);
                        setMsg('account-current-srv-password-msg', 'Неверный серверный пароль.');
                        return;
                    }
                    send();
                });
            } else {
                send();
            }
        });
    }

    // -- Change email ---------------------------------------------------
    var emailForm = document.getElementById('account-email-form');
    if (emailForm) {
        emailForm.addEventListener('submit', function (ev) {
            ev.preventDefault();
            clearMsgs('account-', ['email-password', 'email', 'email-confirm']);

            var aid     = parseInt(emailForm.dataset.aid || '0', 10);
            var pw      = val('account-email-password');
            var email   = val('account-email');
            var confirm = val('account-email-confirm');
            var bad = false;

            if (email.length === 0) {
                setMsg('account-email-msg', 'Введите ваш новый email.');
                bad = true;
            }
            if (confirm.length === 0) {
                setMsg('account-email-confirm-msg', 'Подтвердите ваш новый email.');
                bad = true;
            }
            if (!bad && email !== confirm) {
                setMsg('account-email-confirm-msg', 'Email-адреса не совпадают.');
                bad = true;
            }
            if (pw.length === 0) {
                setMsg('account-email-password-msg', 'Введите ваш пароль.');
                bad = true;
            }
            if (bad) return;

            var emailBtn = emailForm.querySelector('[data-testid="account-email-save"]');
            setBusy(emailBtn, true);
            sb.api.call(Actions.AccountChangeEmail, {
                aid: aid,
                email: email,
                password: pw
            }).then(function (env) {
                setBusy(emailBtn, false);
                if (env && env.ok) { flashSuccess(env); return; }
                if (env && env.redirect) return;
                if (showFieldError(
                    'account-',
                    env && env.error,
                    { emailpw: 'email-password', email1: 'email', email2: 'email-confirm' }
                )) return;
                flashFailure(env);
            });
        });
    }
})();
</script>
{/literal}
