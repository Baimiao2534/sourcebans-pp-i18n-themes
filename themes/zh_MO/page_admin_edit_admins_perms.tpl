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
            {$admin_name|escape} 的權限
        </h1>
        <p class="text-sm text-muted m-0 mt-2">
            切換父分組可一次啟用 / 停用其下所有子權限。
        </p>
    </div>

    <form id="edit-perms-form" class="space-y-4" autocomplete="off"
          data-aid="{$admin_id}">
        {csrf_field}

        {* ============ Web Admin Permissions ============ *}
        <div class="card">
            <div class="card__header"><div>
                <h3>網頁管理員權限</h3>
                <p>面板本身的權限。</p>
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
                            <td><strong>超級管理員</strong>（完全存取）</td>
                            <td class="text-center">
                                <input type="checkbox" id="p2" data-perm="owner" {if $web_owner}checked{/if}>
                            </td>
                        </tr>
                        {/if}
                        <tr>
                            <td><strong>管理管理員</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p3" data-parent="admins">
                            </td>
                        </tr>
                        <tr><td class="pl-6">列出管理員</td>
                            <td class="text-center"><input type="checkbox" id="p4" data-child="admins" {if $web_list_admins}checked{/if}></td></tr>
                        <tr><td class="pl-6">新增管理員</td>
                            <td class="text-center"><input type="checkbox" id="p5" data-child="admins" {if $web_add_admins}checked{/if}></td></tr>
                        <tr><td class="pl-6">編輯管理員</td>
                            <td class="text-center"><input type="checkbox" id="p6" data-child="admins" {if $web_edit_admins}checked{/if}></td></tr>
                        <tr><td class="pl-6">刪除管理員</td>
                            <td class="text-center"><input type="checkbox" id="p7" data-child="admins" {if $web_delete_admins}checked{/if}></td></tr>

                        <tr>
                            <td><strong>伺服器管理</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p8" data-parent="servers">
                            </td>
                        </tr>
                        <tr><td class="pl-6">列出伺服器</td>
                            <td class="text-center"><input type="checkbox" id="p9" data-child="servers" {if $web_list_servers}checked{/if}></td></tr>
                        <tr><td class="pl-6">新增伺服器</td>
                            <td class="text-center"><input type="checkbox" id="p10" data-child="servers" {if $web_add_server}checked{/if}></td></tr>
                        <tr><td class="pl-6">編輯伺服器</td>
                            <td class="text-center"><input type="checkbox" id="p11" data-child="servers" {if $web_edit_servers}checked{/if}></td></tr>
                        <tr><td class="pl-6">刪除伺服器</td>
                            <td class="text-center"><input type="checkbox" id="p12" data-child="servers" {if $web_delete_servers}checked{/if}></td></tr>

                        <tr>
                            <td><strong>封禁管理</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p13" data-parent="bans">
                            </td>
                        </tr>
                        <tr><td class="pl-6">新增封禁</td>
                            <td class="text-center"><input type="checkbox" id="p14" data-child="bans" {if $web_add_ban}checked{/if}></td></tr>
                        <tr><td class="pl-6">編輯自己的封禁</td>
                            <td class="text-center"><input type="checkbox" id="p16" data-child="bans" {if $web_edit_own_bans}checked{/if}></td></tr>
                        <tr><td class="pl-6">編輯同分組的封禁</td>
                            <td class="text-center"><input type="checkbox" id="p17" data-child="bans" {if $web_edit_group_bans}checked{/if}></td></tr>
                        <tr><td class="pl-6">編輯所有封禁</td>
                            <td class="text-center"><input type="checkbox" id="p18" data-child="bans" {if $web_edit_all_bans}checked{/if}></td></tr>
                        <tr><td class="pl-6">封禁申訴</td>
                            <td class="text-center"><input type="checkbox" id="p19" data-child="bans" {if $web_ban_protests}checked{/if}></td></tr>
                        <tr><td class="pl-6">封禁提交</td>
                            <td class="text-center"><input type="checkbox" id="p20" data-child="bans" {if $web_ban_submissions}checked{/if}></td></tr>
                        <tr><td class="pl-6">解封自己的封禁</td>
                            <td class="text-center"><input type="checkbox" id="p38" data-child="bans" {if $web_unban_own_bans}checked{/if}></td></tr>
                        <tr><td class="pl-6">解封同分組的封禁</td>
                            <td class="text-center"><input type="checkbox" id="p39" data-child="bans" {if $web_unban_group_bans}checked{/if}></td></tr>
                        <tr><td class="pl-6">解封所有封禁</td>
                            <td class="text-center"><input type="checkbox" id="p32" data-child="bans" {if $web_unban}checked{/if}></td></tr>
                        <tr><td class="pl-6">刪除封禁</td>
                            <td class="text-center"><input type="checkbox" id="p33" data-child="bans" {if $web_delete_ban}checked{/if}></td></tr>
                        <tr><td class="pl-6">匯入封禁</td>
                            <td class="text-center"><input type="checkbox" id="p34" data-child="bans" {if $web_ban_import}checked{/if}></td></tr>

                        <tr>
                            <td><strong>分組管理</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p21" data-parent="groups">
                            </td>
                        </tr>
                        <tr><td class="pl-6">列出分組</td>
                            <td class="text-center"><input type="checkbox" id="p22" data-child="groups" {if $web_list_groups}checked{/if}></td></tr>
                        <tr><td class="pl-6">新增分組</td>
                            <td class="text-center"><input type="checkbox" id="p23" data-child="groups" {if $web_add_group}checked{/if}></td></tr>
                        <tr><td class="pl-6">編輯分組</td>
                            <td class="text-center"><input type="checkbox" id="p24" data-child="groups" {if $web_edit_groups}checked{/if}></td></tr>
                        <tr><td class="pl-6">刪除分組</td>
                            <td class="text-center"><input type="checkbox" id="p25" data-child="groups" {if $web_delete_groups}checked{/if}></td></tr>

                        <tr>
                            <td><strong>電子郵件通知</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p35" data-parent="notify">
                            </td>
                        </tr>
                        <tr><td class="pl-6">提交時通知</td>
                            <td class="text-center"><input type="checkbox" id="p36" data-child="notify" {if $web_notify_sub}checked{/if}></td></tr>
                        <tr><td class="pl-6">申訴時通知</td>
                            <td class="text-center"><input type="checkbox" id="p37" data-child="notify" {if $web_notify_protest}checked{/if}></td></tr>

                        <tr>
                            <td><strong>網頁面板設定</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p26" {if $web_settings}checked{/if}>
                            </td>
                        </tr>

                        <tr>
                            <td><strong>管理模組</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p27" data-parent="mods">
                            </td>
                        </tr>
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

        {* ============ Server Admin Permissions ============ *}
        <div class="card">
            <div class="card__header"><div>
                <h3>伺服器管理員權限</h3>
                <p>套用至此管理員可管理之所有伺服器的 SourceMod 管理員旗標。</p>
            </div></div>
            <div class="card__body">
                <table class="table" style="margin:0;font-size:var(--fs-sm)">
                    <thead>
                        <tr>
                            <th>權限</th>
                            <th class="text-center" style="width:4rem">旗標</th>
                            <th>用途</th>
                            <th class="text-center" style="width:4rem">啟用</th>
                        </tr>
                    </thead>
                    <tbody>
                        {if $is_owner_editor}
                        <tr>
                            <td><strong>超級管理員</strong></td>
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
                        <tr><td>更換地圖</td><td class="text-center font-mono">g</td><td>更換地圖或主要遊戲功能。</td>
                            <td class="text-center"><input type="checkbox" id="s6" data-sm-flag="g" {if $sm_map}checked{/if}></td></tr>
                        <tr><td>變更 cvar</td><td class="text-center font-mono">h</td><td>變更大多數 cvar。</td>
                            <td class="text-center"><input type="checkbox" id="s7" data-sm-flag="h" {if $sm_cvar}checked{/if}></td></tr>
                        <tr><td>執行設定檔</td><td class="text-center font-mono">i</td><td>執行設定檔。</td>
                            <td class="text-center"><input type="checkbox" id="s8" data-sm-flag="i" {if $sm_config}checked{/if}></td></tr>
                        <tr><td>管理員聊天</td><td class="text-center font-mono">j</td><td>特殊聊天權限。</td>
                            <td class="text-center"><input type="checkbox" id="s9" data-sm-flag="j" {if $sm_chat}checked{/if}></td></tr>
                        <tr><td>發起投票</td><td class="text-center font-mono">k</td><td>發起或建立投票。</td>
                            <td class="text-center"><input type="checkbox" id="s10" data-sm-flag="k" {if $sm_vote}checked{/if}></td></tr>
                        <tr><td>設定伺服器密碼</td><td class="text-center font-mono">l</td><td>為伺服器設定密碼。</td>
                            <td class="text-center"><input type="checkbox" id="s11" data-sm-flag="l" {if $sm_password}checked{/if}></td></tr>
                        <tr><td>執行 RCON 指令</td><td class="text-center font-mono">m</td><td>使用 RCON 指令。</td>
                            <td class="text-center"><input type="checkbox" id="s12" data-sm-flag="m" {if $sm_rcon}checked{/if}></td></tr>
                        <tr><td>啟用作弊</td><td class="text-center font-mono">n</td><td>變更 sv_cheats 或使用作弊指令。</td>
                            <td class="text-center"><input type="checkbox" id="s13" data-sm-flag="n" {if $sm_cheats}checked{/if}></td></tr>
                        <tr>
                            <td>免疫</td>
                            <td class="text-center font-mono">&mdash;</td>
                            <td>數字越高 = 免疫等級越高。</td>
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

        <div class="flex gap-2">
            <button type="submit" class="btn btn--primary"
                    data-testid="admin-edit-perms-save">儲存變更</button>
            <a class="btn btn--ghost" href="index.php?p=admin&amp;c=admins">取消</a>
        </div>
    </form>
</div>
