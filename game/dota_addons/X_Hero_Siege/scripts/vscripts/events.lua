-- This file contains all barebones-registered events and has already set up the passed-in parameters for your use.
-- Do not remove the GameMode:_Function calls in these events as it will mess with the internal barebones systems.

require('libraries/notifications')
require('libraries/spawncreeps')
require('libraries/special_events')

-- Cleanup a player when they leave
function GameMode:OnDisconnect(keys)
  DebugPrint('[BAREBONES] Player Disconnected ' .. tostring(keys.userid))
  DebugPrintTable(keys)

  local name = keys.name
  local networkid = keys.networkid
  local reason = keys.reason
  local userid = keys.userid

end
-- The overall game state has changed
function GameMode:OnGameRulesStateChange(keys)
  DebugPrint("[BAREBONES] GameRules State Changed")
  DebugPrintTable(keys)

  -- This internal handling is used to set up main barebones functions
  GameMode:_OnGameRulesStateChange(keys)

  local newState = GameRules:State_Get()
end

-- An NPC has spawned somewhere in game.  This includes heroes
function GameMode:OnNPCSpawned(keys)
  DebugPrint("[BAREBONES] NPC Spawned")
  DebugPrintTable(keys)

  -- This internal handling is used to set up main barebones functions
  GameMode:_OnNPCSpawned(keys)

  local npc = EntIndexToHScript(keys.entindex)
  if npc:IsRealHero() and npc:GetTeam()== DOTA_TEAM_GOODGUYS then
    npc:AddNewModifier(npc, nil,  "modifier_item_ultimate_scepter", {})
    npc.ankh_respawn = false
  end
end

-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive
-- operations here
function GameMode:OnEntityHurt(keys)
  --DebugPrint("[BAREBONES] Entity Hurt")
  --DebugPrintTable(keys)

  local damagebits = keys.damagebits -- This might always be 0 and therefore useless
  if keys.entindex_attacker ~= nil and keys.entindex_killed ~= nil then
    local entCause = EntIndexToHScript(keys.entindex_attacker)
    local entVictim = EntIndexToHScript(keys.entindex_killed)

    -- The ability/item used to damage, or nil if not damaged by an item/ability
    local damagingAbility = nil

    if keys.entindex_inflictor ~= nil then
      damagingAbility = EntIndexToHScript( keys.entindex_inflictor )
    end
  end
end

-- An item was picked up off the ground
function GameMode:OnItemPickedUp(keys)
  DebugPrint( '[BAREBONES] OnItemPickedUp' )
  DebugPrintTable(keys)

  local heroEntity = EntIndexToHScript(keys.HeroEntityIndex)
  local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local itemname = keys.itemname
end

-- A player has reconnected to the game.  This function can be used to repaint Player-based particles or change
-- state as necessary
function GameMode:OnPlayerReconnect(keys)
  DebugPrint( '[BAREBONES] OnPlayerReconnect' )
  DebugPrintTable(keys) 
end

-- An item was purchased by a player
function GameMode:OnItemPurchased( keys )
  DebugPrint( '[BAREBONES] OnItemPurchased' )
  DebugPrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost
  
end

-- An ability was used by a player
function GameMode:OnAbilityUsed(keys)
  DebugPrint('[BAREBONES] AbilityUsed')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local abilityname = keys.abilityname
end

-- A non-player entity (necro-book, chen creep, etc) used an ability
function GameMode:OnNonPlayerUsedAbility(keys)
  DebugPrint('[BAREBONES] OnNonPlayerUsedAbility')
  DebugPrintTable(keys)

  local abilityname=  keys.abilityname
end

-- A player changed their name
function GameMode:OnPlayerChangedName(keys)
  DebugPrint('[BAREBONES] OnPlayerChangedName')
  DebugPrintTable(keys)

  local newName = keys.newname
  local oldName = keys.oldName
end

