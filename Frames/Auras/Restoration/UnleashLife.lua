local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local UnleashLife = SSA.UnleashLife

-- Initialize Data Variables
UnleashLife.spellID = 73685
UnleashLife.pulseTime = 0
UnleashLife.elapsed = 0
UnleashLife.condition = function()
	local _,_,_,selected = GetTalentInfo(1,3,1)
	
	return selected
end

UnleashLife:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
		self.elapsed = 0
		
		if ((Auras:CharacterCheck(self,3) and self.condition()) or Auras:IsPreviewingAura(self)) then
			local groupID = Auras:GetAuraGroupID(self,self:GetName())
			local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
			local _,_,_,_,buffDuration,buffExpire = Auras:RetrieveAuraInfo("player",self.spellID,"HELPFUL")
		
			Auras:SetGlowStartTime(self,start,duration,self.spellID,"cooldown")
			Auras:SetGlowStartTime(self,((buffExpire or 0) - (buffDuration or 0)),buffDuration,self.spellID,"buff")
			Auras:GlowHandler(self)
			
			Auras:ToggleAuraVisibility(self,true,'showhide')
			Auras:CooldownHandler(self,groupID,start,duration)
			
			if (Auras:IsPlayerInCombat(true)) then
				self:SetAlpha(1)
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