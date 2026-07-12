{*
    SourceBans++ 2026 — page_admin.tpl

    Admin landing page (?p=admin with no c=…). Replaces the A1 stub
    with the canonical 8-card grid from the AdminPanelView mockup
    (handoff/ui_kits/webpanel-2026/views.jsx). Pair:
    web/pages/page.admin.php → web/includes/View/AdminHomeView.php.

    The page-builder route (`case 'admin':` default in
    web/includes/page-builder.php) gates the page itself on
    CheckAdminAccess(ALL_WEB), so anyone landing here already holds
    *some* web flag. This template's job is to gate the per-area
    cards so an admin only sees the cards that match the sub-routes
    they can actually open.

    Cards are gated by composite $can_<area> booleans precomputed by
    the page handler from Sbpp\View\Perms::for($userbank). Each gate
    OR's together the underlying ADMIN_* flags the legacy router
    requires for that sub-route (see page-builder.php), so a card
    visible here implies the router will let the user through —
    "card visible but route 403's" can't drift between the two.

    Comms folds into the sidebar nav (admin/comms) per the mockup,
    not a card here. Audit is owner-gated and points at the live
    `c=audit` route (admin.audit.php), introduced ahead of this
    landing's redesign. The legacy router's `default:` case now
    returns a 404 for any unrecognised c=… (#1207 ADM-1), so a
    typo'd href would surface visibly rather than silently
    rendering this same landing.

    Testability hooks per the issue's "Testability hooks" rule:
      - card grid carries role="list" + aria-label
      - each card carries data-testid="admin-card-<area>"
      - active sidebar item is set by core/navbar.tpl, not here

    Card styles live in a literal-wrapped <style> block at the bottom
    so the Phase B "Don't touch ../css/*.css" rule is honoured (the
    shell tokens — --bg-surface, --border, --accent, etc. — come from
    web/themes/sbpp2026/css/theme.css unchanged). Paired
    {literal}…{/literal} prevents Smarty from interpreting CSS braces
    as tags, matching the convention used by page_lostpassword.tpl.
*}
<section class="admin-home">
    <header class="admin-home__header mb-6">
        <h1 class="admin-home__title">管理面板</h1>
        <p class="admin-home__subtitle text-sm text-muted mt-2">管理管理員、分組、伺服器及面板設定。</p>
    </header>

    <ul class="admin-cards" role="list" aria-label="管理區域">
        {if $can_admins}
            <li>
                <a class="admin-card"
                   href="index.php?p=admin&amp;c=admins"
                   data-testid="admin-card-admins">
                    <div class="admin-card__icon" aria-hidden="true"><i data-lucide="users"></i></div>
                    <div class="admin-card__title">管理員</div>
                    <div class="admin-card__desc">檢視、新增、編輯及移除面板管理員。</div>
                </a>
            </li>
        {/if}

        {if $can_groups}
            <li>
                <a class="admin-card"
                   href="index.php?p=admin&amp;c=groups"
                   data-testid="admin-card-groups">
                    <div class="admin-card__icon" aria-hidden="true"><i data-lucide="shield-check"></i></div>
                    <div class="admin-card__title">分組</div>
                    <div class="admin-card__desc">管理員的權限與免禁分組。</div>
                </a>
            </li>
        {/if}

        {if $can_servers}
            <li>
                <a class="admin-card"
                   href="index.php?p=admin&amp;c=servers"
                   data-testid="admin-card-servers">
                    <div class="admin-card__icon" aria-hidden="true"><i data-lucide="server"></i></div>
                    <div class="admin-card__title">伺服器</div>
                    <div class="admin-card__desc">SourceBans++ 連接的遊戲伺服器。</div>
                </a>
            </li>
        {/if}

        {if $can_bans}
            <li>
                <a class="admin-card"
                   href="index.php?p=admin&amp;c=bans"
                   data-testid="admin-card-bans">
                    <div class="admin-card__icon" aria-hidden="true"><i data-lucide="ban"></i></div>
                    <div class="admin-card__title">封禁</div>
                    <div class="admin-card__desc">新增封禁、審核舉報與申訴。</div>
                </a>
            </li>
        {/if}

        {if $can_mods}
            <li>
                <a class="admin-card"
                   href="index.php?p=admin&amp;c=mods"
                   data-testid="admin-card-mods">
                    <div class="admin-card__icon" aria-hidden="true"><i data-lucide="puzzle"></i></div>
                    <div class="admin-card__title">模組</div>
                    <div class="admin-card__desc">在面板中顯示的遊戲/模組項目。</div>
                </a>
            </li>
        {/if}

        {if $can_overrides}
            <li>
                {* The overrides editor is the `?section=overrides` slice of
                   admin.admins.php's c=admins route — admin.overrides.php
                   is `require`d there. Pre-#1275 this used a `#overrides`
                   fragment to anchor inside a long-scroll page; #1275
                   unified admin-admins on Pattern A so the editor has its
                   own URL. *}
                <a class="admin-card"
                   href="index.php?p=admin&amp;c=admins&amp;section=overrides"
                   data-testid="admin-card-overrides">
                    <div class="admin-card__icon" aria-hidden="true"><i data-lucide="key-round"></i></div>
                    <div class="admin-card__title">覆寫</div>
                    <div class="admin-card__desc">覆寫每個伺服器或分組的 SourceMod 命令旗標。</div>
                </a>
            </li>
        {/if}

        {if $can_settings}
            <li>
                <a class="admin-card"
                   href="index.php?p=admin&amp;c=settings"
                   data-testid="admin-card-settings">
                    <div class="admin-card__icon" aria-hidden="true"><i data-lucide="settings"></i></div>
                    <div class="admin-card__title">設定</div>
                    <div class="admin-card__desc">SMTP、主題與整合設定。</div>
                </a>
            </li>
        {/if}

        {if $can_audit}
            <li>
                <a class="admin-card"
                   href="index.php?p=admin&amp;c=audit"
                   data-testid="admin-card-audit">
                    <div class="admin-card__icon" aria-hidden="true"><i data-lucide="scroll-text"></i></div>
                    <div class="admin-card__title">稽核日誌</div>
                    <div class="admin-card__desc">面板上的管理員操作。</div>
                </a>
            </li>
        {/if}
    </ul>
</section>

{literal}
<style>
    .admin-home { max-width: 1400px; padding: 1rem; }
    @media (min-width: 640px) { .admin-home { padding: 1.5rem; } }
    .admin-home__title {
        font-size: var(--fs-2xl);
        font-weight: 600;
        letter-spacing: -0.02em;
        color: var(--text);
        margin: 0;
    }
    .admin-home__subtitle { margin-bottom: 0; }

    .admin-cards {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(15rem, 1fr));
        gap: 1rem;
        list-style: none;
        margin: 0;
        padding: 0;
    }
    /* #1207 ADM-10: at <768px the auto-fill grid above only fits a
       single 15rem column so the 8 admin cards stack vertically and
       produce a long scroll. Force 2 columns at mobile instead — at
       the iPhone-13's 375px viewport this lands ~165px-wide cards
       (full-width minus 1rem body padding minus 0.75rem gap, halved)
       with ~120px+ height each (2.25rem icon + 1.25rem padding +
       title + description), well above the 44x44 tap-target floor.
       Tablet (768–1023px) and desktop (>=1024px) keep the auto-fill
       behaviour above so wider viewports still get 2-3-4 columns
       depending on how much sidebar-less width is available. */
    @media (max-width: 767.98px) {
        .admin-cards {
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 0.75rem;
        }
    }

    .admin-card {
        display: block;
        background: var(--bg-surface);
        border: 1px solid var(--border);
        border-radius: var(--radius-xl);
        padding: 1.25rem;
        color: var(--text);
        text-decoration: none;
        transition: border-color .15s ease, box-shadow .15s ease, transform .15s ease;
    }
    .admin-card:hover {
        border-color: var(--zinc-300);
        box-shadow: var(--shadow);
    }
    html.dark .admin-card:hover { border-color: var(--zinc-700); }
    .admin-card:focus-visible {
        outline: 2px solid var(--accent);
        outline-offset: 2px;
    }

    .admin-card__icon {
        width: 2.25rem;
        height: 2.25rem;
        border-radius: var(--radius-lg);
        background: var(--bg-muted);
        color: var(--text);
        display: grid;
        place-items: center;
        margin-bottom: 0.75rem;
    }
    .admin-card__icon i { width: 1rem; height: 1rem; }

    .admin-card__title {
        font-size: var(--fs-base);
        font-weight: 600;
        color: var(--text);
    }
    .admin-card__desc {
        font-size: var(--fs-xs);
        color: var(--text-muted);
        margin-top: 0.25rem;
        line-height: 1.5;
    }
</style>
{/literal}
