{*
    SourceBans++ (c) 2014-2026 SourceBans++ Dev Team
    Licensed under the Elastic License 2.0.
    See LICENSE.txt for the full license text and THIRD-PARTY-NOTICES.txt for attributions.

    "Edit group" pair: web/pages/admin.edit.group.php +
    web/includes/View/EditGroupView.php.

    Replaces the v1.x-era inline `echo` of `groups.web.perm.php` /
    `groups.server.perm.php` partials and the `ProcessEditGroup()` /
    `ButtonOver()` / `$('groupname').value` legacy JS handlers (all
    dead since sourcebans.js was removed at #1123 D1).

    Initial state is fully server-rendered; the page-tail vanilla JS
    handles the parent / child composite toggles, the dynamic
    overrides editor, and submission via `Actions.GroupsEdit`.
*}
<div class="space-y-4" data-testid="admin-edit-group">
    <div class="mb-4">
        <h1 style="font-size:var(--fs-xl);font-weight:600;margin:0">
            Gruppe bearbeiten
        </h1>
        <p class="text-sm text-muted m-0 mt-2">
            {if $type === 'srv'}Servergruppe: SourceMod-Administrator-Flags + pro-Befehl-Overrides.
            {else}Webgruppe: Panel-seitige Berechtigungen.{/if}
        </p>
    </div>

    <form id="edit-group-form" class="space-y-4" autocomplete="off"
          data-gid="{$group_id}" data-type="{$type|escape}">
        {csrf_field}

        <div class="card">
            <div class="card__header"><div>
                <h3>Gruppenname</h3>
            </div></div>
            <div class="card__body">
                <label class="label" for="groupname">Gruppenname</label>
                <input class="input" id="groupname" name="groupname" type="text"
                       value="{$group_name|escape}" data-testid="group-name">
                <div id="groupname.msg" class="text-xs" style="color:var(--danger);margin-top:0.25rem"></div>
            </div>
        </div>

        {if $type === 'web'}
            {* ============ Web Admin Permissions ============ *}
            <div class="card">
                <div class="card__header"><div>
                    <h3>Web-Administratorberechtigungen</h3>
                </div></div>
                <div class="card__body">
                    <table class="table" style="margin:0;font-size:var(--fs-sm)">
                        <colgroup>
                            <col style="width:auto">
                            <col style="width:5rem">
                        </colgroup>
                        <tbody>
                            {if $is_owner_editor}
                            <tr>
                                <td><strong>Root-Administrator</strong> (Vollzugriff)</td>
                                <td class="text-center">
                                    <input type="checkbox" id="p2" data-perm="owner" {if $web_owner}checked{/if}>
                                </td>
                            </tr>
                            {/if}
                            <tr><td><strong>Administratoren verwalten</strong></td>
                                <td class="text-center"><input type="checkbox" id="p3" data-parent="admins"></td></tr>
                            <tr><td class="pl-6">Administratoren auflisten</td>
                                <td class="text-center"><input type="checkbox" id="p4" data-child="admins" {if $web_list_admins}checked{/if}></td></tr>
                            <tr><td class="pl-6">Administratoren hinzufügen</td>
                                <td class="text-center"><input type="checkbox" id="p5" data-child="admins" {if $web_add_admins}checked{/if}></td></tr>
                            <tr><td class="pl-6">Administratoren bearbeiten</td>
                                <td class="text-center"><input type="checkbox" id="p6" data-child="admins" {if $web_edit_admins}checked{/if}></td></tr>
                            <tr><td class="pl-6">Administratoren löschen</td>
                                <td class="text-center"><input type="checkbox" id="p7" data-child="admins" {if $web_delete_admins}checked{/if}></td></tr>

                            <tr><td><strong>Serververwaltung</strong></td>
                                <td class="text-center"><input type="checkbox" id="p8" data-parent="servers"></td></tr>
                            <tr><td class="pl-6">Server auflisten</td>
                                <td class="text-center"><input type="checkbox" id="p9" data-child="servers" {if $web_list_servers}checked{/if}></td></tr>
                            <tr><td class="pl-6">Neue Server hinzufügen</td>
                                <td class="text-center"><input type="checkbox" id="p10" data-child="servers" {if $web_add_server}checked{/if}></td></tr>
                            <tr><td class="pl-6">Server bearbeiten</td>
                                <td class="text-center"><input type="checkbox" id="p11" data-child="servers" {if $web_edit_servers}checked{/if}></td></tr>
                            <tr><td class="pl-6">Server löschen</td>
                                <td class="text-center"><input type="checkbox" id="p12" data-child="servers" {if $web_delete_servers}checked{/if}></td></tr>

                            <tr><td><strong>Bannverwaltung</strong></td>
                                <td class="text-center"><input type="checkbox" id="p13" data-parent="bans"></td></tr>
                            <tr><td class="pl-6">Bann hinzufügen</td>
                                <td class="text-center"><input type="checkbox" id="p14" data-child="bans" {if $web_add_ban}checked{/if}></td></tr>
                            <tr><td class="pl-6">Eigene Banns bearbeiten</td>
                                <td class="text-center"><input type="checkbox" id="p16" data-child="bans" {if $web_edit_own_bans}checked{/if}></td></tr>
                            <tr><td class="pl-6">Banns der Gruppe bearbeiten</td>
                                <td class="text-center"><input type="checkbox" id="p17" data-child="bans" {if $web_edit_group_bans}checked{/if}></td></tr>
                            <tr><td class="pl-6">Alle Banns bearbeiten</td>
                                <td class="text-center"><input type="checkbox" id="p18" data-child="bans" {if $web_edit_all_bans}checked{/if}></td></tr>
                            <tr><td class="pl-6">Bann-Einsprüche</td>
                                <td class="text-center"><input type="checkbox" id="p19" data-child="bans" {if $web_ban_protests}checked{/if}></td></tr>
                            <tr><td class="pl-6">Bann-Einreichungen</td>
                                <td class="text-center"><input type="checkbox" id="p20" data-child="bans" {if $web_ban_submissions}checked{/if}></td></tr>
                            <tr><td class="pl-6">Eigene Banns aufheben</td>
                                <td class="text-center"><input type="checkbox" id="p38" data-child="bans" {if $web_unban_own_bans}checked{/if}></td></tr>
                            <tr><td class="pl-6">Banns der Gruppe aufheben</td>
                                <td class="text-center"><input type="checkbox" id="p39" data-child="bans" {if $web_unban_group_bans}checked{/if}></td></tr>
                            <tr><td class="pl-6">Alle Banns aufheben</td>
                                <td class="text-center"><input type="checkbox" id="p32" data-child="bans" {if $web_unban}checked{/if}></td></tr>
                            <tr><td class="pl-6">Banns löschen</td>
                                <td class="text-center"><input type="checkbox" id="p33" data-child="bans" {if $web_delete_ban}checked{/if}></td></tr>
                            <tr><td class="pl-6">Banns importieren</td>
                                <td class="text-center"><input type="checkbox" id="p34" data-child="bans" {if $web_ban_import}checked{/if}></td></tr>

                            <tr><td><strong>Gruppenverwaltung</strong></td>
                                <td class="text-center"><input type="checkbox" id="p21" data-parent="groups"></td></tr>
                            <tr><td class="pl-6">Gruppen auflisten</td>
                                <td class="text-center"><input type="checkbox" id="p22" data-child="groups" {if $web_list_groups}checked{/if}></td></tr>
                            <tr><td class="pl-6">Gruppen hinzufügen</td>
                                <td class="text-center"><input type="checkbox" id="p23" data-child="groups" {if $web_add_group}checked{/if}></td></tr>
                            <tr><td class="pl-6">Gruppen bearbeiten</td>
                                <td class="text-center"><input type="checkbox" id="p24" data-child="groups" {if $web_edit_groups}checked{/if}></td></tr>
                            <tr><td class="pl-6">Gruppen löschen</td>
                                <td class="text-center"><input type="checkbox" id="p25" data-child="groups" {if $web_delete_groups}checked{/if}></td></tr>

                            <tr><td><strong>E-Mail-Benachrichtigungen</strong></td>
                                <td class="text-center"><input type="checkbox" id="p35" data-parent="notify"></td></tr>
                            <tr><td class="pl-6">Bei Einreichung benachrichtigen</td>
                                <td class="text-center"><input type="checkbox" id="p36" data-child="notify" {if $web_notify_sub}checked{/if}></td></tr>
                            <tr><td class="pl-6">Bei Einspruch benachrichtigen</td>
                                <td class="text-center"><input type="checkbox" id="p37" data-child="notify" {if $web_notify_protest}checked{/if}></td></tr>

                            <tr><td><strong>Web-Panel-Einstellungen</strong></td>
                                <td class="text-center"><input type="checkbox" id="p26" {if $web_settings}checked{/if}></td></tr>

                            <tr><td><strong>Mods verwalten</strong></td>
                                <td class="text-center"><input type="checkbox" id="p27" data-parent="mods"></td></tr>
                            <tr><td class="pl-6">Mods auflisten</td>
                                <td class="text-center"><input type="checkbox" id="p28" data-child="mods" {if $web_list_mods}checked{/if}></td></tr>
                            <tr><td class="pl-6">Mods hinzufügen</td>
                                <td class="text-center"><input type="checkbox" id="p29" data-child="mods" {if $web_add_mods}checked{/if}></td></tr>
                            <tr><td class="pl-6">Mods bearbeiten</td>
                                <td class="text-center"><input type="checkbox" id="p30" data-child="mods" {if $web_edit_mods}checked{/if}></td></tr>
                            <tr><td class="pl-6">Mods löschen</td>
                                <td class="text-center"><input type="checkbox" id="p31" data-child="mods" {if $web_delete_mods}checked{/if}></td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        {else}
            {* ============ Server Admin Permissions ============ *}
            <div class="card">
                <div class="card__header"><div>
                    <h3>Server-Administratorberechtigungen</h3>
                </div></div>
                <div class="card__body">
                    <table class="table" style="margin:0;font-size:var(--fs-sm)">
                        <thead><tr>
                            <th>Berechtigung</th>
                            <th class="text-center" style="width:4rem">Flag</th>
                            <th>Zweck</th>
                            <th class="text-center" style="width:4rem">An</th>
                        </tr></thead>
                        <tbody>
                            {if $is_owner_editor}
                            <tr>
                                <td><strong>Root-Administrator</strong></td>
                                <td class="text-center font-mono">z</td>
                                <td>Aktiviert magisch alle Flags.</td>
                                <td class="text-center"><input type="checkbox" id="s14" data-sm-flag="z" {if $sm_root}checked{/if}></td>
                            </tr>
                            {/if}
                            <tr><td>Reservierte Slots</td><td class="text-center font-mono">a</td><td>Zugriff auf reservierte Slots.</td>
                                <td class="text-center"><input type="checkbox" id="s1" data-sm-flag="a" {if $sm_reserved_slot}checked{/if}></td></tr>
                            <tr><td>Generisch</td><td class="text-center font-mono">b</td><td>Generischer Administrator; für Administratoren erforderlich.</td>
                                <td class="text-center"><input type="checkbox" id="s23" data-sm-flag="b" {if $sm_generic}checked{/if}></td></tr>
                            <tr><td>Spieler kicken</td><td class="text-center font-mono">c</td><td>Andere Spieler kicken.</td>
                                <td class="text-center"><input type="checkbox" id="s2" data-sm-flag="c" {if $sm_kick}checked{/if}></td></tr>
                            <tr><td>Spieler bannen</td><td class="text-center font-mono">d</td><td>Andere Spieler bannen.</td>
                                <td class="text-center"><input type="checkbox" id="s3" data-sm-flag="d" {if $sm_ban}checked{/if}></td></tr>
                            <tr><td>Spieler entbannen</td><td class="text-center font-mono">e</td><td>Banns entfernen.</td>
                                <td class="text-center"><input type="checkbox" id="s4" data-sm-flag="e" {if $sm_unban}checked{/if}></td></tr>
                            <tr><td>Töten</td><td class="text-center font-mono">f</td><td>Andere Spieler töten oder verletzen.</td>
                                <td class="text-center"><input type="checkbox" id="s5" data-sm-flag="f" {if $sm_slay}checked{/if}></td></tr>
                            <tr><td>Kartenwechsel</td><td class="text-center font-mono">g</td><td>Karte oder wichtige Spielmechaniken ändern.</td>
                                <td class="text-center"><input type="checkbox" id="s6" data-sm-flag="g" {if $sm_map}checked{/if}></td></tr>
                            <tr><td>Cvars ändern</td><td class="text-center font-mono">h</td><td>Die meisten Cvars ändern.</td>
                                <td class="text-center"><input type="checkbox" id="s7" data-sm-flag="h" {if $sm_cvar}checked{/if}></td></tr>
                            <tr><td>Konfigurationsdateien ausführen</td><td class="text-center font-mono">i</td><td>Konfigurationsdateien ausführen.</td>
                                <td class="text-center"><input type="checkbox" id="s8" data-sm-flag="i" {if $sm_config}checked{/if}></td></tr>
                            <tr><td>Administrator-Chat</td><td class="text-center font-mono">j</td><td>Besondere Chat-Berechtigungen.</td>
                                <td class="text-center"><input type="checkbox" id="s9" data-sm-flag="j" {if $sm_chat}checked{/if}></td></tr>
                            <tr><td>Abstimmungen starten</td><td class="text-center font-mono">k</td><td>Abstimmungen starten oder erstellen.</td>
                                <td class="text-center"><input type="checkbox" id="s10" data-sm-flag="k" {if $sm_vote}checked{/if}></td></tr>
                            <tr><td>Server-Passwort</td><td class="text-center font-mono">l</td><td>Passwort für den Server festlegen.</td>
                                <td class="text-center"><input type="checkbox" id="s11" data-sm-flag="l" {if $sm_password}checked{/if}></td></tr>
                            <tr><td>RCON-Befehle ausführen</td><td class="text-center font-mono">m</td><td>RCON-Befehle verwenden.</td>
                                <td class="text-center"><input type="checkbox" id="s12" data-sm-flag="m" {if $sm_rcon}checked{/if}></td></tr>
                            <tr><td>Cheats aktivieren</td><td class="text-center font-mono">n</td><td>sv_cheats ändern oder Cheat-Befehle verwenden.</td>
                                <td class="text-center"><input type="checkbox" id="s13" data-sm-flag="n" {if $sm_cheats}checked{/if}></td></tr>
                            <tr>
                                <td>Immunität</td>
                                <td class="text-center font-mono">&mdash;</td>
                                <td>Höhere Zahl = höhere Immunität.</td>
                                <td class="text-center">
                                    <input class="input" type="number" min="0" id="immunity"
                                           value="{$immunity|escape}" style="width:5rem;text-align:center">
                                </td>
                            </tr>
                            <tr><td>Benutzerdefiniertes Flag &quot;o&quot;</td><td class="text-center font-mono">o</td><td>&nbsp;</td>
                                <td class="text-center"><input type="checkbox" id="s17" data-sm-flag="o" {if $sm_custom1}checked{/if}></td></tr>
                            <tr><td>Benutzerdefiniertes Flag &quot;p&quot;</td><td class="text-center font-mono">p</td><td>&nbsp;</td>
                                <td class="text-center"><input type="checkbox" id="s18" data-sm-flag="p" {if $sm_custom2}checked{/if}></td></tr>
                            <tr><td>Benutzerdefiniertes Flag &quot;q&quot;</td><td class="text-center font-mono">q</td><td>&nbsp;</td>
                                <td class="text-center"><input type="checkbox" id="s19" data-sm-flag="q" {if $sm_custom3}checked{/if}></td></tr>
                            <tr><td>Benutzerdefiniertes Flag &quot;r&quot;</td><td class="text-center font-mono">r</td><td>&nbsp;</td>
                                <td class="text-center"><input type="checkbox" id="s20" data-sm-flag="r" {if $sm_custom4}checked{/if}></td></tr>
                            <tr><td>Benutzerdefiniertes Flag &quot;s&quot;</td><td class="text-center font-mono">s</td><td>&nbsp;</td>
                                <td class="text-center"><input type="checkbox" id="s21" data-sm-flag="s" {if $sm_custom5}checked{/if}></td></tr>
                            <tr><td>Benutzerdefiniertes Flag &quot;t&quot;</td><td class="text-center font-mono">t</td><td>&nbsp;</td>
                                <td class="text-center"><input type="checkbox" id="s22" data-sm-flag="t" {if $sm_custom6}checked{/if}></td></tr>
                        </tbody>
                    </table>
                </div>
            </div>

            {* ============ Group Overrides ============ *}
            <div class="card">
                <div class="card__header"><div>
                    <h3>Gruppen-Overrides</h3>
                    <p>
                        Gruppen-Overrides erlauben es, bestimmte Befehle oder Befehlsgruppen für Mitglieder der Gruppe
                        vollständig zuzulassen oder zu verweigern. Lesen Sie mehr über
                        <a href="http://wiki.alliedmods.net/Adding_Groups_%28SourceMod%29" target="_blank" rel="noopener noreferrer">Gruppen-Overrides</a>
                        im AlliedModders-Wiki.
                    </p>
                    <p class="text-sm text-muted m-0 mt-2">
                        Das Leeren des Namens eines Overrides löscht diesen.
                    </p>
                </div></div>
                <div class="card__body">
                    <table class="table" style="margin:0;font-size:var(--fs-sm)" id="overrides-table">
                        <thead><tr>
                            <th style="width:7rem">Typ</th>
                            <th>Name</th>
                            <th style="width:7rem">Zugriff</th>
                        </tr></thead>
                        <tbody data-overrides-body>
                            {foreach $overrides as $override}
                                <tr data-override-row data-override-id="{$override.id}">
                                    <td>
                                        <select class="input" data-override-field="type">
                                            <option value="command" {if $override.type === 'command'}selected{/if}>Befehl</option>
                                            <option value="group"   {if $override.type === 'group'}selected{/if}>Gruppe</option>
                                        </select>
                                    </td>
                                    <td>
                                        <input class="input" type="text"
                                               data-override-field="name" value="{$override.name|escape}">
                                    </td>
                                    <td>
                                        <select class="input" data-override-field="access">
                                            <option value="allow" {if $override.access === 'allow'}selected{/if}>Erlauben</option>
                                            <option value="deny"  {if $override.access === 'deny'}selected{/if}>Verweigern</option>
                                        </select>
                                    </td>
                                </tr>
                            {/foreach}
                            <tr data-override-new>
                                <td>
                                    <select class="input" id="new_override_type">
                                        <option value="command">Befehl</option>
                                        <option value="group">Gruppe</option>
                                    </select>
                                </td>
                                <td><input class="input" type="text" id="new_override_name" placeholder="(leer = kein neuer Override)"></td>
                                <td>
                                    <select class="input" id="new_override_access">
                                        <option value="allow">Erlauben</option>
                                        <option value="deny">Verweigern</option>
                                    </select>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        {/if}

        <div class="flex gap-2">
            <button type="submit" class="btn btn--primary"
                    data-testid="admin-edit-group-save">Änderungen speichern</button>
            <a class="btn btn--ghost" href="index.php?p=admin&amp;c=groups">Abbrechen</a>
        </div>
    </form>
</div>
