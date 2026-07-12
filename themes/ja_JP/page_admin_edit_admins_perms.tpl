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
            {$admin_name|escape} の権限
        </h1>
        <p class="text-sm text-muted m-0 mt-2">
            親グループのチェックを入れると、配下のすべての子権限を一括で有効化または無効化できます。
        </p>
    </div>

    <form id="edit-perms-form" class="space-y-4" autocomplete="off"
          data-aid="{$admin_id}">
        {csrf_field}

        {* ============ Web Admin Permissions ============ *}
        <div class="card">
            <div class="card__header"><div>
                <h3>ウェブ管理者権限</h3>
                <p>パネル内部の権限。</p>
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
                            <td><strong>スーパー管理者</strong>（完全アクセス）</td>
                            <td class="text-center">
                                <input type="checkbox" id="p2" data-perm="owner" {if $web_owner}checked{/if}>
                            </td>
                        </tr>
                        {/if}
                        <tr>
                            <td><strong>管理者管理</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p3" data-parent="admins">
                            </td>
                        </tr>
                        <tr><td class="pl-6">管理者一覧</td>
                            <td class="text-center"><input type="checkbox" id="p4" data-child="admins" {if $web_list_admins}checked{/if}></td></tr>
                        <tr><td class="pl-6">管理者追加</td>
                            <td class="text-center"><input type="checkbox" id="p5" data-child="admins" {if $web_add_admins}checked{/if}></td></tr>
                        <tr><td class="pl-6">管理者編集</td>
                            <td class="text-center"><input type="checkbox" id="p6" data-child="admins" {if $web_edit_admins}checked{/if}></td></tr>
                        <tr><td class="pl-6">管理者削除</td>
                            <td class="text-center"><input type="checkbox" id="p7" data-child="admins" {if $web_delete_admins}checked{/if}></td></tr>

                        <tr>
                            <td><strong>サーバー管理</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p8" data-parent="servers">
                            </td>
                        </tr>
                        <tr><td class="pl-6">サーバー一覧</td>
                            <td class="text-center"><input type="checkbox" id="p9" data-child="servers" {if $web_list_servers}checked{/if}></td></tr>
                        <tr><td class="pl-6">新規サーバー追加</td>
                            <td class="text-center"><input type="checkbox" id="p10" data-child="servers" {if $web_add_server}checked{/if}></td></tr>
                        <tr><td class="pl-6">サーバー編集</td>
                            <td class="text-center"><input type="checkbox" id="p11" data-child="servers" {if $web_edit_servers}checked{/if}></td></tr>
                        <tr><td class="pl-6">サーバー削除</td>
                            <td class="text-center"><input type="checkbox" id="p12" data-child="servers" {if $web_delete_servers}checked{/if}></td></tr>

                        <tr>
                            <td><strong>BAN 管理</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p13" data-parent="bans">
                            </td>
                        </tr>
                        <tr><td class="pl-6">BAN 追加</td>
                            <td class="text-center"><input type="checkbox" id="p14" data-child="bans" {if $web_add_ban}checked{/if}></td></tr>
                        <tr><td class="pl-6">自分の BAN を編集</td>
                            <td class="text-center"><input type="checkbox" id="p16" data-child="bans" {if $web_edit_own_bans}checked{/if}></td></tr>
                        <tr><td class="pl-6">同グループの BAN を編集</td>
                            <td class="text-center"><input type="checkbox" id="p17" data-child="bans" {if $web_edit_group_bans}checked{/if}></td></tr>
                        <tr><td class="pl-6">すべての BAN を編集</td>
                            <td class="text-center"><input type="checkbox" id="p18" data-child="bans" {if $web_edit_all_bans}checked{/if}></td></tr>
                        <tr><td class="pl-6">BAN 申し立て</td>
                            <td class="text-center"><input type="checkbox" id="p19" data-child="bans" {if $web_ban_protests}checked{/if}></td></tr>
                        <tr><td class="pl-6">BAN 申告</td>
                            <td class="text-center"><input type="checkbox" id="p20" data-child="bans" {if $web_ban_submissions}checked{/if}></td></tr>
                        <tr><td class="pl-6">自分の BAN を解除</td>
                            <td class="text-center"><input type="checkbox" id="p38" data-child="bans" {if $web_unban_own_bans}checked{/if}></td></tr>
                        <tr><td class="pl-6">同グループの BAN を解除</td>
                            <td class="text-center"><input type="checkbox" id="p39" data-child="bans" {if $web_unban_group_bans}checked{/if}></td></tr>
                        <tr><td class="pl-6">すべての BAN を解除</td>
                            <td class="text-center"><input type="checkbox" id="p32" data-child="bans" {if $web_unban}checked{/if}></td></tr>
                        <tr><td class="pl-6">BAN 削除</td>
                            <td class="text-center"><input type="checkbox" id="p33" data-child="bans" {if $web_delete_ban}checked{/if}></td></tr>
                        <tr><td class="pl-6">BAN インポート</td>
                            <td class="text-center"><input type="checkbox" id="p34" data-child="bans" {if $web_ban_import}checked{/if}></td></tr>

                        <tr>
                            <td><strong>グループ管理</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p21" data-parent="groups">
                            </td>
                        </tr>
                        <tr><td class="pl-6">グループ一覧</td>
                            <td class="text-center"><input type="checkbox" id="p22" data-child="groups" {if $web_list_groups}checked{/if}></td></tr>
                        <tr><td class="pl-6">グループ追加</td>
                            <td class="text-center"><input type="checkbox" id="p23" data-child="groups" {if $web_add_group}checked{/if}></td></tr>
                        <tr><td class="pl-6">グループ編集</td>
                            <td class="text-center"><input type="checkbox" id="p24" data-child="groups" {if $web_edit_groups}checked{/if}></td></tr>
                        <tr><td class="pl-6">グループ削除</td>
                            <td class="text-center"><input type="checkbox" id="p25" data-child="groups" {if $web_delete_groups}checked{/if}></td></tr>

                        <tr>
                            <td><strong>メール通知</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p35" data-parent="notify">
                            </td>
                        </tr>
                        <tr><td class="pl-6">申告通知</td>
                            <td class="text-center"><input type="checkbox" id="p36" data-child="notify" {if $web_notify_sub}checked{/if}></td></tr>
                        <tr><td class="pl-6">申し立て通知</td>
                            <td class="text-center"><input type="checkbox" id="p37" data-child="notify" {if $web_notify_protest}checked{/if}></td></tr>

                        <tr>
                            <td><strong>ウェブパネル設定</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p26" {if $web_settings}checked{/if}>
                            </td>
                        </tr>

                        <tr>
                            <td><strong>MOD 管理</strong></td>
                            <td class="text-center">
                                <input type="checkbox" id="p27" data-parent="mods">
                            </td>
                        </tr>
                        <tr><td class="pl-6">MOD 一覧</td>
                            <td class="text-center"><input type="checkbox" id="p28" data-child="mods" {if $web_list_mods}checked{/if}></td></tr>
                        <tr><td class="pl-6">MOD 追加</td>
                            <td class="text-center"><input type="checkbox" id="p29" data-child="mods" {if $web_add_mods}checked{/if}></td></tr>
                        <tr><td class="pl-6">MOD 編集</td>
                            <td class="text-center"><input type="checkbox" id="p30" data-child="mods" {if $web_edit_mods}checked{/if}></td></tr>
                        <tr><td class="pl-6">MOD 削除</td>
                            <td class="text-center"><input type="checkbox" id="p31" data-child="mods" {if $web_delete_mods}checked{/if}></td></tr>
                    </tbody>
                </table>
            </div>
        </div>

        {* ============ Server Admin Permissions ============ *}
        <div class="card">
            <div class="card__header"><div>
                <h3>サーバー管理者権限</h3>
                <p>この管理者が管理できるすべてのサーバーに適用される SourceMod 管理者フラグ。</p>
            </div></div>
            <div class="card__body">
                <table class="table" style="margin:0;font-size:var(--fs-sm)">
                    <thead>
                        <tr>
                            <th>権限</th>
                            <th class="text-center" style="width:4rem">フラグ</th>
                            <th>用途</th>
                            <th class="text-center" style="width:4rem">有効</th>
                        </tr>
                    </thead>
                    <tbody>
                        {if $is_owner_editor}
                        <tr>
                            <td><strong>スーパー管理者</strong></td>
                            <td class="text-center font-mono">z</td>
                            <td>魔法ですべてのフラグを有効化します。</td>
                            <td class="text-center"><input type="checkbox" id="s14" data-sm-flag="z" {if $sm_root}checked{/if}></td>
                        </tr>
                        {/if}
                        <tr><td>予約スロット</td><td class="text-center font-mono">a</td><td>予約スロットへのアクセス。</td>
                            <td class="text-center"><input type="checkbox" id="s1" data-sm-flag="a" {if $sm_reserved_slot}checked{/if}></td></tr>
                        <tr><td>一般管理者</td><td class="text-center font-mono">b</td><td>一般管理者。管理者として必須です。</td>
                            <td class="text-center"><input type="checkbox" id="s23" data-sm-flag="b" {if $sm_generic}checked{/if}></td></tr>
                        <tr><td>プレイヤーキック</td><td class="text-center font-mono">c</td><td>他のプレイヤーをキックします。</td>
                            <td class="text-center"><input type="checkbox" id="s2" data-sm-flag="c" {if $sm_kick}checked{/if}></td></tr>
                        <tr><td>プレイヤー BAN</td><td class="text-center font-mono">d</td><td>他のプレイヤーを BAN します。</td>
                            <td class="text-center"><input type="checkbox" id="s3" data-sm-flag="d" {if $sm_ban}checked{/if}></td></tr>
                        <tr><td>プレイヤー BAN 解除</td><td class="text-center font-mono">e</td><td>BAN を解除します。</td>
                            <td class="text-center"><input type="checkbox" id="s4" data-sm-flag="e" {if $sm_unban}checked{/if}></td></tr>
                        <tr><td>スレイ</td><td class="text-center font-mono">f</td><td>他のプレイヤーを殺害またはダメージを与えます。</td>
                            <td class="text-center"><input type="checkbox" id="s5" data-sm-flag="f" {if $sm_slay}checked{/if}></td></tr>
                        <tr><td>マップ変更</td><td class="text-center font-mono">g</td><td>マップや主要なゲーム機能を変更します。</td>
                            <td class="text-center"><input type="checkbox" id="s6" data-sm-flag="g" {if $sm_map}checked{/if}></td></tr>
                        <tr><td>cvar 変更</td><td class="text-center font-mono">h</td><td>ほとんどの cvar を変更します。</td>
                            <td class="text-center"><input type="checkbox" id="s7" data-sm-flag="h" {if $sm_cvar}checked{/if}></td></tr>
                        <tr><td>設定ファイル実行</td><td class="text-center font-mono">i</td><td>設定ファイルを実行します。</td>
                            <td class="text-center"><input type="checkbox" id="s8" data-sm-flag="i" {if $sm_config}checked{/if}></td></tr>
                        <tr><td>管理者チャット</td><td class="text-center font-mono">j</td><td>特別なチャット権限。</td>
                            <td class="text-center"><input type="checkbox" id="s9" data-sm-flag="j" {if $sm_chat}checked{/if}></td></tr>
                        <tr><td>投票開始</td><td class="text-center font-mono">k</td><td>投票を開始または作成します。</td>
                            <td class="text-center"><input type="checkbox" id="s10" data-sm-flag="k" {if $sm_vote}checked{/if}></td></tr>
                        <tr><td>サーバーパスワード</td><td class="text-center font-mono">l</td><td>サーバーにパスワードを設定します。</td>
                            <td class="text-center"><input type="checkbox" id="s11" data-sm-flag="l" {if $sm_password}checked{/if}></td></tr>
                        <tr><td>RCON コマンド実行</td><td class="text-center font-mono">m</td><td>RCON コマンドを使用します。</td>
                            <td class="text-center"><input type="checkbox" id="s12" data-sm-flag="m" {if $sm_rcon}checked{/if}></td></tr>
                        <tr><td>チート有効化</td><td class="text-center font-mono">n</td><td>sv_cheats を変更するかチートコマンドを使用します。</td>
                            <td class="text-center"><input type="checkbox" id="s13" data-sm-flag="n" {if $sm_cheats}checked{/if}></td></tr>
                        <tr>
                            <td>免除</td>
                            <td class="text-center font-mono">&mdash;</td>
                            <td>数値が大きいほど免除レベルが高くなります。</td>
                            <td class="text-center">
                                <input class="input" type="number" min="0" id="immunity"
                                       value="{$immunity|escape}" style="width:5rem;text-align:center">
                            </td>
                        </tr>
                        <tr><td>カスタムフラグ &quot;o&quot;</td><td class="text-center font-mono">o</td><td>&nbsp;</td>
                            <td class="text-center"><input type="checkbox" id="s17" data-sm-flag="o" {if $sm_custom1}checked{/if}></td></tr>
                        <tr><td>カスタムフラグ &quot;p&quot;</td><td class="text-center font-mono">p</td><td>&nbsp;</td>
                            <td class="text-center"><input type="checkbox" id="s18" data-sm-flag="p" {if $sm_custom2}checked{/if}></td></tr>
                        <tr><td>カスタムフラグ &quot;q&quot;</td><td class="text-center font-mono">q</td><td>&nbsp;</td>
                            <td class="text-center"><input type="checkbox" id="s19" data-sm-flag="q" {if $sm_custom3}checked{/if}></td></tr>
                        <tr><td>カスタムフラグ &quot;r&quot;</td><td class="text-center font-mono">r</td><td>&nbsp;</td>
                            <td class="text-center"><input type="checkbox" id="s20" data-sm-flag="r" {if $sm_custom4}checked{/if}></td></tr>
                        <tr><td>カスタムフラグ &quot;s&quot;</td><td class="text-center font-mono">s</td><td>&nbsp;</td>
                            <td class="text-center"><input type="checkbox" id="s21" data-sm-flag="s" {if $sm_custom5}checked{/if}></td></tr>
                        <tr><td>カスタムフラグ &quot;t&quot;</td><td class="text-center font-mono">t</td><td>&nbsp;</td>
                            <td class="text-center"><input type="checkbox" id="s22" data-sm-flag="t" {if $sm_custom6}checked{/if}></td></tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="flex gap-2">
            <button type="submit" class="btn btn--primary"
                    data-testid="admin-edit-perms-save">変更を保存</button>
            <a class="btn btn--ghost" href="index.php?p=admin&amp;c=admins">キャンセル</a>
        </div>
    </form>
</div>