-- A player leveled up an ability
function GameMode:OnPlayerLearnedAbility( keys)
  DebugPrint('[BAREBONES] OnPlayerLearnedAbility')
  DebugPrintTable(keys)

  local player = EntIndexToHScript(keys.player)
  local abilityname = keys.abilityname
end

-- A channelled ability finished by either completing or being interrupted
function GameMode:OnAbilityChannelFinished(keys)
  DebugPrint('[BAREBONES] OnAbilityChannelFinished')
  DebugPrintTable(keys)

  local abilityname = keys.abilityname
  local interrupted = keys.interrupted == 1
end

-- A player leveled up
function GameMode:OnPlayerLevelUp(keys)
  DebugPrint('[BAREBONES] OnPlayerLevelUp')
  DebugPrintTable(keys)

  local player = EntIndexToHScript(keys.player)
  local level = keys.level
  local hero = nil
  if player ~= nil then
    hero = player:GetAssignedHero()
  else
    return nil
  end
  print(level)
  if level >= 19 then
    hero:SetAbilityPoints(hero:GetAbilityPoints()-1) 
  end
end

-- A player last hit a creep, a tower, or a hero
function GameMode:OnLastHit(keys)
  DebugPrint('[BAREBONES] OnLastHit')

  local isFirstBlood = keys.FirstBlood == 1
  local isHeroKill = keys.HeroKill == 1
  local isTowerKill = keys.TowerKill == 1
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local killedEnt = EntIndexToHScript(keys.EntKilled) 
  
  if player == nil or isTowerKill then
    return nil
  end
  local hero = player:GetAssignedHero()

  if not killedEnt:HasModifier("modifier_arena_kill") then
    hero.creep_kills = hero.creep_kills +1
  end
  if not isTowerKill and player:GetAssignedHero():IsAlive() and not player:GetAssignedHero().in_special_event and player:GetTeam() == DOTA_TEAM_GOODGUYS then
    if hero.creep_kills >= creep_kills_for_gold and not hero.got_kill_bonus then
      PlayerResource:SetGold(keys.PlayerID, PlayerResource:GetGold(keys.PlayerID)+5000, true)
      hero.got_kill_bonus = true
      Notifications:TopToAll({text=player:GetAssignedHero():GetName().." has "..creep_kills_for_gold.." kills. He got 5000 gold.", duration=5.0})
    
    elseif not  GameMode.kill_event_happened  and hero.creep_kills >= creep_kills_for_event then
      GameMode.kill_event_happened = true
      hero.creep_kills = 0
      startKillEvent(player:GetAssignedHero())
    end

    if killedEnt:HasAbility("wave_modifier") then
      hero.wave_kills = hero.wave_kills +1
      if not GameMode.wave_event_happened and hero.wave_kills >= wave_kills_for_event then
        Notifications:TopToAll({text=player:GetAssignedHero():GetName().." has ".. wave_kills_for_event.." wave kills. Special Arena WAVE.", duration=5.0})
        GameMode.wave_event_happened = true
        hero.wave_kills = 0
        startWaveKillEvent(hero)
      end
    end
  end
end

-- A tree was cut down by tango, quelling blade, etc
function GameMode:OnTreeCut(keys)
  DebugPrint('[BAREBONES] OnTreeCut')
  DebugPrintTable(keys)

  local treeX = keys.tree_x
  local treeY = keys.tree_y
end

-- A rune was activated by a player
function GameMode:OnRuneActivated (keys)
  DebugPrint('[BAREBONES] OnRuneActivated')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local rune = keys.rune

  --[[ Rune Can be one of the following types
  DOTA_RUNE_DOUBLEDAMAGE
  DOTA_RUNE_HASTE
  DOTA_RUNE_HAUNTED
  DOTA_RUNE_ILLUSION
  DOTA_RUNE_INVISIBILITY
  DOTA_RUNE_BOUNTY
  DOTA_RUNE_MYSTERY
  DOTA_RUNE_RAPIER
  DOTA_RUNE_REGENERATION
  DOTA_RUNE_SPOOKY
  DOTA_RUNE_TURBO
  ]]
