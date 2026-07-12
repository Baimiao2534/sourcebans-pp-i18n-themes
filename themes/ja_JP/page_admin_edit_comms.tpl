{*
    SourceBans++ 2026 — page_admin_edit_comms.tpl

    Edit-existing-block form on the admin comms page. Bound to
    Sbpp\View\AdminCommsEditView; SmartyTemplateRule cross-checks
    referenced vars against that DTO.

    Variable contract matches the legacy default theme:
      - $ban_name   — current player name on the comms row.
      - $ban_authid — current authid (Steam2) on the comms row.

    Length / type / current-reason are NOT Smarty vars: the page
    handler emits an inline `<script>selectLengthTypeReason(…)</script>`
    after rendering the form, hydrating the <select>s post-mount.
    This mirrors the legacy convention preserved during the v2.0.0
    rollout window so the same View satisfies SmartyTemplateRule on
    both theme legs of the CI matrix (#1123 A2). Per-handler errors
    from the previous POST are surfaced through the same legacy
    `<script>$('steam.msg')…</script>` block at the end of
    web/pages/admin.edit.comms.php — the inline error containers
    below have IDs the script targets.

    The form POSTs to itself (action="" preserves the URL incl.
    ?id, ?key, ?page); admin.edit.comms.php validates the CSRF token
    and writes the row.

    Testability hooks per the issue's "Testability hooks" rule:
      - data-testid="editcomm-<field>" on every input/select.
      - data-testid="editcomm-submit" / "editcomm-back" on buttons.
*}
<div class="p-6" style="max-width:48rem">
    <div class="mb-6">
        <h1 style="font-size:1.5rem;font-weight:600;margin:0">ブロックを編集</h1>
        <p class="text-sm text-muted m-0 mt-2">このブロックのプレイヤー名、authid、タイプ、期間、または理由を更新します。</p>
    </div>

    <form id="editcomm-form" class="card p-6 space-y-4" method="post" action="" data-testid="editcomm-form">
        {csrf_field}
        <input type="hidden" name="insert_type" value="add">

        <div>
            <label class="label" for="name">プレイヤー名</label>
            <input type="text"
                   class="input"
                   id="name"
                   name="name"
                   value="{$ban_name|escape}"
                   data-testid="editcomm-name">
            <div class="text-xs mt-2" id="name.msg" style="color:var(--danger);display:none"></div>
        </div>

        <div>
            <label class="label" for="steam">Steam ID / コミュニティ ID</label>
            <input type="text"
                   class="input font-mono"
                   id="steam"
                   name="steam"
                   value="{$ban_authid|escape}"
                   data-testid="editcomm-steam"
                   {* #1420 follow-up #2 — strict `pattern` mirrors the
                       server-side `SteamID::isValidID()` allowlist
                       (Steam2 / bracketed Steam3 / 17-digit Steam64
                       — same as `page_admin_comms_add.tpl`). The
                       handler validates raw input via `isValidID()`
                       BEFORE calling `toSteam2()`, but the pattern
                       gate stops the round-trip on a typo. `title`
                       is what the browser surfaces on the popover
                       when the pattern fails — keep it short and
                       actionable. *}
                   pattern="STEAM_[01]:[01]:\d+|\[U:1:\d+\]|\d{17}"
                   title="Steam ID (STEAM_0:1:23498765)、Steam3 ID ([U:1:23498765]) または17桁の SteamID64 を入力してください。"
                   required
                   aria-required="true">
            <div class="text-xs mt-2" id="steam.msg" style="color:var(--danger);display:none"></div>
        </div>

        <div class="grid gap-4" style="grid-template-columns:1fr 1fr">
            <div>
                <label class="label" for="type">ブロックタイプ</label>
                <select class="select" id="type" name="type" data-testid="editcomm-type">
                    <option value="1">ミュート（ボイス）</option>
                    <option value="2">ギャグ（チャット）</option>
                </select>
            </div>
            <div>
                <label class="label" for="banlength">ブロック期間</label>
                <select class="select" id="banlength" name="banlength" data-testid="editcomm-length">
                    <option value="0">永久</option>
                    <optgroup label="分">
                        <option value="1">1分</option>
                        <option value="5">5分</option>
                        <option value="10">10分</option>
                        <option value="15">15分</option>
                        <option value="30">30分</option>
                        <option value="45">45分</option>
                    </optgroup>
                    <optgroup label="時間">
                        <option value="60">1時間</option>
                        <option value="120">2時間</option>
                        <option value="180">3時間</option>
                        <option value="240">4時間</option>
                        <option value="480">8時間</option>
                        <option value="720">12時間</option>
                    </optgroup>
                    <optgroup label="日">
                        <option value="1440">1日</option>
                        <option value="2880">2日</option>
                        <option value="4320">3日</option>
                        <option value="5760">4日</option>
                        <option value="7200">5日</option>
                        <option value="8640">6日</option>
                    </optgroup>
                    <optgroup label="週間">
                        <option value="10080">1週間</option>
                        <option value="20160">2週間</option>
                        <option value="30240">3週間</option>
                    </optgroup>
                    <optgroup label="か月">
                        <option value="43200">1か月</option>
                        <option value="86400">2か月</option>
                        <option value="129600">3か月</option>
                        <option value="259200">6か月</option>
                        <option value="518400">12か月</option>
                    </optgroup>
                </select>
                <div class="text-xs mt-2" id="length.msg" style="color:var(--danger);display:none"></div>
            </div>
        </div>

        <div>
            <label class="label" for="listReason">ブロック理由</label>
            <select class="select"
                    id="listReason"
                    name="listReason"
                    data-testid="editcomm-reason"
                    onchange="changeReason(this[this.selectedIndex].value);">
                <option value="" selected>-- 理由を選択 --</option>
                <optgroup label="違反">
                    <option value="Obscene language">Obscene language</option>
                    <option value="Insult players">Insult players</option>
                    <option value="Admin disrespect">Admin disrespect</option>
                    <option value="Inappropriate Language">Inappropriate language</option>
                    <option value="Trading">Trading</option>
                    <option value="Spam in chat/voice">Spam</option>
                    <option value="Advertisement">Advertisement</option>
                </optgroup>
                <option value="other">カスタム</option>
            </select>
            <div id="dreason" class="mt-2" style="display:none">
                <textarea class="textarea"
                          id="txtReason"
                          name="txtReason"
                          rows="4"
                          data-testid="editcomm-reason-custom"></textarea>
            </div>
            <div class="text-xs mt-2" id="reason.msg" style="color:var(--danger);display:none"></div>
        </div>

        <div class="flex justify-end gap-2" style="border-top:1px solid var(--border);padding-top:0.75rem">
            <button type="button"
                    class="btn btn--ghost"
                    data-testid="editcomm-back"
                    onclick="history.go(-1);">戻る</button>
            <button type="submit"
                    class="btn btn--primary"
                    id="editcomm-submit"
                    data-testid="editcomm-submit">
                <i data-lucide="save"></i> 変更を保存
            </button>
        </div>
    </form>
</div>
