
local kRightSidePadding = 10


local oldGMTDPlayerPlaqueWidgetInitialize = GMTDPlayerPlaqueWidget.Initialize
function GMTDPlayerPlaqueWidget:Initialize(params, errorDepth)

    oldGMTDPlayerPlaqueWidgetInitialize(self, params, errorDepth)
    self.hiveskill = CreateGUIObject("hiveSkill", GUIMenuTruncatedText, self,
    {
        cls = GUIMenuText,
    }, errorDepth)

    self.hiveskill:SetSize(self.kPlayerNameMaxWidth, self.kPlayerNameHeight)
    self.hiveskill:SetPosition(self.avatar:GetSize().x + kRightSidePadding, -12)
    self.hiveskill:SetFont("AgencyBold", 32)
    self.hiveskill:SetText("")
    self.hiveskill:SetColor(self.kNameColor_Active)

end


function GMTDPlayerPlaqueWidget:GetHiveSkill()
    return self.hiveSkill:GetText()
end


local oldGMTDPlayerPlaqueWidgetOnSizeChanged = GMTDPlayerPlaqueWidget.OnSizeChanged
function GMTDPlayerPlaqueWidget:OnSizeChanged(newSize)
    oldGMTDPlayerPlaqueWidgetOnSizeChanged(self, newSize)
    local halfHeight = newSize.y / 2
    self.skilltierIcon:SetPosition(self.avatar:GetSize().x + kRightSidePadding + 55, halfHeight)

    if self.hiveskill then
      self.hiveskill:SetSize(newSize.x - kRightSidePadding - self.avatar:GetSize().x, halfHeight)
      self.hiveskill:SetPosition(self.avatar:GetSize().x + kRightSidePadding + 5 , halfHeight)
    end
end




local oldGMTDPlayerPlaqueWidgetUpdatePlayerDataElements = GMTDPlayerPlaqueWidget.UpdatePlayerDataElements
function GMTDPlayerPlaqueWidget:UpdatePlayerDataElements( lobbyId )
    oldGMTDPlayerPlaqueWidgetUpdatePlayerDataElements(self, lobbyId)

    local steamID64 = self:GetSteamID64()
    if steamID64 == "" then -- nothing to update
        return
    end

    local td = Thunderdome()
    assert(td, "Error: No Thunderdome object found")

    local lobbyState
    if td:GetIsGroupId( lobbyId ) then
        lobbyState = td:GetGroupLobbyState()
    else
        lobbyState = td:GetLobbyState()
    end

    if not lobbyState then
        return
    end

    local memberModel = td:GetMemberLocalData( lobbyId, steamID64 )

    if memberModel then

        if (memberModel.avg_skill == nil) or (memberModel.avg_skill == false) or (memberModel.adagrad == nil) or (memberModel.adagrad == false) then
            self.hiveskill:SetText("")
        else
            --self.hiveskill:SetText(tostring(math.floor(memberModel.avg_skill + 0.5 )))

            local displaySkill = 0
            if memberModel.adagrad > 0 then
                displaySkill = math.max(memberModel.avg_skill - 25 / math.sqrt(memberModel.adagrad), 0)
            end


            self.hiveskill:SetText(tostring(math.floor(displaySkill + 0.5 )))
            
        end

        local isCommanderVolunteer = memberModel.commander_able == 1 and self:GetCommanderIconEnabled()
        self.commanderIcon:SetVisible(isCommanderVolunteer)

        -- move the commandericon up instead of replacing it
        if lobbyState == kLobbyState.WaitingForMapVote then  
            self.commanderIcon:SetPosition(0, -45)
        end

    end

end

local oldGMTDPlayerPlaqueWidgetSetChildrenVisible = GMTDPlayerPlaqueWidget.SetChildrenVisible
function GMTDPlayerPlaqueWidget:SetChildrenVisible(newVisible)

    oldGMTDPlayerPlaqueWidgetSetChildrenVisible(self, newVisible)
    if self.hiveskill then
        self.hiveskill:SetVisible(newVisible)
    end
end

local oldGMTDPlayerPlaqueWidgetOnSteamID64Changed = GMTDPlayerPlaqueWidget.OnSteamID64Changed
function GMTDPlayerPlaqueWidget:OnSteamID64Changed()

    oldGMTDPlayerPlaqueWidgetOnSteamID64Changed(self)

    local steamID64 = self:GetSteamID64()
    if steamID64 == "" then
        self.hiveskill:SetText(self.emptyText)
    end
end
