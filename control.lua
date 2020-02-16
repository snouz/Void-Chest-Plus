--[[ Copyright (c) 2017 Optera
* Part of Void Chest Plus
*
* See LICENSE.md in the project directory for license information.
--]]

---- runtime Events ----
function OnChestCreated(entity)
  entity.infinity_container_filters = {}
  entity.remove_unfiltered_items = true
end


do ---- Init ----
local function init_chests()
  -- gather all void chests on every surface in case another mod added some
  global.VoidChests = nil
  for _, surface in pairs(game.surfaces) do
    local chests = surface.find_entities_filtered{ name = "void-chest" }
    for _, chest in pairs(chests) do
      chest.infinity_container_filters = {}
      chest.remove_unfiltered_items = true
    end
  end
end

local function init_events()
  -- event filters turn a one liner into this mess
  script.on_event( defines.events.on_built_entity,
    function(event) OnChestCreated(event.created_entity) end,
    {{ filter="name", name="void-chest" }}
  )
  script.on_event( defines.events.on_robot_built_entity,
    function(event) OnChestCreated(event.created_entity) end,
    {{ filter="name", name="void-chest" }}
  )
  script.on_event( {defines.events.script_raised_built, defines.events.script_raised_revive},
    function(event)
      local entity = event.created_entity or event.entity
      if entity.valid and entity.name == "void-chest" then
        OnChestCreated(entity)
      end
    end
  )
end

script.on_load(function()
  init_events()
end)

script.on_init(function()
  init_chests()
  init_events()
end)

script.on_configuration_changed(function(data)
  init_chests()
  init_events()
end)

end