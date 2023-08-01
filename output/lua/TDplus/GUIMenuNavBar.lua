
GUIMenuNavBar.kYoutubeSize = Vector(2000, 1500, 0)
local kDefaultNewsFeedWebViewSize = Vector(750, 562, 0) -- 0.375 of the GUIMenuNavBar.kNewsFeedSize

GUIMenuNavBar.kYoutubeConfig =
{

    { -- CHANGELOG
        name = "youtube",
        label = string.upper("youtube"),
        webPageParams =
        {
            url = "https://www.youtube.com/",
            renderSize = kDefaultNewsFeedWebViewSize,
            wheelEnabled = true,
            clickMode = "Full",
        },
    },
}


local oldGUIMenuNavBarInitialize = GUIMenuNavBar.Initialize
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

    local  dj = true
    -- context menu should set DJ true or false
    function setDJ(choice)
        dj = choice
        if choice == true then
            --self.youtube:Show(true)
            self.youtube:Collapse(false, false)
        else
            disableYoutube()
        end
    end

    function disableYoutube()
        self.youtube:Collapse(true, true)
        self.youtube.webPageObjs["youtube"]:SetURL("https://www.youtube.com/")
        self.youtube.webPageObjs["youtube"]:Set_WebViewShouldBeRendering(false)
    end

    self.youtube.pullout.label:SetText("")
    self.youtube.pullout.label2:SetText("")

    function youtubePopup(link)

        if dj == false then return end
        local   message = "Do you want to open this Youtube link? : " ..  tostring(link)

          local OnOk = function(popup)
            --self.youtube:Show(true)
            self.youtube:Collapse(false, false)
            self.youtube.webPageObjs["youtube"]:SetURL(tostring(link))
            self.youtube.webPageObjs["youtube"]:Set_WebViewShouldBeRendering(true)
            popup:Close()
          end

          local OnCancel = function(popup)
              popup:Close()
          end

          local OnStop = function(popup)
                dj = false
                setDJtext("Enable YouTube")
            popup:Close()
        end


          local popup = CreateGUIObject("popup", GUIMenuPopupSimpleMessage, nil,
          {
              title = "Youtube",
              message = message,
              escDisabled = true,
              buttonConfig =
              {
                  {
                      name = "ok",
                      params =
                      {
                          label = string.upper("YES"),
                      },
                      callback = OnOk,
                  },
                  {
                      name = "cancel",
                      params =
                      {
                          label = string.upper("NO"),
                      },
                      callback = OnCancel,
                  },
                  {
                    name = "stop",
                    params =
                    {
                        label = string.upper("BLOCK ALL"),
                    },
                    callback = OnStop,
                }
              }
          })
      end
end
