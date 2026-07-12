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
            Права {$admin_name|escape}
        </h1>
        <p class="text-sm text-muted m-0 mt-2">
            Переключите родительскую группу, чтобы включить / отключить сразу все дочерние права внутри неё.
        </p>
    </div>

    <form id="edit-perms-form" class="space-y-4" autocomplete="off"
          data-aid="{$admin_id}">
        {csrf_field}

        {* ============ Web Admin Permissions ============ *}
        <div class="card">
            <div class="card__header"><div>
                <h3>Права веб-администратора</h3>
                <p>Права внутри самой панели.</p>
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
                            <td><strong>Root-администратор</strong> (Полный доступ)</td>
                            <td class="text-center">
                                <input type="checkbox" id="p2" data-perm="owner" {if $web_owner}checked{/if}>
                            </td>
                        </tr>
                        {/if}
                        <tr>
                            <td><strong>Управление администраторами</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p3" data-parent="admins">
                            </td>
                        </tr>
                        <tr><td class="pl-6">Список администраторов</td>
                            <td class="text-center"><input type="checkbox" id="p4" data-child="admins" {if $web_list_admins}checked{/if}></td></tr>
                        <tr><td class="pl-6">Добавление администраторов</td>
                            <td class="text-center"><input type="checkbox" id="p5" data-child="admins" {if $web_add_admins}checked{/if}></td></tr>
                        <tr><td class="pl-6">Изменение администраторов</td>
                            <td class="text-center"><input type="checkbox" id="p6" data-child="admins" {if $web_edit_admins}checked{/if}></td></tr>
                        <tr><td class="pl-6">Удаление администраторов</td>
                            <td class="text-center"><input type="checkbox" id="p7" data-child="admins" {if $web_delete_admins}checked{/if}></td></tr>

                        <tr>
                            <td><strong>Управление серверами</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p8" data-parent="servers">
                            </td>
                        </tr>
                        <tr><td class="pl-6">Список серверов</td>
                            <td class="text-center"><input type="checkbox" id="p9" data-child="servers" {if $web_list_servers}checked{/if}></td></tr>
                        <tr><td class="pl-6">Добавление серверов</td>
                            <td class="text-center"><input type="checkbox" id="p10" data-child="servers" {if $web_add_server}checked{/if}></td></tr>
                        <tr><td class="pl-6">Изменение серверов</td>
                            <td class="text-center"><input type="checkbox" id="p11" data-child="servers" {if $web_edit_servers}checked{/if}></td></tr>
                        <tr><td class="pl-6">Удаление серверов</td>
                            <td class="text-center"><input type="checkbox" id="p12" data-child="servers" {if $web_delete_servers}checked{/if}></td></tr>

                        <tr>
                            <td><strong>Управление банами</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p13" data-parent="bans">
                            </td>
                        </tr>
                        <tr><td class="pl-6">Добавить бан</td>
                            <td class="text-center"><input type="checkbox" id="p14" data-child="bans" {if $web_add_ban}checked{/if}></td></tr>
                        <tr><td class="pl-6">Изменение своих банов</td>
                            <td class="text-center"><input type="checkbox" id="p16" data-child="bans" {if $web_edit_own_bans}checked{/if}></td></tr>
                        <tr><td class="pl-6">Изменение банов группы</td>
                            <td class="text-center"><input type="checkbox" id="p17" data-child="bans" {if $web_edit_group_bans}checked{/if}></td></tr>
                        <tr><td class="pl-6">Изменение всех банов</td>
                            <td class="text-center"><input type="checkbox" id="p18" data-child="bans" {if $web_edit_all_bans}checked{/if}></td></tr>
                        <tr><td class="pl-6">Апелляции на баны</td>
                            <td class="text-center"><input type="checkbox" id="p19" data-child="bans" {if $web_ban_protests}checked{/if}></td></tr>
                        <tr><td class="pl-6">Заявки на баны</td>
                            <td class="text-center"><input type="checkbox" id="p20" data-child="bans" {if $web_ban_submissions}checked{/if}></td></tr>
                        <tr><td class="pl-6">Снятие своих банов</td>
                            <td class="text-center"><input type="checkbox" id="p38" data-child="bans" {if $web_unban_own_bans}checked{/if}></td></tr>
                        <tr><td class="pl-6">Снятие банов группы</td>
                            <td class="text-center"><input type="checkbox" id="p39" data-child="bans" {if $web_unban_group_bans}checked{/if}></td></tr>
                        <tr><td class="pl-6">Снятие всех банов</td>
                            <td class="text-center"><input type="checkbox" id="p32" data-child="bans" {if $web_unban}checked{/if}></td></tr>
                        <tr><td class="pl-6">Удаление банов</td>
                            <td class="text-center"><input type="checkbox" id="p33" data-child="bans" {if $web_delete_ban}checked{/if}></td></tr>
                        <tr><td class="pl-6">Импорт банов</td>
                            <td class="text-center"><input type="checkbox" id="p34" data-child="bans" {if $web_ban_import}checked{/if}></td></tr>

                        <tr>
                            <td><strong>Управление группами</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p21" data-parent="groups">
                            </td>
                        </tr>
                        <tr><td class="pl-6">Список групп</td>
                            <td class="text-center"><input type="checkbox" id="p22" data-child="groups" {if $web_list_groups}checked{/if}></td></tr>
                        <tr><td class="pl-6">Добавление групп</td>
                            <td class="text-center"><input type="checkbox" id="p23" data-child="groups" {if $web_add_group}checked{/if}></td></tr>
                        <tr><td class="pl-6">Изменение групп</td>
                            <td class="text-center"><input type="checkbox" id="p24" data-child="groups" {if $web_edit_groups}checked{/if}></td></tr>
                        <tr><td class="pl-6">Удаление групп</td>
                            <td class="text-center"><input type="checkbox" id="p25" data-child="groups" {if $web_delete_groups}checked{/if}></td></tr>

                        <tr>
                            <td><strong>Уведомления на email</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p35" data-parent="notify">
                            </td>
                        </tr>
                        <tr><td class="pl-6">Уведомлять о заявках</td>
                            <td class="text-center"><input type="checkbox" id="p36" data-child="notify" {if $web_notify_sub}checked{/if}></td></tr>
                        <tr><td class="pl-6">Уведомлять об апелляциях</td>
                            <td class="text-center"><input type="checkbox" id="p37" data-child="notify" {if $web_notify_protest}checked{/if}></td></tr>

                        <tr>
                            <td><strong>Настройки веб-панели</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p26" {if $web_settings}checked{/if}>
                            </td>
                        </tr>

                        <tr>
                            <td><strong>Управление модами</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p27" data-parent="mods">
                            </td>
                        </tr>
                        <tr><td class="pl-6">Список модов</td>
                            <td class="text-center"><input type="checkbox" id="p28" data-child="mods" {if $web_list_mods}checked{/if}></td></tr>
                        <tr><td class="pl-6">Добавление модов</td>
                            <td class="text-center"><input type="checkbox" id="p29" data-child="mods" {if $web_add_mods}checked{/if}></td></tr>
                        <tr><td class="pl-6">Изменение модов</td>
                            <td class="text-center"><input type="checkbox" id="p30" data-child="mods" {if $web_edit_mods}checked{/if}></td></tr>
                        <tr><td class="pl-6">Удаление модов</td>
                            <td class="text-center"><input type="checkbox" id="p31" data-child="mods" {if $web_delete_mods}checked{/if}></td></tr>
                    </tbody>
                </table>
            </div>
        </div>

        {* ============ Server Admin Permissions ============ *}
        <div class="card">
            <div class="card__header"><div>
                <h3>Права серверного администратора</h3>
                <p>Флаги администратора SourceMod, применяемые ко всем серверам, которыми может управлять этот администратор.</p>
            </div></div>
            <div class="card__body">
                <table class="table" style="margin:0;font-size:var(--fs-sm)">
                    <thead>
                        <tr>
                            <th>Право</th>
                            <th class="text-center" style="width:4rem">Флаг</th>
                            <th>Назначение</th>
                            <th class="text-center" style="width:4rem">Вкл</th>
                        </tr>
                    </thead>
                    <tbody>
                        {if $is_owner_editor}
                        <tr>
                            <td><strong>Root-администратор</strong></td>
                            <td class="text-center font-mono">z</td>
                            <td>Автоматически включает все флаги.</td>
                            <td class="text-center"><input type="checkbox" id="s14" data-sm-flag="z" {if $sm_root}checked{/if}></td>
                        </tr>
                        {/if}
                        <tr><td>Зарезервированные слоты</td><td class="text-center font-mono">a</td><td>Доступ к зарезервированным слотам.</td>
                            <td class="text-center"><input type="checkbox" id="s1" data-sm-flag="a" {if $sm_reserved_slot}checked{/if}></td></tr>
                        <tr><td>Общие</td><td class="text-center font-mono">b</td><td>Базовый флаг администратора; обязателен для администраторов.</td>
                            <td class="text-center"><input type="checkbox" id="s23" data-sm-flag="b" {if $sm_generic}checked{/if}></td></tr>
                        <tr><td>Кик игроков</td><td class="text-center font-mono">c</td><td>Кикать других игроков.</td>
                            <td class="text-center"><input type="checkbox" id="s2" data-sm-flag="c" {if $sm_kick}checked{/if}></td></tr>
                        <tr><td>Бан игроков</td><td class="text-center font-mono">d</td><td>Банить других игроков.</td>
                            <td class="text-center"><input type="checkbox" id="s3" data-sm-flag="d" {if $sm_ban}checked{/if}></td></tr>
                        <tr><td>Снятие банов</td><td class="text-center font-mono">e</td><td>Снимать баны.</td>
                            <td class="text-center"><input type="checkbox" id="s4" data-sm-flag="e" {if $sm_unban}checked{/if}></td></tr>
                        <tr><td>Убийство</td><td class="text-center font-mono">f</td><td>Убивать / наносить урон другим игрокам.</td>
                            <td class="text-center"><input type="checkbox" id="s5" data-sm-flag="f" {if $sm_slay}checked{/if}></td></tr>
                        <tr><td>Смена карты</td><td class="text-center font-mono">g</td><td>Менять карту или ключевые параметры игры.</td>
                            <td class="text-center"><input type="checkbox" id="s6" data-sm-flag="g" {if $sm_map}checked{/if}></td></tr>
                        <tr><td>Изменение cvars</td><td class="text-center font-mono">h</td><td>Изменять большинство cvars.</td>
                            <td class="text-center"><input type="checkbox" id="s7" data-sm-flag="h" {if $sm_cvar}checked{/if}></td></tr>
                        <tr><td>Выполнение конфигов</td><td class="text-center font-mono">i</td><td>Выполнять конфигурационные файлы.</td>
                            <td class="text-center"><input type="checkbox" id="s8" data-sm-flag="i" {if $sm_config}checked{/if}></td></tr>
                        <tr><td>Админ-чат</td><td class="text-center font-mono">j</td><td>Особые права в чате.</td>
                            <td class="text-center"><input type="checkbox" id="s9" data-sm-flag="j" {if $sm_chat}checked{/if}></td></tr>
                        <tr><td>Запуск голосований</td><td class="text-center font-mono">k</td><td>Начинать или создавать голосования.</td>
                            <td class="text-center"><input type="checkbox" id="s10" data-sm-flag="k" {if $sm_vote}checked{/if}></td></tr>
                        <tr><td>Пароль на сервер</td><td class="text-center font-mono">l</td><td>Устанавливать пароль на сервер.</td>
                            <td class="text-center"><input type="checkbox" id="s11" data-sm-flag="l" {if $sm_password}checked{/if}></td></tr>
                        <tr><td>RCON команды</td><td class="text-center font-mono">m</td><td>Использовать RCON команды.</td>
                            <td class="text-center"><input type="checkbox" id="s12" data-sm-flag="m" {if $sm_rcon}checked{/if}></td></tr>
                        <tr><td>Включение читов</td><td class="text-center font-mono">n</td><td>Изменять sv_cheats или использовать чит-команды.</td>
                            <td class="text-center"><input type="checkbox" id="s13" data-sm-flag="n" {if $sm_cheats}checked{/if}></td></tr>
                        <tr>
                            <td>Иммунитет</td>
                            <td class="text-center font-mono">&mdash;</td>
                            <td>Большее значение = выше иммунитет.</td>
                            <td class="text-center">
                                <input class="input" type="number" min="0" id="immunity"
                                       value="{$immunity|escape}" style="width:5rem;text-align:center">
                            </td>
                        </tr>
                        <tr><td>Пользовательский флаг &quot;o&quot;</td><td class="text-center font-mono">o</td><td>&nbsp;</td>
                            <td class="text-center"><input type="checkbox" id="s17" data-sm-flag="o" {if $sm_custom1}checked{/if}></td></tr>
                        <tr><td>Пользовательский флаг &quot;p&quot;</td><td class="text-center font-mono">p</td><td>&nbsp;</td>
                            <td class="text-center"><input type="checkbox" id="s18" data-sm-flag="p" {if $sm_custom2}checked{/if}></td></tr>
                        <tr><td>Пользовательский флаг &quot;q&quot;</td><td class="text-center font-mono">q</td><td>&nbsp;</td>
                            <td class="text-center"><input type="checkbox" id="s19" data-sm-flag="q" {if $sm_custom3}checked{/if}></td></tr>
                        <tr><td>Пользовательский флаг &quot;r&quot;</td><td class="text-center font-mono">r</td><td>&nbsp;</td>
                            <td class="text-center"><input type="checkbox" id="s20" data-sm-flag="r" {if $sm_custom4}checked{/if}></td></tr>
                        <tr><td>Пользовательский флаг &quot;s&quot;</td><td class="text-center font-mono">s</td><td>&nbsp;</td>
                            <td class="text-center"><input type="checkbox" id="s21" data-sm-flag="s" {if $sm_custom5}checked{/if}></td></tr>
                        <tr><td>Пользовательский флаг &quot;t&quot;</td><td class="text-center font-mono">t</td><td>&nbsp;</td>
                            <td class="text-center"><input type="checkbox" id="s22" data-sm-flag="t" {if $sm_custom6}checked{/if}></td></tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="flex gap-2">
            <button type="submit" class="btn btn--primary"
                    data-testid="admin-edit-perms-save">Сохранить изменения</button>
            <a class="btn btn--ghost" href="index.php?p=admin&amp;c=admins">Отмена</a>
        </div>
    </form>
</div>