end

-- A player took damage from a tower
function GameMode:OnPlayerTakeTowerDamage(keys)
  DebugPrint('[BAREBONES] OnPlayerTakeTowerDamage')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local damage = keys.damage
end

-- A player picked a hero
function GameMode:OnPlayerPickHero(keys)
  DebugPrint('[BAREBONES] OnPlayerPickHero')
  DebugPrintTable(keys)

  local heroClass = keys.hero
  local heroEntity = EntIndexToHScript(keys.heroindex)
  local player = EntIndexToHScript(keys.player)
end

-- A player killed another player in a multi-team context
function GameMode:OnTeamKillCredit(keys)
  DebugPrint('[BAREBONES] OnTeamKillCredit')
  DebugPrintTable(keys)

  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
  local numKills = keys.herokills
  local killerTeamNumber = keys.teamnumber
end

-- An entity died
function GameMode:OnEntityKilled( keys )
  DebugPrint( '[BAREBONES] OnEntityKilled Called' )
  DebugPrintTable( keys )

  GameMode:_OnEntityKilled( keys )
  

  -- The Unit that was Killed
  local killedUnit = EntIndexToHScript( keys.entindex_killed )
  -- The Killing entity
  local killerEntity = nil

  if keys.entindex_attacker ~= nil then
    killerEntity = EntIndexToHScript( keys.entindex_attacker )
  end

  -- The ability/item used to kill, or nil if not killed by an item/ability
  local killerAbility = nil

  if keys.entindex_inflictor ~= nil then
    killerAbility = EntIndexToHScript( keys.entindex_inflictor )
  end

  local damagebits = keys.damagebits -- This might always be 0 and therefore useless

  -- Put code here to handle when an entity gets killed
end



-- This function is called 1 to 2 times as the player connects initially but before they 
-- have completely connected
function GameMode:PlayerConnect(keys)
  DebugPrint('[BAREBONES] PlayerConnect')
  DebugPrintTable(keys)
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(keys)
  DebugPrint('[BAREBONES] OnConnectFull')
  DebugPrintTable(keys)

  GameMode:_OnConnectFull(keys)
  
  local entIndex = keys.index+1
  -- The Player entity of the joining user
  local ply = EntIndexToHScript(entIndex)
  
  -- The Player ID of the joining player
  local playerID = ply:GetPlayerID()
end

-- This function is called whenever illusions are created and tells you which was/is the original entity
function GameMode:OnIllusionsCreated(keys)
  DebugPrint('[BAREBONES] OnIllusionsCreated')
  DebugPrintTable(keys)

  local originalEntity = EntIndexToHScript(keys.original_entindex)
end

-- This function is called whenever an item is combined to create a new item
function GameMode:OnItemCombined(keys)
  DebugPrint('[BAREBONES] OnItemCombined')
  DebugPrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end
  local player = PlayerResource:GetPlayer(plyID)

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost
end

-- This function is called whenever an ability begins its PhaseStart phase (but before it is actually cast)
function GameMode:OnAbilityCastBegins(keys)
  DebugPrint('[BAREBONES] OnAbilityCastBegins')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local abilityName = keys.abilityname
  end

-- This function is called whenever a tower is killed
function GameMode:OnTowerKill(keys)
  DebugPrint('[BAREBONES] OnTowerKill')
  DebugPrintTable(keys)

  local gold = keys.gold
  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local team = keys.teamnumber
end

-- This function is called whenever a player changes there custom team selection during Game Setup 
function GameMode:OnPlayerSelectedCustomTeam(keys)
  DebugPrint('[BAREBONES] OnPlayerSelectedCustomTeam')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.player_id)
  local success = (keys.success == 1)
  local team = keys.team_id
end

