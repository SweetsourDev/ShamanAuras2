local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local Enum = Enum
local GetSpellCooldown = GetSpellCooldown
local IsSpellKnown = IsSpellKnown

-- Cache Global Addon Variables
local EarthShock = SSA.EarthShock

-- Initialize Data Variables
EarthShock.spellID = 8042
EarthShock.condition = function()
	return IsSpellKnown(8042)
end

EarthShock:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(self,1,self.spellID)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local power = UnitPower('player',Enum.PowerType.Maelstrom)
		local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:SpellRangeCheck(self,self.spellID,true)
		Auras:CooldownHandler(self,groupID,start,duration,true)
		
		if (Auras:IsPlayerInCombat()) then
			--[[if (power >= Auras.db.char.elements[1].statusbars.maelstromBar.threshold) then
				Auras:ToggleOverlayGlow(self.glow,true)
			else
				Auras:ToggleOverlayGlow(self.glow,false)
			end]]
			if (power >= 60) then
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