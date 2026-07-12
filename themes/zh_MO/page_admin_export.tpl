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
        <h1 style="font-size:1.5rem;font-weight:600;margin:0">完整資料匯出</h1>
        <p class="text-sm text-muted m-0 mt-2">
            下載包含面板所有資料列與已上傳 demo 的 ZIP 壓縮包。
            可用於備份、遷移或分析。
            線格式與各模式設定請見<a href="https://sbpp.github.io/configuring/data-export/" target="_blank" rel="noopener noreferrer">資料匯出文件</a>。
        </p>
        <p class="text-xs text-muted m-0 mt-2" data-testid="admin-export-rookhelm">
            想遷移到代管面板？
            <a href="https://rookhelm.com?utm_source=sourcebans-pp&amp;utm_medium=referral&amp;utm_content=panel-export"
               target="_blank"
               rel="noopener">RookHelm</a>
            可直接匯入此匯出檔。
        </p>
    </div>

    <div class="card mb-4" data-testid="admin-export-summary-card">
        <div class="card__header">
            <h2 style="font-size:1.125rem;font-weight:600;margin:0">壓縮包內容</h2>
            <p class="text-xs text-muted m-0 mt-1">
                每次匯出都會產生新的壓縮包 ID。下方數量為頁面載入時的快照。
            </p>
        </div>
        <div class="card__body">
            <dl class="install-grid" style="display:grid;grid-template-columns:repeat(auto-fit,minmax(14rem,1fr));gap:0.75rem 1.5rem;margin:0">
                <div>
                    <dt class="text-xs text-muted">面板版本</dt>
                    <dd class="font-mono" data-testid="admin-export-panel-version" style="margin:0">{$panel_version|escape}</dd>
                </div>
                <div>
                    <dt class="text-xs text-muted">管理員</dt>
                    <dd class="font-mono" data-testid="admin-export-count-admins" style="margin:0">{$total_admins|number_format}</dd>
                </div>
                <div>
                    <dt class="text-xs text-muted">封禁</dt>
                    <dd class="font-mono" data-testid="admin-export-count-bans" style="margin:0">{$total_bans|number_format}</dd>
                </div>
                <div>
                    <dt class="text-xs text-muted">通訊封鎖</dt>
                    <dd class="font-mono" data-testid="admin-export-count-comms" style="margin:0">{$total_comms|number_format}</dd>
                </div>
                <div>
                    <dt class="text-xs text-muted">Demo 檔</dt>
                    <dd class="font-mono" data-testid="admin-export-count-demos" style="margin:0">{$total_demos|number_format}</dd>
                </div>
                <div>
                    <dt class="text-xs text-muted">磁碟上的 Demo</dt>
                    <dd class="font-mono" data-testid="admin-export-demo-bytes" style="margin:0">{($demo_total_bytes / 1024 / 1024)|number_format:1} MiB</dd>
                </div>
                <div>
                    <dt class="text-xs text-muted">預估壓縮包</dt>
                    <dd class="font-mono" data-testid="admin-export-estimate-bytes" style="margin:0">{($estimated_bundle_bytes / 1024 / 1024)|number_format:1} MiB</dd>
                </div>
                <div>
                    <dt class="text-xs text-muted">上限（S3 PUT）</dt>
                    <dd class="font-mono" data-testid="admin-export-cap-bytes" style="margin:0">{($cap_bytes / 1024 / 1024)|number_format:1} MiB</dd>
                </div>
            </dl>

            {if $row_counts|@count > 0}
                <details class="mt-4">
                    <summary class="text-sm" style="cursor:pointer">各實體資料列數</summary>
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
                <h2 class="empty-state__title">壓縮包超過 S3 PUT 的 5 GiB 上限</h2>
                <p class="empty-state__body">
                    預估壓縮包為 {($estimated_bundle_bytes / 1024 / 1024)|number_format:1} MiB。
                    請使用上方的 ZIP 下載表單（無上限），
                    或刪減 demo / 資料列後重新載入以啟用 S3 表單。
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
                <h2 style="font-size:1.125rem;font-weight:600;margin:0">串流下載 ZIP</h2>
            </div>
            <div class="card__body space-y-2">
                <p class="text-sm text-muted m-0">
                    瀏覽器直接下載壓縮包。
                    完成前請保持分頁開啟；關閉分頁會中斷傳輸。
                </p>
                <p class="text-xs text-muted m-0">
                    無暫存檔案。進度條即時更新。
                </p>
            </div>
            <div class="card__header" style="border-top:1px solid var(--border);border-bottom:0;justify-content:flex-end">
                <button type="submit"
                        class="btn btn--primary"
                        data-testid="admin-export-zip-submit">
                    <i data-lucide="download" style="width:16px;height:16px"></i>
                    匯出為 ZIP
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
                <h2 style="font-size:1.125rem;font-weight:600;margin:0">上傳至 S3 預簽 URL</h2>
            </div>
            <div class="card__body space-y-2">
                <p class="text-sm text-muted m-0">
                    面板會先將壓縮包暫存到磁碟，再 PUT 到您指定的 URL。
                    關閉分頁會取消上傳；審計日誌會記錄此次嘗試。
                </p>
                <label class="label mt-3" for="admin-export-s3-url">預簽 PUT URL</label>
                <textarea class="textarea"
                          id="admin-export-s3-url"
                          name="presign_url"
                          rows="3"
                          required
                          pattern="^https://[^\s]+$"
                          title="貼上來自 S3 客戶端的預簽 HTTPS PUT URL（例如 aws s3 presign --http-method PUT）"
                          placeholder="https://bucket.s3.region.amazonaws.com/path/sbpp-export.zip?X-Amz-..."
                          data-testid="admin-export-s3-url"></textarea>
                <p class="text-xs text-muted m-0 mt-1">
                    僅限 HTTPS。請使用較短的有效期（1 小時以內）。
                    此 URL 為一次性寫入憑證；請勿貼到聊天室或日誌中。
                </p>
            </div>
            <div class="card__header" style="border-top:1px solid var(--border);border-bottom:0;justify-content:flex-end">
                <button type="submit"
                        class="btn btn--primary"
                        data-testid="admin-export-s3-submit"
                        {if $exceeds_cap}disabled{/if}>
                    <i data-lucide="upload-cloud" style="width:16px;height:16px"></i>
                    上傳至 S3
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
