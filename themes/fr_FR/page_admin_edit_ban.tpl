{*
    SourceBans++ 2026 — page_admin_edit_ban.tpl
    Bound to Sbpp\View\AdminBansEditView (validated by SmartyTemplateRule).

    Edit-existing-ban form — the sister of page_admin_bans_add.tpl
    (B13). The legacy default theme's template uses Smarty's custom
    `-{ … }-` delimiter pair (a SourceBans-1.x oddity preserved on the
    edit-ban page only); the sbpp2026 redesign drops that override and
    renders with the standard `{ … }` pair. The page handler picks one
    delimiter set unconditionally — see web/pages/admin.edit.ban.php
    for the "no per-theme conditional" rationale (#1123 B13 follow-up).

    DOM ids (`name`, `type`, `steam`, `ip`, `listReason`, `txtReason`,
    `dreason`, `banlength`, `did`, `dname`, `nick.msg`, `steam.msg`,
    `ip.msg`, `reason.msg`, `length.msg`, `demo.msg`, `editban`,
    `back`) match the legacy template exactly so the page handler's
    tail script (`changeReason`, `selectLengthTypeReason`, `demo`) can
    target them by `document.getElementById(...)` without a per-theme
    fork. The popup window opened by `pages/admin.uploaddemo.php` also
    calls `window.opener.demo(id, name)` against those same ids.

    sbpp2026 doesn't load `web/scripts/sourcebans.js`, so the legacy
    `selectLengthTypeReason` / `ShowBox` helpers are unavailable. The
    handler emits a vanilla replacement script after Renderer::render
    (defined inline against window.SBPP.showToast / sb.message as a
    fallback). That keeps THIS template purely declarative — no
    inline {literal} block needed for client-side glue beyond the
    server-emitted tail.

    Form posts back to action="" (preserves the URL incl. ?id, ?key,
    ?page); admin.edit.ban.php validates the CSRF token and writes the
    row. Server-side validation errors (per field) are pushed into the
    `*.msg` divs below by the handler's tail script (vanilla DOM, no
    MooTools).

    Testability hooks per the issue's "Testability hooks" rule:
      - data-testid="editban-<field>" on every input/select.
      - data-testid="editban-submit" / "editban-cancel" on buttons.

    Permission gate: $can_edit_ban is precomputed in admin.edit.ban.php
    (row-aware: ADMIN_OWNER | ADMIN_EDIT_ALL_BANS, or own/group ban
    with the matching flag). The handler also early-PageDie's on
    failure, so this template gate is defense-in-depth for the case
    where the View is ever instantiated without that upstream check.
*}
{if NOT $can_edit_ban}
    <div class="card" data-testid="editban-denied">
        <div class="card__body">
            <h1 style="font-size:1.25rem;font-weight:600;margin:0">Accès refusé</h1>
            <p class="text-sm text-muted m-0 mt-2">Vous n&rsquo;avez pas la permission de modifier ce bannissement.</p>
        </div>
    </div>
{else}
    <section class="p-6" data-testid="editban-section" style="max-width:48rem">
        <div class="mb-6">
            <h1 style="font-size:1.5rem;font-weight:600;margin:0">Modifier le bannissement</h1>
            <p class="text-sm text-muted m-0 mt-2">
                Mettez à jour le nom du joueur, l&rsquo;identifiant, la durée ou le motif de ce bannissement.
            </p>
        </div>

        <form id="editban-form"
              class="card p-6 space-y-4"
              method="post"
              action=""
              data-testid="editban-form"
              autocomplete="off">
            {csrf_field}
            <input type="hidden" name="insert_type" value="add">

            <div>
                <label class="label" for="name">Nom du joueur</label>
                <input type="text"
                       class="input"
                       id="name"
                       name="name"
                       value="{$ban_name|escape}"
                       data-testid="editban-name">
                <div class="text-xs mt-2"
                     id="name.msg"
                     style="color:var(--danger);display:none"></div>
            </div>

            <div class="grid gap-4" style="grid-template-columns:repeat(auto-fit,minmax(14rem,1fr))">
                <div>
                    <label class="label" for="type">Type de bannissement</label>
                    <select class="select"
                            id="type"
                            name="type"
                            data-testid="editban-type">
                        <option value="0">Steam ID</option>
                        <option value="1">Adresse IP</option>
                    </select>
                </div>
                <div>
                    <label class="label" for="banlength">Durée du bannissement</label>
                    <select class="select"
                            id="banlength"
                            name="banlength"
                            data-testid="editban-length">
                        <option value="0">Permanent</option>
                        <optgroup label="Minutes">
                            <option value="1">1 minute</option>
                            <option value="5">5 minutes</option>
                            <option value="10">10 minutes</option>
                            <option value="15">15 minutes</option>
                            <option value="30">30 minutes</option>
                            <option value="45">45 minutes</option>
                        </optgroup>
                        <optgroup label="Heures">
                            <option value="60">1 heure</option>
                            <option value="120">2 heures</option>
                            <option value="180">3 heures</option>
                            <option value="240">4 heures</option>
                            <option value="480">8 heures</option>
                            <option value="720">12 heures</option>
                        </optgroup>
                        <optgroup label="Jours">
                            <option value="1440">1 jour</option>
                            <option value="2880">2 jours</option>
                            <option value="4320">3 jours</option>
                            <option value="5760">4 jours</option>
                            <option value="7200">5 jours</option>
                            <option value="8640">6 jours</option>
                        </optgroup>
                        <optgroup label="Semaines">
                            <option value="10080">1 semaine</option>
                            <option value="20160">2 semaines</option>
                            <option value="30240">3 semaines</option>
                        </optgroup>
                        <optgroup label="Mois">
                            <option value="43200">1 mois</option>
                            <option value="86400">2 mois</option>
                            <option value="129600">3 mois</option>
                            <option value="259200">6 mois</option>
                            <option value="518400">12 mois</option>
                        </optgroup>
                    </select>
                    <div class="text-xs mt-2"
                         id="length.msg"
                         style="color:var(--danger);display:none"></div>
                </div>
            </div>

            <div>
                <label class="label" for="steam">Steam ID / ID communauté</label>
                <input type="text"
                       class="input font-mono"
                       id="steam"
                       name="steam"
                       value="{$ban_authid|escape}"
                       data-testid="editban-steam"
                       placeholder="STEAM_0:1:23498765"
                       {* #1420 follow-up #2 — strict `pattern` mirrors
                           the server-side `SteamID::isValidID()`
                           allowlist (Steam2 / bracketed Steam3 /
                           17-digit Steam64 — same as
                           `page_admin_bans_add.tpl`). The handler
                           validates raw input via `isValidID()`
                           BEFORE calling `toSteam2()`. Edit-ban can
                           target either a Steam ID (Type=0) or an IP
                           (Type=1) so this input is NOT `required` —
                           the page handler enforces "one of the two
                           is non-empty" per `$postBanType`. When
                           empty (the IP-target case) the browser's
                           pattern check is satisfied (it only fires
                           on non-empty values). *}
                       pattern="STEAM_[01]:[01]:\d+|\[U:1:\d+\]|\d{17}"
                       title="Saisissez un Steam ID (STEAM_0:1:23498765), un Steam3 ID ([U:1:23498765]) ou un SteamID64 à 17 chiffres.">
                <div class="text-xs mt-2"
                     id="steam.msg"
                     style="color:var(--danger);display:none"></div>
            </div>

            <div>
                <label class="label" for="ip">Adresse IP</label>
                <input type="text"
                       class="input font-mono"
                       id="ip"
                       name="ip"
                       value="{$ban_ip|escape}"
                       data-testid="editban-ip"
                       placeholder="203.0.113.10">
                <div class="text-xs mt-2"
                     id="ip.msg"
                     style="color:var(--danger);display:none"></div>
            </div>

            <div>
                <label class="label" for="listReason">Motif du bannissement</label>
                <select class="select"
                        id="listReason"
                        name="listReason"
                        data-testid="editban-reason"
                        onchange="changeReason(this[this.selectedIndex].value);">
                    <option value="" selected>-- Sélectionner un motif --</option>
                    <optgroup label="Triche">
                        <option value="Aimbot">Aimbot</option>
                        <option value="Antirecoil">Anti-recul</option>
                        <option value="Wallhack">Wallhack</option>
                        <option value="Spinhack">Spinhack</option>
                        <option value="Multi-Hack">Multi-Hack</option>
                        <option value="No Smoke">Sans fumée</option>
                        <option value="No Flash">Sans flash</option>
                    </optgroup>
                    <optgroup label="Comportement">
                        <option value="Team Killing">Tueur d&rsquo;équipe</option>
                        <option value="Team Flashing">Flash d&rsquo;équipe</option>
                        <option value="Spamming Mic/Chat">Spam micro/chat</option>
                        <option value="Inappropriate Spray">Spray inapproprié</option>
                        <option value="Inappropriate Language">Langage inapproprié</option>
                        <option value="Inappropriate Name">Nom inapproprié</option>
                        <option value="Ignoring Admins">Ignorer les administrateurs</option>
                        <option value="Team Stacking">Empilement d&rsquo;équipe</option>
                    </optgroup>
                    {if $customreason}
                        <optgroup label="Personnalisé">
                            {foreach from=$customreason item="creason"}
                                {* nofilter: bans.customreasons round-trips through htmlspecialchars in admin.settings.php before serialize() into sb_settings, so the value is already entity-encoded; auto-escaping would double-encode. *}
                                <option value="{$creason nofilter}">{$creason nofilter}</option>
                            {/foreach}
                        </optgroup>
                    {/if}
                    <option value="other">Autre motif</option>
                </select>
                <div id="dreason" class="mt-2" style="display:none">
                    <textarea class="textarea"
                              id="txtReason"
                              name="txtReason"
                              rows="4"
                              placeholder="Expliquez en détail pourquoi ce bannissement est appliqué."
                              data-testid="editban-reason-custom"></textarea>
                </div>
                <div class="text-xs mt-2"
                     id="reason.msg"
                     style="color:var(--danger);display:none"></div>
            </div>

            <div data-ban-id="{$ban_id}" data-testid="editban-demo-section">
                <label class="label">Téléversement de démo</label>
                <div class="flex flex-wrap items-center gap-2">
                    <button type="button"
                            class="btn btn--secondary btn--sm"
                            id="uploaddemo"
                            data-testid="editban-demo"
                            onclick="childWindow=open('pages/admin.uploaddemo.php','upload','resizable=no,width=300,height=130');">
                        Téléverser une démo
                    </button>
                    <button type="button"
                            class="btn btn--ghost btn--sm"
                            id="removedemo"
                            data-testid="editban-demo-remove"
                            {if NOT $has_demo}hidden{/if}>
                        Supprimer la démo
                    </button>
                </div>
                <input type="hidden" name="did" id="did" value="">
                <input type="hidden" name="dname" id="dname" value="">
                {* nofilter: $ban_demo is empty-or `Uploaded: <a href="getdemo.php?type=B&id=…" data-testid="editban-demo-download"><b>` + htmlspecialchars($res['dname'], ENT_QUOTES, 'UTF-8') + `</b></a>` built in admin.edit.ban.php. The tag literals and href are server-controlled; the user-supplied dname is escaped on store-side per #1113 so dropping it raw here is safe. *}
                <div class="text-xs mt-2" id="demo.msg" style="color:#cc0000">{$ban_demo nofilter}</div>
            </div>

            <div class="flex justify-end gap-2"
                 style="border-top:1px solid var(--border);padding-top:0.75rem">
                <button type="button"
                        class="btn btn--ghost"
                        id="back"
                        data-testid="editban-cancel"
                        onclick="history.go(-1);">Retour</button>
                <button type="submit"
                        class="btn btn--primary"
                        id="editban"
                        data-testid="editban-submit">
                    Enregistrer les modifications
                </button>
            </div>
        </form>
    </section>
{/if}
