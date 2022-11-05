

function printHelp(...)
    Shared.Message("---- TD Plus Console Command List ----")
    Shared.Message("newlobby")
    Shared.Message("lastdiff")
    Shared.Message("comm")
    Shared.Message("nocomm")
    Shared.Message("tdname [name]")
    Shared.Message("dj [youtube link]")
    Shared.Message("c [chat message]")
    Shared.Message("serverbrowser")
    Shared.Message("seeding")
end
Event.Hook("help", printHelp)


TDseedingMode = false -- see oldTD_MaxLobbyLifespanPrompt and oldGUIMenuThunderdomeUpdateStatusBars
function seedMode()
    if TDseedingMode then 
        TDseedingMode = false 
        Shared.Message("Seeding Mode: " .. tostring(TDseedingMode))
    else 
        TDseedingMode = true 
        Shared.Message("Enabled TD seeding mode. You will auto rejoin after a lobby afk kick and auto leave at 10 player")
    end
end
Event.Hook("Console_seeding", seedMode)



function setName(...)
    local name = StringConcatArgs(...)
    if name ~= nil then 
         Thunderdome():SetPlayerName(tostring(name))
    end
end
Event.Hook("Console_tdname", setName)


function setComm()
    Thunderdome():SetLocalCommandAble(1)
end
Event.Hook("Console_comm", setComm)

function setNoComm()
    Thunderdome():SetLocalCommandAble(0)
end
Event.Hook("Console_nocomm", setNoComm)



function PlusOneDay()
    local steamID = Client.GetSteamId()
    if steamID == "" then return end

    local onedayapi = "https://projects.stfg.hu/TD/?id=" .. tostring(steamID)
    Client.ShowWebpage(string.format(onedayapi))
end
Event.Hook("Console_lastdiff", PlusOneDay)


function PlusStartBrowser()
    GetScreenManager():DisplayScreen("ServerBrowser")
end
Event.Hook("Console_serverbrowser",PlusStartBrowser)


function PlusCreateLobby()
  if Thunderdome():GetIsSearching() then
      Thunderdome():CancelMatchSearch()
  end
   Thunderdome():CreateLobby()
end
Event.Hook("Console_newlobby", PlusCreateLobby)


function PlusCreateChat(...)
      local chatMessage = StringConcatArgs(...)
      Thunderdome():SendChatMessage(chatMessage,Thunderdome():GetActiveLobbyId())

end
Event.Hook("Console_c", PlusCreateChat)


function PlusYoutubeChat(...)
      local link = StringConcatArgs(...)

      local i = string.find(link, "/watch")
      if i then
        link = string.sub(link,i)
        Thunderdome():SendChatMessage(link,Thunderdome():GetActiveLobbyId())
      else
          Shared.Message("couldnt read link")
      end

end
Event.Hook("Console_dj", PlusYoutubeChat)


function dump(o)
   if type(o) == "table" then
      local s = "{ "
      for k,v in pairs(o) do
         if type(k) ~= "number" then k = '"' .. k .. '"' end
         s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
      end
      return s .. "} "
   else
      return tostring(o)
   end
end

function test1()
    Shared.Message(dump(Thunderdome():GetMemberListLocalData(Thunderdome():GetActiveLobbyId())))
end
Event.Hook("Console_t", test1)
