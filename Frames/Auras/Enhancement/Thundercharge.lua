local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetPvpTalentInfoByID = GetPvpTalentInfoByID
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local Thundercharge = SSA.Thundercharge

-- Initialize Data Variables
Thundercharge.spellID = 204366
Thundercharge.pulseTime = 0
Thundercharge.condition = function()
	local _,_,_,_,_,_,_,_,_,selected = GetPvpTalentInfoByID(725)
	
	return selected and Auras:IsPvPZone()
end

Thundercharge:SetScript('OnUpdate',function(self)
	if ((Auras:CharacterCheck(self,2) and self.condition()) or Auras:IsPreviewingAura(self)) then
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