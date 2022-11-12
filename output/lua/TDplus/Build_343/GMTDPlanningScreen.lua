


local oldGMTDPlanningScreenInitialize = GMTDPlanningScreen.Initialize
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

    self.marineguidebutton = CreateGUIObject("marineguidebutton", PlusMarineGuide, self,
        {
        },
        errorDepth)
    self.marineguidebutton:AlignTopLeft()
    self.marineguidebutton:SetPosition(2130, 30 - 15 )
    self.marineguidebutton:SetLayer(2002)
    self.marineguidebutton:SetVisible(true)


end
