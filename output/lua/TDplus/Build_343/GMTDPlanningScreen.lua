


oldGMTDPlanningScreenInitialize = GMTDPlanningScreen.Initialize
function GMTDPlanningScreen:Initialize(params, errorDepth)
    oldGMTDPlanningScreenInitialize(self, params, errorDepth)

    self.mapvote = CreateGUIObject("mapvote", GUIMenuText, self.playerPlaquesLayout,
    {
        font = {family = "Agency", size = 40}
    }  )
    self.mapvote:SetText("")
    self.mapvote:SetColor(Color(189, 189, 189, 1))
    self.mapvote:SetVisible(false)

    function setMapvoteText(map1, p1, map2, p2, map3, p3, totalvotes)
        p1 = p1 / totalvotes * 100
        p2 = p2 / totalvotes * 100
        p3 = p3 / totalvotes * 100
        map1 = string.sub(map1, 5)
        map2 = string.sub(map2, 5)
        map3 = string.sub(map3, 5)
        self.mapvote:SetText(string.format("Votes:  %s: %d%%,  %s: %d%%,  %s: %d%% ...",map1, p1, map2, p2, map3, p3))
        self.mapvote:SetVisible(true)
    end

end

--TODO remove before updating
function GMTDPlanningScreen:UpdatePlayerMetadata()

    local lobbyId = Thunderdome():GetActiveLobbyId()

    if not lobbyId then
        SLog("GMTDPlanningScreen:UpdatePlayerMetadata() - not in an active lobby!")
        return
    end

    local steamIDToNames, processedAll = GetThunderdomeNameOverrides( lobbyId )
    local members = Thunderdome():GetMemberListLocalData( lobbyId )

    local plaqueNum = 1

    for i = 1, #members do

        local member = members[i]
        local steamId = member.steamid

        if member.team ~= 0 and member.team ~= Thunderdome():GetLocalClientTeam() then

            local plaque = self.enemyPlaques[plaqueNum]
            plaqueNum = plaqueNum + 1

            plaque:SetSteamID64(steamId)

            local overrideName = steamIDToNames[steamId]
            if plaque and overrideName then
                plaque:SetNameOverride(overrideName)
            end

        end

    end

    if plaqueNum <= #self.enemyPlaques then

        for i = plaqueNum, #self.enemyPlaques do
            self.enemyPlaques[i]:SetSteamID64("76561198081308439")
        end

    end

    self.chatWidget:SetNameOverridesTable(steamIDToNames)

    if processedAll then
        self:RemoveTimedCallback(self.memberMetadataCallback)
        self.memberMetadataCallback = nil
    end
end
