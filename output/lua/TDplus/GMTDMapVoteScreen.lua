

function GMTDMapVoteScreen:InitializeVoteButtons(errorDepth)

      local sortedMapList = {}
      table.insert(sortedMapList, 1, kThunderdomeMaps[kThunderdomeMaps.RANDOMIZE])
      table.insert(sortedMapList, 2, kThunderdomeMaps[kThunderdomeMaps.ns2_biodome])
      table.insert(sortedMapList, 3, kThunderdomeMaps[kThunderdomeMaps.ns2_descent])
      table.insert(sortedMapList, 4, kThunderdomeMaps[kThunderdomeMaps.ns2_docking])
      table.insert(sortedMapList, 5, kThunderdomeMaps[kThunderdomeMaps.ns2_summit])
      table.insert(sortedMapList, 6, kThunderdomeMaps[kThunderdomeMaps.ns2_tanith])
      table.insert(sortedMapList, 7, kThunderdomeMaps[kThunderdomeMaps.ns2_tram])
      table.insert(sortedMapList, 8, kThunderdomeMaps[kThunderdomeMaps.ns2_unearthed])
      table.insert(sortedMapList, 9, kThunderdomeMaps[kThunderdomeMaps.ns2_veil])
      table.insert(sortedMapList, 10, kThunderdomeMaps[kThunderdomeMaps.ns2_ayumi])
      table.insert(sortedMapList, 11, kThunderdomeMaps[kThunderdomeMaps.ns2_caged])
      table.insert(sortedMapList, 12, kThunderdomeMaps[kThunderdomeMaps.ns2_derelict])
      table.insert(sortedMapList, 13, kThunderdomeMaps[kThunderdomeMaps.ns2_eclipse])
      table.insert(sortedMapList, 14, kThunderdomeMaps[kThunderdomeMaps.ns2_kodiak])
      table.insert(sortedMapList, 15, kThunderdomeMaps[kThunderdomeMaps.ns2_metro])
      table.insert(sortedMapList, 16, kThunderdomeMaps[kThunderdomeMaps.ns2_mineshaft])
      table.insert(sortedMapList, 17, kThunderdomeMaps[kThunderdomeMaps.ns2_origin])
      table.insert(sortedMapList, 18, kThunderdomeMaps[kThunderdomeMaps.ns2_refinery])

      for i = 1, #sortedMapList do
          local button = CreateGUIObject(string.format("mapVoteButton_%s", sortedMapList[i]), GMTDMapVoteButton, self.voteButtonsLayout, { levelName = sortedMapList[i] }, errorDepth)
          self:HookEvent(button, "OnMapVoteSelected", self.OnMapVoteSelected)
          self:HookEvent(button, "OnMapVoteUndo", self.OnMapVoteUndo)
          self:HookEvent(button, "OnMapVoteButtonMouseOver", self.OnMapVoteButtonMouseOver)
          table.insert(self.voteButtons, button)
      end
end
