



function GMTDPlayerPlaqueContextMenu:Initialize(params, errorDepth)
    errorDepth = (errorDepth or 1) + 1

    GUIObject.Initialize(self, params, errorDepth)

    -- Cache locale so we don't resolve it every time we set a player as the menu's target
    self.locale_MutePlayer       = Locale.ResolveString("THUNDERDOME_MUTE_PLAYER_CHAT")
    self.locale_UnmutePlayer     = Locale.ResolveString("THUNDERDOME_UNMUTE_PLAYER_CHAT")
    self.locale_ViewSteamProfile = Locale.ResolveString("THUNDERDOME_VIEW_PLAYER_STEAM_PROFILE")
    self.locale_AddToFriends     = Locale.ResolveString("THUNDERDOME_ADD_TO_FRIENDS")
    self.locale_VoteToKick       = Locale.ResolveString("THUNDERDOME_VOTE_TO_KICK")
    self.locale_KickPlayer       = Locale.ResolveString("THUNDERDOME_KICK_PLAYER")

    self.lastVoteKickTime = 0

    self.steamProfileURL = nil

    RequireType({"boolean", "nil"}, params.enabled, "params.enabled", errorDepth)

    self:SetTexture(self.kBackgroundTexture)
    self:SetSizeFromTexture()
    self:SetColor(1,1,1)

    self.layout = CreateGUIObject("layout", GUIListLayout, self, { orientation = "vertical" }, errorDepth)
    self.layout:SetPosition(self.kTextXOffset, self.kTextYOffset)
    self.layout:SetSpacing(10)

    self.targetNameObj = CreateGUIObject("targetName", GUIMenuTruncatedText, self.layout,
    {
        cls = GUIMenuText,
        font = {family = "AgencyBold", size = 50}
    }, errorDepth)
    self.targetNameObj:SetColor(ColorFrom255(219, 219, 219))
    self.targetNameObj:SetSize(self:GetSize().x - (self.kTextXOffset * 2), self.targetNameObj:CalculateTextSize("AEIOUgjq^&").y)

    self.dividerObj = CreateGUIObject("dividerLine", GUIObject, self.layout)

    local dividerBrightness = 50
    self.dividerObj:SetColor(ColorFrom255(dividerBrightness, dividerBrightness, dividerBrightness))

    -----------------added new buttons here-----------------
    self:HookEvent(self, "OnSteamID64Changed", function()
        local steamID64 = self:GetSteamID64()
        if steamID64 == "" then return end

            local td = Thunderdome()
            assert(td, "Error: No Thunderdome object found")
            lobbyId = td:GetActiveLobbyId()

            local memberModel = td:GetMemberLocalData( lobbyId, steamID64 )
            if memberModel then


            -- fetch request takes a bit, it should update the values by itself once its receives the data
            local function OtherParseHiveProfileResponse( response, errMsg, errCode )
                if errCode == kHttpOpTimeoutErrorCode or errCode == kHttpOpRefusedErrorCode then
                --Hive did not respond in a timely manner, check retry and attempt or fail-out
                    if kNumHiveProfileFetchAttempts <= kMaxHiveProfileAttemptsLimit then
                        kNumHiveProfileFetchAttempts = kNumHiveProfileFetchAttempts + 1
                        Log("Re-attempting[%s] Hive profile fetch...", kNumHiveProfileFetchAttempts)
                        RequestHiveProfile()
                    end
                    return
                end

                local obj, pos, err = json.decode(response, 1, nil)

                if not obj then
                    Log("Error: failed to retrieve Hive profile:\n%s\n%s\n%s", obj, pos, err)
                    return false
                end

                if obj and err then
                    return false
                end

                obj.level = obj.level or 0
                obj.td_skill = obj.td_skill or 0
                obj.td_skill_offset = obj.td_skill_offset or 0

                --local  fetchedLevel = obj.level

                local MarineSkillDiff = obj.td_skill + obj.td_skill_offset - tonumber(memberModel.marine_skill)
                local AlienSkillDiff = obj.td_skill - obj.td_skill_offset - tonumber(memberModel.alien_skill)

                local function diffstring(skilldiff)
                    if skilldiff >= 1 then
                        return " +" .. tostring(skilldiff)
                    elseif skilldiff <= -1 then
                        return " " .. tostring(skilldiff) -- it shows already "-"
                    else
                        return ""
                    end
                end
                --Shared.Message(tostring(fetchedLevel))

                self.marineskill:SetText("Marine: " .. tostring(memberModel.marine_skill) .. diffstring(MarineSkillDiff))
                self.alienskill:SetText("Kharaa: " .. tostring(memberModel.alien_skill) .. diffstring(AlienSkillDiff))
            end

            local fieldhourdata = calcFieldhoursFromLifeforms(memberModel)
            if not fieldhourdata then 
                self.tdprogress:SetVisible(false)
            else 
                self.tdprogress:SetText("Playtime: " .. fieldhourdata .. " hours")
                self.tdprogress:SetVisible(true)
            end

            local state = Thunderdome():GetLobbyState()
            if state > 4 then 
                self.tdprogress:SetVisible(false)
            end
            
            local steamId32 = Shared.ConvertSteamId64To32(steamID64)
            local requestUrl = string.format("%s%s", "http://hive2.ns2cdt.com/api/players/", steamId32)
            --Shared.SendHTTPRequest(requestUrl, "GET", OtherParseHiveProfileResponse)

            self.marineskill:SetText("Marine: " .. tostring(memberModel.marine_skill))
            self.alienskill:SetText("Kharaa: " .. tostring(memberModel.alien_skill))
            self.marineskill:SetVisible(true)
            self.alienskill:SetVisible(true)
        end
    end)

    self.marineskill = CreateGUIObject("marineskill", GUIMenuText, self.layout,
    {
        font = {family = "Agency", size = 40}
    }  )
    self.marineskill:SetText("")
    self.marineskill:SetColor(Color(0.756, 0.952, 0.988, 1))
    self.marineskill:SetVisible(false)

    self.alienskill = CreateGUIObject("alienskill", GUIMenuText, self.layout,
    {
        font = {family = "Agency", size = 40}
    }  )
    self.alienskill:SetText("")
    self.alienskill:SetColor(Color(0.901, 0.623, 0.215, 1))
    self.alienskill:SetVisible(false)

    self.tdprogress = CreateGUIObject("tdprogress", GUIMenuText, self.layout,
    {
        font = {family = "Agency", size = 40}
    }  )
    self.tdprogress:SetText("")
    self.tdprogress:SetColor(Color(0.7, 0.7, 0.7, 1))
    self.tdprogress:SetVisible(false)


    self.ns2panel = CreateGUIObject("ns2panel", GUIMenuSimpleTextButton, self.layout,
    {
        font = {family = "Agency", size = 40}
    }, errorDepth)
    self.ns2panel:SetLabel("View NS2Panel")
    self:HookEvent(self.ns2panel, "OnPressed",
    function()
        local steamID64 = self:GetSteamID64()
        if steamID64 == "" then return end
        local steamId32 = Shared.ConvertSteamId64To32(steamID64)
        local ns2panel = "https://ns2panel.ocservers.com/player/" .. tostring(steamId32)
        Client.ShowWebpage(string.format(ns2panel))
        self:OnHideContextMenu(false)
    end)

    loadedgameendstats = false
    self.gameendstats = CreateGUIObject("lastgame", GUIMenuSimpleTextButton, self.layout,
    {
        font = {family = "Agency", size = 40}
    }, errorDepth  )
    self.gameendstats:SetLabel("View Roundstats")
    self:HookEvent(self.gameendstats, "OnPressed",
    function()
        if loadedgameendstats == false then
          Script.Load("lua/TDplus/Build_343/PlusGUIGameEndStats.lua") -- has to be loaded late
          EndgameStatsTD = GetGUIManager():CreateGUIScript("PlusGUIGameEndStats")
          loadedgameendstats = true
          EndgameStatsTD:SetIsVisible(true)
        elseif EndgameStatsTD:GetIsVisible() then
            EndgameStatsTD:SetIsVisible(false)
        else
            EndgameStatsTD:SetIsVisible(true)
        end
    end)

    self.youtube = CreateGUIObject("youtube", GUIMenuSimpleTextButton, self.layout,
    {
        font = {family = "Agency", size = 40}
    }, errorDepth  )
    self.youtube:SetLabel("Disable YouTube")
    self:HookEvent(self.youtube, "OnPressed",
    function()
        if "Enable YouTube" == self.youtube:GetLabel() then
            setDJ(true)
            self.youtube:SetLabel("Disable YouTube")
            Thunderdome():TriggerEvent( kThunderdomeEvents.OnGUIChatMessage,Thunderdome():GetActiveLobbyId(), "TD Plus ", "To share a video type DJ /watch?v=dQw4w9WgXcQ in the console. Ctrl V works there", 0, 13 )
        else
            setDJ(false)
            self.youtube:SetLabel("Enable YouTube")
        end
    end)
    function setDJtext(text)
        self.youtube:SetLabel(text)
    end

    self.command = CreateGUIObject("command", GUIMenuSimpleTextButton, self.layout,
    {
        font = {family = "Agency", size = 40}
    }, errorDepth  )
    self.command:SetLabel("Withdraw as Comm")
    self:HookEvent(self.command, "OnPressed",
    function()
        if "Withdraw as Comm" == self.command:GetLabel() then
            local state = Thunderdome():GetLobbyState()
            if state < 3 then 
                Thunderdome():SetLocalCommandAble(0)
                self.command:SetLabel("Volunteer as Comm")
            end
        else
            Thunderdome():SetLocalCommandAble(1)
            self.command:SetLabel("Withdraw as Comm")
        end
    end)


