--[[Author: Pizzalol/Noya
  Date: 10.01.2015.
  Swaps the ranged attack, projectile and caster model
]]
function ModelSwapStart( keys )
  local caster = keys.caster
  local model = keys.model
  local ability = keys.ability
  local health_bonus = ability:GetSpecialValueFor("health_bonus")
  -- Saves the original model and attack capability
  if caster.caster_model == nil then 
    caster.caster_model = caster:GetModelName()
  end
  caster.caster_attack = caster:GetAttackCapability()

  -- Sets the new model and projectile
  caster:SetOriginalModel(model)
  local health = caster:GetBaseMaxHealth()+health_bonus
  caster:SetBaseMaxHealth(health)

  -- Sets the new attack type
  caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
end

--[[Author: Pizzalol/Noya
  Date: 10.01.2015.
  Reverts back to the original model and attack type
]]
function ModelSwapEnd( keys )
  local caster = keys.caster
  local ability = keys.ability
  local health_bonus = ability:GetSpecialValueFor("health_bonus")
  caster:SetModel(caster.caster_model)
  caster:SetOriginalModel(caster.caster_model)
  local health = caster:GetBaseMaxHealth()-health_bonus
  local health_percentage = caster:GetHealthPercent()

  caster:SetBaseMaxHealth(health)
  caster:SetMaxHealth(health)
  caster:SetHealth(caster:GetMaxHealth()*health_percentage)
  caster:SetAttackCapability(caster.caster_attack)
end

function HideWearables( event )
  local hero = event.caster
  local ability = event.ability
  local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
  hero.hiddenWearables = {} -- Keep every wearable handle in a table, as its way better to iterate than in the MovePeer system
  print("Hiding Wearables")
  local model = hero:FirstMoveChild()
  --hero:AddNoDraw() -- Doesn't work on classname dota_item_wearable
  while model ~= nil do
    if model:GetClassname() == "dota_item_wearable" then
        
        model:AddEffects(EF_NODRAW)

        table.insert(hero.hiddenWearables,model)
    end
    model = model:NextMovePeer()
  end
end

--[[Author: Noya
  Date: 10.01.2015.
  Shows the hidden hero wearables
]]
function ShowWearables( event )
  local hero = event.caster

  -- Iterate on both tables to set each item back to their original modelName
  for i,v in ipairs(hero.hiddenWearables) do
    v:RemoveEffects(EF_NODRAW)
  end
end