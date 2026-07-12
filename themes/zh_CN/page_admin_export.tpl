{*
    SourceBans++ 2026 — page_admin_export.tpl
    Bound to Sbpp\View\AdminExportView (validated by SmartyTemplateRule).

    "Full data export" admin surface. Two delivery modes:
      - ZIP download (stream-to-output, no intermediate disk) — uncapped
      - S3 presigned PUT (build-to-disk-then-PUT) — 5 GiB S3 single-PUT cap

    Both forms POST to web/export.php (top-level entry point — binary
    wire format → doesn't fit the JSON dispatcher; same shape as
    `exportbans.php` / `getdemo.php`). See that file's lifecycle
    docblock for the security contract.

    The mode is carried as a hidden `<input name="mode" value="…">`
    inside each form (NOT as a `?mode=…` query string on the action
    URL); the entry point reads `$_POST['mode']` and rejects anything
    other than `'zip'` / `'s3'`.

    `$exceeds_cap` carries the S3 single-PUT cap signal (5 GiB minus
    the 64 MiB safety margin — the hard structural limit on a
    presigned PUT across every S3-API-compatible provider). When
    true, the S3 submit is disabled and an `.empty-state` block
    points the operator at the uncapped ZIP path. The ZIP submit
    stays enabled regardless because direct ZIP download is uncapped
    under Zip64. The s3 arm re-enforces the cap at the entry point
    so a hand-edited form submission can't bypass it.
*}
<section class="p-6" data-testid="admin-export-section" style="max-width:56rem">
    <div class="mb-6">
        <h1 style="font-size:1.5rem;font-weight:600;margin:0">完整数据导出</h1>
        <p class="text-sm text-muted m-0 mt-2">
            下载包含面板每一行数据和已上传演示的 ZIP 压缩包。
            可用于备份、迁移或分析。
            参见 <a href="https://sbpp.github.io/configuring/data-export/" target="_blank" rel="noopener noreferrer">数据导出文档</a>
            以查看传输格式和各模式配置。
        </p>
        <p class="text-xs text-muted m-0 mt-2" data-testid="admin-export-rookhelm">
            迁移到托管面板？
            <a href="https://rookhelm.com?utm_source=sourcebans-pp&amp;utm_medium=referral&amp;utm_content=panel-export"
               target="_blank"
               rel="noopener">RookHelm</a>
            可直接导入此导出。
        </p>
    </div>

    <div class="card mb-4" data-testid="admin-export-summary-card">
        <div class="card__header">
            <h2 style="font-size:1.125rem;font-weight:600;margin:0">压缩包内容</h2>
            <p class="text-xs text-muted m-0 mt-1">
                每次导出生成新的压缩包 ID。下方计数为页面加载时的快照。
            </p>
        </div>
        <div class="card__body">
            <dl class="install-grid" style="display:grid;grid-template-columns:repeat(auto-fit,minmax(14rem,1fr));gap:0.75rem 1.5rem;margin:0">
                <div>
                    <dt class="text-xs text-muted">面板版本</dt>
                    <dd class="font-mono" data-testid="admin-export-panel-version" style="margin:0">{$panel_version|escape}</dd>
                </div>
                <div>
                    <dt class="text-xs text-muted">管理员</dt>
                    <dd class="font-mono" data-testid="admin-export-count-admins" style="margin:0">{$total_admins|number_format}</dd>
                </div>
                <div>
                    <dt class="text-xs text-muted">封禁</dt>
                    <dd class="font-mono" data-testid="admin-export-count-bans" style="margin:0">{$total_bans|number_format}</dd>
                </div>
                <div>
                    <dt class="text-xs text-muted">通信封禁</dt>
                    <dd class="font-mono" data-testid="admin-export-count-comms" style="margin:0">{$total_comms|number_format}</dd>
                </div>
                <div>
                    <dt class="text-xs text-muted">演示</dt>
                    <dd class="font-mono" data-testid="admin-export-count-demos" style="margin:0">{$total_demos|number_format}</dd>
                </div>
                <div>
                    <dt class="text-xs text-muted">磁盘上的演示</dt>
                    <dd class="font-mono" data-testid="admin-export-demo-bytes" style="margin:0">{($demo_total_bytes / 1024 / 1024)|number_format:1} MiB</dd>
                </div>
                <div>
                    <dt class="text-xs text-muted">预计压缩包大小</dt>
                    <dd class="font-mono" data-testid="admin-export-estimate-bytes" style="margin:0">{($estimated_bundle_bytes / 1024 / 1024)|number_format:1} MiB</dd>
                </div>
                <div>
                    <dt class="text-xs text-muted">容量上限（S3 PUT）</dt>
                    <dd class="font-mono" data-testid="admin-export-cap-bytes" style="margin:0">{($cap_bytes / 1024 / 1024)|number_format:1} MiB</dd>
                </div>
            </dl>

            {if $row_counts|@count > 0}
                <details class="mt-4">
                    <summary class="text-sm" style="cursor:pointer">按实体行数统计</summary>
                    <dl class="install-grid mt-2" style="display:grid;grid-template-columns:repeat(auto-fill,minmax(12rem,1fr));gap:0.25rem 1.5rem;margin:0;font-size:var(--fs-xs)">
                        {foreach from=$row_counts key=entity item=count}
                            <div style="display:flex;justify-content:space-between;gap:0.5rem">
                                <dt class="text-muted font-mono">{$entity|escape}</dt>
                                <dd class="font-mono" style="margin:0">{$count|number_format}</dd>
                            </div>
                        {/foreach}
                    </dl>
                </details>
            {/if}
        </div>
    </div>

    {if $exceeds_cap}
        {* First-run vs filtered shape per AGENTS.md "Empty states": the
           bundle is too big for S3's single-PUT cap, but the ZIP path
           is still available so the operator isn't blocked outright.
           Use the first-run shape with NO Clear-filters CTA — the
           ZIP form above IS the path forward, no extra CTA needed.
           `data-filtered="false"` per the convention. *}
        <div class="card" data-testid="admin-export-cap-empty" data-filtered="false">
            <div class="empty-state">
                <span class="empty-state__icon" aria-hidden="true">
                    <i data-lucide="alert-triangle" style="width:18px;height:18px"></i>
                </span>
                <h2 class="empty-state__title">压缩包超过 5 GiB 的 S3 PUT 限制</h2>
                <p class="empty-state__body">
                    预计压缩包大小为 {($estimated_bundle_bytes / 1024 / 1024)|number_format:1} MiB。
                    请使用上方的 ZIP 下载表单（无限制），
                    或清理演示 / 行数后重新加载以启用 S3 表单。
                </p>
            </div>
        </div>
    {/if}

    <div class="grid" style="display:grid;grid-template-columns:repeat(auto-fit,minmax(22rem,1fr));gap:1rem;margin-top:1rem">
        <form class="card"
              method="post"
              action="export.php"
              data-testid="admin-export-zip-form">
            {csrf_field}
            <input type="hidden" name="mode" value="zip">
            <div class="card__header">
                <h2 style="font-size:1.125rem;font-weight:600;margin:0">流式下载 ZIP</h2>
            </div>
            <div class="card__body space-y-2">
                <p class="text-sm text-muted m-0">
                    浏览器直接下载压缩包。
                    在下载完成前请保持标签页打开；关闭标签页将中断传输。
                </p>
                <p class="text-xs text-muted m-0">
                    无暂存文件。进度条实时移动。
                </p>
            </div>
            <div class="card__header" style="border-top:1px solid var(--border);border-bottom:0;justify-content:flex-end">
                <button type="submit"
                        class="btn btn--primary"
                        data-testid="admin-export-zip-submit">
                    <i data-lucide="download" style="width:16px;height:16px"></i>
                    导出为 ZIP
                </button>
            </div>
        </form>

        <form class="card"
              method="post"
              action="export.php"
              data-testid="admin-export-s3-form">
            {csrf_field}
            <input type="hidden" name="mode" value="s3">
            <div class="card__header">
                <h2 style="font-size:1.125rem;font-weight:600;margin:0">上传到 S3 预签名 URL</h2>
            </div>
            <div class="card__body space-y-2">
                <p class="text-sm text-muted m-0">
                    面板将压缩包暂存到磁盘，然后 PUT 到你的 URL。
                    关闭标签页将取消上传；审计日志会记录此次尝试。
                </p>
                <label class="label mt-3" for="admin-export-s3-url">预签名 PUT URL</label>
                <textarea class="textarea"
                          id="admin-export-s3-url"
                          name="presign_url"
                          rows="3"
                          required
                          pattern="^https://[^\s]+$"
                          title="粘贴来自 S3 客户端的预签名 HTTPS PUT URL（例如 aws s3 presign --http-method PUT）"
                          placeholder="https://bucket.s3.region.amazonaws.com/path/sbpp-export.zip?X-Amz-..."
                          data-testid="admin-export-s3-url"></textarea>
                <p class="text-xs text-muted m-0 mt-1">
                    仅限 HTTPS。请使用较短的有效期（1 小时或更短）。
                    此 URL 为一次性写入凭证；请勿在聊天或日志中粘贴。
                </p>
            </div>
            <div class="card__header" style="border-top:1px solid var(--border);border-bottom:0;justify-content:flex-end">
                <button type="submit"
                        class="btn btn--primary"
                        data-testid="admin-export-s3-submit"
                        {if $exceeds_cap}disabled{/if}>
                    <i data-lucide="upload-cloud" style="width:16px;height:16px"></i>
                    上传到 S3
                </button>
            </div>
        </form>
    </div>
