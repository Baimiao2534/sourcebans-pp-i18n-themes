{*
    SourceBans++ (c) 2014-2026 SourceBans++ Dev Team
    Licensed under the Elastic License 2.0.
    See LICENSE.txt for the full license text and THIRD-PARTY-NOTICES.txt for attributions.

    Pair: web/pages/admin.admins.php (renders this OR the list OR the
    overrides editor based on ?section=) and
    web/includes/View/AdminAdminsAddView.php.

    #1402: Wires the four dead-on-v2.0 JS handlers
    (`ProcessAddAdmin`, `LoadGeneratePassword`, `update_server`,
    `update_web`) directly to the existing JSON API actions
    (`Actions.AdminsAdd`, `Actions.AdminsGeneratePassword`) via a
    page-tail vanilla-JS dispatcher. The pre-fix shape relied on
    helpers from `web/scripts/sourcebans.js` (deleted at #1123 D1):
    the form's `onsubmit="event.preventDefault(); if (typeof
    ProcessAddAdmin === 'function') ProcessAddAdmin();"` always took
    the `event.preventDefault()` path (silent no-op — the guard
    swallowed the missing helper and the form never POSTed), the
    "Generate password" button's onclick was the same shape, and the
    `<select>`'s `onchange="if (typeof update_server === 'function')
    update_server();"` never mounted the conditional flag-picker UI,
    so picking "Custom permissions" or "New admin group" left the
    extra inputs hidden forever.

    The CSRF protection comes from {csrf_field}; the dispatcher's
    sb.api.call already attaches the X-CSRF-Token header so the
    hidden token is for any future server-side fallback.

    #1275 — Pattern A `?section=…` routing
    --------------------------------------
    Pre-#1275 this template was wrapped in `<section id="add-admin">`
    (a `.page-toc-section` anchor target inside the cross-template
    `.page-toc-shell`). #1275 unifies on Pattern A: this template now
    renders by itself when the URL is `?section=add-admin`, so the
    section becomes the whole page. The data-testid stays as
    `admin-admins-section-add-admin` so existing E2E selectors keep
    matching the surface.
*}
<div data-testid="admin-admins-section-add-admin">
    {if !$can_add_admins}
        <div class="card">
            <div class="card__body">
                <p class="text-sm text-muted m-0">存取被拒絕。</p>
            </div>
        </div>
    {else}
        <div class="mb-4">
            <h1 style="font-size:var(--fs-xl);font-weight:600;margin:0">新增管理員</h1>
            <p class="text-sm text-muted m-0 mt-2">將游標停留在說明圖示上以查看欄位級指引。</p>
        </div>

        <div id="msg-green" class="card" style="display:none;border-left:3px solid var(--success)">
            <div class="card__body">
                <div class="flex items-center gap-3">
                    <i data-lucide="check-circle-2" style="color:var(--success)"></i>
                    <div>
                        <div class="font-semibold">管理員已新增</div>
                        <div class="text-sm text-muted">新管理員已成功新增。正在重新導向&hellip;</div>
                    </div>
                </div>
            </div>
        </div>

        <form id="add-admin-form" method="post" action="" class="space-y-4" autocomplete="off">
            {csrf_field}

            <div class="card">
                <div class="card__header">
                    <div>
                        <h3>識別資訊</h3>
                        <p>登入名稱與 Steam ID 在面板及遊戲伺服器上用於識別此管理員。</p>
                    </div>
                </div>
                <div class="card__body space-y-3">
                    <div class="grid gap-4" style="grid-template-columns:1fr 1fr">
                        <div>
                            <label class="label" for="adminname">管理員登入</label>
                            <input class="input" id="adminname" name="adminname" type="text"
                                   tabindex="1" data-testid="admin-add-name" autocomplete="off">
                            <div id="name.msg" class="text-xs" style="color:var(--danger);margin-top:0.25rem"></div>
                        </div>
                        <div>
                            <label class="label" for="steam">Steam ID</label>
                            <input class="input font-mono" id="steam" name="steam" type="text"
                                   tabindex="2" value="STEAM_0:" data-testid="admin-add-steam" autocomplete="off">
                            <div id="steam.msg" class="text-xs" style="color:var(--danger);margin-top:0.25rem"></div>
                        </div>
                    </div>
                    <div>
                        <label class="label" for="email">電子郵件 <span class="text-faint" style="font-weight:400">(網頁存取必填)</span></label>
                        <input class="input" id="email" name="email" type="email"
                               tabindex="3" data-testid="admin-add-email" autocomplete="off">
                        <div id="email.msg" class="text-xs" style="color:var(--danger);margin-top:0.25rem"></div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card__header">
                    <div>
                        <h3>驗證</h3>
                        <p>網頁面板密碼與可選的遊戲內管理員密碼。</p>
                    </div>
                </div>
                <div class="card__body space-y-3">
                    <div class="grid gap-4" style="grid-template-columns:1fr 1fr">
                        <div>
                            <label class="label" for="password">密碼 <span class="text-faint" style="font-weight:400">(網頁存取必填)</span></label>
                            <div class="flex gap-2">
                                <input class="input" id="password" name="password" type="password"
                                       tabindex="4" data-testid="admin-add-password" autocomplete="new-password">
                                {* #1402: data-action="admin-add-generate-password" replaces the
                                   dead `onclick="if (typeof LoadGeneratePassword === 'function')
                                   LoadGeneratePassword(); return false;"` guard. The page-tail
                                   dispatcher below calls Actions.AdminsGeneratePassword and
                                   writes the result into #password / #password2. *}
                                <button type="button" class="btn btn--ghost btn--icon"
                                        title="產生隨機密碼"
                                        aria-label="產生隨機密碼"
                                        data-action="admin-add-generate-password"
                                        data-testid="admin-add-generate-password">
                                    <i data-lucide="refresh-cw" style="width:14px;height:14px"></i>
                                </button>
                            </div>
                            <div id="password.msg" class="text-xs" style="color:var(--danger);margin-top:0.25rem"></div>
                        </div>
                        <div>
                            <label class="label" for="password2">確認密碼</label>
                            <input class="input" id="password2" name="password2" type="password"
                                   tabindex="5" data-testid="admin-add-password2" autocomplete="new-password">
                            <div id="password2.msg" class="text-xs" style="color:var(--danger);margin-top:0.25rem"></div>
                        </div>
                    </div>
                    <div class="flex items-center gap-2 mt-2" style="border-top:1px solid var(--border);padding-top:0.75rem">
                        <input type="checkbox" id="a_useserverpass" name="a_useserverpass"
                               tabindex="6" data-testid="admin-add-useserverpass"
                               onclick="var el = document.getElementById('a_serverpass'); if (el) el.disabled = !this.checked;">
                        <label for="a_useserverpass" class="text-sm font-medium" style="margin:0">設定遊戲內管理員密碼</label>
                        <input class="input" id="a_serverpass" name="a_serverpass" type="password"
                               style="max-width:14rem;margin-left:auto" disabled tabindex="7"
                               data-testid="admin-add-serverpass" autocomplete="new-password"
                               aria-label="遊戲內管理員密碼">
                    </div>
                    <div id="a_serverpass.msg" class="text-xs" style="color:var(--danger)"></div>
                </div>
            </div>

            <div class="card">
                <div class="card__header">
                    <div>
                        <h3>伺服器存取</h3>
                        <p>管理員可在遊戲內管理的伺服器及伺服器分組。</p>
                    </div>
                </div>
                <div class="card__body space-y-3">
                    {if !$group_list && !$server_list}
                        <p class="text-sm text-muted m-0"><em>尚未新增任何伺服器或伺服器分組。</em></p>
                    {else}
                        {if $group_list}
                            <div class="text-xs text-faint" style="text-transform:uppercase;letter-spacing:0.06em;font-weight:600">伺服器分組</div>
                            <div class="grid gap-2" style="grid-template-columns:repeat(auto-fill,minmax(14rem,1fr))">
                                {foreach $group_list as $group}
                                    <label class="flex items-center gap-2 p-3"
                                           style="border:1px solid var(--border);border-radius:var(--radius-md)">
                                        <input type="checkbox" id="add-server-group-{$group.gid}" name="group[]" value="g{$group.gid}"
                                               data-testid="admin-add-server-group">
                                        <span class="text-sm">{$group.name|escape}</span>
                                    </label>
                                {/foreach}
                            </div>
                        {/if}
                        {if $server_list}
                            <div class="text-xs text-faint" style="text-transform:uppercase;letter-spacing:0.06em;font-weight:600;margin-top:0.5rem">個別伺服器</div>
                            {*
                                #1405 — per-row hostname hydration. The
                                `data-server-hydrate="auto"` wrapper opts
                                this grid into the shared
                                `web/scripts/server-tile-hydrate.js`
                                helper (the same one driving
                                `page_servers.tpl` / `page_admin_servers_list.tpl`
                                / `page_dashboard.tpl`'s Servers widget).
                                The helper auto-runs on first paint,
                                walks every `[data-testid="server-tile"]`
                                child, and fires
                                `Actions.ServersHostPlayers` per row to
                                patch the live hostname into the inner
                                `[data-testid="server-host"]` slot via
                                `sb.setHTML`. SourceQueryCache (~30s TTL
                                per `(ip, port)`) coalesces back-to-back
                                probes server-side.

                                Mirrors the dashboard widget's minimal-
                                integration shape: the only optional
                                testid we ship is `server-host` — every
                                other cell hook (`server-status` /
                                `server-map` / `server-players` /
                                `server-players-bar` / `server-map-img`)
                                is intentionally omitted, and the
                                helper's feature-detection branches
                                no-op for the missing ones. The Add
                                Admin form is the editor for per-server
                                access, not a player-row table; status
                                pills / player counts would only add
                                visual noise to the checkbox grid.

                                `data-trunchostname="40"` caps the live
                                hostname server-side: this grid's per-row
                                card is a FIXED ~18rem wide, so a small
                                fixed cap keeps a long hostname from
                                tripping `truncate`'s ellipsis. (The
                                dashboard widget dropped its cap to `0`
                                in #1487 because its column is fluid and
                                CSS sizes the cut to the rendered width;
                                this grid's column is fixed, so the cap
                                stays.) The number forwards to
                                `api_servers_host_players` as the
                                SourceQuery truncation hint (cheaper
                                server-side than a JS-side trim because
                                the handler also htmlspecialchars()'s the
                                truncated string for `sb.setHTML`).

                                Pre-#1405 (post-#1404 cleanup) the row
                                shipped `<span id="sa{$server.sid}">IP:port</span>`
                                with the legacy v1.4.11 `<script>LoadServerHost(...)</script>`
                                feeder. `LoadServerHost` was deleted
                                with `sourcebans.js` at #1123 D1; #1404
                                dropped the dead feeder + the orphan
                                `$server_script` View property. This is
                                the additive replacement that restores
                                live hostname hydration without
                                reintroducing any of the deleted
                                helpers. The bare `IP:port` text inside
                                the `[data-testid="server-host"]` span
                                stays as the no-JS / cache-cold
                                fallback; `data-fallback` lets the
                                helper re-paint it after a UDP probe
                                failure so the row never goes blank.
                            *}
                            <div class="grid gap-2"
                                 style="grid-template-columns:repeat(auto-fill,minmax(18rem,1fr))"
                                 data-server-hydrate="auto"
                                 data-trunchostname="40">
                                {foreach $server_list as $server}
                                    <label class="flex items-center gap-2 p-3"
                                           style="border:1px solid var(--border);border-radius:var(--radius-md)"
                                           data-testid="server-tile"
                                           data-id="{$server.sid}">
                                        <input type="checkbox" id="servers[]" name="servers[]" value="s{$server.sid}"
                                               data-testid="admin-add-server">
                                        <span class="text-sm font-mono"
                                              data-testid="server-host"
                                              data-fallback="{$server.ip}:{$server.port}">{$server.ip}:{$server.port}</span>
                                    </label>
                                {/foreach}
                            </div>
                        {/if}
                    {/if}
                </div>
            </div>

            <div class="card">
                <div class="card__header">
                    <div>
                        <h3>權限</h3>
                        <p>預設分組、自訂旗標或無權限。選擇新分組會開啟內嵌編輯器。</p>
                    </div>
                </div>
                <div class="card__body space-y-3">
                    <div>
                        <label class="label" for="serverg">伺服器管理員分組</label>
                        {* #1402: replaces the dead `onchange="if (typeof update_server === 'function')
                           update_server();"` guard. The page-tail dispatcher reacts to `change`
                           on this element via `data-action="admin-add-update-server"`. *}
                        <select class="select" id="serverg" name="serverg" tabindex="8"
                                data-testid="admin-add-serverg"
                                data-action="admin-add-update-server">
                            <option value="-2">請選擇&hellip;</option>
                            <option value="-3">無權限</option>
                            <option value="c">自訂權限</option>
                            <option value="n">新管理員分組</option>
                            <optgroup label="分組" style="font-weight:bold">
                                {foreach $server_admin_group_list as $server_wg}
                                    <option value="{$server_wg.id}">{$server_wg.name|escape}</option>
                                {/foreach}
                            </optgroup>
                        </select>
                        <div id="server.msg" class="text-xs" style="color:var(--danger);margin-top:0.25rem"></div>
                        {* #1402: pre-#1402 this was a hollow `<div id="serverperm">` that the
                           legacy `update_server()` helper was supposed to mount the new-group
                           name field + SourceMod flag input into. The helper was deleted with
                           sourcebans.js (#1123 D1); the new dispatcher reveals these inline
                           inputs on the right `<select>` value. *}
                        <div id="serverperm" style="overflow:hidden">
                            <div id="server-new-name-block" hidden style="margin-top:0.75rem">
                                <label class="label" for="server-new-name">新伺服器管理員分組名稱</label>
                                <input class="input" id="server-new-name" name="server-new-name" type="text"
                                       data-testid="admin-add-server-new-name" autocomplete="off">
                                <div id="servername_err.msg" class="text-xs" style="color:var(--danger);margin-top:0.25rem"></div>
                            </div>
                            <div id="server-flags-block" hidden style="margin-top:0.75rem">
                                <label class="label" for="server-flags">SourceMod 旗標與免禁</label>
                                <input class="input font-mono" id="server-flags" name="server-flags" type="text"
                                       data-testid="admin-add-server-flags" autocomplete="off"
                                       placeholder="e.g. abz#50">
                                <p class="text-xs text-muted m-0 mt-2">
                                    SourceMod 旗標字串。附加 <code>#&lt;immunity&gt;</code> 以設定免禁值（預設為 0）。
                                </p>
                            </div>
                        </div>
                    </div>
                    <div>
                        <label class="label" for="webg">網頁管理員分組</label>
                        <select class="select" id="webg" name="webg" tabindex="9"
                                data-testid="admin-add-webg"
                                data-action="admin-add-update-web">
                            <option value="-2">請選擇&hellip;</option>
                            <option value="-3">無權限</option>
                            <option value="c">自訂權限</option>
                            <option value="n">新管理員分組</option>
                            <optgroup label="分組" style="font-weight:bold">
                                {foreach $server_group_list as $server_g}
                                    <option value="{$server_g.gid}">{$server_g.name|escape}</option>
                                {/foreach}
                            </optgroup>
                        </select>
                        <div id="web.msg" class="text-xs" style="color:var(--danger);margin-top:0.25rem"></div>
                        <div id="webperm" style="overflow:hidden">
                            <div id="web-new-name-block" hidden style="margin-top:0.75rem">
                                <label class="label" for="web-new-name">新網頁管理員分組名稱</label>
                                <input class="input" id="web-new-name" name="web-new-name" type="text"
                                       data-testid="admin-add-web-new-name" autocomplete="off">
                                <div id="webname_err.msg" class="text-xs" style="color:var(--danger);margin-top:0.25rem"></div>
                            </div>
                            <div id="web-flags-block" hidden style="margin-top:0.75rem">
                                <fieldset style="border:1px solid var(--border);border-radius:var(--radius-md);padding:0.75rem">
                                    <legend class="text-xs text-faint" style="padding:0 0.5rem;text-transform:uppercase;letter-spacing:0.06em;font-weight:600">網頁權限</legend>
                                    <p class="text-xs text-muted m-0 mb-2">勾選此管理員（或新分組）持有的旗標。Owner 會授予所有其他旗標。</p>
                                    <div class="grid gap-2" style="grid-template-columns:repeat(auto-fill,minmax(16rem,1fr))">
                                        {* Hard-coded canonical web flag set. Mirrors the
                                           Perms global from web/scripts/api-contract.js
                                           (auto-generated from web.json). Kept narrow so a
                                           panel-add operator doesn't get drowned in 33
                                           checkboxes; the full grid lives on the separate
                                           Edit Permissions page (admin.edit.adminperms.php).
                                           NOT load-bearing if a flag is missed here — the
                                           edit page is the canonical full editor.

                                           data-flag values map to ADMIN_* names so the
                                           JS dispatcher can OR them with Perms.ADMIN_*. *}
                                        {if $can_grant_owner}
                                            {* #1402 adversarial review HIGH 1: OWNER is gated.
                                               A non-owner with ADMIN_ADD_ADMINS otherwise sees
                                               the checkbox and can grant OWNER (full panel
                                               takeover). Server-side guard in api_admins_add
                                               is the load-bearing pair; this is the visible-
                                               affordance half. *}
                                            <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_OWNER" data-testid="admin-add-flag-owner"> <span class="text-sm">Owner</span></label>
                                        {/if}
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_LIST_ADMINS"> <span class="text-sm">檢視管理員</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_ADD_ADMINS"> <span class="text-sm">新增管理員</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_EDIT_ADMINS"> <span class="text-sm">編輯管理員</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_DELETE_ADMINS"> <span class="text-sm">刪除管理員</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_LIST_SERVERS"> <span class="text-sm">檢視伺服器</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_ADD_SERVER"> <span class="text-sm">新增伺服器</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_EDIT_SERVERS"> <span class="text-sm">編輯伺服器</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_DELETE_SERVERS"> <span class="text-sm">刪除伺服器</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_ADD_BAN"> <span class="text-sm">新增封禁</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_EDIT_OWN_BANS"> <span class="text-sm">編輯自己的封禁</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_EDIT_GROUP_BANS"> <span class="text-sm">編輯同組封禁</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_EDIT_ALL_BANS"> <span class="text-sm">編輯所有封禁</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_UNBAN"> <span class="text-sm">解封所有封禁</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_UNBAN_OWN_BANS"> <span class="text-sm">解封自己的封禁</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_UNBAN_GROUP_BANS"> <span class="text-sm">解封同組封禁</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_DELETE_BAN"> <span class="text-sm">刪除所有封禁</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_BAN_PROTESTS"> <span class="text-sm">封禁申訴</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_BAN_SUBMISSIONS"> <span class="text-sm">封禁舉報</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_BAN_IMPORT"> <span class="text-sm">匯入封禁</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_LIST_GROUPS"> <span class="text-sm">檢視分組</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_ADD_GROUP"> <span class="text-sm">新增分組</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_EDIT_GROUPS"> <span class="text-sm">編輯分組</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_DELETE_GROUPS"> <span class="text-sm">刪除分組</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_WEB_SETTINGS"> <span class="text-sm">網頁設定</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_LIST_MODS"> <span class="text-sm">檢視模組</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_ADD_MODS"> <span class="text-sm">新增模組</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_EDIT_MODS"> <span class="text-sm">編輯模組</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_DELETE_MODS"> <span class="text-sm">刪除模組</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_NOTIFY_SUB"> <span class="text-sm">封禁舉報電子郵件通知</span></label>
                                        <label class="flex items-center gap-2"><input type="checkbox" data-flag="ADMIN_NOTIFY_PROTEST"> <span class="text-sm">封禁申訴電子郵件通知</span></label>
                                    </div>
                                </fieldset>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="flex justify-end gap-2">
                <button type="button" class="btn btn--ghost btn--sm"
                        onclick="history.go(-1);" data-testid="admin-add-back">返回</button>
                <button type="submit" class="btn btn--primary btn--sm" id="aadmin"
                        data-testid="admin-add-submit"><i data-lucide="user-plus"></i> 新增管理員</button>
            </div>
        </form>

        {* #1404 — the `{$server_script nofilter}` tail used to emit a
            server-built `<script>LoadServerHost('SID', 'id', 'saSID');…</script>`
            blob; the helper was deleted with `sourcebans.js` at #1123 D1
            so every page load raised `ReferenceError: LoadServerHost is
            not defined` once per server. #1404 dropped the dead blob +
            the orphan `$server_script` View property + the per-row
            `id="sa{$server.sid}"` span hook it targeted.

            #1405 — additive replacement: the per-row span above carries
            `[data-testid="server-host"]` + `data-fallback="<ip>:<port>"`
            and the wrapping grid div opts in via
            `data-server-hydrate="auto"` + `data-trunchostname="40"`. The
            shared helper (`<script src>` below, same one driving the
            public servers list / admin Server Management list / dashboard
            Servers widget) fires `Actions.ServersHostPlayers` per row
            and patches the live hostname via `sb.setHTML`. SourceQueryCache
            (~30s TTL per `(ip, port)`) coalesces the per-row probes
            server-side. *}

        {* ============================================================
           #1402 — Add-admin constructive form wiring.

           Replaces four dead JS helpers from sourcebans.js (#1123 D1):
             - `ProcessAddAdmin()` → submit handler that collects fields,
               builds the web-flag bitmask + server-flag string, fires
               sb.api.call(Actions.AdminsAdd, …) and dispatches errors
               into the per-field `.msg` slots.
             - `LoadGeneratePassword()` → click handler that calls
               Actions.AdminsGeneratePassword and writes the result
               into #password / #password2.
             - `update_server()` / `update_web()` → change handlers that
               reveal the conditional inputs on "Custom permissions" /
               "New admin group".

           All four were silent no-ops on v2.0 because the helpers
           lived in the deleted sourcebans.js: the form's
           `event.preventDefault()` swallowed every submit; the
           "Generate password" button did nothing; picking "Custom
           permissions" left the flag picker hidden, so an operator
           who tried to ride the form ended up POSTing nothing useful
           anyway.

           Constructive-form pattern mirrors `SbppGroupsAdd` in
           page_admin_groups_add.tpl (canonical reference from
           AGENTS.md "Add a confirm + reason modal …").
           ============================================================ *}
        {literal}
        <script>
        (function () {
            'use strict';

            /** @returns {{call: (a:string,p?:object)=>Promise<any>}|null} */
            function api()     { return (window.sb && window.sb.api) || null; }
            /** @returns {Record<string,string>|null} */
            function actions() { return /** @type {any} */ (window).Actions || null; }
            /** @returns {Record<string,number>|null} */
            function perms()   { return /** @type {any} */ (window).Perms || null; }
            function toast(kind, title, body) {
                var S = /** @type {any} */ (window).SBPP;
                if (S && typeof S.showToast === 'function') {
                    S.showToast({ kind: kind, title: title, body: body || '' });
                }
            }
            /**
             * Flip the busy / loading state on a triggered button. Calls
             * window.SBPP.setBusy when present (theme.js owns the spinner
             * CSS contract) and falls back to plain `disabled` so
             * third-party themes that strip theme.js still gate against
             * double-clicks.
             * @param {Element|null} btn
             * @param {boolean} [busy] defaults to true
             */
            function setBusy(btn, busy) {
                if (!btn) return;
                var S = /** @type {any} */ (window).SBPP;
                if (S && typeof S.setBusy === 'function') S.setBusy(btn, busy);
                else /** @type {HTMLButtonElement} */ (btn).disabled = busy === undefined ? true : !!busy;
            }

            /** @param {string} id @param {string} msg */
            function showMsg(id, msg) {
                var el = document.getElementById(id);
                if (!el) return;
                el.textContent = msg;
            }
            function clearAllMsgs() {
                ['name.msg', 'steam.msg', 'email.msg', 'password.msg', 'password2.msg',
                 'a_serverpass.msg', 'server.msg', 'web.msg',
                 'servername_err.msg', 'webname_err.msg'].forEach(function (id) {
                    var el = document.getElementById(id);
                    if (el) el.textContent = '';
                });
            }

            /**
             * Clear every web-flag checkbox inside #web-flags-block and
             * the SourceMod flags / new-group name text inputs. Called
             * by updateServer() / updateWeb() when the dropdown swings
             * back to a value that hides the dependent block. Pre-fix
             * (#1402 adversarial review HIGH 3), the helpers only
             * toggled the `hidden` attribute and left the inputs'
             * values intact, so an operator who ticked Owner under
             * "Custom permissions" and then flipped the dropdown to
             * "No permissions" still submitted `mask = ADMIN_OWNER`
             * (silent OWNER grant). Mirrored on both the web + server
             * sides.
             */
            function clearWebFlags() {
                document.querySelectorAll('#web-flags-block input[data-flag]').forEach(function (cb) {
                    /** @type {HTMLInputElement} */ (cb).checked = false;
                });
            }
            function clearServerFlags() {
                var srvFlags = /** @type {HTMLInputElement|null} */ (document.getElementById('server-flags'));
                if (srvFlags) srvFlags.value = '';
            }
            function clearWebNewName() {
                var el = /** @type {HTMLInputElement|null} */ (document.getElementById('web-new-name'));
                if (el) el.value = '';
            }
            function clearServerNewName() {
                var el = /** @type {HTMLInputElement|null} */ (document.getElementById('server-new-name'));
                if (el) el.value = '';
            }

            /**
             * update_server() replacement: react to #serverg change and
             * reveal the matching conditional inputs. Clears the
             * dependent blocks' values when the dropdown swings back
             * to a value that hides them (#1402 adversarial review
             * HIGH 3 — stale-flags ride-through fix).
             */
            function updateServer() {
                var sel = /** @type {HTMLSelectElement|null} */ (document.getElementById('serverg'));
                var nameBlock = document.getElementById('server-new-name-block');
                var flagsBlock = document.getElementById('server-flags-block');
                if (!sel || !nameBlock || !flagsBlock) return;
                var v = sel.value;
                if (v === 'n') {
                    nameBlock.removeAttribute('hidden');
                    flagsBlock.removeAttribute('hidden');
                } else if (v === 'c') {
                    nameBlock.setAttribute('hidden', '');
                    flagsBlock.removeAttribute('hidden');
                    clearServerNewName();
                } else {
                    nameBlock.setAttribute('hidden', '');
                    flagsBlock.setAttribute('hidden', '');
                    clearServerNewName();
                    clearServerFlags();
                }
            }
            /**
             * update_web() replacement: react to #webg change and reveal
             * the matching conditional inputs. Clears the dependent
             * blocks' values when the dropdown swings back to a value
             * that hides them (#1402 adversarial review HIGH 3 —
             * stale-flags ride-through fix; particularly important
             * because the OWNER bit lives here).
             */
            function updateWeb() {
                var sel = /** @type {HTMLSelectElement|null} */ (document.getElementById('webg'));
                var nameBlock = document.getElementById('web-new-name-block');
                var flagsBlock = document.getElementById('web-flags-block');
                if (!sel || !nameBlock || !flagsBlock) return;
                var v = sel.value;
                if (v === 'n') {
                    nameBlock.removeAttribute('hidden');
                    flagsBlock.removeAttribute('hidden');
                } else if (v === 'c') {
                    nameBlock.setAttribute('hidden', '');
                    flagsBlock.removeAttribute('hidden');
                    clearWebNewName();
                } else {
                    nameBlock.setAttribute('hidden', '');
                    flagsBlock.setAttribute('hidden', '');
                    clearWebNewName();
                    clearWebFlags();
                }
            }

            /**
             * Walk the web-flag checkboxes inside #web-flags-block and
             * OR-combine the matching Perms.ADMIN_* constants into one
             * integer mask. We use `+=` rather than `|=` to keep the
             * 32-bit-unsigned high bits intact (JS bitwise ops promote
             * to signed int32, which drops bits above 2^31).
             *
             * Defensively scopes to `#web-flags-block:not([hidden])`
             * so a checkbox the operator ticked under "Custom
             * permissions" and then re-hid by flipping the dropdown
             * back to "No permissions" can't ride into the mask even
             * if `clearWebFlags()` ever stops firing (#1402 adversarial
             * review HIGH 3 — belt + suspenders on top of the clear).
             * @returns {number}
             */
            function collectWebFlags() {
                var P = perms();
                if (!P) return 0;
                var mask = 0;
                document.querySelectorAll('#web-flags-block:not([hidden]) input[data-flag]').forEach(function (cb) {
                    var el = /** @type {HTMLInputElement} */ (cb);
                    if (!el.checked) return;
                    var flagName = el.getAttribute('data-flag') || '';
                    var bit = P[flagName];
                    if (typeof bit === 'number' && bit > 0) {
                        mask += bit;
                    }
                });
                return mask;
            }
            /**
             * Mirror of `collectWebFlags`'s defensive hidden-scoping
             * for the SourceMod flags string. Returns '' when the
             * server flags block is hidden so a stale value can't
             * ride into `srv_mask` after a dropdown flip.
             * @returns {string}
             */
            function collectServerFlags() {
                var flagsBlock = document.getElementById('server-flags-block');
                if (!flagsBlock || flagsBlock.hasAttribute('hidden')) return '';
                var el = /** @type {HTMLInputElement|null} */ (document.getElementById('server-flags'));
                return el ? el.value.trim() : '';
            }
            /**
             * Mirror of `collectWebFlags`'s defensive hidden-scoping
             * for the new-group name inputs.
             * @returns {string}
             */
            function collectWebNewName() {
                var block = document.getElementById('web-new-name-block');
                if (!block || block.hasAttribute('hidden')) return '';
                var el = /** @type {HTMLInputElement|null} */ (document.getElementById('web-new-name'));
                return el ? el.value.trim() : '';
            }
            function collectServerNewName() {
                var block = document.getElementById('server-new-name-block');
                if (!block || block.hasAttribute('hidden')) return '';
                var el = /** @type {HTMLInputElement|null} */ (document.getElementById('server-new-name'));
                return el ? el.value.trim() : '';
            }

            /**
             * Collect comma-separated `g<gid>` server-group selections.
             * `name="group[]"` was the legacy form's shape (post-v1.4.11)
             * — we collect to the same csv format api_admins_add expects
             * on its `servers` param.
             * @returns {string}
             */
            function collectServerGroups() {
                /** @type {string[]} */
                var out = [];
                document.querySelectorAll('input[name="group[]"]').forEach(function (cb) {
                    var el = /** @type {HTMLInputElement} */ (cb);
                    if (el.checked) out.push(el.value);
                });
                return out.join(',');
            }
            /**
             * Collect comma-separated `s<sid>` individual-server selections.
             * @returns {string}
             */
            function collectSingleServers() {
                /** @type {string[]} */
                var out = [];
                document.querySelectorAll('input[name="servers[]"]').forEach(function (cb) {
                    var el = /** @type {HTMLInputElement} */ (cb);
                    if (el.checked) out.push(el.value);
                });
                return out.join(',');
            }

            // ---------- Generate password ----------
            document.addEventListener('click', function (e) {
                var t = /** @type {Element|null} */ (e.target);
                if (!t || !t.closest) return;
                var btn = /** @type {HTMLElement|null} */ (t.closest('[data-action="admin-add-generate-password"]'));
                if (!btn) return;
                e.preventDefault();
                var a = api(), A = actions();
                if (!a || !A) return;
                setBusy(btn, true);
                a.call(A.AdminsGeneratePassword, {}).then(function (r) {
                    setBusy(btn, false);
                    if (!r || r.ok === false || !r.data || !r.data.password) return;
                    var p1 = /** @type {HTMLInputElement|null} */ (document.getElementById('password'));
                    var p2 = /** @type {HTMLInputElement|null} */ (document.getElementById('password2'));
                    if (p1) p1.value = String(r.data.password);
                    if (p2) p2.value = String(r.data.password);
                    // #1402 adversarial review MEDIUM 5: leave the input
                    // types as `password` (matches v1.x `LoadGeneratePassword`
                    // — the legacy helper never flipped .type either).
                    // The pre-fix `type='text'` change was a privacy /
                    // shoulder-surf / screenshot leak: the freshly-
                    // generated password sat in plaintext on the operator's
                    // screen indefinitely after the click, even after the
                    // operator left the field. Operators who genuinely
                    // need to see the value can copy it into their
                    // password manager from the password field's clipboard
                    // (browsers + extensions both support this) or use
                    // their browser's "show password" toggle on a per-
                    // field basis.
                }).catch(function (err) {
                    // sb.api.call only rejects on internal failures (it
                    // catches fetch / json errors and synthesises an
                    // error envelope), but defensive .catch() ensures the
                    // button doesn't stay busy if a throw escapes the
                    // success callback (e.g., DOM nodes vanished mid-
                    // request). Per the AGENTS.md "Loading state on
                    // action buttons" rule, setBusy(btn, false) must
                    // fire on every non-navigating response branch.
                    setBusy(btn, false);
                    toast('error', '生成密碼失敗', String(err && err.message ? err.message : err));
                });
            });

            // ---------- Server-group / web-group conditional UI ----------
            document.addEventListener('change', function (e) {
                var t = /** @type {Element|null} */ (e.target);
                if (!t) return;
                var action = t.getAttribute && t.getAttribute('data-action');
                if (action === 'admin-add-update-server') updateServer();
                else if (action === 'admin-add-update-web') updateWeb();
            });

            // ---------- Form submit ----------
            document.addEventListener('submit', function (e) {
                var form = /** @type {Element|null} */ (e.target);
                if (!form || form.id !== 'add-admin-form') return;
                e.preventDefault();
                clearAllMsgs();

                var a = api(), A = actions();
                if (!a || !A) return;

                var name = (/** @type {HTMLInputElement} */ (document.getElementById('adminname'))).value.trim();
                var steam = (/** @type {HTMLInputElement} */ (document.getElementById('steam'))).value.trim();
                var email = (/** @type {HTMLInputElement} */ (document.getElementById('email'))).value.trim();
                var password = (/** @type {HTMLInputElement} */ (document.getElementById('password'))).value;
                var password2 = (/** @type {HTMLInputElement} */ (document.getElementById('password2'))).value;
                var useSrvPass = !!(/** @type {HTMLInputElement} */ (document.getElementById('a_useserverpass'))).checked;
                var srvPassEl = /** @type {HTMLInputElement} */ (document.getElementById('a_serverpass'));
                var serverPassword = useSrvPass ? srvPassEl.value : '-1';
                var sg = (/** @type {HTMLSelectElement} */ (document.getElementById('serverg'))).value;
                var wg = (/** @type {HTMLSelectElement} */ (document.getElementById('webg'))).value;
                // #1402 adversarial review HIGH 3: collect via the
                // hidden-scoped helpers so a value left over from a
                // previously-revealed block can't ride into the API
                // call after the dropdown swung to "No permissions".
                // Both updateServer/updateWeb clear the inputs AND
                // these collectors fall through to '' when the parent
                // block is hidden — belt + suspenders.
                var serverNewName = collectServerNewName();
                var webNewName = collectWebNewName();
                var srvFlags = collectServerFlags();
                var webMask = collectWebFlags();

                var submitBtn = /** @type {HTMLButtonElement|null} */ (form.querySelector('[data-testid="admin-add-submit"]'));
                setBusy(submitBtn, true);

                a.call(A.AdminsAdd, {
                    name:            name,
                    steam:           steam,
                    email:           email,
                    password:        password,
                    password2:       password2,
                    server_password: serverPassword,
                    server_group:    sg,
                    web_group:       wg,
                    server_name:     serverNewName || '0',
                    web_name:        webNewName,
                    mask:            webMask,
                    srv_mask:        srvFlags,
                    servers:         collectServerGroups(),
                    single_servers:  collectSingleServers(),
                }).then(function (r) {
                    if (!r) { setBusy(submitBtn, false); return; }
                    if (r.redirect) return;
                    if (r.ok === false) {
                        setBusy(submitBtn, false);
                        var em = (r.error && r.error.message) || '未知錯誤';
                        var field = (r.error && r.error.field) || '';
                        // Map handler field codes to our `.msg` slot ids.
                        // `server` / `web` are the dropdown error slots;
                        // `servername_err` / `webname_err` are the new-group
                        // name input slots.
                        /** @type {Record<string,string>} */
                        var slotMap = {
                            'name': 'name.msg',
                            'steam': 'steam.msg',
                            'email': 'email.msg',
                            'password': 'password.msg',
                            'password2': 'password2.msg',
                            'a_serverpass': 'a_serverpass.msg',
                            'server': 'server.msg',
                            'web': 'web.msg',
                            'servername_err': 'servername_err.msg',
                            'webname_err': 'webname_err.msg'
                        };
                        var slot = slotMap[field] || 'name.msg';
                        showMsg(slot, em);
                        toast('error', '新增管理員失敗', em);
                        return;
                    }
                    var data = r.data || {};
                    var msg = data.message || {};
                    toast('success', msg.title || '管理員已新增', msg.body || '管理員已新增。');
                    // Surface the green "Admin added" card too (it was there
                    // pre-#1402 but never visible because the success branch
                    // was unreachable from a dead submit handler).
                    var green = document.getElementById('msg-green');
                    if (green) green.style.display = '';

                    // #1402 adversarial review HIGH 2: chain
                    // `Actions.SystemRehashAdmins` when the handler tells
                    // us the new admin's per-server access requires a
                    // rehash. The legacy ProcessAddAdmin path consumed
                    // `data.rehash`; the rewrite silently dropped it,
                    // which meant new admins could log in to the panel
                    // but couldn't moderate on game servers until the
                    // next server restart (config.enableadminrehashing
                    // defaults to '1' in data.sql — the rehash is the
                    // expected default behaviour). Mirrors the
                    // _admin_edit_helpers.php:fireRehash shape (same
                    // catch arm so a flaky rehash endpoint still resolves
                    // the navigation).
                    var rehashSids = (data.rehash || '').toString();
                    var navigate = function () {
                        // Leave the button busy across the navigation so
                        // the form can't be re-submitted while the redirect
                        // resolves.
                        setTimeout(function () {
                            window.location.href = (msg.redir || 'index.php?p=admin&c=admins');
                        }, 1200);
                    };
                    if (rehashSids && A.SystemRehashAdmins) {
                        a.call(A.SystemRehashAdmins, { servers: rehashSids })
                            .then(navigate)
                            .catch(navigate);
                        return;
                    }
                    navigate();
                }).catch(function (err) {
                    // Defensive: sb.api.call doesn't reject on network
                    // errors (it returns a synthetic envelope), but a
                    // throw escaping the success callback would otherwise
                    // leave the submit button busy forever. Per AGENTS.md
                    // "Loading state on action buttons" — setBusy(btn,
                    // false) on every non-navigating response branch.
                    setBusy(submitBtn, false);
                    toast('error', '新增管理員失敗', String(err && err.message ? err.message : err));
                });
            });

            // Initial mount: make sure the conditional blocks reflect the
            // current `<select>` values (e.g., a server-bounced re-render
            // that pre-selected "Custom permissions").
            try { updateServer(); updateWeb(); } catch (_e) { /* defensive */ }
        })();
        </script>
        {/literal}

        {*
            #1405 — per-tile A2S hydration for the "Individual servers"
            grid above. The shared helper auto-runs on first paint for
            every `[data-server-hydrate="auto"]` container, fires
            `Actions.ServersHostPlayers` per tile, and patches the live
            hostname into the row's `[data-testid="server-host"]` slot.
            This template only consumes the hostname cell — the rest of
            the helper's hydration surface (status pill / map / players
            bar / map-img / refresh / toggle / players panel) is
            feature-detected and silently no-ops on tiles that don't
            ship those testid hooks. Same mounting shape as
            `page_dashboard.tpl`'s Servers widget.

            `defer` lets the rest of the page paint before the helper
            boots; auto-run still fires once it does (the helper
            branches on `document.readyState`). The script ships under
            web/scripts/ so all four surfaces (public servers list,
            admin Server Management list, dashboard Servers widget, this
            Add Admin per-server access grid) share one helper file —
            never copy-paste the hydration code into a new template.
        *}
        <script src="./scripts/server-tile-hydrate.js" defer></script>
    {/if}
</div>
