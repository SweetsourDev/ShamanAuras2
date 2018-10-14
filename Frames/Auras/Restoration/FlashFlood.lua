local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetTalentInfo = GetTalentInfo

-- Cache Global Addon Variables
local FlashFlood = SSA.FlashFlood

-- Initialize Data Variables
FlashFlood.spellID = 280614
FlashFlood.pulseTime = 0
FlashFlood.condition = function()
	return select(4,GetTalentInfo(6,1,1))
end

FlashFlood:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(spec,3,6,1)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local buff,_,_,_,duration,expires = Auras:RetrieveAuraInfo("player", self.spellID)

		Auras:SetAuraStartTime(self,((expires or 0) - (duration or 0)),duration,self.spellID,"buff")
		Auras:GlowHandler(self)
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,groupID,((expires or 0) - (duration or 0)),duration)
		
		if (Auras:IsPlayerInCombat(true)) then
			if (buff) then
				self:SetAlpha(1)
				Auras:ToggleOverlayGlow(self.glow,true,false)
			else
				self:SetAlpha(0.5)
				Auras:ToggleOverlayGlow(self.glow,false)
			end
		else
			Auras:NoCombatDisplay(self,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)