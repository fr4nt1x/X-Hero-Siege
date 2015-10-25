function GiffMana(event)
	local hero = event.caster
	local ability = event.ability
    hero:GiveMana(ability:GetSpecialValueFor ("mana"))
end