---------------------------------------------
    self.viewSteamProfileObj = CreateGUIObject("viewSteamProfile", GUIMenuSimpleTextButton, self.layout,
    {
        font = {family = "Agency", size = 52}
    }, errorDepth)
    self.viewSteamProfileObj:SetLabel(self.locale_ViewSteamProfile)
    self:HookEvent(self.viewSteamProfileObj, "OnPressed",
    function()
        local steamID64 = self:GetSteamID64()
        if steamID64 == "" then return end
        Client.ShowWebpage(self.steamProfileURL)
        self:OnHideContextMenu(false)
    end)

    self.addToFriendsObj = CreateGUIObject("addToFriends", GUIMenuSimpleTextButton, self.layout,
    {
        font = {family = "Agency", size = 52}
    }, errorDepth)
    self.addToFriendsObj:SetLabel(self.locale_AddToFriends)
    self:HookEvent(self.addToFriendsObj, "OnPressed",
    function()
        local steamID64 = self:GetSteamID64()
        if steamID64 == "" then return end
        Client.ActivateOverlayToAddFriend(steamID64)
        self:OnHideContextMenu(false)
    end)

    -- uses mutedclients in GMTDChatWidget instead of TDManager
    self.mutePlayerObj = CreateGUIObject("mutePlayer", GUIMenuSimpleTextButton, self.layout,
    {
        font = {family = "Agency", size = 52}
    }, errorDepth)
    self:HookEvent(self.mutePlayerObj, "OnPressed",
    function()
        local steamID64 = self:GetSteamID64()
        if steamID64 == "" then return end
        local isMuted = table.icontains(GetMutedClients(), steamID64) 
        if isMuted then
            self:FireEvent("unmuteId", steamID64)
            self.mutePlayerObj:SetLabel(self.locale_MutePlayer)
        else
            self:FireEvent("muteId", steamID64)
            self.mutePlayerObj:SetLabel(self.locale_UnmutePlayer)
        end
        self:OnHideContextMenu(false)

    end)

    self.voteToKickObj = CreateGUIObject("voteToKick", GUIMenuSimpleTextButton, self.layout,
    {
        font = {family = "Agency", size = 52}
    }, errorDepth)
    self.voteToKickObj:SetLabel(self.locale_VoteToKick)
    self:HookEvent(self.voteToKickObj, "OnPressed",
    function()
        local steamID64 = self:GetSteamID64()
        if steamID64 == "" then return end
        Thunderdome():RequestVoteKickPlayer(steamID64)
        self:OnHideContextMenu(false)
    end)

    self.kickPlayerObj = CreateGUIObject("kickPlayer", GUIMenuSimpleTextButton, self.layout,
    {
        font = {family = "Agency", size = 52}
    }, errorDepth)
    self.kickPlayerObj:SetLabel(self.locale_KickPlayer)
    self:HookEvent(self.kickPlayerObj, "OnPressed",
    function()
        local steamID64 = self:GetSteamID64()
        if steamID64 == "" then return end
        Thunderdome():KickPlayerFromGroup(steamID64)
        self:OnHideContextMenu(false)
    end)

    if params.enabled ~= nil then
        self:SetEnabled(params.enabled)
    end

    ------size changes-----
    local textsize = 45 -- was 52
    self.layout:SetSpacing(5) -- was 10
    self.marineskill:SetFont({family = "Agency", size = textsize})
    self.alienskill:SetFont({family = "Agency", size = textsize})
    self.tdprogress:SetFont({family = "Agency", size = textsize})
    self.ns2panel:SetFont({family = "Agency", size = textsize})
    self.gameendstats:SetFont({family = "Agency", size = textsize})
    self.youtube:SetFont({family = "Agency", size = textsize})
    self.command:SetFont({family = "Agency", size = textsize})

    self.viewSteamProfileObj:SetFont({family = "Agency", size = textsize})
    self.addToFriendsObj:SetFont({family = "Agency", size = textsize})
    self.mutePlayerObj:SetFont({family = "Agency", size = textsize})
    self.voteToKickObj:SetFont({family = "Agency", size = textsize})
    self.kickPlayerObj:SetFont({family = "Agency", size = textsize})
    --------


    self:HookEvent(self, "OnOutsideClick",      self.OnOutsideClickHandler)
    self:HookEvent(self, "OnMouseRightClick",   self.OnOutsideRightClickHandler) -- Same close behavior, want to immediately move it if clicked on same plaque
    self:HookEvent(self, "OnOutsideRightClick", self.OnOutsideRightClickHandler)

    self:HookEvent(self, "OnSteamID64Changed", self.OnSteamID64Changed)
    self:HookEvent(self, "OnSizeChanged",      self.OnSizeChanged)

    self:ListenForCursorInteractions()
    self:OnSizeChanged(self:GetSize())
