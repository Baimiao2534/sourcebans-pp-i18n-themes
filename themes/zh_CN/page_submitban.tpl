{*
    SourceBans++ 2026 — page_submitban.tpl

    Public "Submit a ban / Report a player" form. Pair:
    web/pages/page.submit.php → web/includes/View/SubmitBanView.php.

    Form-input name= keys (SteamID, BanIP, PlayerName, BanReason,
    SubmitName, EmailAddr, server, demo_file) and the `subban=1` marker
    are LOCKED by the page handler's $_POST reads and by the
    :prefix_submissions schema; only the visual layout differs from
    web/themes/default/page_submitban.tpl. Both templates render the
    same set of Smarty vars on SubmitBanView so the dual-theme
    SmartyTemplateRule (#1123 A2) is happy.

    CSRF: {csrf_field} is required because this is a state-changing
    POST (creates a row in :prefix_submissions). The token plugin
    already escapes its values; auto-escape is on globally.

    Testability hooks (per #1123 "Testability hooks") — every
    interactive surface gets data-testid="submitban-<field>" so the
    forthcoming Playwright suite has stable selectors:
      submitban-steam, submitban-ip, submitban-name, submitban-reason,
      submitban-reporter-name, submitban-reporter-email,
      submitban-server, submitban-demo, submitban-submit, submitban-cancel.

    Captcha / honeypot: none in the legacy flow, so nothing to
    preserve here. If captcha lands later, drop it above the action
    row and gate the submit button on it.
*}
<section class="p-6" style="max-width:48rem">
    <header class="mb-6">
        <h1 style="font-size:var(--fs-2xl);font-weight:600;margin:0">提交封禁申请</h1>
        <p class="text-sm text-muted m-0 mt-2">
            举报玩家作弊、骚扰或其他违规行为。演示和截图有助于管理员更快处理。
        </p>
    </header>

    {*
        #1420 follow-up #2: `novalidate` was dropped so the native
        `required` / `pattern` validation gates fire on submit. The
        cross-field "one of Steam ID OR IP" check that native HTML
        can't express stays in the inline JS at the bottom — it runs
        AFTER native validation passes. The server-side rules in
        `page.submit.php` remain the source of truth for JS-off
        visitors and any client bypass.
    *}
    <form class="card"
          method="post"
          enctype="multipart/form-data"
          action="index.php?p=submit"
          aria-labelledby="submitban-heading">
        {csrf_field}
        <input type="hidden" name="subban" value="1">

        <div class="card__body space-y-4">
            <div>
                <h2 id="submitban-heading" class="m-0" style="font-size:var(--fs-base);font-weight:600">
                    违规者详情
                </h2>
                <p class="text-xs text-muted m-0 mt-2">
                    提供 Steam ID 或 IP 地址（或两者）。昵称和清晰的事件描述为必填项。
                </p>
            </div>

            {*
                #1207 PUB-4: shared "1 of these required" badge. Steam ID
                + IP are an "either/or" pair (the page handler validates
                neither-empty server-side, but the form previously had
                no visual hint, and a typo would round-trip through a
                full POST before bouncing). The two inputs share the
                same `data-required-group="steamid-or-ip"` plus
                `aria-describedby` pointing at the help line above; the
                inline `<script>` at the bottom blocks submit when both
                are blank, surfaces a `data-error="true"` on the group
                container, and toggles the help line's
                `[data-state="error"]`.
            *}
            <div data-testid="submitban-id-or-ip"
                 data-required-group="steamid-or-ip"
                 data-error="false"
                 class="space-y-4">
                <p id="submitban-id-or-ip-help"
                   class="flex items-center gap-2 text-xs m-0"
                   data-testid="submitban-id-or-ip-help"
                   data-state="info">
                    <span class="pill"
                          aria-hidden="true"
                          style="height:1.25rem;background:var(--bg-muted);color:var(--text-muted);box-shadow:inset 0 0 0 1px var(--border)">
                        必填其中一项
                    </span>
                    <span class="text-muted" data-id-or-ip-text>提供 Steam ID 或 IP 地址（或两者）。</span>
                </p>
                <div>
                    <label class="label" for="submitban-steam">
                        玩家的 Steam ID
                        <span class="text-muted text-xs" style="font-weight:400">（或使用下方的 IP）</span>
                    </label>
                    {*
                        #1420 follow-up #2: strict `pattern` mirrors the
                        server-side `SteamID::isValidID()` allowlist
                        (Steam2 / bracketed Steam3 / 17-digit Steam64
                        — same as `page_admin_comms_add.tpl` /
                        `page_admin_bans_add.tpl`). The input is
                        intentionally NOT `required` — this surface
                        accepts EITHER a Steam ID OR an IP, and the
                        either/or guard is enforced by the page-tail
                        script + the server-side rule in
                        `page.submit.php`. When the input is empty
                        HTML5 `pattern` validation passes (it only
                        fires on non-empty values), so the cross-field
                        guard stays in JS as before.
                    *}
                    <input type="text"
                           class="input font-mono"
                           id="submitban-steam"
                           name="SteamID"
                           maxlength="64"
                           value="{$STEAMID}"
                           placeholder="STEAM_0:1:23498765"
                           pattern="STEAM_[01]:[01]:\d+|\[U:1:\d+\]|\d{17}"
                           title="Enter a Steam ID (STEAM_0:1:23498765), Steam3 ID ([U:1:23498765]), or 17-digit SteamID64."
                           autocomplete="off"
                           aria-describedby="submitban-id-or-ip-help"
                           data-testid="submitban-steam">
                </div>

                <div>
                    <label class="label" for="submitban-ip">
                        玩家的 IP 地址
                        <span class="text-muted text-xs" style="font-weight:400">（或使用上方的 Steam ID）</span>
                    </label>
                    <input type="text"
                           class="input font-mono"
                           id="submitban-ip"
                           name="BanIP"
                           maxlength="64"
                           value="{$ban_ip}"
                           placeholder="203.0.113.42"
                           autocomplete="off"
                           aria-describedby="submitban-id-or-ip-help"
                           data-testid="submitban-ip">
                </div>
            </div>

            <div>
                <label class="label" for="submitban-name">
                    玩家昵称 <span style="color:var(--danger)" aria-hidden="true">*</span>
                </label>
                <input type="text"
                       class="input"
                       id="submitban-name"
                       name="PlayerName"
                       maxlength="70"
                       value="{$player_name}"
                       required
                       aria-required="true"
                       data-testid="submitban-name">
            </div>

            <div>
                <label class="label" for="submitban-reason">
                    备注 <span style="color:var(--danger)" aria-hidden="true">*</span>
                </label>
                <textarea class="textarea"
                          id="submitban-reason"
                          name="BanReason"
                          rows="5"
                          required
                          aria-required="true"
                          aria-describedby="submitban-reason-help"
                          data-testid="submitban-reason">{$ban_reason}</textarea>
                <p id="submitban-reason-help" class="text-xs text-muted m-0 mt-2">
                    请具体描述。仅写"作弊"是不够的。请描述您看到了什么、何时发生、在哪台服务器上。
                </p>
            </div>
        </div>

        <div class="card__body space-y-4" style="border-top:1px solid var(--border)">
            <div>
                <h2 class="m-0" style="font-size:var(--fs-base);font-weight:600">
                    您的详情
                </h2>
                <p class="text-xs text-muted m-0 mt-2">
                    以便管理员就后续问题与您联系。
                </p>
            </div>

            <div class="grid gap-4" style="grid-template-columns:1fr 1fr">
                <div>
                    <label class="label" for="submitban-reporter-name">您的姓名</label>
                    <input type="text"
                           class="input"
                           id="submitban-reporter-name"
                           name="SubmitName"
                           maxlength="70"
                           value="{$subplayer_name}"
                           autocomplete="name"
                           data-testid="submitban-reporter-name">
                </div>
                <div>
                    <label class="label" for="submitban-reporter-email">
                        您的邮箱 <span style="color:var(--danger)" aria-hidden="true">*</span>
                    </label>
                    <input type="email"
                           class="input"
                           id="submitban-reporter-email"
                           name="EmailAddr"
                           maxlength="70"
                           value="{$player_email}"
                           required
                           aria-required="true"
                           autocomplete="email"
                           data-testid="submitban-reporter-email">
                </div>
            </div>

            <div>
                <label class="label" for="submitban-server">
                    服务器 <span style="color:var(--danger)" aria-hidden="true">*</span>
                </label>
                <select class="select"
                        id="submitban-server"
                        name="server"
                        required
                        aria-required="true"
                        data-testid="submitban-server">
                    <option value="-1">&mdash; 选择服务器 &mdash;</option>
                    {foreach from=$server_list item="server"}
                        <option value="{$server.sid}"{if $server_selected == $server.sid} selected{/if}>{$server.hostname}</option>
                    {/foreach}
                    <option value="0"{if $server_selected == 0} selected{/if}>其他服务器 / 未在列表中</option>
                </select>
            </div>

            <div>
                <label class="label" for="submitban-demo">上传演示或证据</label>
                <div class="file-input">
                    <label class="btn btn--secondary">
                        <input type="file"
                               id="submitban-demo"
                               name="demo_file"
                               accept=".dem,.zip,.rar,.7z,.bz2,.gz"
                               data-testid="submitban-demo"
                               data-file-input
                               hidden>
                        <i data-lucide="upload" style="width:14px;height:14px"></i>
                        选择文件&hellip;
                    </label>
                    <span class="text-muted text-sm" data-file-name>未选择文件</span>
                </div>
                <p class="text-xs text-muted m-0 mt-2">
                    可选。允许的格式：<code class="font-mono">.dem</code>、
                    <code class="font-mono">.zip</code>、<code class="font-mono">.rar</code>、
                    <code class="font-mono">.7z</code>、<code class="font-mono">.bz2</code>、
                    <code class="font-mono">.gz</code>。
                </p>
            </div>
        </div>

        <div class="card__body flex items-center justify-between gap-2"
             style="border-top:1px solid var(--border)">
            <p class="text-xs text-muted m-0">
                <span style="color:var(--danger)" aria-hidden="true">*</span> 必填项
            </p>
            <div class="flex gap-2">
                <a class="btn btn--ghost"
                   href="index.php?p=banlist"
                   data-testid="submitban-cancel">取消</a>
                <button class="btn btn--primary"
                        type="submit"
                        data-testid="submitban-submit">
                    <i data-lucide="send-horizontal" aria-hidden="true"></i>
                    提交举报
                </button>
            </div>
        </div>
    </form>
</section>

{*
    #1207 PUB-4: client-side either/or validation for Steam ID + IP.

    Server-side validation in `web/pages/page.submit.php` enforces the
    same rule (the matching `(SteamID empty + BanIP empty)` branch
    flips `$validsubmit = false` and pushes the inline toast through
    `emitSubmitToast`), so it stays the source of truth — JS-off
    visitors get the same bounce. This pre-flight just keeps the user
    from paying the round-trip when the rule is trivially violated.

    Inline rather than a `web/scripts/<page>.js` file because the
    contract is one form on one page and the canonical pattern for new
    page-tail helpers is "self-contained vanilla JS per page" per
    AGENTS.md ("v1.x bulk file" anti-pattern). `// @ts-check` + JSDoc
    keeps it under the ts-check gate.
*}
<script>
{literal}
// @ts-check
(function () {
    'use strict';

    var form = /** @type {HTMLFormElement|null} */ (
        document.querySelector('form[action="index.php?p=submit"]')
    );
    if (!form) return;

    var group = /** @type {HTMLElement|null} */ (form.querySelector('[data-required-group="steamid-or-ip"]'));
    var steam = /** @type {HTMLInputElement|null} */ (form.querySelector('[data-testid="submitban-steam"]'));
    var ip    = /** @type {HTMLInputElement|null} */ (form.querySelector('[data-testid="submitban-ip"]'));
    var help  = /** @type {HTMLElement|null} */ (form.querySelector('[data-testid="submitban-id-or-ip-help"]'));
    var helpText = /** @type {HTMLElement|null} */ (form.querySelector('[data-id-or-ip-text]'));
    if (!group || !steam || !ip || !help || !helpText) return;

    /** @type {string} */
    var defaultText = helpText.textContent || '';

    /**
     * @param {boolean} isError
     */
    function setError(isError) {
        group.setAttribute('data-error', isError ? 'true' : 'false');
        help.setAttribute('data-state', isError ? 'error' : 'info');
        // Keep the visible copy stable (a11y: don't swap text on
        // every keystroke); the data-state attribute is the
        // testability hook E2E asserts on. Color shift is the
        // visible signal — see the inline style in this script.
        help.style.color = isError ? 'var(--danger)' : '';
        if (isError) {
            steam.setAttribute('aria-invalid', 'true');
            ip.setAttribute('aria-invalid', 'true');
            helpText.textContent = '请在提交前输入 Steam ID 或 IP 地址。';
        } else {
            steam.removeAttribute('aria-invalid');
            ip.removeAttribute('aria-invalid');
            helpText.textContent = defaultText;
        }
    }

    function isEmpty(/** @type {HTMLInputElement} */ el) {
        // #1420 follow-up #2: the legacy `STEAM_0:` empty-sentinel
        // collapse was dropped here when the page handler stopped
        // re-emitting it (see the `SubmitBanView` constructor in
        // `page.submit.php` for the matching change). The strict
        // `pattern="…"` on the input now rejects partial sentinels
        // pre-submit, and the server-side `SteamID::isValidID()`
        // gate (tightened in follow-up #1) closes the path for any
        // bypass that gets through.
        return (el.value || '').trim() === '';
    }

    /** @type {(ev: Event) => void} */
    function onSubmit(ev) {
        if (isEmpty(steam) && isEmpty(ip)) {
            ev.preventDefault();
            setError(true);
            // Focus the first of the two inputs so keyboard users
            // land on the offending field; matches native
            // `required` + `:invalid` UX.
            steam.focus();
            return;
        }
        setError(false);
    }

    /** Clear the error as soon as either input gets non-empty. */
    function onInput() {
        if (group.getAttribute('data-error') !== 'true') return;
        if (!isEmpty(steam) || !isEmpty(ip)) setError(false);
    }

    form.addEventListener('submit', onSubmit);
    steam.addEventListener('input', onInput);
    ip.addEventListener('input', onInput);
})();
{/literal}
</script>
