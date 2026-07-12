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
            編輯分組
        </h1>
        <p class="text-sm text-muted m-0 mt-2">
            {if $type === 'srv'}伺服器分組：SourceMod 管理員旗標 + 各指令覆寫。
            {else}網頁分組：面板端權限。{/if}
        </p>
    </div>

    <form id="edit-group-form" class="space-y-4" autocomplete="off"
          data-gid="{$group_id}" data-type="{$type|escape}">
        {csrf_field}

        <div class="card">
            <div class="card__header"><div>
                <h3>分組名稱</h3>
            </div></div>
            <div class="card__body">
                <label class="label" for="groupname">分組名稱</label>
                <input class="input" id="groupname" name="groupname" type="text"
                       value="{$group_name|escape}" data-testid="group-name">
                <div id="groupname.msg" class="text-xs" style="color:var(--danger);margin-top:0.25rem"></div>
            </div>
        </div>

        {if $type === 'web'}
            {* ============ Web Admin Permissions ============ *}
            <div class="card">
                <div class="card__header"><div>
                    <h3>網頁管理員權限</h3>
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
                                <td><strong>Root 管理員</strong>（完整存取）</td>
                                <td class="text-center">
                                    <input type="checkbox" id="p2" data-perm="owner" {if $web_owner}checked{/if}>
                                </td>
                            </tr>
                            {/if}
                            <tr><td><strong>管理管理員</strong></td>
                                <td class="text-center"><input type="checkbox" id="p3" data-parent="admins"></td></tr>
                            <tr><td class="pl-6">列出管理員</td>
                                <td class="text-center"><input type="checkbox" id="p4" data-child="admins" {if $web_list_admins}checked{/if}></td></tr>
                            <tr><td class="pl-6">新增管理員</td>
                                <td class="text-center"><input type="checkbox" id="p5" data-child="admins" {if $web_add_admins}checked{/if}></td></tr>
                            <tr><td class="pl-6">編輯管理員</td>
                                <td class="text-center"><input type="checkbox" id="p6" data-child="admins" {if $web_edit_admins}checked{/if}></td></tr>
                            <tr><td class="pl-6">刪除管理員</td>
                                <td class="text-center"><input type="checkbox" id="p7" data-child="admins" {if $web_delete_admins}checked{/if}></td></tr>

                            <tr><td><strong>伺服器管理</strong></td>
                                <td class="text-center"><input type="checkbox" id="p8" data-parent="servers"></td></tr>
                            <tr><td class="pl-6">列出伺服器</td>
                                <td class="text-center"><input type="checkbox" id="p9" data-child="servers" {if $web_list_servers}checked{/if}></td></tr>
                            <tr><td class="pl-6">新增伺服器</td>
                                <td class="text-center"><input type="checkbox" id="p10" data-child="servers" {if $web_add_server}checked{/if}></td></tr>
                            <tr><td class="pl-6">編輯伺服器</td>
                                <td class="text-center"><input type="checkbox" id="p11" data-child="servers" {if $web_edit_servers}checked{/if}></td></tr>
                            <tr><td class="pl-6">刪除伺服器</td>
                                <td class="text-center"><input type="checkbox" id="p12" data-child="servers" {if $web_delete_servers}checked{/if}></td></tr>

                            <tr><td><strong>封禁管理</strong></td>
                                <td class="text-center"><input type="checkbox" id="p13" data-parent="bans"></td></tr>
                            <tr><td class="pl-6">新增封禁</td>
                                <td class="text-center"><input type="checkbox" id="p14" data-child="bans" {if $web_add_ban}checked{/if}></td></tr>
                            <tr><td class="pl-6">編輯自己的封禁</td>
                                <td class="text-center"><input type="checkbox" id="p16" data-child="bans" {if $web_edit_own_bans}checked{/if}></td></tr>
                            <tr><td class="pl-6">編輯同分組封禁</td>
                                <td class="text-center"><input type="checkbox" id="p17" data-child="bans" {if $web_edit_group_bans}checked{/if}></td></tr>
                            <tr><td class="pl-6">編輯所有封禁</td>
                                <td class="text-center"><input type="checkbox" id="p18" data-child="bans" {if $web_edit_all_bans}checked{/if}></td></tr>
                            <tr><td class="pl-6">封禁申訴</td>
                                <td class="text-center"><input type="checkbox" id="p19" data-child="bans" {if $web_ban_protests}checked{/if}></td></tr>
                            <tr><td class="pl-6">封禁提交</td>
                                <td class="text-center"><input type="checkbox" id="p20" data-child="bans" {if $web_ban_submissions}checked{/if}></td></tr>
                            <tr><td class="pl-6">解封自己的封禁</td>
                                <td class="text-center"><input type="checkbox" id="p38" data-child="bans" {if $web_unban_own_bans}checked{/if}></td></tr>
                            <tr><td class="pl-6">解封分組封禁</td>
                                <td class="text-center"><input type="checkbox" id="p39" data-child="bans" {if $web_unban_group_bans}checked{/if}></td></tr>
                            <tr><td class="pl-6">解封所有封禁</td>
                                <td class="text-center"><input type="checkbox" id="p32" data-child="bans" {if $web_unban}checked{/if}></td></tr>
                            <tr><td class="pl-6">刪除封禁</td>
                                <td class="text-center"><input type="checkbox" id="p33" data-child="bans" {if $web_delete_ban}checked{/if}></td></tr>
                            <tr><td class="pl-6">匯入封禁</td>
                                <td class="text-center"><input type="checkbox" id="p34" data-child="bans" {if $web_ban_import}checked{/if}></td></tr>

                            <tr><td><strong>分組管理</strong></td>
                                <td class="text-center"><input type="checkbox" id="p21" data-parent="groups"></td></tr>
                            <tr><td class="pl-6">列出分組</td>
                                <td class="text-center"><input type="checkbox" id="p22" data-child="groups" {if $web_list_groups}checked{/if}></td></tr>
                            <tr><td class="pl-6">新增分組</td>
                                <td class="text-center"><input type="checkbox" id="p23" data-child="groups" {if $web_add_group}checked{/if}></td></tr>
                            <tr><td class="pl-6">編輯分組</td>
                                <td class="text-center"><input type="checkbox" id="p24" data-child="groups" {if $web_edit_groups}checked{/if}></td></tr>
                            <tr><td class="pl-6">刪除分組</td>
                                <td class="text-center"><input type="checkbox" id="p25" data-child="groups" {if $web_delete_groups}checked{/if}></td></tr>

                            <tr><td><strong>電子郵件通知</strong></td>
                                <td class="text-center"><input type="checkbox" id="p35" data-parent="notify"></td></tr>
                            <tr><td class="pl-6">提交時通知</td>
                                <td class="text-center"><input type="checkbox" id="p36" data-child="notify" {if $web_notify_sub}checked{/if}></td></tr>
                            <tr><td class="pl-6">申訴時通知</td>
                                <td class="text-center"><input type="checkbox" id="p37" data-child="notify" {if $web_notify_protest}checked{/if}></td></tr>

                            <tr><td><strong>網頁面板設定</strong></td>
                                <td class="text-center"><input type="checkbox" id="p26" {if $web_settings}checked{/if}></td></tr>

                            <tr><td><strong>管理模組</strong></td>
                                <td class="text-center"><input type="checkbox" id="p27" data-parent="mods"></td></tr>
                            <tr><td class="pl-6">列出模組</td>
                                <td class="text-center"><input type="checkbox" id="p28" data-child="mods" {if $web_list_mods}checked{/if}></td></tr>
                            <tr><td class="pl-6">新增模組</td>
                                <td class="text-center"><input type="checkbox" id="p29" data-child="mods" {if $web_add_mods}checked{/if}></td></tr>
                            <tr><td class="pl-6">編輯模組</td>
                                <td class="text-center"><input type="checkbox" id="p30" data-child="mods" {if $web_edit_mods}checked{/if}></td></tr>
                            <tr><td class="pl-6">刪除模組</td>
                                <td class="text-center"><input type="checkbox" id="p31" data-child="mods" {if $web_delete_mods}checked{/if}></td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        {else}
            {* ============ Server Admin Permissions ============ *}
            <div class="card">
                <div class="card__header"><div>
                    <h3>伺服器管理員權限</h3>
                </div></div>
                <div class="card__body">
                    <table class="table" style="margin:0;font-size:var(--fs-sm)">
                        <thead><tr>
                            <th>權限</th>
                            <th class="text-center" style="width:4rem">旗標</th>
                            <th>用途</th>
                            <th class="text-center" style="width:4rem">啟用</th>
                        </tr></thead>
                        <tbody>
                            {if $is_owner_editor}
                            <tr>
                                <td><strong>Root 管理員</strong></td>
                                <td class="text-center font-mono">z</td>
                                <td>自動啟用所有旗標。</td>
                                <td class="text-center"><input type="checkbox" id="s14" data-sm-flag="z" {if $sm_root}checked{/if}></td>
                            </tr>
                            {/if}
                            <tr><td>保留席位</td><td class="text-center font-mono">a</td><td>保留席位存取。</td>
                                <td class="text-center"><input type="checkbox" id="s1" data-sm-flag="a" {if $sm_reserved_slot}checked{/if}></td></tr>
                            <tr><td>一般</td><td class="text-center font-mono">b</td><td>一般管理員；管理員必備。</td>
                                <td class="text-center"><input type="checkbox" id="s23" data-sm-flag="b" {if $sm_generic}checked{/if}></td></tr>
                            <tr><td>踢出玩家</td><td class="text-center font-mono">c</td><td>踢出其他玩家。</td>
                                <td class="text-center"><input type="checkbox" id="s2" data-sm-flag="c" {if $sm_kick}checked{/if}></td></tr>
                            <tr><td>封禁玩家</td><td class="text-center font-mono">d</td><td>封禁其他玩家。</td>
                                <td class="text-center"><input type="checkbox" id="s3" data-sm-flag="d" {if $sm_ban}checked{/if}></td></tr>
                            <tr><td>解封玩家</td><td class="text-center font-mono">e</td><td>移除封禁。</td>
                                <td class="text-center"><input type="checkbox" id="s4" data-sm-flag="e" {if $sm_unban}checked{/if}></td></tr>
                            <tr><td>擊殺</td><td class="text-center font-mono">f</td><td>擊殺 / 傷害其他玩家。</td>
                                <td class="text-center"><input type="checkbox" id="s5" data-sm-flag="f" {if $sm_slay}checked{/if}></td></tr>
                            <tr><td>變更地圖</td><td class="text-center font-mono">g</td><td>變更地圖或主要遊戲功能。</td>
                                <td class="text-center"><input type="checkbox" id="s6" data-sm-flag="g" {if $sm_map}checked{/if}></td></tr>
                            <tr><td>變更 cvar</td><td class="text-center font-mono">h</td><td>變更大部分 cvar。</td>
                                <td class="text-center"><input type="checkbox" id="s7" data-sm-flag="h" {if $sm_cvar}checked{/if}></td></tr>
                            <tr><td>執行設定檔</td><td class="text-center font-mono">i</td><td>執行設定檔。</td>
                                <td class="text-center"><input type="checkbox" id="s8" data-sm-flag="i" {if $sm_config}checked{/if}></td></tr>
                            <tr><td>管理員聊天</td><td class="text-center font-mono">j</td><td>特殊聊天權限。</td>
                                <td class="text-center"><input type="checkbox" id="s9" data-sm-flag="j" {if $sm_chat}checked{/if}></td></tr>
                            <tr><td>發起投票</td><td class="text-center font-mono">k</td><td>發起或建立投票。</td>
                                <td class="text-center"><input type="checkbox" id="s10" data-sm-flag="k" {if $sm_vote}checked{/if}></td></tr>
                            <tr><td>伺服器密碼</td><td class="text-center font-mono">l</td><td>設定伺服器密碼。</td>
                                <td class="text-center"><input type="checkbox" id="s11" data-sm-flag="l" {if $sm_password}checked{/if}></td></tr>
                            <tr><td>執行 RCON 指令</td><td class="text-center font-mono">m</td><td>使用 RCON 指令。</td>
                                <td class="text-center"><input type="checkbox" id="s12" data-sm-flag="m" {if $sm_rcon}checked{/if}></td></tr>
                            <tr><td>啟用作弊</td><td class="text-center font-mono">n</td><td>變更 sv_cheats 或使用作弊指令。</td>
                                <td class="text-center"><input type="checkbox" id="s13" data-sm-flag="n" {if $sm_cheats}checked{/if}></td></tr>
                            <tr>
                                <td>免疫</td>
                                <td class="text-center font-mono">&mdash;</td>
                                <td>數字愈高 = 免疫力愈高。</td>
                                <td class="text-center">
                                    <input class="input" type="number" min="0" id="immunity"
                                           value="{$immunity|escape}" style="width:5rem;text-align:center">
                                </td>
                            </tr>
                            <tr><td>自訂旗標 &quot;o&quot;</td><td class="text-center font-mono">o</td><td>&nbsp;</td>
                                <td class="text-center"><input type="checkbox" id="s17" data-sm-flag="o" {if $sm_custom1}checked{/if}></td></tr>
                            <tr><td>自訂旗標 &quot;p&quot;</td><td class="text-center font-mono">p</td><td>&nbsp;</td>
                                <td class="text-center"><input type="checkbox" id="s18" data-sm-flag="p" {if $sm_custom2}checked{/if}></td></tr>
                            <tr><td>自訂旗標 &quot;q&quot;</td><td class="text-center font-mono">q</td><td>&nbsp;</td>
                                <td class="text-center"><input type="checkbox" id="s19" data-sm-flag="q" {if $sm_custom3}checked{/if}></td></tr>
                            <tr><td>自訂旗標 &quot;r&quot;</td><td class="text-center font-mono">r</td><td>&nbsp;</td>
                                <td class="text-center"><input type="checkbox" id="s20" data-sm-flag="r" {if $sm_custom4}checked{/if}></td></tr>
                            <tr><td>自訂旗標 &quot;s&quot;</td><td class="text-center font-mono">s</td><td>&nbsp;</td>
                                <td class="text-center"><input type="checkbox" id="s21" data-sm-flag="s" {if $sm_custom5}checked{/if}></td></tr>
                            <tr><td>自訂旗標 &quot;t&quot;</td><td class="text-center font-mono">t</td><td>&nbsp;</td>
                                <td class="text-center"><input type="checkbox" id="s22" data-sm-flag="t" {if $sm_custom6}checked{/if}></td></tr>
                        </tbody>
                    </table>
                </div>
            </div>

            {* ============ Group Overrides ============ *}
            <div class="card">
                <div class="card__header"><div>
                    <h3>分組覆寫</h3>
                    <p>
                        分組覆寫允許完全允許或拒絕分組成員使用特定指令或指令群組。請參閱
                        <a href="http://wiki.alliedmods.net/Adding_Groups_%28SourceMod%29" target="_blank" rel="noopener noreferrer"> AlliedModders wiki 中的分組覆寫</a>
                        說明文件。
                    </p>
                    <p class="text-sm text-muted m-0 mt-2">
                        將覆寫的名稱留白將會刪除該覆寫。
                    </p>
                </div></div>
                <div class="card__body">
                    <table class="table" style="margin:0;font-size:var(--fs-sm)" id="overrides-table">
                        <thead><tr>
                            <th style="width:7rem">類型</th>
                            <th>名稱</th>
                            <th style="width:7rem">存取</th>
                        </tr></thead>
                        <tbody data-overrides-body>
                            {foreach $overrides as $override}
                                <tr data-override-row data-override-id="{$override.id}">
                                    <td>
                                        <select class="input" data-override-field="type">
                                            <option value="command" {if $override.type === 'command'}selected{/if}>指令</option>
                                            <option value="group"   {if $override.type === 'group'}selected{/if}>分組</option>
                                        </select>
                                    </td>
                                    <td>
                                        <input class="input" type="text"
                                               data-override-field="name" value="{$override.name|escape}">
                                    </td>
                                    <td>
                                        <select class="input" data-override-field="access">
                                            <option value="allow" {if $override.access === 'allow'}selected{/if}>允許</option>
                                            <option value="deny"  {if $override.access === 'deny'}selected{/if}>拒絕</option>
                                        </select>
                                    </td>
                                </tr>
                            {/foreach}
                            <tr data-override-new>
                                <td>
                                    <select class="input" id="new_override_type">
                                        <option value="command">指令</option>
                                        <option value="group">分組</option>
                                    </select>
                                </td>
                                <td><input class="input" type="text" id="new_override_name" placeholder="(留白 = 不新增覆寫)"></td>
                                <td>
                                    <select class="input" id="new_override_access">
                                        <option value="allow">允許</option>
                                        <option value="deny">拒絕</option>
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
                    data-testid="admin-edit-group-save">儲存變更</button>
            <a class="btn btn--ghost" href="index.php?p=admin&amp;c=groups">取消</a>
        </div>
    </form>
</div>
