local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetTalentInfo = GetTalentInfo

-- Cache Global Addon Variables
local FlashFlood = SSA.FlashFlood

-- Initialize Data Variables
FlashFlood.spellID = 280614
FlashFlood.pulseTime = 0
FlashFlood.elapsed = 0
FlashFlood.condition = function()
	local _,_,_,selected = GetTalentInfo(6,1,1)
	
	return selected
end

FlashFlood:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
		self.elapsed = 0
		
		if ((Auras:CharacterCheck(spec,3) and self.condition()) or Auras:IsPreviewingAura(self)) then
			local groupID = Auras:GetAuraGroupID(self,self:GetName())
			local buff,_,_,_,duration,expires = Auras:RetrieveAuraInfo("player", 280615)

			Auras:SetGlowStartTime(self,((expires or 0) - (duration or 0)),duration,280615,"buff")
			Auras:GlowHandler(self)
			Auras:ToggleAuraVisibility(self,true,'showhide')
			Auras:CooldownHandler(self,groupID,((expires or 0) - (duration or 0)),duration)
			
			if (Auras:IsPlayerInCombat(true)) then
				if (buff) then
					self:SetAlpha(1)
					--Auras:ToggleOverlayGlow(self.glow,true,false)
				else
					self:SetAlpha(0.5)
					--Auras:ToggleOverlayGlow(self.glow,false)
				end
			else
				Auras:NoCombatDisplay(self,groupID)
			end
		else
			Auras:ToggleAuraVisibility(self,false,'showhide')
		end
	else
		self.elapsed = self.elapsed + elapsed
	end
end)