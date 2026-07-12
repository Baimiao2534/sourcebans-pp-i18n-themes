{*
    SourceBans++ install wizard — step 3 (requirements check).
    Pair view: \Sbpp\View\Install\InstallRequirementsView (web/includes/View/Install/InstallRequirementsView.php).
    Page handler: web/install/pages/page.3.php.
*}
{include file="install/_chrome.tpl"}

<p class="lead">
    データベースにアクセスする前に環境チェックを行います。
    {if $errors > 0}
        <strong>{$errors} 件のブロック問題</strong>
        を修正するまで続行できません。
    {elseif $warnings > 0}
        <strong>{$warnings} 件の警告</strong>があります。
        続行できますが、一部機能が正常に動作しない可能性があります。
    {else}
        すべて正常です。
    {/if}
</p>

{if $errors > 0}
    <div class="install-alert install-alert--error"
         role="alert"
         data-testid="install-requirements-blocked"
         style="margin-bottom:1.25rem">
        下記の赤字で示されたブロック問題を修正し、
        <strong>再チェック</strong>をクリックしてください。
    </div>
{elseif $warnings > 0}
    <div class="install-alert install-alert--warn"
         role="status"
         data-testid="install-requirements-warning"
         style="margin-bottom:1.25rem">
        一部の推奨項目が不合格です。ウィザードは続行できます。
    </div>
{else}
    <div class="install-alert install-alert--ok"
         role="status"
         data-testid="install-requirements-ok"
         style="margin-bottom:1.25rem">
        すべてのチェックに合格しました。
    </div>
{/if}

{foreach from=$groups item=group}
    <div class="install-section">
        <h2>{$group.title}</h2>
        <div class="card">
            <table class="install-table" data-testid="install-requirements-{$group.title|lower|replace:' ':'-'}">
                <thead>
                    <tr>
                        <th>設定</th>
                        <th>要件</th>
                        <th>状態</th>
                        <th>詳細</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$group.rows item=row}
                        <tr>
                            <td><strong>{$row.label}</strong></td>
                            <td>{$row.required}</td>
                            <td>
                                {if $row.status == 'ok'}
                                    <span class="install-pill install-pill--ok">合格</span>
                                {elseif $row.status == 'warn'}
                                    <span class="install-pill install-pill--warn">警告</span>
                                {else}
                                    <span class="install-pill install-pill--err">不合格</span>
                                {/if}
                            </td>
                            <td>{$row.detail}</td>
                        </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
    </div>
{/foreach}

<form method="post"
      action="?step=4"
      id="install-requirements-form"
      data-testid="install-requirements-form"
      autocomplete="off">
    <input type="hidden" name="server"   value="{$val_server}">
    <input type="hidden" name="port"     value="{$val_port}">
    <input type="hidden" name="username" value="{$val_username}">
    <input type="hidden" name="password" value="{$val_password}">
    <input type="hidden" name="database" value="{$val_database}">
    <input type="hidden" name="prefix"   value="{$val_prefix}">
    <input type="hidden" name="apikey"   value="{$val_apikey}">
    <input type="hidden" name="sb-email" value="{$val_email}">

    <div class="install-actions">
        <a class="btn btn--ghost" href="?step=2" data-testid="install-requirements-back">
            戻る
        </a>
        <button class="btn btn--secondary"
                type="button"
                data-testid="install-requirements-recheck"
                onclick="window.location.reload()">
            再チェック
        </button>
        {if $can_continue}
            <button class="btn btn--primary"
                    type="submit"
                    data-testid="install-requirements-continue">
                続行
            </button>
        {else}
            <button class="btn btn--primary"
                    type="submit"
                    disabled
                    aria-disabled="true"
                    data-testid="install-requirements-continue">
                問題を修正して続行
            </button>
        {/if}
    </div>
</form>

{include file="install/_chrome_close.tpl"}
