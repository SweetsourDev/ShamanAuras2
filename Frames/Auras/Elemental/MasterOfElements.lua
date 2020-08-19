local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW Functions
local GetTalentInfo = GetTalentInfo

-- Cache Global Addon Variables
local MasterOfElements = SSA.MasterOfElements

-- Initialize Data Variables
MasterOfElements.spellID = 260734
MasterOfElements.pulseTime = 0
MasterOfElements.elapsed = 0
MasterOfElements.condition = function()
	local _,_,_,selected = GetTalentInfo(4,1,1)
	
	return selected
end

MasterOfElements:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
		self.elapsed = 0
		
		if ((Auras:CharacterCheck(self,1) and self.condition()) or Auras:IsPreviewingAura(self)) then
			local groupID = Auras:GetAuraGroupID(self,self:GetName())
			local buff,_,_,_,duration,expires = Auras:RetrieveAuraInfo("player", self.spellID)
			
			Auras:SetGlowStartTime(self,((expires or 0) - (duration or 0)),duration,16166,"buff")
			Auras:GlowHandler(self)
			Auras:ToggleAuraVisibility(self,true,'showhide')
			Auras:CooldownHandler(self,groupID,((expires or 0) - (duration or 0)),duration)
				
			if (Auras:IsPlayerInCombat()) then
				if (buff) then
					self:SetAlpha(1)
					--Auras:ToggleOverlayGlow(self.glow,true,false)
				else
					self:SetAlpha(0.5)
					--Auras:ToggleOverlayGlow(self.glow,false)
				end
			else
				Auras:NoCombatDisplay(self,groupID)
				
				--[[if (buff) then
					Auras:ToggleOverlayGlow(self.glow,true,false)
				else
					Auras:ToggleOverlayGlow(self.glow,false)
				end]]
			end
		else
			Auras:ToggleAuraVisibility(self,false,'showhide')
		end
	else
		self.elapsed = self.elapsed + elapsed
	end
end)