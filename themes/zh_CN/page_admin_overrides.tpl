{*
    SourceBans++ 2026 — page_admin_overrides.tpl

    SourceMod command/group overrides editor. Pair: Sbpp\View\AdminOverridesView.

    Behavior parity with web/themes/default/page_admin_overrides.tpl:
      - Existing rows show editable type/name/flags + a hidden `override_id[]`.
      - Blanking out the name on an existing row deletes it on POST
        (parity with the legacy handler in admin.overrides.php).
      - The bottom "add" row maps to `new_override_*` POST fields.
      - {csrf_field} is required because the dispatcher invokes
        CSRF::rejectIfInvalid() on every POST.

    #1275 — Pattern A `?section=…` routing
    --------------------------------------
    Pre-#1275 this template lived inside the cross-template
    `.page-toc-shell` opened by page_admin_admins_list.tpl, with two
    `<section id="…">` anchor targets ("overrides" and "add-override")
    that the page-level ToC scrolled between. #1275 unifies on
    Pattern A: this template renders by itself when the URL is
    `?section=overrides`, so the section is the whole page. The
    "add an override" form sits inline below the editable table —
    one `<form>`, one Save button, both rows submit together.
*}
<div data-testid="admin-admins-section-overrides">
{if not $permission_addadmin}
    <div class="card">
        <div class="card__body">
            <p class="text-muted m-0">访问被拒绝。</p>
        </div>
    </div>
{else}
    <div class="mb-4">
        <h1 style="font-size:var(--fs-xl);font-weight:600;margin:0">命令与分组覆盖</h1>
        <p class="text-sm text-muted m-0 mt-2">覆盖运行任意 SourceMod 命令所需的标志，可全局或按分组设置。</p>
    </div>

    {if $overrides_error != ""}
        <div class="card mb-4" role="alert" style="border-color:var(--danger);background:var(--danger-bg)">
            <div class="card__body" style="color:#b91c1c">
                <strong>错误</strong>
                {* nofilter: $overrides_error is built by the handler from Exception::getMessage(); any user-controlled override name embedded in it is run through htmlspecialchars(addslashes(...)) in admin.overrides.php before concatenation, and the surrounding wrapper is server-built static HTML — same provenance as the legacy ShowBox() path *}
                <div class="mt-2 text-sm" data-testid="overrides-error">{$overrides_error nofilter}</div>
            </div>
        </div>
    {/if}
    {if $overrides_save_success}
        <div class="card mb-4" role="status" style="border-color:var(--success);background:var(--success-bg)">
            <div class="card__body" style="color:#047857" data-testid="overrides-success">
                <strong>已保存。</strong>覆盖更改已应用。
            </div>
        </div>
    {/if}

    <form method="post" action="index.php?p=admin&amp;c=admins&amp;section=overrides" data-testid="overrides-form">
        {csrf_field}

        <div class="card mb-4">
            <div class="card__header">
                <div>
                    <h3>现有覆盖</h3>
                    <p>
                        将名称留空可在保存时删除该覆盖。
                        参见 AlliedModders Wiki 中的
                        <a href="https://wiki.alliedmods.net/Overriding_Command_Access_%28SourceMod%29"
                              target="_blank" rel="noopener noreferrer">覆盖命令访问</a>
                        以查看标志参考。
                    </p>
                </div>
            </div>
            <div class="card__body">
                <table class="table" data-testid="overrides-table">
                    <thead>
                        <tr>
                            <th style="width:8rem">类型</th>
                            <th>名称</th>
                            <th style="width:14rem">标志</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach from=$overrides_list item=override}
                            <tr data-testid="override-row" data-id="{$override.oid}">
                                <td>
                                    <select class="select" name="override_type[]" aria-label="覆盖类型">
                                        <option value="command"{if $override.type == "command"} selected="selected"{/if}>命令</option>
                                        <option value="group"{if $override.type == "group"} selected="selected"{/if}>分组</option>
                                    </select>
                                    <input type="hidden" name="override_id[]" value="{$override.oid}" />
                                </td>
                                <td>
                                    <input class="input font-mono" name="override_name[]"
                                           value="{$override.command_or_group}"
                                           aria-label="覆盖名称（留空以删除）" />
                                </td>
                                <td>
                                    <input class="input font-mono" name="override_flags[]"
                                           value="{$override.flags}"
                                           aria-label="覆盖标志" />
                                </td>
                            </tr>
                        {foreachelse}
                            <tr data-testid="overrides-empty">
                                <td colspan="3" class="text-muted text-sm" style="text-align:center;padding:1.5rem">
                                    暂无已配置的覆盖 — 在下方添加一个。
                                </td>
                            </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
        </div>

        <div class="card mb-4" data-testid="admin-admins-section-add-override">
            <div class="card__header">
                <div>
                    <h3>添加覆盖</h3>
                    <p>选择类型，提供命令/分组名称以及管理员运行它所需的标志。</p>
                </div>
            </div>
            <div class="card__body">
                <div class="grid gap-3" style="grid-template-columns:8rem 1fr 14rem">
                    <div>
                        <label class="label" for="addoverride-type">类型</label>
                        <select class="select" id="addoverride-type" name="new_override_type"
                                data-testid="addoverride-type">
                            <option value="command">命令</option>
                            <option value="group">分组</option>
                        </select>
                    </div>
                    <div>
                        <label class="label" for="addoverride-name">名称</label>
                        <input class="input font-mono" id="addoverride-name" name="new_override_name"
                               data-testid="addoverride-name" autocomplete="off" />
                    </div>
                    <div>
                        <label class="label" for="addoverride-flags">标志</label>
                        <input class="input font-mono" id="addoverride-flags" name="new_override_flags"
                               data-testid="addoverride-flags" autocomplete="off" />
                    </div>
                </div>
            </div>
        </div>

        <div class="flex justify-end gap-2">
            <a class="btn btn--ghost" href="javascript:history.go(-1);" data-testid="overrides-back">返回</a>
            <button class="btn btn--primary" type="submit" data-testid="overrides-save">保存更改</button>
        </div>
    </form>
{/if}
</div>
