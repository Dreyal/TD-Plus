
GUIMenuNavBar.kYoutubeSize = Vector(2000, 1500, 0)
local kDefaultNewsFeedWebViewSize = Vector(750, 562, 0) -- 0.375 of the GUIMenuNavBar.kNewsFeedSize


local youtubeOpenLink = "https://www.youtube.com/" -- we want the first link to be the last shared one
GUIMenuNavBar.kYoutubeConfig =
{

    { -- CHANGELOG
        name = "youtube",
        label = string.upper("youtube"),
        webPageParams =
        {
            url = youtubeOpenLink,
            renderSize = kDefaultNewsFeedWebViewSize,
            wheelEnabled = true,
            clickMode = "Full",
        },
    },
}


oldGUIMenuNavBarInitialize = GUIMenuNavBar.Initialize
function GUIMenuNavBar:Initialize(params, errorDepth)
    oldGUIMenuNavBarInitialize(self, params, errorDepth)

    self.youtube = CreateGUIObject("youtube", GUIMenuNewsFeed, self,
    {
        webPages = self.kYoutubeConfig,
    })
    self.youtube:SetAnchor(0.5, 1)
    self.youtube:SetHotSpot(0.5, 0)
    self.youtube:SetSize(self.kYoutubeSize)
    self.youtube:SetY(-self.youtube:GetPulloutHeight())
    self.youtube:SetInheritsParentPosition(false)
    self.youtube:Collapse(true, true)

    local  dj = false
    -- context menu should set DJ true or false
    function setDJ(choice)
        dj = choice
        if choice == true then
            --self.youtube:Show(true)
            self.youtube:Collapse(false, false)
        else
            self.youtube:Collapse(true, true)
            self.youtube.webPageObjs["youtube"]:SetURL("https://www.youtube.com/")
            self.youtube.webPageObjs["youtube"]:Set_WebViewShouldBeRendering(false)
        end
    end

    self.youtube.pullout.label:SetText("")
    self.youtube.pullout.label2:SetText("")

    function updateYoutubeLink(link)
        youtubeOpenLink = link
        if dj == true then
         self.youtube.webPageObjs["youtube"]:SetURL(tostring(link))
         self.youtube.webPageObjs["youtube"]:Set_WebViewShouldBeRendering(true)
        end
    end
end
