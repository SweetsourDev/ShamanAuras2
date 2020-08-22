local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local SurgeOfPower = SSA.SurgeOfPower

-- Initialize Data Variables
SurgeOfPower.spellID = 285514
SurgeOfPower.pulseTime = 0
SurgeOfPower.elapsed = 0
SurgeOfPower.condition = function()
	local _,_,_,selected = GetTalentInfo(6,1,1)
	
	return selected
end

SurgeOfPower:SetScript('OnUpdate', function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
			self.elapsed = 0
			
			if ((Auras:CharacterCheck(self,1) and self.condition()) or Auras:IsPreviewingAura(self)) then
				local groupID = Auras:GetAuraGroupID(self,self:GetName())
				local buff,_,_,_,duration,expires= Auras:RetrieveAuraInfo("player", self.spellID)

				Auras:SetGlowStartTime(self,((expires or 0) - (duration or 0)),duration,self.spellID,"buff")
				Auras:GlowHandler(self,groupID)
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
	end
end)