</section>

{* Page-tail script: gates the submit buttons through window.SBPP.setBusy
   so the browser doesn't appear frozen while the request travels. The
   ZIP path streams a binary response body (no page-render reset, no
   redirect); the S3 path 302-redirects back here on completion. Both
   tear the page down so we deliberately DON'T `setBusy(submitBtn, false)`
   in the submit handler — the next paint resets the DOM either way. The
   local `setBusy` wrapper falls back to plain `disabled` so third-party
   themes that strip theme.js still gate against double-clicks. *}
{literal}
<script>
(function () {
    'use strict';
    function setBusy(btn, busy) {
        if (!btn) return;
        var S = window.SBPP;
        if (S && typeof S.setBusy === 'function') {
            S.setBusy(btn, busy);
        } else {
            btn.disabled = busy === undefined ? true : !!busy;
        }
    }
    var forms = document.querySelectorAll('[data-testid="admin-export-zip-form"], [data-testid="admin-export-s3-form"]');
    for (var i = 0; i < forms.length; i++) {
        forms[i].addEventListener('submit', function (e) {
            var submit = e.target.querySelector('[type="submit"]');
            if (submit && submit.disabled) {
                e.preventDefault();
                return;
            }
            setBusy(submit, true);
        });
    }
})();
</script>
{/literal}
