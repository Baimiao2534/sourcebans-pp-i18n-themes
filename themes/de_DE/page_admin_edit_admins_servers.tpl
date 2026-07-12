{*
    SourceBans++ 2026 — admin/admins edit server access

    Pair: web/pages/admin.edit.adminservers.php and
    web/includes/View/EditAdminServersView.php.

    The handler gates entry on ADMIN_OWNER | ADMIN_EDIT_ADMINS before
    reaching this template, so there is no per-template access boolean.
    The admin id rides the URL via $smarty.get.id rather than a View
    property so this template stays compatible with the unmodified
    handler (which never assigned $aid).

    The cross-page tab nav (Details / Group / Servers / Permissions)
    keeps the URL bar honest about which sub-page you're on; the
    data-testid hooks match the issue's edit-form-tabs contract.

    The legacy template re-checked boxes via inline JS that drove
    LoadServerHost(); the 2026 footer drops sourcebans.js, so this
    template renders the persisted hostname server-side from $server_list
    and pre-checks via Smarty {if} comparisons against $assigned_servers.
*}
<div class="card-tab page-section" id="Edit Admin Server Access">
    <div class="mb-4">
        <h1 style="font-size:var(--fs-xl);font-weight:600;margin:0">Administrator-Serverzugriff bearbeiten</h1>
        <p class="text-sm text-muted m-0 mt-2">Wählen Sie die Server und Servergruppen, die dieser Administrator im Spiel verwalten kann.</p>
    </div>

    <nav class="flex gap-2 mb-4" role="tablist" aria-label="Administrator-Bearbeitungsabschnitte">
        <a class="btn btn--ghost btn--sm" role="tab"
           href="?p=admin&c=admins&o=editdetails&id={$smarty.get.id|escape:'url'}"
           data-testid="admin-tab-details">Details</a>
        <a class="btn btn--ghost btn--sm" role="tab"
           href="?p=admin&c=admins&o=editgroup&id={$smarty.get.id|escape:'url'}"
           data-testid="admin-tab-group">Gruppe</a>
        <a class="btn btn--secondary btn--sm" role="tab" aria-current="page"
           href="?p=admin&c=admins&o=editservers&id={$smarty.get.id|escape:'url'}"
           data-testid="admin-tab-servers">Server</a>
        <a class="btn btn--ghost btn--sm"
           href="?p=admin&c=admins&o=editpermissions&id={$smarty.get.id|escape:'url'}">Berechtigungen</a>
    </nav>

    {if $row_count < 1}
        <div class="card">
            <div class="card__body">
                <p class="text-sm text-muted m-0"><em>Sie müssen einen Server oder eine Servergruppe hinzufügen, bevor Sie Administrator-Serverberechtigungen einrichten können.</em></p>
            </div>
        </div>
    {else}
        <form method="post" action="" class="space-y-4">
            {csrf_field}
            <input type="hidden" name="editadminserver" value="1">

            {if $group_list}
                <div class="card">
                    <div class="card__header">
                        <div>
                            <h3>Servergruppen</h3>
                            <p>Die Gewährung einer Gruppe deckt jeden Server in dieser Gruppe ab.</p>
                        </div>
                    </div>
                    <div class="card__body">
                        <div class="grid gap-2" style="grid-template-columns:repeat(auto-fill,minmax(14rem,1fr))">
                            {foreach $group_list as $group}
                                <label class="flex items-center gap-2 p-3"
                                       style="border:1px solid var(--border);border-radius:var(--radius-md)">
                                    <input type="checkbox" id="group_{$group.gid}" name="group[]" value="g{$group.gid}"
                                           data-testid="edit-admin-server-group"
                                           {foreach $assigned_servers as $asrv}{if $asrv.srv_group_id == $group.gid}checked{/if}{/foreach}>
                                    <span class="text-sm">{$group.name|escape}</span>
                                </label>
                            {/foreach}
                        </div>
                    </div>
                </div>
            {/if}

            {if $server_list}
                <div class="card">
                    <div class="card__header">
                        <div>
                            <h3>Einzelne Server</h3>
                            <p>Einmaliger Zugriff für Server, die nicht Teil einer gewährten Gruppe sind.</p>
                        </div>
                    </div>
                    <div class="card__body">
                        <div class="grid gap-2" style="grid-template-columns:repeat(auto-fill,minmax(18rem,1fr))">
                            {foreach $server_list as $server}
                                <label class="flex items-center gap-2 p-3"
                                       style="border:1px solid var(--border);border-radius:var(--radius-md)">
                                    <input type="checkbox" id="server_{$server.sid}" name="servers[]" value="s{$server.sid}"
                                           data-testid="edit-admin-server"
                                           {foreach $assigned_servers as $asrv}{if $asrv.server_id == $server.sid}checked{/if}{/foreach}>
                                    <span class="text-sm font-mono">{$server.ip|escape}:{$server.port|escape}</span>
                                </label>
                            {/foreach}
                        </div>
                    </div>
                </div>
            {/if}

            <div class="flex justify-end gap-2">
                <button type="button" class="btn btn--ghost btn--sm"
                        onclick="history.go(-1);">Zurück</button>
                <button type="submit" class="btn btn--primary btn--sm" id="editadminserver"
                        data-testid="edit-admin-servers-save"><i data-lucide="save"></i> Änderungen speichern</button>
            </div>
        </form>
    {/if}
</div>
