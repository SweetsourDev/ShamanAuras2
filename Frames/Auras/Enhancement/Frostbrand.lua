local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Function
local GetSpellCooldown = GetSpellCooldown
local GetTime = GetTime
local UnitPower = UnitPower

-- Cache Global Addon Variables
local Frostbrand = SSA.Frostbrand

Frostbrand:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(self,2,196834)) then
		local spec,groupID = Auras:GetAuraInfo(self,self:GetName())
		local start,duration = GetSpellCooldown(Auras:GetSpellName(196834))
		local buff,_,_,_,_,expires = Auras:RetrieveBuffInfo('player',Auras:GetSpellName(196834))
		local power = UnitPower('player',Enum.PowerType.Maelstrom)
		
		Auras:SpellRangeCheck(self,193796,true,spec)
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,spec,groupID,start,duration,true)
		
		-- If the player has the Frostbrand buff, run this code
		if (buff) then
			local timer,seconds = Auras:parseTime((expires or 0) - GetTime(),false,spec,groupID)
			
			if (seconds > Auras.db.char.settings[spec].frostbrand or power < 20) then
				Auras:ToggleOverlayGlow(self.glow,false)
			elseif (seconds <= Auras.db.char.settings[spec].frostbrand and Auras:IsPlayerInCombat(true) and power >= 20) then
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
			Auras:NoCombatDisplay(self,spec,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)