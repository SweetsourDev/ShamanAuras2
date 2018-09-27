local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local Enum = Enum
local GetSpellCooldown = GetSpellCooldown
local GetTalentInfo = GetTalentInfo
local UnitPower = UnitPower

-- Cache Global Addon Variables
local EarthenSpike = SSA.EarthenSpike

-- Initialize Data Variables
EarthenSpike.spellID = 188089
EarthenSpike.condition = function()
	return select(4,GetTalentInfo(7,2,1))
end

EarthenSpike:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(self,2,7,2)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
		local power = UnitPower('player',Enum.PowerType.Maelstrom)
	
		Auras:SpellRangeCheck(self,self.spellID,true)
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,groupID,start,duration)

		if (Auras:IsPlayerInCombat()) then
			if (power >= 30) then
				self:SetAlpha(1)
			else
				self:SetAlpha(0.5)
			end
		else
			Auras:NoCombatDisplay(self,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)