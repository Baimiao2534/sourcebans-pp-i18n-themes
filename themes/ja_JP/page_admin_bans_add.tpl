{*
    SourceBans++ 2026 — page_admin_bans_add.tpl
    Bound to Sbpp\View\AdminBansAddView (validated by SmartyTemplateRule).

    "Add a ban" tab on the admin bans page. The form keeps every legacy
    DOM id (nickname, type, steam, ip, listReason, txtReason, dreason,
    banlength, fromsub, demo.msg, *.msg, aban, aback, udemo) so:
      - the legacy ProcessBan() / changeReason() / window.demo() helpers
        living in admin.bans.php's tail <script> still find their nodes,
      - the Actions.BansSetupBan response handler in sourcebans.js
        (applyBanFields) reuses the same ids when filling the form
        from a submission's "Ban" link.

    sbpp2026 doesn't ship sourcebans.js so applyApiResponse() isn't
    available; the inline literal-block script at the bottom of this
    file intercepts clicks on [data-action="addban-submit"], mirrors the
    legacy ProcessBan validation, and dispatches Actions.BansAdd
    directly through sb.api.call. Toasts go through window.SBPP.showToast
    when present (theme.js, sbpp2026) with sb.message as a fallback.

    Kickit (kick-on-ban) — when `config.enablekickit` is on (the
    install default), api_bans_add returns a `kickit` envelope
    (`{check, type}`). The success branch spawns a hidden iframe
    pointing at `pages/admin.kickit.php?check=...&type=...` — the
    iframe enumerates enabled servers and fires `sm_kick` via rcon
    on each. This mirrors the comms.add → blockit.php pattern one
    flow over and replaces the v1.x `ShowKickBox()` / `TabToReload()`
    helpers that lived in `web/scripts/sourcebans.js` (deleted at
    #1123 D1). Pre-#1441 the branch checked `typeof window.ShowKickBox
    === 'function'` which silently resolved to `false`, falling
    through to a "Ban added" toast while the ban DB row landed but
    no live server ever kicked the player.

    Permission gate: $permission_addban is precomputed in admin.bans.php
    from ADMIN_OWNER | ADMIN_ADD_BAN.
*}
{if NOT $permission_addban}
    <div class="card" data-testid="addban-denied">
        <div class="card__body">
            <h1 style="font-size:1.25rem;font-weight:600;margin:0">アクセスが拒否されました</h1>
            <p class="text-sm text-muted m-0 mt-2">BAN を追加する権限がありません。</p>
        </div>
    </div>
{else}
    <section class="p-6" data-testid="addban-section" style="max-width:48rem">
        <div class="mb-6">
            <h1 style="font-size:1.5rem;font-weight:600;margin:0">BAN を追加</h1>
            <p class="text-sm text-muted m-0 mt-2">
                SteamID または IP アドレスで BAN します。ラベルにマウスを合わせるとヘルプが表示されます。
            </p>
        </div>
        <form id="addban-form"
              class="card p-6 space-y-4"
              data-testid="addban-form"
              onsubmit="return false;"
              autocomplete="off">
            {csrf_field}
            <input type="hidden" id="fromsub" value="">

            <div>
                <label class="label" for="nickname">ニックネーム</label>
                {* #1420: `required` is the native gate paired with the
                   IIFE's `nick.msg` fallback (the IIFE's regex layer
                   still runs for the cases native HTML can't catch).
                   Together they make the empty-input case surface a
                   browser popover BEFORE the API call fires.
                   #1440: smart-default pre-fill via `?name=…` (paired
                   with `?steam=…`) — used by the public servers list's
                   right-click context menu's "Ban player" item.
                   admin.bans.php strips control chars + caps at 128
                   codepoints; Smarty auto-escape is the HTML-attribute
                   safety layer. *}
                <input type="text"
                       class="input"
                       id="nickname"
                       name="nickname"
                       data-testid="addban-nickname"
                       value="{$prefill_name}"
                       placeholder="ゲーム内で表示されていた名前"
                       required>
                <div class="text-xs mt-2" id="nick.msg" style="color:var(--danger);display:none"></div>
            </div>

            <div class="grid gap-4" style="grid-template-columns:repeat(auto-fit,minmax(14rem,1fr))">
                <div>
                    <label class="label" for="type">BAN タイプ</label>
                    {* Smart-default Ban type via `?type=…` (paired with
                       `?steam=…` — see admin.bans.php for the allowlist).
                       Default is 0 (Steam ID) when no smart-default is
                       active, matching the form's pre-#PLAYER_CTX_MENU
                       shape. *}
                    <select class="select"
                            id="type"
                            name="type"
                            data-testid="addban-type">
                        <option value="0"{if $prefill_type == 0} selected{/if}>Steam ID</option>
                        <option value="1"{if $prefill_type == 1} selected{/if}>IP アドレス</option>
                    </select>
                </div>
                <div>
                    <label class="label" for="banlength">BAN 期間</label>
                    <select class="select"
                            id="banlength"
                            data-testid="addban-length">
                        <option value="0">永久</option>
                        <optgroup label="分">
                            <option value="1">1 分</option>
                            <option value="5">5 分</option>
                            <option value="10">10 分</option>
                            <option value="15">15 分</option>
                            <option value="30">30 分</option>
                            <option value="45">45 分</option>
                        </optgroup>
                        <optgroup label="時間">
                            <option value="60">1 時間</option>
                            <option value="120">2 時間</option>
                            <option value="180">3 時間</option>
                            <option value="240">4 時間</option>
                            <option value="480">8 時間</option>
                            <option value="720">12 時間</option>
                        </optgroup>
                        <optgroup label="日">
                            <option value="1440">1 日</option>
                            <option value="2880">2 日</option>
                            <option value="4320">3 日</option>
                            <option value="5760">4 日</option>
                            <option value="7200">5 日</option>
                            <option value="8640">6 日</option>
                        </optgroup>
                        <optgroup label="週">
                            <option value="10080">1 週間</option>
                            <option value="20160">2 週間</option>
                            <option value="30240">3 週間</option>
                        </optgroup>
                        <optgroup label="月">
                            <option value="43200">1 か月</option>
                            <option value="86400">2 か月</option>
                            <option value="129600">3 か月</option>
                            <option value="259200">6 か月</option>
                            <option value="518400">12 か月</option>
                        </optgroup>
                    </select>
                </div>
            </div>

            <div>
                <label class="label" for="steam">Steam ID / コミュニティ ID</label>
                {* Smart-default SteamID via `?steam=…&type=0` (admin.bans.php
                   allowlists STEAM_X:Y:Z / [U:1:N] / SteamID64 before this
                   value reaches the template, so the auto-escape is the
                   belt-and-braces). Used by the public servers list's
                   right-click context menu's "Ban player" item. *}
                {* #1420: `pattern` (no `required`) mirrors the inline
                   IIFE's regex for type=0; this lets the browser show
                   a native popover for a non-empty bad-shape value
                   like "asdf" BEFORE the IIFE's setMsg path runs.
                   `required` is intentionally absent because for
                   type=1 (IP Address) the steam field is legitimately
                   empty and the ip field carries the value — the
                   IIFE's per-type check is the right gate for that
                   branch. The defensive server-side validation in
                   api_bans_add (also #1420) is what closes the loop
                   if a hostile / curl-driven caller smuggles a bad
                   shape past every client-side check. *}
                <input type="text"
                       class="input font-mono"
                       id="steam"
                       name="steam"
                       data-testid="addban-steam"
                       value="{if $prefill_type == 0}{$prefill_steam}{/if}"
                       placeholder="STEAM_0:1:23498765"
                       pattern="STEAM_[01]:[01]:\d+|\[U:1:\d+\]|\d{17}"
                       title="Steam ID（STEAM_0:1:23498765）、Steam3 ID（[U:1:23498765]）、または 17 桁の SteamID64 を入力してください。">
                <div class="text-xs mt-2" id="steam.msg" style="color:var(--danger);display:none"></div>
            </div>

            <div>
                <label class="label" for="ip">IP アドレス</label>
                {* Smart-default IP via `?steam=…&type=1` — same shape as the
                   Steam field above, but only populated when the prefill
                   declared an IP type. *}
                <input type="text"
                       class="input font-mono"
                       id="ip"
                       name="ip"
                       data-testid="addban-ip"
                       value="{if $prefill_type == 1}{$prefill_steam}{/if}"
                       placeholder="203.0.113.10">
                <div class="text-xs mt-2" id="ip.msg" style="color:var(--danger);display:none"></div>
            </div>

            <div>
                <label class="label" for="listReason">BAN 理由</label>
                <select class="select"
                        id="listReason"
                        name="listReason"
                        data-testid="addban-reason"
                        onchange="changeReason(this[this.selectedIndex].value);">
                    <option value="" selected>-- 理由を選択 --</option>
                    <optgroup label="ハック">
                        <option value="Aimbot">Aimbot</option>
                        <option value="Antirecoil">反動無効</option>
                        <option value="Wallhack">Wallhack</option>
                        <option value="Spinhack">スピンハック</option>
                        <option value="Multi-Hack">複合ハック</option>
                        <option value="No Smoke">煙無効</option>
                        <option value="No Flash">フラッシュ無効</option>
                    </optgroup>
                    <optgroup label="行動">
                        <option value="Team Killing">チームキル</option>
                        <option value="Team Flashing">チームフラッシュ</option>
                        <option value="Spamming Mic/Chat">マイク/チャットのスパム</option>
                        <option value="Inappropriate Spray">不適切なスプレー</option>
                        <option value="Inappropriate Language">不適切な言語</option>
                        <option value="Inappropriate Name">不適切な名前</option>
                        <option value="Ignoring Admins">管理者の指示無視</option>
                        <option value="Team Stacking">チーム偏り</option>
                    </optgroup>
                    {if $customreason}
                        <optgroup label="カスタム">
                            {foreach from=$customreason item="creason"}
                                {* nofilter: bans.customreasons round-trips through htmlspecialchars in admin.settings.php before serialize() into sb_settings, so the value is already entity-encoded; auto-escaping would double-encode. *}
                                <option value="{$creason nofilter}">{$creason nofilter}</option>
                            {/foreach}
                        </optgroup>
                    {/if}
                    <option value="other">その他の理由</option>
                </select>
                <div id="dreason" class="mt-2" style="display:none">
                    <textarea class="textarea"
                              id="txtReason"
                              name="txtReason"
                              rows="4"
                              placeholder="この BAN を行う理由を詳しく説明してください。"
                              data-testid="addban-reason-custom"></textarea>
                </div>
                <div class="text-xs mt-2" id="reason.msg" style="color:var(--danger);display:none"></div>
            </div>

            <div>
                <label class="label">デモをアップロード</label>
                <button type="button"
                        class="btn btn--secondary btn--sm"
                        id="udemo"
                        data-testid="addban-demo"
                        onclick="childWindow=open('pages/admin.uploaddemo.php','upload','resizable=no,width=300,height=130');">
                    デモをアップロード
                </button>
                <div class="text-xs mt-2" id="demo.msg" style="color:var(--text-muted)"></div>
            </div>

            <div class="flex justify-end gap-2"
                 style="border-top:1px solid var(--border);padding-top:0.75rem">
                <button type="button"
                        class="btn btn--ghost"
                        id="aback"
                        data-testid="addban-back"
                        onclick="history.go(-1);">戻る</button>
                <button type="button"
                        class="btn btn--primary"
                        id="aban"
                        data-testid="addban-submit"
                        data-action="addban-submit">
                    BAN を追加
                </button>
            </div>
        </form>
    </section>
{/if}
{* Inline action wiring — sbpp2026 doesn't load sourcebans.js, so the
   legacy ProcessBan() / applyApiResponse() pair would throw inside the
   promise's .then() and leave the admin with no toast / no form reset.
   We intercept the click here, mirror ProcessBan's client-side validation,
   and dispatch Actions.BansAdd directly via sb.api.call. The default
   theme keeps its own copy of `page_admin_bans_add.tpl` (still
   onclick="ProcessBan();") so this script is sbpp2026-only. *}
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
    function validate(type) {
        var err = 0;
        var reason = '';
        var listReason = $id('listReason');
        if (listReason) {
            reason = listReason.value;
            if (reason === 'other') {
                var txtReason = $id('txtReason');
                reason = txtReason ? txtReason.value : '';
            }
        }
        var nick = $id('nickname');
        if (!nick || !nick.value) { setMsg('nick.msg', 'BAN する対象者のニックネームを入力してください'); err++; }
        else { setMsg('nick.msg', ''); }

        var steam = $id('steam');
        if (type === 0) {
            if (!steam || !/(?:STEAM_[01]:[01]:\d+)|(?:\[U:1:\d+\])|(?:\d{17})/.test(steam.value)) {
                setMsg('steam.msg', '有効な STEAM ID またはコミュニティ ID を入力してください'); err++;
            } else { setMsg('steam.msg', ''); }
        } else { setMsg('steam.msg', ''); }

        var ip = $id('ip');
        if (type === 1) {
            if (!ip || ip.value.length < 7) {
                setMsg('ip.msg', '有効な IP アドレスを入力してください'); err++;
            } else { setMsg('ip.msg', ''); }
        } else { setMsg('ip.msg', ''); }

        if (!reason) {
            setMsg('reason.msg', 'この BAN の理由を選択または入力してください。'); err++;
        } else { setMsg('reason.msg', ''); }
        return err === 0 ? reason : null;
    }
    function reset() {
        var form = $id('addban-form');
        if (form && typeof form.reset === 'function') form.reset();
        var dreason = $id('dreason');
        if (dreason) dreason.style.display = 'none';
        var demoMsg = $id('demo.msg');
        if (demoMsg) demoMsg.innerHTML = '';
        var fromsub = $id('fromsub');
        if (fromsub) fromsub.value = '';
    }
    document.addEventListener('click', function (e) {
        var t = e.target;
        if (!t || !t.closest) return;
        var btn = t.closest('[data-action="addban-submit"]');
        if (!btn) return;
        e.preventDefault();
        var typeEl = $id('type');
        var type = typeEl ? Number(typeEl.value) : 0;
        var reason = validate(type);
        if (reason === null) return;
        var a = api(), A = actions();
        if (!a || !A) return;
        setBusy(btn, true);
        a.call(A.BansAdd, {
            nickname: $id('nickname').value,
            type: type,
            steam: $id('steam').value,
            ip: $id('ip').value,
            length: Number($id('banlength').value),
            dfile: (typeof window.did === 'string' || typeof window.did === 'number') ? window.did : 0,
            dname: (typeof window.dname === 'string') ? window.dname : '',
            reason: reason,
            fromsub: Number(($id('fromsub') && $id('fromsub').value) || 0)
        }).then(function (r) {
            if (r && r.ok && r.data && r.data.kickit) {
                // Success - keep the button busy (matches the comms.add
                // shape) so the operator can't queue a second submit
                // while the iframe fires rcon at every server.
                var k = r.data.kickit;
                toast('success', 'BAN を追加しました',
                    'BAN は正常に追加されました。');
                // The iframe is load-bearing - pages/admin.kickit.php
                // loops the enabled servers and fires `sm_kick` via
                // rcon for each one. Without it the DB row exists but
                // no live server kicks the banned player. Mirror of
                // the comms.add → blockit.php pattern one branch over
                // (#1441 - replaces the v1.x ShowKickBox helper that
                // was deleted with sourcebans.js at #1123 D1).
                var iframe = document.createElement('iframe');
                iframe.id = 'srvkicker';
                iframe.style.display = 'none';
                iframe.src = 'pages/admin.kickit.php?check='
                    + encodeURIComponent(k.check)
                    + '&type=' + encodeURIComponent(k.type);
                document.body.appendChild(iframe);
                if (r.data.reload) {
                    setTimeout(function () {
                        window.location.href = window.location.href.replace(/#\^.*$/, '');
                    }, 2000);
                }
                return;
            }
            setBusy(btn, false);
            if (!r || r.ok === false) {
                toast('error', 'BAN 追加に失敗しました', (r && r.error && r.error.message) || '不明なエラー');
                return;
            }
            var msg = (r.data && r.data.message) || null;
            // 'Ban Added' (Title Case) matches the kickit branch above
            // AND comms.add's 'Block Added'. Pre-#1441 the kickit branch
            // never fired, so only this fallback's lowercase 'Ban added'
            // was visible to operators; the casing inconsistency was
            // invisible. With #1441 both branches now run on different
            // installs (kickit enabled vs disabled) and operators would
            // see two casings; standardise on Title Case for symmetry.
            toast('success', (msg && msg.title) || 'BAN を追加しました', (msg && msg.body) || 'BAN は正常に追加されました');
            reset();
        });
    });
})();
</script>
{/literal}
