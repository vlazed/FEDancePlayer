local feDancePlayer = script:FindFirstAncestor("FE-Dance-Animations")
local ControllerSettings = require(feDancePlayer.Controllers.ControllerSettings)
local PlayerHelper = require(feDancePlayer.PlayerHelper)

local ContextActionService = game:GetService("ContextActionService")
local prevSettings = {}

local ActionHandler = {}


function table_eq(table1, table2)
    local avoid_loops = {}
    local function recurse(t1, t2)
       -- compare value types
       if type(t1) ~= type(t2) then return false end
       -- Base case: compare simple values
       if type(t1) ~= "table" then return t1 == t2 end
       -- Now, on to tables.
       -- First, let's avoid looping forever.
       if avoid_loops[t1] then return avoid_loops[t1] == t2 end
       avoid_loops[t1] = t2
       -- Copy keys from t2
       local t2keys = {}
       local t2tablekeys = {}
       for k, _ in pairs(t2) do
          if type(k) == "table" then table.insert(t2tablekeys, k) end
          t2keys[k] = true
       end
       -- Let's iterate keys from t1
       for k1, v1 in pairs(t1) do
          local v2 = t2[k1]
          if type(k1) == "table" then
             -- if key is a table, we need to find an equivalent one.
             local ok = false
             for i, tk in ipairs(t2tablekeys) do
                if table_eq(k1, tk) and recurse(v1, t2[tk]) then
                   table.remove(t2tablekeys, i)
                   t2keys[tk] = nil
                   ok = true
                   break
                end
             end
             if not ok then return false end
          else
             -- t1 has a key which t2 doesn't have, fail.
             if v2 == nil then return false end
             t2keys[k1] = nil
             if not recurse(v1, v2) then return false end
          end
       end
       -- if t2 has a key which t1 doesn't have, fail.
       if next(t2keys) then return false end
       return true
    end
    return recurse(table1, table2)
end


function ActionHandler:Update()
    
    local Settings = ControllerSettings.GetSettings()
    
    if table_eq(Settings, prevSettings) then 
        --print("Tables equal") 
        return 
    end

    prevSettings = Settings
    
    ContextActionService:UnbindAction("Listen")
    ContextActionService:BindAction("Listen", ActionHandler.Listen, false, Settings.followButton, Settings.respawnButton)
end


function ActionHandler.Listen(an, is, io)
    if is == Enum.UserInputState.Begin then
        if io.KeyCode == prevSettings.followButton then
            print("Following")
            PlayerHelper.Following = not PlayerHelper.Following
        elseif io.KeyCode == prevSettings.respawnButton then
            print("Respawning")
            PlayerHelper.Respawning = true
        end
    end
end


function ActionHandler:Init()
    local Settings = ControllerSettings.GetSettings()
    prevSettings = Settings

    ContextActionService:BindAction("Listen", ActionHandler.Listen, false, Settings.followButton, Settings.respawnButton)
end

return ActionHandler