-- This function is called whenever an NPC reaches its goal position/target
function GameMode:OnNPCGoalReached(keys)
  DebugPrint('[BAREBONES] OnNPCGoalReached')
  DebugPrintTable(keys)

  local goalEntity = EntIndexToHScript(keys.goal_entindex)
  local nextGoalEntity = EntIndexToHScript(keys.next_goal_entindex)
  local npc = EntIndexToHScript(keys.npc_entindex)
end

-- This function is called whenever any player sends a chat message to team or All
function GameMode:OnPlayerChat(keys)
  local teamonly = keys.teamonly
  local userID = keys.userid
  local playerID = self.vUserIds[userID]:GetPlayerID()
  local text = keys.text
  local player = PlayerResource:GetPlayer(playerID)
  local numberOFPlayers = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
  
  for i = 0,numberOFPlayers-1 do
      if playerID == i then

        local i,j = string.find(text,"openlane_%d")
        local lane = nil
        if i ~= nil then
           lane = string.sub(text,i,j)
        end
        if lane == text then
          local i,j = string.find(lane,"%d")
          lane = tonumber(string.sub(lane,i,j))
          print(lane)
          if lane <= 8 then
            GameMode.openLanes["spawn"..lane] = "wp_p"..lane.."_1"
            local towers = Entities:FindAllByName("tower_p"..lane)
        
            for _,tower in pairs(towers)do
            tower:RemoveModifierByName("modifier_invulnerable")
            end 

          end
        end

        local i,j = string.find(text,"closelane_%d")
        local lane = nil
        if i ~= nil then
           lane = string.sub(text,i,j)
        end
        if lane == text then
          local i,j = string.find(lane,"%d")
          lane = tonumber(string.sub(lane,i,j))
          print(lane)
          if lane <= 8 then
            GameMode.openLanes["spawn"..lane] = nil
            local towers = Entities:FindAllByName("tower_p"..lane)
        
            for _,tower in pairs(towers)do
              tower:AddNewModifier(nil,nil,"modifier_invulnerable",nil)
            end 
          end
        end

        break
      end
  end
  
  if text ~= nil and text == "bt" then
    local hero = PlayerResource:GetPlayer(playerID):GetAssignedHero()
    if hero.old_position_arena ~= nil then
      Notifications:Top(hero:GetPlayerOwnerID(), {text="Buy Tomes is not working during this special_event!", duration=5, style={color="red"}, continue=true})
      return nil
    end
    local gold = hero:GetGold()
    local cost = 8000
    local numberOfTomes = math.floor(gold / cost)
    if numberOfTomes >= 1 then
      PlayerResource:SpendGold(playerID, (numberOfTomes)*cost, DOTA_ModifyGold_PurchaseItem)
      hero:ModifyAgility(numberOfTomes*100)
      hero:ModifyStrength(numberOfTomes*100)
      hero:ModifyIntellect(numberOfTomes*100)
    end
  end

  local  i, j = string.find(text, "giff_%d_%d+")
  
  if text ~= nil and i ~=nil and text == string.sub(text,i,j) then
    local i,j = string.find(text, "giff")
    local both_numbers = string.sub(text,j+2,-1)
    i,j = string.find(both_numbers,"_")
    local receiving_player = string.sub(both_numbers,1,i-1)
    local amount = string.sub(both_numbers,j+1,-1)

    receiving_player = PlayerResource:GetPlayer(receiving_player-1)

    if player ~= nil and receiving_player~=nil and receiving_player ~= player and player:GetAssignedHero():GetGold() >= tonumber(amount) and receiving_player~=nil then
      PlayerResource:ModifyGold(receiving_player:GetPlayerID(),tonumber(amount), false, DOTA_ModifyGold_Unspecified)
      PlayerResource:ModifyGold(player:GetPlayerID(),-tonumber(amount), false, DOTA_ModifyGold_Unspecified)
    end
    
  end


end