{*
    SourceBans++ 2026 — page_admin_bans_submissions_archiv.tpl
    Bound to Sbpp\View\AdminBansSubmissionsArchivView (validated by SmartyTemplateRule).

    Archived ban submissions. Same shape as the current-queue template
    plus the "Archived because" banner and the archivedby attribution
    that admin.bans.php attaches to each row. Action set differs:

      - archiv 0/1: Ban (re-open into the Add Ban form), Restore
        (archiv=2 → put back in queue), Delete (archiv=0 → drop the row).
      - archiv 2/3: only Delete + Contact (already accepted/rejected).

    Row id `asid_<subid>` is preserved for legacy callers that still
    look it up by id.
*}
{if NOT $permissions_submissions}
    <div class="card" data-testid="submissions-archive-denied">
        <div class="card__body">
            <h1 style="font-size:1.25rem;font-weight:600;margin:0">Zugriff verweigert</h1>
            <p class="text-sm text-muted m-0 mt-2">Sie haben keine Berechtigung, Bann-Einreichungen anzusehen.</p>
        </div>
    </div>
{else}
    <section class="p-6" data-testid="submissions-archive-section" style="max-width:1400px">
        <div class="flex items-center justify-between gap-4 mb-4" style="flex-wrap:wrap">
            <div>
                <h1 style="font-size:1.5rem;font-weight:600;margin:0">
                    Archiv der Bann-Einreichungen
                    <span class="text-sm text-muted" style="font-weight:400">
                        (<span id="subcountarchiv" data-testid="submissions-archive-count">{$submission_count_archiv}</span>)
                    </span>
                </h1>
                <p class="text-sm text-muted m-0 mt-2">
                    Einreichungen, die archiviert, angenommen oder abgelehnt wurden.
                </p>
            </div>
            <div class="text-xs text-muted" data-testid="submissions-archive-nav">
                {* nofilter: $asubmission_nav is server-built pagination HTML from admin.bans.php with no $_GET interpolation in this branch. *}
                {$asubmission_nav nofilter}
            </div>
        </div>

        {if $submission_list_archiv|@count == 0}
            {* #1207 empty-state unification — read-only / closed-loop
               surface (accepted / rejected / archived rows live here),
               so no CTA. Kept the testid hook for any spec watching for
               the archive's empty state. *}
            <div class="card" data-testid="submissions-archive-empty">
                <div class="empty-state">
                    <span class="empty-state__icon" aria-hidden="true">
                        <i data-lucide="archive" style="width:18px;height:18px"></i>
                    </span>
                    <h2 class="empty-state__title">Einreichungsarchiv ist leer</h2>
                    <p class="empty-state__body">Sobald Einreichungen angenommen, abgelehnt oder archiviert wurden, werden sie hier zur Aufbewahrung verschoben.</p>
                </div>
            </div>
        {else}
            <div class="card" style="overflow:hidden" data-testid="submissions-archive-list">
                {foreach from=$submission_list_archiv item="sub"}
                    {* PUB-2 (#1207): `queue-row` is the layout class; see
                       the `.queue-row` block in theme.css. `ban-row--expired`
                       keeps the gray state-border. *}
                    <details class="queue-row ban-row ban-row--expired"
                             id="asid_{$sub.subid}"
                             data-testid="submission-archive-row"
                             data-id="{$sub.subid}"
                             style="border-bottom:1px solid var(--border)">
                        <summary>
                            <div class="queue-row__body">
                                <div class="font-medium text-sm truncate" data-testid="submission-archive-row-name">
                                    {* nofilter: sub.name is wordwrap(htmlspecialchars($sub['name']), 55, "<br />", true) — already entity-escaped in admin.bans.php. *}
                                    {$sub.name nofilter}
                                </div>
                                <div class="font-mono text-xs text-muted truncate" data-testid="submission-archive-row-steam">
                                    {if $sub.SteamId != ""}{$sub.SteamId|escape}{else}{$sub.sip|escape}{/if}
                                </div>
                            </div>
                            <div class="queue-row__date">
                                {$sub.submitted|escape}
                            </div>
                            <div class="row-actions">
                                {if $sub.archiv != "2" AND $sub.archiv != "3"}
                                    <button type="button"
                                            class="btn btn--secondary btn--sm"
                                            data-testid="row-action-ban"
                                            data-action="submission-ban"
                                            data-subid="{$sub.subid}">
                                        Bannen
                                    </button>
                                    {if $permissions_editsub}
                                        <button type="button"
                                                class="btn btn--ghost btn--sm"
                                                data-testid="row-action-restore"
                                                data-action="submission-archive-toggle"
                                                data-subid="{$sub.subid}"
                                                data-name="{$sub.name|smarty_stripslashes|escape}"
                                                data-archiv="2">
                                            Wiederherstellen
                                        </button>
                                    {/if}
                                {/if}
                                {if $permissions_editsub}
                                    <button type="button"
                                            class="btn btn--ghost btn--sm"
                                            data-testid="row-action-delete"
                                            data-action="submission-archive-toggle"
                                            data-subid="{$sub.subid}"
                                            data-name="{$sub.name|smarty_stripslashes|escape}"
                                            data-archiv="0"
                                            style="color:var(--danger)">
                                        Löschen
                                    </button>
                                {/if}
                                <a class="btn btn--ghost btn--sm"
                                   data-testid="row-action-contact"
                                   href="index.php?p=admin&c=bans&o=email&type=s&id={$sub.subid|escape:'url'}">
                                    Kontakt
                                </a>
                            </div>
                        </summary>

                        <div class="p-4" style="background:var(--bg-muted);border-top:1px solid var(--border)">
                            <div class="text-sm font-medium mb-3">
                                Archiviert, weil {$sub.archive|escape}
                            </div>
                            <div class="grid gap-4" style="grid-template-columns:2fr 1fr">
                                <dl class="text-sm" style="margin:0;display:grid;grid-template-columns:auto 1fr;gap:0.375rem 0.75rem">
                                    <dt class="text-muted">Spieler</dt>
                                    {* nofilter: sub.name is wordwrap(htmlspecialchars(...))-encoded in admin.bans.php. *}
                                    <dd class="font-medium" style="margin:0">{$sub.name nofilter}</dd>

                                    <dt class="text-muted">Eingereicht</dt>
                                    <dd style="margin:0">{$sub.submitted|escape}</dd>

                                    <dt class="text-muted">Steam-ID</dt>
                                    <dd class="font-mono" style="margin:0">
                                        {if $sub.SteamId == ""}<span class="text-faint">keine Steam-ID vorhanden</span>{else}{$sub.SteamId|escape}{/if}
                                    </dd>

                                    <dt class="text-muted">IP</dt>
                                    <dd class="font-mono" style="margin:0">
                                        {if $sub.sip == ""}<span class="text-faint">keine IP-Adresse vorhanden</span>{else}{$sub.sip|escape}{/if}
                                    </dd>

                                    <dt class="text-muted">Grund</dt>
                                    {* nofilter: sub.reason is wordwrap(htmlspecialchars($sub['reason']), 55, "<br />", true) — already entity-escaped in admin.bans.php. *}
                                    <dd style="margin:0">{$sub.reason nofilter}</dd>

                                    <dt class="text-muted">Server</dt>
                                    <dd style="margin:0" id="suba{$sub.subid}">
                                        {if $sub.hostname == ""}
                                            <i class="text-faint">Hostname wird abgerufen</i>
                                        {else}
                                            {* nofilter: sub.hostname is the literal `<i><font color="#677882">Other server...</font></i>` HTML emitted by admin.bans.php for non-tracked servers — server-controlled, no user input. *}
                                            {$sub.hostname nofilter}
                                        {/if}
                                    </dd>

                                    <dt class="text-muted">MOD</dt>
                                    <dd style="margin:0">{$sub.mod|escape}</dd>

                                    <dt class="text-muted">Einreichender</dt>
                                    <dd style="margin:0">
                                        {if $sub.subname == ""}<span class="text-faint">kein Name vorhanden</span>{else}{$sub.subname|escape}{/if}
                                    </dd>

                                    <dt class="text-muted">IP des Einreichenden</dt>
                                    <dd class="font-mono" style="margin:0">{$sub.ip|escape}</dd>

                                    <dt class="text-muted">Archiviert von</dt>
                                    <dd style="margin:0">
                                        {if !empty($sub.archivedby)}{$sub.archivedby|escape}{else}<i class="text-faint">Administrator gelöscht.</i>{/if}
                                    </dd>
                                </dl>

                                <ul class="text-sm" style="list-style:none;padding:0;margin:0;display:flex;flex-direction:column;gap:0.375rem">
                                    {* nofilter: sub.demo is server-built `<a href="getdemo.php?id={URLENCODED INT}…">` HTML, sub.subaddcomment is CreateLinkR-built; no user input. *}
                                    <li>{$sub.demo nofilter}</li>
                                    <li>{$sub.subaddcomment nofilter}</li>
                                </ul>
                            </div>

                            {if $sub.commentdata != "None"}
                                <div class="mt-4">
                                    <h4 class="text-xs text-muted" style="font-weight:600;margin:0 0 0.5rem;text-transform:uppercase;letter-spacing:0.06em">Kommentare</h4>
                                    <div class="space-y-3">
                                        {foreach from=$sub.commentdata item=commenta}
                                            <div class="card p-4">
                                                <div class="flex items-center justify-between gap-2 text-xs text-muted mb-2">
                                                    <strong style="color:var(--text);font-weight:600">
                                                        {if !empty($commenta.comname)}{$commenta.comname|escape}{else}<i class="text-faint">Administrator gelöscht</i>{/if}
                                                    </strong>
                                                    <span class="flex items-center gap-2">
                                                        <span>{$commenta.added|escape}</span>
                                                        {if $commenta.editcomlink != ""}
                                                            {* nofilter: editcomlink/delcomlink are CreateLinkR-built `<a … onclick="…">` HTML from admin.bans.php with integer cid + literal subid; no user input. *}
                                                            <span>{$commenta.editcomlink nofilter} {$commenta.delcomlink nofilter}</span>
                                                        {/if}
                                                    </span>
                                                </div>
                                                <div class="text-sm" style="word-break:break-all;word-wrap:break-word">
                                                    {* nofilter: commenttxt passes through encodePreservingBr (htmlspecialchars per-segment, only `<br/>` survives) + URL-wrap regex on already-escaped text in admin.bans.php. *}
                                                    {$commenta.commenttxt nofilter}
                                                </div>
                                                {if !empty($commenta.edittime)}
                                                    <div class="text-xs text-faint mt-2">
                                                        zuletzt bearbeitet {$commenta.edittime|escape} von
                                                        {if !empty($commenta.editname)}{$commenta.editname|escape}{else}<i>Administrator gelöscht</i>{/if}
                                                    </div>
                                                {/if}
                                            </div>
                                        {/foreach}
                                    </div>
                                </div>
                            {else}
                                <div class="text-xs text-faint mt-3">{$sub.commentdata|escape}</div>
                            {/if}
                        </div>
                    </details>
                {/foreach}
            </div>
        {/if}
    </section>
{/if}
{* Inline action wiring: Ban prefills the Add Ban form via Actions.BansSetupBan,
   Restore/Delete dispatch Actions.SubmissionsRemove with archiv=2/0. The
   `submission-ban` data-action is also handled by the inline script in the
   sibling current-queue template, so we declare a separate one here to
   avoid double-binding; both templates are rendered on the same page. *}
{literal}
<script>
(function () {
    'use strict';
    function api() { return (window.sb && window.sb.api) || null; }
    function actions() { return window.Actions || null; }
    function toast(kind, title, body) {
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
        var btn = t.closest('[data-action="submission-archive-toggle"]');
        if (!btn) return;
        e.preventDefault();
        var sid = Number(btn.dataset.subid);
        var name = btn.dataset.name || ('submission #' + sid);
        var archiv = btn.dataset.archiv || '0';
        var msg;
        if (archiv === '2') msg = 'Die Bann-Einreichung für "' + name + '" aus dem Archiv wiederherstellen?';
        else if (archiv === '1') msg = 'Die Bann-Einreichung für "' + name + '" ins Archiv verschieben?';
        else msg = 'Die Bann-Einreichung für "' + name + '" löschen?';
        if (!window.confirm(msg)) return;
        var a = api(), A = actions();
        if (!a || !A || !Number.isFinite(sid)) return;
        setBusy(btn, true);
        a.call(A.SubmissionsRemove, { sid: sid, archiv: archiv }).then(function (r) {
            if (!r || r.ok === false) {
                setBusy(btn, false);
                toast('error', 'Aktion fehlgeschlagen', (r && r.error && r.error.message) || 'Unbekannter Fehler');
                return;
            }
            var node = document.getElementById('asid_' + sid);
            if (node && node.parentNode) node.parentNode.removeChild(node);
            var counter = document.getElementById('subcountarchiv');
            if (counter) counter.textContent = String(Math.max(0, Number(counter.textContent) - 1));
            toast('success', 'Erledigt', 'Archiv aktualisiert.');
        });
    });
})();
</script>
{/literal}
