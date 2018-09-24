local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local UnitPower = UnitPower

-- Cache Global Addon Variables
local EarthenSpike = SSA.EarthenSpike

EarthenSpike:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(self,2,7,2)) then
		local spec,groupID = Auras:GetAuraInfo(self,'EarthenSpike')
		local start,duration = GetSpellCooldown(Auras:GetSpellName(188089))
		local power = UnitPower('player',Enum.PowerType.Maelstrom)
	
		Auras:SpellRangeCheck(self,188089,true,spec)
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,spec,groupID,start,duration)

		if (Auras:IsPlayerInCombat()) then
			if (power >= 30) then
				self:SetAlpha(1)
			else
				self:SetAlpha(0.5)
			end
		else
			Auras:NoCombatDisplay(self,spec,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)