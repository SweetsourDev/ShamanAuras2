local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetPvpTalentInfoByID = GetPvpTalentInfoByID
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local LightningLasso = SSA.LightningLasso

-- Initialize Data Variables
LightningLasso.spellID = 204437
LightningLasso.pulseTime = 0
LightningLasso.elapsed = 0
LightningLasso.condition = function()
	local _,_,_,_,_,_,_,_,_,selected = GetPvpTalentInfoByID(731)
	
	return selected and Auras:IsPvPZone()
end

LightningLasso:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
		self.elapsed = 0
		
		if ((Auras:CharacterCheck(self,1) and self.condition()) or Auras:IsPreviewingAura(self)) then
			local groupID = Auras:GetAuraGroupID(self,self:GetName())
			local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
			
			Auras:SetGlowStartTime(self,start,duration,self.spellID,"cooldown")
			Auras:GlowHandler(self)
			Auras:ToggleAuraVisibility(self,true,'showhide')
			Auras:SpellRangeCheck(self,self.spellID,true)
			Auras:CooldownHandler(self,groupID,start,duration)
				
			if (Auras:IsPlayerInCombat()) then
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