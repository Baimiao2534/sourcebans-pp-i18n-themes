{*
    SourceBans++ install wizard — step 1 (license agreement).
    Pair view: \Sbpp\View\Install\InstallLicenseView (web/includes/View/Install/InstallLicenseView.php).
    Page handler: web/install/pages/page.1.php.
*}
{include file="install/_chrome.tpl"}

<p class="lead">
    您需要接受以下许可证才能安装面板。
    完整文本位于
    <a href="https://www.elastic.co/licensing/elastic-license"
       target="_blank" rel="noopener">elastic.co/licensing/elastic-license</a>;
    随此安装包附带的 SourceMod 插件单独采用
    <a href="https://www.gnu.org/licenses/gpl-3.0.html"
       target="_blank" rel="noopener">GPLv3</a> 许可证。
</p>

<div class="card">
    <div class="card__header">
        <div>
            <h2 style="margin:0;font-size:0.95rem;font-weight:600">
                Elastic License 2.0 (Web 面板) &middot; GPLv3 (SourceMod 插件)
            </h2>
        </div>
    </div>
    <div class="card__body">
        {*
            Issue #1335 m5: pre-fix this used `class="input"` +
            `rows="20"`, but theme.css's `.input` rule pins
            `height: 2.25rem` and the rows attribute is ignored —
            the textarea rendered at ~5 lines instead of the ~20
            the form intends. Switch to `class="textarea"` (which
            sets `height: auto`) and force the visible height with
            `min-height` inline so the surface matches the
            content's volume.
        *}
        <textarea class="textarea"
                  readonly
                  style="width:100%;min-height:24rem;font-family:var(--font-mono,monospace);font-size:0.8rem;line-height:1.5"
                  data-testid="install-license-text">{$license_text}</textarea>
    </div>
</div>

<form method="post"
      action="?step=2"
      data-testid="install-license-form"
      style="margin-top:1.5rem">
    <label class="flex items-center gap-2"
           style="user-select:none;cursor:pointer">
        <input type="checkbox"
               id="install-license-accept"
               name="accept"
               value="1"
               data-testid="install-license-accept"
               required>
        <span>我已阅读并接受上述许可证。</span>
    </label>

    <div class="install-actions">
        <button class="btn btn--primary"
                type="submit"
                data-testid="install-license-continue">
            继续
        </button>
    </div>
</form>

{include file="install/_chrome_close.tpl"}

<script>
(function () {
    'use strict';
    // Native form `required` already blocks submit when the checkbox
    // is unchecked, but browsers that surface that via a popup
    // anchored to the checkbox can be surprising — emit a clear
    // visible message in the form instead. The page-tail script is
    // intentionally vanilla / no-deps; the wizard chrome doesn't
    // load theme.js (no DB / no command palette / no toast surface),
    // so window.SBPP.showToast is unavailable here. See
    // web/themes/default/install/_chrome.tpl for the full rationale.
    var form = document.querySelector('[data-testid="install-license-form"]');
    var box  = document.getElementById('install-license-accept');
    if (!form || !box) return;
    form.addEventListener('submit', function (e) {
        if (!box.checked) {
            e.preventDefault();
            box.focus();
        }
    });
})();
</script>
