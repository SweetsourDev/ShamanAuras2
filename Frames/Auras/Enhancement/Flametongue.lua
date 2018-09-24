local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local GetTime = GetTime

-- Cache Global Addon Variables
local Flametongue = SSA.Flametongue

Flametongue:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(self,2,193796)) then
		local spec,groupID = Auras:GetAuraInfo(self,self:GetName())
		local buff,_,_,_,_,expires = Auras:RetrieveBuffInfo('player',Auras:GetSpellName(193796))
		local start,duration = GetSpellCooldown(Auras:GetSpellName(193796))
		
		Auras:SpellRangeCheck(self,193796,true,spec)
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,spec,groupID,start,duration)
		
		if (buff) then
			local timer,seconds = Auras:parseTime((expires or 0) - GetTime(),false,spec,groupID)
			
			if (seconds > Auras.db.char.settings[spec].flametongue) then
				Auras:ToggleOverlayGlow(self.glow,false)
			elseif (seconds <= Auras.db.char.settings[spec].flametongue and Auras:IsPlayerInCombat(true)) then
				Auras:ToggleOverlayGlow(self.glow,true)
			end
		end
		
		if (Auras:IsPlayerInCombat()) then
			self:SetAlpha(1)
		else
			Auras:NoCombatDisplay(self,spec,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)