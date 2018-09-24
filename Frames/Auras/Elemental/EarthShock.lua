local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local EarthShock = SSA.EarthShock

EarthShock:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(self,1,546)) then
		local spec,groupID = Auras:GetAuraInfo(self,'EarthShock')
		local power = UnitPower('player',Enum.PowerType.Maelstrom)
		local start,duration = GetSpellCooldown(Auras:GetSpellName(546))
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:SpellRangeCheck(self,8042,true,spec)	
		Auras:CooldownHandler(self,spec,groupID,start,duration,true)
		
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
			Auras:NoCombatDisplay(self,spec,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)