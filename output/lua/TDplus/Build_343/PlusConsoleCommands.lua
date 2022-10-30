

--[[
TODO s:
Save the youtube setting in a config file,
Youtubebar is sometimes visible when it shouldnt be,
LastRoundStats are not perfect aligned,
add comm time when hovering over a player at LastRoundStats,
Babbler has a weird pixel

Ideas:
Display the XP/level info
Load the images from a webpage instead of saving them locally
]]


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