end



local oldGMTDPlayerPlaqueContextMenuOnSteamID64Changed = GMTDPlayerPlaqueContextMenu.OnSteamID64Changed
function GMTDPlayerPlaqueContextMenu:OnSteamID64Changed(newSteamID)
    oldGMTDPlayerPlaqueContextMenuOnSteamID64Changed(self, newSteamID)
    local isSelf = newSteamID == GetLocalSteamID64()
    self.gameendstats:SetVisible(isSelf)
    self.youtube:SetVisible(isSelf)

    local state = Thunderdome():GetLobbyState()
    
    if state ~= nil then 
        self.command:SetVisible(isSelf and state < 3)
    end

    local isMuted = table.icontains(GetMutedClients(), newSteamID)
    if isMuted then
        self.mutePlayerObj:SetLabel(self.locale_UnmutePlayer)
    else
        self.mutePlayerObj:SetLabel(self.locale_MutePlayer)
    end
    self.mutePlayerObj:SetVisible(not isSelf)
    
end


function calcFieldhoursFromLifeforms(memberModel)

    lifeformChoices = memberModel.lifeforms

    if #lifeformChoices == 0 then 
       return false
    end

    local hours = 0
    for i = 1, #lifeformChoices do
        if lifeformChoices[i] == "Skulk" then 
            hours = hours + 1
        elseif lifeformChoices[i] == "Gorge" then 
            hours = hours + 5
        elseif lifeformChoices[i] == "Lerk" then 
            hours = hours + 25
        elseif lifeformChoices[i] == "Fade" then 
            hours = hours + 125
        elseif lifeformChoices[i] == "Onos" then 
            hours = hours + 625
        end
    end

    if hours == 2500 then 
        hours = 0
    end
    return hours
end