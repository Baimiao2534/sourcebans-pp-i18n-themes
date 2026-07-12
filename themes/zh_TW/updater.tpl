{*
 SourceBans++ 2026 — updater.tpl

 Standalone wizard rendered by web/updater/index.php after Updater.php
 has finished applying any pending migrations. View:
 Sbpp\View\UpdaterView (just `$updates`).

 The updater runs in its own bootstrap context — it does NOT go
 through index.php's page-builder, so the chrome from
 `core/header.tpl` + `core/footer.tpl` is intentionally not pulled
 in. This template is therefore a complete <!DOCTYPE html> document
 and links the theme stylesheet directly. Asset paths are relative
 to /web/updater/ (where the script runs from), so `../themes/...`
 points at /web/themes/default/.

 Test hooks: each card header carries a stable
 `data-testid="updater-<step>"` attribute.

 Anti-FOUC bootloader (#1438): the updater is hit by logged-in
 admins (same origin as the panel), and the body uses
 `background:var(--bg-page);color:var(--text)` directly — so
 without the bootloader, an admin in dark mode upgrading the
 panel lands on a stark-white "Updater" page. The inline script
 below mirrors `core/header.tpl`'s bootloader exactly; the
 byte-equivalence contract is gated by
 `web/tests/integration/IframeChromeAntiFoucBootloaderTest.php`.
 See "Anti-FOUC theme bootloader" in AGENTS.md Conventions for
 the full contract. Distinct from the install wizard's
 `_chrome.tpl` (which is intentionally exempt — pre-install
 panel has no logged-in user / no theme.js / no persisted
 preference); the updater runs against a configured panel and
 inherits the operator's already-set theme preference.
*}
<!DOCTYPE html>
<html lang="zh-TW">
<head>
 <meta charset="utf-8">
 <meta name="viewport" content="width=device-width,initial-scale=1">
 <title>更新器 | SourceBans++</title>
 <script>
 (function () {
 try {
 var m = localStorage.getItem('sbpp-theme') || 'system';
 document.documentElement.setAttribute('data-theme-pref', m);
 var d = m === 'dark' || (m === 'system' && window.matchMedia
 && matchMedia('(prefers-color-scheme: dark)').matches);
 if (d) document.documentElement.classList.add('dark');
 } catch (e) { /* localStorage / matchMedia unavailable; default to light */ }
 })();
 </script>
 <link rel="stylesheet" href="../themes/default/css/theme.css">
</head>
<body style="background:var(--bg-page);color:var(--text);min-height:100vh">

<div class="p-6 space-y-6" style="max-width:48rem;margin:2.5rem auto;width:100%">

    <header class="flex items-center gap-3" data-testid="updater-header">
        {* #1235 — the updater renders in its own bootstrap context
           (web/updater/index.php) which doesn't load core/header.php,
           so the operator-configurable `template.logo` setting and
           the `$theme_url` Smarty global aren't in scope here. The
           favicon path is therefore hardcoded — the updater is an
           internal one-off page that runs once per upgrade, never
           through the regular page-builder lifecycle, so threading
           the setting through `UpdaterView` would be plumbing for a
           single admin-facing screen that doesn't need theming.
           Path is relative to /web/updater/ where the script runs. *}
        <img class="sidebar__brand-mark" src="../themes/default/images/favicon.svg" alt="">
        <div>
            <h1 style="font-size:var(--fs-2xl);font-weight:600;margin:0">SourceBans++ 更新器</h1>
            <p class="text-sm text-muted m-0 mt-2">資料庫遷移日誌。</p>
        </div>
    </header>

    <section class="card">
        <div class="card__header" data-testid="updater-progress">
            <div>
                <h3>進度</h3>
                <p>下方每一行是遷移執行器的一個步驟。</p>
            </div>
        </div>
        <div class="card__body">
            {if $updates}
                <ol class="font-mono text-sm space-y-3" style="margin:0;padding-left:1.5rem">
                    {* nofilter: every $update line is built inside Updater.php from int versions
                       and static templates (see Updater::update()); no user input flows in. *}
                    {foreach from=$updates item=update}
                        <li>{$update nofilter}</li>
                    {/foreach}
                </ol>
            {else}
                <p class="text-sm text-muted m-0" data-testid="updater-empty">未套用任何更新。</p>
            {/if}
        </div>
    </section>

    <section class="card">
        <div class="card__header" data-testid="updater-cleanup">
            <div>
                <h3>下一步</h3>
                <p>執行完成後，在向管理員開放面板之前，請移除 <code class="font-mono">/updater</code> 目錄。</p>
            </div>
        </div>
        <div class="card__body">
            <a class="btn btn--primary" href="../index.php" data-testid="updater-return">
                返回面板
            </a>
        </div>
    </section>

    <footer class="text-xs text-faint" style="text-align:center">
        <a href="https://sbpp.github.io/" target="_blank" rel="noopener" style="color:inherit">SourceBans++</a>
    </footer>

</div>

</body>
</html>
