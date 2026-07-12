{*
    SourceBans++ 2026 — admin/admins edit groups

    Pair: web/pages/admin.edit.admingroup.php and
    web/includes/View/EditAdminGroupView.php.

    The handler gates entry on ADMIN_OWNER | ADMIN_EDIT_ADMINS before
    reaching this template, so there is no per-template access boolean.
    The admin id rides the URL via $smarty.get.id rather than a View
    property so this template stays compatible with the unmodified
    handler (which never assigned $aid).

    The cross-page tab nav (Details / Group / Servers / Permissions)
    keeps the URL bar honest about which sub-page you're on; the
    data-testid hooks match the issue's edit-form-tabs contract.
*}
<div class="card-tab page-section" id="Edit Admin Groups">
    <div class="mb-4">
        <h1 style="font-size:var(--fs-xl);font-weight:600;margin:0">编辑管理员 · {$group_admin_name|escape}</h1>
        <p class="text-sm text-muted m-0 mt-2">在网页和服务器管理员分组之间移动 <strong>{$group_admin_name|escape}</strong>。</p>
    </div>

    <nav class="flex gap-2 mb-4" role="tablist" aria-label="编辑管理员分区">
        <a class="btn btn--ghost btn--sm" role="tab"
           href="?p=admin&c=admins&o=editdetails&id={$smarty.get.id|escape:'url'}"
           data-testid="admin-tab-details">详情</a>
        <a class="btn btn--secondary btn--sm" role="tab" aria-current="page"
           href="?p=admin&c=admins&o=editgroup&id={$smarty.get.id|escape:'url'}"
           data-testid="admin-tab-group">分组</a>
        <a class="btn btn--ghost btn--sm" role="tab"
           href="?p=admin&c=admins&o=editservers&id={$smarty.get.id|escape:'url'}"
           data-testid="admin-tab-servers">服务器</a>
        <a class="btn btn--ghost btn--sm"
           href="?p=admin&c=admins&o=editpermissions&id={$smarty.get.id|escape:'url'}">权限</a>
    </nav>

    <form method="post" action="" class="space-y-4">
        {csrf_field}

        <div class="card">
            <div class="card__header">
                <div>
                    <h3>网页管理员分组</h3>
                    <p>控制网页面板访问权限的分组。</p>
                </div>
            </div>
            <div class="card__body">
                <label class="label" for="wg">网页管理员分组</label>
                <select class="select" id="wg" name="wg" data-testid="edit-admin-webgroup">
                    <option value="-1">无分组</option>
                    <optgroup label="分组" style="font-weight:bold">
                        {foreach $web_lst as $wg}
                            <option value="{$wg.gid}" {if $wg.gid == $group_admin_id}selected{/if}>{$wg.name|escape}</option>
                        {/foreach}
                    </optgroup>
                </select>
                <div id="wgroup.msg" class="text-xs" style="color:var(--danger);margin-top:0.25rem"></div>
            </div>
        </div>

        <div class="card">
            <div class="card__header">
                <div>
                    <h3>服务器管理员分组</h3>
                    <p>控制游戏内管理员权限的 SourceMod 分组。</p>
                </div>
            </div>
            <div class="card__body">
                <label class="label" for="sg">服务器管理员分组</label>
                <select class="select" id="sg" name="sg" data-testid="edit-admin-srvgroup">
                    <option value="-1">无分组</option>
                    <optgroup label="分组" style="font-weight:bold">
                        {foreach $group_lst as $sg}
                            <option value="{$sg.id}" {if $sg.id == $server_admin_group_id}selected{/if}>{$sg.name|escape}</option>
                        {/foreach}
                    </optgroup>
                </select>
                <div id="sgroup.msg" class="text-xs" style="color:var(--danger);margin-top:0.25rem"></div>
            </div>
        </div>

        <div class="flex justify-end gap-2">
            <button type="button" class="btn btn--ghost btn--sm"
                    onclick="history.go(-1);">返回</button>
            <button type="submit" class="btn btn--primary btn--sm" id="agroups"
                    data-testid="edit-admin-group-save"><i data-lucide="save"></i> 保存更改</button>
        </div>
    </form>
</div>
