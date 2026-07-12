{*
    SourceBans++ 2026 — chrome / navbar.tpl

    Sidebar nav. Pair: web/pages/core/navbar.php (assigns $navbar,
    $adminbar, $isAdmin, $login, $username — same contract as
    web/themes/default/core/navbar.tpl). The $navbar / $adminbar
    arrays come from navbar.php unchanged; this template just reskins
    the legacy <div id="tabs"> markup as the new collapsible sidebar.

    Endpoint→icon mapping is inline because the chrome PHP files
    intentionally don't grow new fields in this PR (variable contract
    is locked per A2; B/C tickets touch their own templates). The
    {if/elseif} chain keeps the data flow PHP→template untouched.

    Interactive surfaces carry data-testid + ARIA per the issue's
    "Testability hooks" rule. The <nav> wrapper carries
    role="navigation" + aria-label; each link gets data-testid
    "nav-<endpoint>" and aria-current="page" when active.
*}
<aside class="sidebar" id="sidebar" data-mobile-open="false">
    {* #1271 — `data-testid="sidebar-brand"` is the canonical hook for
       the user-visible canary in the sidebar-sticky regression test
       (`web/tests/e2e/specs/responsive/sidebar-sticky.spec.ts`). The
       brand is the first element to scroll off the top if sticky
       drifts up by `footerHeight`, so anchoring the spec on this
       testid (rather than the `.sidebar__brand` class chain) keeps
       the assertion compliant with AGENTS.md's "Selectors must use
       testability hooks; never CSS class chains as the primary
       selector" rule.

       #1235 — the brand mark renders the operator-configurable
       `template.logo` setting (Admin → Settings → General → Logo
       path), resolved relative to the active theme's directory.
       `$logo` is assigned by `core/header.php` (which runs before
       this template per page-builder.php's lifecycle:
       header → navbar → title → page → footer), so it's always in
       scope here. Default ships as `images/favicon.svg` — the
       canonical SourceBans++ shield-with-cross mark from the
       favicon set; admins can repoint at any theme-relative path
       (PNG / SVG / etc). The setting was vestigial in v2.0 until
       this PR wired it back in; sees `web/updater/data/809.php`
       for the upgrade-path migration that converts the v1.x
       `logos/sb-large.png` default forward. *}
    <div class="sidebar__brand" data-testid="sidebar-brand">
        {* #1480 — `data-testid="brand-mark"` lets the
           `brand-mark-resolution.spec.ts` E2E spec anchor on the
           rendered `<img>` element without relying on the
           `sidebar__brand-mark` CSS class chain (per AGENTS.md
           "selectors must use testability hooks"). Mirror on
           `page_login.tpl`'s sign-in card so one selector covers
           both render paths. *}
        <img class="sidebar__brand-mark" data-testid="brand-mark" src="{$theme_url}/{$logo}" alt="">
        <div>
            <div class="font-semibold text-sm">SourceBans++</div>
        </div>
    </div>
    <nav class="sidebar__nav" role="navigation" aria-label="主導航">
        <div class="sidebar__section">
            <div class="sidebar__section-label">公共</div>
            {foreach from=$navbar item=nav}
                {if $nav.endpoint != 'admin'}
                    <a class="sidebar__link"
                       href="index.php?p={$nav.endpoint}"
                       data-testid="nav-{$nav.endpoint}"
                       title="{if $nav.endpoint == 'home'}此頁面顯示您的封禁和伺服器的概覽。{elseif $nav.endpoint == 'servers'}可以在此處查看所有伺服器及其狀態。{elseif $nav.endpoint == 'banlist'}可以在此處查看資料庫中的所有封禁記錄。{elseif $nav.endpoint == 'commslist'}可以在此處查看資料庫中的所有通訊封禁（如文字禁言和語音靜音）。{elseif $nav.endpoint == 'submit'}您可以在此處提交疑似作弊者的演示檔案或截圖。提交後將由管理員審核。{elseif $nav.endpoint == 'protest'}您可以在此處申訴您的封禁，並說明您應該被解封的理由。{else}{$nav.description}{/if}"
                       {if $nav.state == 'active'}aria-current="page"{/if}>
                        <i data-lucide="{if $nav.endpoint == 'home'}layout-dashboard{elseif $nav.endpoint == 'banlist'}ban{elseif $nav.endpoint == 'commslist'}mic-off{elseif $nav.endpoint == 'submit'}flag{elseif $nav.endpoint == 'protest'}megaphone{elseif $nav.endpoint == 'servers'}server{else}circle{/if}"></i>
                        {if $nav.endpoint == 'home'}儀表盤{elseif $nav.endpoint == 'servers'}伺服器{elseif $nav.endpoint == 'banlist'}封禁列表{elseif $nav.endpoint == 'commslist'}通訊管理{elseif $nav.endpoint == 'submit'}舉報玩家{elseif $nav.endpoint == 'protest'}申訴封禁{else}{$nav.title}{/if}
                    </a>
                {/if}
            {/foreach}
        </div>

        {if $isAdmin}
            <div class="sidebar__section">
                <div class="sidebar__section-label">管理</div>
                {foreach from=$navbar item=nav}
                    {if $nav.endpoint == 'admin'}
                        <a class="sidebar__link"
                           href="index.php?p={$nav.endpoint}"
                           data-testid="nav-{$nav.endpoint}"
                           title="{if $nav.endpoint == 'home'}此頁面顯示您的封禁和伺服器的概覽。{elseif $nav.endpoint == 'servers'}可以在此處查看所有伺服器及其狀態。{elseif $nav.endpoint == 'banlist'}可以在此處查看資料庫中的所有封禁記錄。{elseif $nav.endpoint == 'commslist'}可以在此處查看資料庫中的所有通訊封禁（如文字禁言和語音靜音）。{elseif $nav.endpoint == 'submit'}您可以在此處提交疑似作弊者的演示檔案或截圖。提交後將由管理員審核。{elseif $nav.endpoint == 'protest'}您可以在此處申訴您的封禁，並說明您應該被解封的理由。{else}{$nav.description}{/if}"
                           {if $nav.state == 'active'}aria-current="page"{/if}>
                            <i data-lucide="shield"></i>
                            管理面板
                        </a>
                    {/if}
                {/foreach}
                {foreach from=$adminbar item=admin}
                    <a class="sidebar__link"
                       href="index.php?p=admin&c={$admin.endpoint}"
                       data-testid="nav-admin-{$admin.endpoint}"
                       {if $admin.state == 'active'}aria-current="page"{/if}>
                        <i data-lucide="{if $admin.endpoint == 'admins'}users{elseif $admin.endpoint == 'servers'}server{elseif $admin.endpoint == 'bans'}ban{elseif $admin.endpoint == 'comms'}mic-off{elseif $admin.endpoint == 'groups'}shield-check{elseif $admin.endpoint == 'settings'}settings{elseif $admin.endpoint == 'mods'}puzzle{else}circle{/if}"></i>
                        {if $admin.endpoint == 'admins'}管理員{elseif $admin.endpoint == 'servers'}伺服器{elseif $admin.endpoint == 'bans'}封禁{elseif $admin.endpoint == 'comms'}通訊{elseif $admin.endpoint == 'groups'}分組{elseif $admin.endpoint == 'settings'}設定{elseif $admin.endpoint == 'mods'}模組{elseif $admin.endpoint == 'export'}匯出{else}{$admin.title}{/if}
                    </a>
                {/foreach}
            </div>
        {/if}
    </nav>

    <div style="border-top: 1px solid var(--border); padding: 0.5rem; display: flex; flex-direction: column; gap: 0.125rem;">
        {if $login}
            <a class="sidebar__link"
               href="index.php?p=account"
               data-testid="nav-account">
                <i data-lucide="user"></i>
                <div class="truncate" style="flex:1;min-width:0">{$username}</div>
            </a>
            <a class="sidebar__link"
               href="index.php?p=logout"
               data-testid="nav-logout">
                <i data-lucide="log-out"></i> 登出
            </a>
        {else}
            <a class="sidebar__link"
               href="index.php?p=login"
               data-testid="nav-login">
                <i data-lucide="log-in"></i> 登入
            </a>
        {/if}
    </div>
</aside>
