local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Function
local Enum = Enum
local GetSpellCooldown = GetSpellCooldown
local GetTime = GetTime
local UnitPower = UnitPower

-- Cache Global Addon Variables
local Frostbrand = SSA.Frostbrand

-- Initialize Data Variables
Frostbrand.spellID = 196834
Frostbrand.condition = function()
	return IsSpellKnown(196834)
end

Frostbrand:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(self,2,self.spellID)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local start,duration = GetSpellCooldown(Auras:GetSpellName(spellID))
		local buff,_,_,_,_,expires = Auras:RetrieveAuraInfo('player',self.spellID)
		local power = UnitPower('player',Enum.PowerType.Maelstrom)
		
		Auras:SpellRangeCheck(self,self.spellID,true)
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,groupID,start,duration,true)
		
		-- If the player has the Frostbrand buff, run this code
		if (buff) then
			local timer,seconds = Auras:parseTime((expires or 0) - GetTime(),false,true,groupID)
			
			if (seconds > Auras.db.char.settings[SSA.spec].frostbrand or power < 20) then
				Auras:ToggleOverlayGlow(self.glow,false)
			elseif (seconds <= Auras.db.char.settings[SSA.spec].frostbrand and Auras:IsPlayerInCombat(true) and power >= 20) then
				Auras:ToggleOverlayGlow(self.glow,true)
			end
		end
		
		if (Auras:IsPlayerInCombat()) then
			if (power >= 20) then
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