{*
    SourceBans++ 2026 — page_admin_groups_add.tpl

    "Add a group" tab. Plain card form: name + type + (type-dependent
    extras). Mirrors the legacy add form's behaviour — the lazy-loaded
    flag selector lives on the master-detail editor in the list tab
    (#1123 B12), so this form intentionally stays minimal.

    The form posts via `sb.api.call(Actions.GroupsAdd, …)`; the
    {csrf_field} hidden input is included so an unsupported-JS
    fallback would still ship a valid token if a future change wires
    a server-side POST handler. State updates currently flow through
    the existing JSON API.
*}
{if NOT $permission_addgroup}
    <div class="card"><div class="card__body"><p class="text-muted m-0">访问被拒绝。</p></div></div>
{else}
{* #1266 — outer `.p-6` removed; the 1.5rem page inset now lives on
   `.admin-sidebar-shell` (the AdminTabs grid host). The `max-width:
   48rem` form clamp stays so the form column doesn't grow past a
   readable line length on wide viewports. *}
<div style="max-width:48rem">
    <div class="mb-4">
        <h1 style="font-size:var(--fs-2xl);font-weight:600;margin:0">创建分组</h1>
        <p class="text-sm text-muted m-0 mt-2">选择名称和类型。分组创建后可在<strong>列分组</strong>选项卡中编辑权限标志。</p>
    </div>
    <form class="card"
          method="post"
          action="?p=admin&c=groups"
          data-testid="add-group-form"
          onsubmit="return SbppGroupsAdd(event);">
        {csrf_field}
        <div class="card__body space-y-4">
            <div>
                <label class="label" for="add-group-name">分组名称</label>
                <input class="input"
                       id="add-group-name"
                       name="name"
                       data-testid="add-group-name"
                       autocomplete="off"
                       placeholder="例如：高级管理员"
                       required>
                <p class="text-xs text-muted m-0 mt-2">必须唯一，不能包含逗号。</p>
            </div>

            <div>
                <label class="label" for="add-group-type">分组类型</label>
                <select class="select"
                        id="add-group-type"
                        name="type"
                        data-testid="add-group-type"
                        onchange="SbppGroupsAddTypeChanged(this);">
                    <option value="0">请选择 &hellip;</option>
                    <option value="1">网页管理员分组</option>
                    <option value="2">服务器管理员分组</option>
                    <option value="3">服务器分组</option>
                </select>
                <p class="text-xs text-muted m-0 mt-2">网页管理员 = 面板权限。服务器管理员 = SourceMod 字符标志。服务器分组 = 游戏服务器的集合。</p>
            </div>

            <div data-testid="add-group-srvflags-block" id="add-group-srvflags-block" style="display:none">
                <label class="label" for="add-group-srvflags">SourceMod 标志与免疫</label>
                <input class="input"
                       id="add-group-srvflags"
                       name="srvflags"
                       data-testid="add-group-srvflags"
                       autocomplete="off"
                       placeholder="例如：abz#50">
                <p class="text-xs text-muted m-0 mt-2">SourceMod 标志字符串。追加 <code>#&lt;immunity&gt;</code> 设置免疫（默认为 0）。</p>
            </div>
        </div>
        <div class="card__header" style="border-top:1px solid var(--border);border-bottom:0;justify-content:flex-end">
            <div class="flex gap-2">
                <a class="btn btn--ghost" href="?p=admin&c=groups&section=list" data-testid="add-group-cancel">取消</a>
                <button class="btn btn--primary" type="submit" data-testid="add-group-submit">创建分组</button>
            </div>
        </div>
    </form>
</div>

<script>
{literal}
function SbppGroupsAddTypeChanged(sel) {
    var srvBlock = sb.$id('add-group-srvflags-block');
    if (!srvBlock) return;
    srvBlock.style.display = (sel.value === '2') ? 'block' : 'none';
}

// Local wrapper around window.SBPP.setBusy with a `disabled`-only fallback
// so a third-party theme that strips theme.js still gates against double-clicks.
function SbppGroupsAddSetBusy(btn, busy) {
    if (!btn) return;
    var S = window.SBPP;
    if (S && typeof S.setBusy === 'function') S.setBusy(btn, busy);
    else btn.disabled = busy === undefined ? true : !!busy;
}

function SbppGroupsAdd(event) {
    event.preventDefault();
    var form = event.target;
    var name = form.querySelector('input[name="name"]').value.trim();
    var type = form.querySelector('select[name="type"]').value;
    var srvflagsEl = form.querySelector('input[name="srvflags"]');
    var srvflags = srvflagsEl ? srvflagsEl.value : '';
    var submitBtn = form.querySelector('[data-testid="add-group-submit"]');
    SbppGroupsAddSetBusy(submitBtn, true);
    sb.api.call(Actions.GroupsAdd, {
        name: name,
        type: type,
        bitmask: 0,
        srvflags: srvflags
    }).then(function (r) {
        // Inlined sourcebans.js helper (#1123 D1 prep): applyApiResponse is removed at D1.
        // sb.api.call already follows r.redirect natively, so we only need to surface
        // the success/error toast. SBPP.showToast (theme.js) takes {kind,title,body};
        // sb.message is the legacy fallback (no-ops under sbpp2026 since #dialog-* is
        // legacy-default-only, but kept so a third-party theme that never wired SBPP
        // still gets some signal).
        if (!r) { SbppGroupsAddSetBusy(submitBtn, false); return; }
        if (r.redirect) return;
        SbppGroupsAddSetBusy(submitBtn, false);
        if (r.ok === false) {
            var em = (r.error && r.error.message) || '未知错误';
            if (window.SBPP && typeof window.SBPP.showToast === 'function') {
                window.SBPP.showToast({ kind: 'error', title: '错误', body: em });
            } else {
                sb.message.error('错误', em);
            }
            return;
        }
        var data = r.data || {};
        var body = (data.message && data.message.body) || '分组已添加。';
        var title = (data.message && data.message.title) || '分组已添加';
        if (window.SBPP && typeof window.SBPP.showToast === 'function') {
            window.SBPP.showToast({ kind: 'success', title: title, body: body });
        } else {
            sb.message.success(title, body, data.message ? data.message.redir : '');
        }
        if (data.reload) {
            // Re-arm before the reload so a stale render briefly shows the
            // disabled state, then leaves the form re-enabled if reload fails.
            SbppGroupsAddSetBusy(submitBtn, true);
            setTimeout(function () { window.location.reload(); }, 2000);
        }
    });
    return false;
}
{/literal}
</script>
{/if}
