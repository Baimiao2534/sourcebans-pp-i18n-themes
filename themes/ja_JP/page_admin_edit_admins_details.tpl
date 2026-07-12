{*
    SourceBans++ 2026 — admin/admins edit details

    Pair: web/pages/admin.edit.admindetails.php and
    web/includes/View/EditAdminDetailsView.php.

    The handler gates entry on ADMIN_OWNER | ADMIN_EDIT_ADMINS (or
    self-edit) before reaching this template. $change_pass narrows the
    in-template form: when the editor lacks password-edit rights (e.g.
    a non-owner editing someone else), the password rows hide.

    The cross-page tab nav (Details / Group / Servers / Permissions)
    lifts the four legacy admin-edit handlers into a single tabbed UX;
    the data-testid hooks match the issue's edit-form-tabs contract.
    The admin id rides the URL via $smarty.get.id rather than a View
    property so this template stays compatible with the unmodified
    handler (which never assigned $aid).
*}
<div class="card-tab page-section" id="Edit Admin Details">
    <div class="mb-4">
        <h1 style="font-size:var(--fs-xl);font-weight:600;margin:0">管理者を編集 · {$user|escape}</h1>
        <p class="text-sm text-muted m-0 mt-2">身元情報・ログイン認証情報・ゲーム内管理者パスワードを更新します。</p>
    </div>

    <nav class="flex gap-2 mb-4" role="tablist" aria-label="管理者編集セクション">
        <a class="btn btn--secondary btn--sm" role="tab" aria-current="page"
           href="?p=admin&c=admins&o=editdetails&id={$smarty.get.id|escape:'url'}"
           data-testid="admin-tab-details">詳細</a>
        <a class="btn btn--ghost btn--sm" role="tab"
           href="?p=admin&c=admins&o=editgroup&id={$smarty.get.id|escape:'url'}"
           data-testid="admin-tab-group">グループ</a>
        <a class="btn btn--ghost btn--sm" role="tab"
           href="?p=admin&c=admins&o=editservers&id={$smarty.get.id|escape:'url'}"
           data-testid="admin-tab-servers">サーバー</a>
        <a class="btn btn--ghost btn--sm"
           href="?p=admin&c=admins&o=editpermissions&id={$smarty.get.id|escape:'url'}">権限</a>
    </nav>

    <form method="post" action="" class="space-y-4" autocomplete="off">
        {csrf_field}

        <div class="card">
            <div class="card__header">
                <div>
                    <h3>身元情報</h3>
                    <p>ログイン名・Steam ID・連絡用メールアドレス。</p>
                </div>
            </div>
            <div class="card__body space-y-3">
                <div class="grid gap-4" style="grid-template-columns:1fr 1fr">
                    <div>
                        <label class="label" for="adminname">管理者ログイン名</label>
                        <input class="input" id="adminname" name="adminname" type="text"
                               value="{$user|escape}" data-testid="edit-admin-name">
                        <div id="adminname.msg" class="text-xs" style="color:var(--danger);margin-top:0.25rem"></div>
                    </div>
                    <div>
                        <label class="label" for="steam">Steam ID</label>
                        {* #1420 follow-up #2 — strict `pattern` mirrors
                            the server-side `SteamID::isValidID()`
                            allowlist (Steam2 / bracketed Steam3 /
                            17-digit Steam64). The handler validates
                            raw input via `isValidID()` BEFORE calling
                            `toSteam2()`. `required` matches the
                            server-side rule that admins MUST carry a
                            non-empty `authid`. *}
                        <input class="input font-mono" id="steam" name="steam" type="text"
                               value="{$authid|escape}" data-testid="edit-admin-steam"
                               placeholder="STEAM_0:1:23498765"
                               pattern="STEAM_[01]:[01]:\d+|\[U:1:\d+\]|\d{17}"
                               title="Steam ID（STEAM_0:1:23498765）、Steam3 ID（[U:1:23498765]）または 17 桁の SteamID64 を入力してください。"
                               required aria-required="true">
                        <div id="steam.msg" class="text-xs" style="color:var(--danger);margin-top:0.25rem"></div>
                    </div>
                </div>
                <div>
                    <label class="label" for="email">メールアドレス</label>
                    <input class="input" id="email" name="email" type="email"
                           value="{$email|escape}" data-testid="edit-admin-email">
                    <div id="email.msg" class="text-xs" style="color:var(--danger);margin-top:0.25rem"></div>
                </div>
            </div>
        </div>

        {if $change_pass}
            <div class="card">
                <div class="card__header">
                    <div>
                        <h3>パスワード</h3>
                        <p>パスワード欄を空のままにすると元のパスワードが保持されます。</p>
                    </div>
                </div>
                <div class="card__body space-y-3">
                    <div class="grid gap-4" style="grid-template-columns:1fr 1fr">
                        <div>
                            <label class="label" for="password">新しいパスワード</label>
                            <input class="input" id="password" name="password" type="password"
                                   data-testid="edit-admin-password" autocomplete="new-password">
                            <div id="password.msg" class="text-xs" style="color:var(--danger);margin-top:0.25rem"></div>
                        </div>
                        <div>
                            <label class="label" for="password2">パスワードの確認</label>
                            <input class="input" id="password2" name="password2" type="password"
                                   data-testid="edit-admin-password2" autocomplete="new-password">
                            <div id="password2.msg" class="text-xs" style="color:var(--danger);margin-top:0.25rem"></div>
                        </div>
                    </div>
                    <div class="flex items-center gap-2 mt-2" style="border-top:1px solid var(--border);padding-top:0.75rem">
                        <input type="checkbox" id="a_useserverpass" name="a_useserverpass"
                               {if $a_spass}checked{/if}
                               data-testid="edit-admin-useserverpass"
                               onclick="var el = document.getElementById('a_serverpass'); if (el) el.disabled = !this.checked;">
                        <label for="a_useserverpass" class="text-sm font-medium" style="margin:0">ゲーム内管理者パスワードを使用</label>
                        <input class="input" id="a_serverpass" name="a_serverpass" type="password"
                               style="max-width:14rem;margin-left:auto"
                               {if !$a_spass}disabled{/if}
                               data-testid="edit-admin-serverpass" autocomplete="new-password">
                    </div>
                    <div id="a_serverpass.msg" class="text-xs" style="color:var(--danger)"></div>
                </div>
            </div>
        {/if}

        <div class="flex justify-end gap-2">
            <button type="button" class="btn btn--ghost btn--sm"
                    onclick="history.go(-1);">戻る</button>
            <button type="submit" class="btn btn--primary btn--sm" id="editmod"
                    data-testid="edit-admin-save"><i data-lucide="save"></i> 変更を保存</button>
        </div>
    </form>
</div>
