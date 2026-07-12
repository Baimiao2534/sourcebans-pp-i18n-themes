{*
    SourceBans++ (c) 2014-2026 SourceBans++ Dev Team
    Licensed under the Elastic License 2.0.
    See LICENSE.txt for the full license text and THIRD-PARTY-NOTICES.txt for attributions.

    "Edit admin permissions" pair: web/pages/admin.edit.adminperms.php +
    web/includes/View/EditAdminPermsView.php.

    Replaces the v1.x-era inline `echo` of `groups.web.perm.php` and
    `groups.server.perm.php` partials and their `ProcessEditAdminPermissions()`
    / `ButtonOver(...)` / `UpdateCheckBox(...)` JS handlers (all dead since
    sourcebans.js was removed at #1123 D1).

    Initial checkbox state is server-rendered — no MooTools-era
    `$('p2').checked = true` re-paint script. The form submits via
    `Actions.AdminsEditPerms` (existing JSON action); the page-tail
    vanilla JS handles composite-toggle behaviour and the API round-trip.
*}
<div class="space-y-4" data-testid="admin-edit-perms">
    <div class="mb-4">
        <h1 style="font-size:var(--fs-xl);font-weight:600;margin:0">
            Permissions de {$admin_name|escape}
        </h1>
        <p class="text-sm text-muted m-0 mt-2">
            Activez un groupe parent pour activer / désactiver toutes les permissions enfant en dessous d'un seul coup.
        </p>
    </div>

    <form id="edit-perms-form" class="space-y-4" autocomplete="off"
          data-aid="{$admin_id}">
        {csrf_field}

        {* ============ Web Admin Permissions ============ *}
        <div class="card">
            <div class="card__header"><div>
                <h3>Permissions administrateur web</h3>
                <p>Permissions au sein du panneau lui-même.</p>
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
                            <td><strong>Administrateur racine</strong> (Accès complet)</td>
                            <td class="text-center">
                                <input type="checkbox" id="p2" data-perm="owner" {if $web_owner}checked{/if}>
                            </td>
                        </tr>
                        {/if}
                        <tr>
                            <td><strong>Gérer les administrateurs</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p3" data-parent="admins">
                            </td>
                        </tr>
                        <tr><td class="pl-6">Lister les administrateurs</td>
                            <td class="text-center"><input type="checkbox" id="p4" data-child="admins" {if $web_list_admins}checked{/if}></td></tr>
                        <tr><td class="pl-6">Ajouter des administrateurs</td>
                            <td class="text-center"><input type="checkbox" id="p5" data-child="admins" {if $web_add_admins}checked{/if}></td></tr>
                        <tr><td class="pl-6">Modifier les administrateurs</td>
                            <td class="text-center"><input type="checkbox" id="p6" data-child="admins" {if $web_edit_admins}checked{/if}></td></tr>
                        <tr><td class="pl-6">Supprimer les administrateurs</td>
                            <td class="text-center"><input type="checkbox" id="p7" data-child="admins" {if $web_delete_admins}checked{/if}></td></tr>

                        <tr>
                            <td><strong>Gestion des serveurs</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p8" data-parent="servers">
                            </td>
                        </tr>
                        <tr><td class="pl-6">Lister les serveurs</td>
                            <td class="text-center"><input type="checkbox" id="p9" data-child="servers" {if $web_list_servers}checked{/if}></td></tr>
                        <tr><td class="pl-6">Ajouter de nouveaux serveurs</td>
                            <td class="text-center"><input type="checkbox" id="p10" data-child="servers" {if $web_add_server}checked{/if}></td></tr>
                        <tr><td class="pl-6">Modifier les serveurs</td>
                            <td class="text-center"><input type="checkbox" id="p11" data-child="servers" {if $web_edit_servers}checked{/if}></td></tr>
                        <tr><td class="pl-6">Supprimer les serveurs</td>
                            <td class="text-center"><input type="checkbox" id="p12" data-child="servers" {if $web_delete_servers}checked{/if}></td></tr>

                        <tr>
                            <td><strong>Gestion des bannissements</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p13" data-parent="bans">
                            </td>
                        </tr>
                        <tr><td class="pl-6">Ajouter un bannissement</td>
                            <td class="text-center"><input type="checkbox" id="p14" data-child="bans" {if $web_add_ban}checked{/if}></td></tr>
                        <tr><td class="pl-6">Modifier ses propres bannissements</td>
                            <td class="text-center"><input type="checkbox" id="p16" data-child="bans" {if $web_edit_own_bans}checked{/if}></td></tr>
                        <tr><td class="pl-6">Modifier les bannissements du groupe</td>
                            <td class="text-center"><input type="checkbox" id="p17" data-child="bans" {if $web_edit_group_bans}checked{/if}></td></tr>
                        <tr><td class="pl-6">Modifier tous les bannissements</td>
                            <td class="text-center"><input type="checkbox" id="p18" data-child="bans" {if $web_edit_all_bans}checked{/if}></td></tr>
                        <tr><td class="pl-6">Appels de bannissement</td>
                            <td class="text-center"><input type="checkbox" id="p19" data-child="bans" {if $web_ban_protests}checked{/if}></td></tr>
                        <tr><td class="pl-6">Signalements de bannissement</td>
                            <td class="text-center"><input type="checkbox" id="p20" data-child="bans" {if $web_ban_submissions}checked{/if}></td></tr>
                        <tr><td class="pl-6">Lever ses propres bannissements</td>
                            <td class="text-center"><input type="checkbox" id="p38" data-child="bans" {if $web_unban_own_bans}checked{/if}></td></tr>
                        <tr><td class="pl-6">Lever les bannissements du groupe</td>
                            <td class="text-center"><input type="checkbox" id="p39" data-child="bans" {if $web_unban_group_bans}checked{/if}></td></tr>
                        <tr><td class="pl-6">Lever tous les bannissements</td>
                            <td class="text-center"><input type="checkbox" id="p32" data-child="bans" {if $web_unban}checked{/if}></td></tr>
                        <tr><td class="pl-6">Supprimer les bannissements</td>
                            <td class="text-center"><input type="checkbox" id="p33" data-child="bans" {if $web_delete_ban}checked{/if}></td></tr>
                        <tr><td class="pl-6">Importer des bannissements</td>
                            <td class="text-center"><input type="checkbox" id="p34" data-child="bans" {if $web_ban_import}checked{/if}></td></tr>

                        <tr>
                            <td><strong>Gestion des groupes</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p21" data-parent="groups">
                            </td>
                        </tr>
                        <tr><td class="pl-6">Lister les groupes</td>
                            <td class="text-center"><input type="checkbox" id="p22" data-child="groups" {if $web_list_groups}checked{/if}></td></tr>
                        <tr><td class="pl-6">Ajouter des groupes</td>
                            <td class="text-center"><input type="checkbox" id="p23" data-child="groups" {if $web_add_group}checked{/if}></td></tr>
                        <tr><td class="pl-6">Modifier les groupes</td>
                            <td class="text-center"><input type="checkbox" id="p24" data-child="groups" {if $web_edit_groups}checked{/if}></td></tr>
                        <tr><td class="pl-6">Supprimer les groupes</td>
                            <td class="text-center"><input type="checkbox" id="p25" data-child="groups" {if $web_delete_groups}checked{/if}></td></tr>

                        <tr>
                            <td><strong>Notifications par e-mail</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p35" data-parent="notify">
                            </td>
                        </tr>
                        <tr><td class="pl-6">Notifier lors d'un signalement</td>
                            <td class="text-center"><input type="checkbox" id="p36" data-child="notify" {if $web_notify_sub}checked{/if}></td></tr>
                        <tr><td class="pl-6">Notifier lors d'un appel</td>
                            <td class="text-center"><input type="checkbox" id="p37" data-child="notify" {if $web_notify_protest}checked{/if}></td></tr>

                        <tr>
                            <td><strong>Paramètres du panneau web</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p26" {if $web_settings}checked{/if}>
                            </td>
                        </tr>

                        <tr>
                            <td><strong>Gérer les mods</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p27" data-parent="mods">
                            </td>
                        </tr>
                        <tr><td class="pl-6">Lister les mods</td>
                            <td class="text-center"><input type="checkbox" id="p28" data-child="mods" {if $web_list_mods}checked{/if}></td></tr>
                        <tr><td class="pl-6">Ajouter des mods</td>
                            <td class="text-center"><input type="checkbox" id="p29" data-child="mods" {if $web_add_mods}checked{/if}></td></tr>
                        <tr><td class="pl-6">Modifier les mods</td>
                            <td class="text-center"><input type="checkbox" id="p30" data-child="mods" {if $web_edit_mods}checked{/if}></td></tr>
                        <tr><td class="pl-6">Supprimer les mods</td>
                            <td class="text-center"><input type="checkbox" id="p31" data-child="mods" {if $web_delete_mods}checked{/if}></td></tr>
                    </tbody>
                </table>
            </div>
        </div>

        {* ============ Server Admin Permissions ============ *}
        <div class="card">
            <div class="card__header"><div>
                <h3>Permissions administrateur serveur</h3>
                <p>Flags d'administrateur SourceMod appliqués à tous les serveurs que cet administrateur peut gérer.</p>
            </div></div>
            <div class="card__body">
                <table class="table" style="margin:0;font-size:var(--fs-sm)">
                    <thead>
                        <tr>
                            <th>Permission</th>
                            <th class="text-center" style="width:4rem">Flag</th>
                            <th>Objectif</th>
                            <th class="text-center" style="width:4rem">Activé</th>
                        </tr>
                    </thead>
                    <tbody>
                        {if $is_owner_editor}
                        <tr>
                            <td><strong>Administrateur racine</strong></td>
                            <td class="text-center font-mono">z</td>
                            <td>Active magiquement tous les flags.</td>
                            <td class="text-center"><input type="checkbox" id="s14" data-sm-flag="z" {if $sm_root}checked{/if}></td>
                        </tr>
                        {/if}
                        <tr><td>Slots réservés</td><td class="text-center font-mono">a</td><td>Accès aux slots réservés.</td>
                            <td class="text-center"><input type="checkbox" id="s1" data-sm-flag="a" {if $sm_reserved_slot}checked{/if}></td></tr>
                        <tr><td>Générique</td><td class="text-center font-mono">b</td><td>Administrateur générique ; requis pour les administrateurs.</td>
                            <td class="text-center"><input type="checkbox" id="s23" data-sm-flag="b" {if $sm_generic}checked{/if}></td></tr>
                        <tr><td>Expulser des joueurs</td><td class="text-center font-mono">c</td><td>Expulser d'autres joueurs.</td>
                            <td class="text-center"><input type="checkbox" id="s2" data-sm-flag="c" {if $sm_kick}checked{/if}></td></tr>
                        <tr><td>Bannir des joueurs</td><td class="text-center font-mono">d</td><td>Bannir d'autres joueurs.</td>
                            <td class="text-center"><input type="checkbox" id="s3" data-sm-flag="d" {if $sm_ban}checked{/if}></td></tr>
                        <tr><td>Lever un bannissement</td><td class="text-center font-mono">e</td><td>Supprimer des bannissements.</td>
                            <td class="text-center"><input type="checkbox" id="s4" data-sm-flag="e" {if $sm_unban}checked{/if}></td></tr>
                        <tr><td>Tuer</td><td class="text-center font-mono">f</td><td>Tuer / blesser d'autres joueurs.</td>
                            <td class="text-center"><input type="checkbox" id="s5" data-sm-flag="f" {if $sm_slay}checked{/if}></td></tr>
                        <tr><td>Changer de carte</td><td class="text-center font-mono">g</td><td>Changer la carte ou les fonctionnalités principales du jeu.</td>
                            <td class="text-center"><input type="checkbox" id="s6" data-sm-flag="g" {if $sm_map}checked{/if}></td></tr>
                        <tr><td>Modifier les cvars</td><td class="text-center font-mono">h</td><td>Modifier la plupart des cvars.</td>
                            <td class="text-center"><input type="checkbox" id="s7" data-sm-flag="h" {if $sm_cvar}checked{/if}></td></tr>
                        <tr><td>Exécuter des fichiers de config</td><td class="text-center font-mono">i</td><td>Exécuter des fichiers de configuration.</td>
                            <td class="text-center"><input type="checkbox" id="s8" data-sm-flag="i" {if $sm_config}checked{/if}></td></tr>
                        <tr><td>Chat administrateur</td><td class="text-center font-mono">j</td><td>Privilèges de chat spéciaux.</td>
                            <td class="text-center"><input type="checkbox" id="s9" data-sm-flag="j" {if $sm_chat}checked{/if}></td></tr>
                        <tr><td>Lancer des votes</td><td class="text-center font-mono">k</td><td>Lancer ou créer des votes.</td>
                            <td class="text-center"><input type="checkbox" id="s10" data-sm-flag="k" {if $sm_vote}checked{/if}></td></tr>
                        <tr><td>Mot de passe du serveur</td><td class="text-center font-mono">l</td><td>Définir un mot de passe sur le serveur.</td>
                            <td class="text-center"><input type="checkbox" id="s11" data-sm-flag="l" {if $sm_password}checked{/if}></td></tr>
                        <tr><td>Exécuter des commandes RCON</td><td class="text-center font-mono">m</td><td>Utiliser des commandes RCON.</td>
                            <td class="text-center"><input type="checkbox" id="s12" data-sm-flag="m" {if $sm_rcon}checked{/if}></td></tr>
                        <tr><td>Activer les triches</td><td class="text-center font-mono">n</td><td>Modifier sv_cheats ou utiliser des commandes de triche.</td>
                            <td class="text-center"><input type="checkbox" id="s13" data-sm-flag="n" {if $sm_cheats}checked{/if}></td></tr>
                        <tr>
                            <td>Immunité</td>
                            <td class="text-center font-mono">&mdash;</td>
                            <td>Numéro plus élevé = plus d'immunité.</td>
                            <td class="text-center">
                                <input class="input" type="number" min="0" id="immunity"
                                       value="{$immunity|escape}" style="width:5rem;text-align:center">
                            </td>
                        </tr>
                        <tr><td>Flag personnalisé &quot;o&quot;</td><td class="text-center font-mono">o</td><td>&nbsp;</td>
                            <td class="text-center"><input type="checkbox" id="s17" data-sm-flag="o" {if $sm_custom1}checked{/if}></td></tr>
                        <tr><td>Flag personnalisé &quot;p&quot;</td><td class="text-center font-mono">p</td><td>&nbsp;</td>
                            <td class="text-center"><input type="checkbox" id="s18" data-sm-flag="p" {if $sm_custom2}checked{/if}></td></tr>
                        <tr><td>Flag personnalisé &quot;q&quot;</td><td class="text-center font-mono">q</td><td>&nbsp;</td>
                            <td class="text-center"><input type="checkbox" id="s19" data-sm-flag="q" {if $sm_custom3}checked{/if}></td></tr>
                        <tr><td>Flag personnalisé &quot;r&quot;</td><td class="text-center font-mono">r</td><td>&nbsp;</td>
                            <td class="text-center"><input type="checkbox" id="s20" data-sm-flag="r" {if $sm_custom4}checked{/if}></td></tr>
                        <tr><td>Flag personnalisé &quot;s&quot;</td><td class="text-center font-mono">s</td><td>&nbsp;</td>
                            <td class="text-center"><input type="checkbox" id="s21" data-sm-flag="s" {if $sm_custom5}checked{/if}></td></tr>
                        <tr><td>Flag personnalisé &quot;t&quot;</td><td class="text-center font-mono">t</td><td>&nbsp;</td>
                            <td class="text-center"><input type="checkbox" id="s22" data-sm-flag="t" {if $sm_custom6}checked{/if}></td></tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="flex gap-2">
            <button type="submit" class="btn btn--primary"
                    data-testid="admin-edit-perms-save">Enregistrer les modifications</button>
            <a class="btn btn--ghost" href="index.php?p=admin&amp;c=admins">Annuler</a>
        </div>
    </form>
</div>
