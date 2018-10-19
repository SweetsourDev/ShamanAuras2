local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local GetTalentInfo = GetTalentInfo

-- Cache Global Addon Variables
local AncestralGuidance = SSA.AncestralGuidance

-- Initialize Data Variables
AncestralGuidance.spellID = 108281
AncestralGuidance.pulseTime = 0
AncestralGuidance.condition = function()
	return select(4,GetTalentInfo(5,2,1))
end

AncestralGuidance:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,5,2)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
		
		Auras:SetGlowStartTime(self,start,duration,self.spellID,"cooldown")
		Auras:GlowHandler(self)
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,groupID,start,duration)
			
		if (Auras:IsPlayerInCombat()) then
			self:SetAlpha(1)
		else
			Auras:NoCombatDisplay(self,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)