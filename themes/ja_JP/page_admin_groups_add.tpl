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
    <div class="card"><div class="card__body"><p class="text-muted m-0">アクセス拒否</p></div></div>
{else}
{* #1266 — outer `.p-6` removed; the 1.5rem page inset now lives on
   `.admin-sidebar-shell` (the AdminTabs grid host). The `max-width:
   48rem` form clamp stays so the form column doesn't grow past a
   readable line length on wide viewports. *}
<div style="max-width:48rem">
    <div class="mb-4">
        <h1 style="font-size:var(--fs-2xl);font-weight:600;margin:0">グループを作成</h1>
        <p class="text-sm text-muted m-0 mt-2">名前とタイプを選択してください。グループ作成後は<strong>グループ一覧</strong>タブで権限フラグを編集できます。</p>
    </div>
    <form class="card"
          method="post"
          action="?p=admin&c=groups"
          data-testid="add-group-form"
          onsubmit="return SbppGroupsAdd(event);">
        {csrf_field}
        <div class="card__body space-y-4">
            <div>
                <label class="label" for="add-group-name">グループ名</label>
                <input class="input"
                       id="add-group-name"
                       name="name"
                       data-testid="add-group-name"
                       autocomplete="off"
                       placeholder="例：シニア管理者"
                       required>
                <p class="text-xs text-muted m-0 mt-2">一意である必要があります。カンマは使用できません。</p>
            </div>

            <div>
                <label class="label" for="add-group-type">グループタイプ</label>
                <select class="select"
                        id="add-group-type"
                        name="type"
                        data-testid="add-group-type"
                        onchange="SbppGroupsAddTypeChanged(this);">
                    <option value="0">選択してください &hellip;</option>
                    <option value="1">ウェブ管理者グループ</option>
                    <option value="2">サーバー管理者グループ</option>
                    <option value="3">サーバーグループ</option>
                </select>
                <p class="text-xs text-muted m-0 mt-2">ウェブ管理者 = パネル権限。サーバー管理者 = SourceMod 文字フラグ。サーバーグループ = ゲームサーバーのグループ化。</p>
            </div>

            <div data-testid="add-group-srvflags-block" id="add-group-srvflags-block" style="display:none">
                <label class="label" for="add-group-srvflags">SourceMod フラグと免責</label>
                <input class="input"
                       id="add-group-srvflags"
                       name="srvflags"
                       data-testid="add-group-srvflags"
                       autocomplete="off"
                       placeholder="例：abz#50">
                <p class="text-xs text-muted m-0 mt-2">SourceMod フラグ文字列。免責を設定するには <code>#&lt;immunity&gt;</code> を追加してください（デフォルトは 0）。</p>
            </div>
        </div>
        <div class="card__header" style="border-top:1px solid var(--border);border-bottom:0;justify-content:flex-end">
            <div class="flex gap-2">
                <a class="btn btn--ghost" href="?p=admin&c=groups&section=list" data-testid="add-group-cancel">キャンセル</a>
                <button class="btn btn--primary" type="submit" data-testid="add-group-submit">グループを作成</button>
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
            var em = (r.error && r.error.message) || '不明なエラー';
            if (window.SBPP && typeof window.SBPP.showToast === 'function') {
                window.SBPP.showToast({ kind: 'error', title: 'エラー', body: em });
            } else {
                sb.message.error('エラー', em);
            }
            return;
        }
        var data = r.data || {};
        var body = (data.message && data.message.body) || 'グループが追加されました。';
        var title = (data.message && data.message.title) || 'グループが追加されました';
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
