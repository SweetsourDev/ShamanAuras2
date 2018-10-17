local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetPvpTalentInfoByID = GetPvpTalentInfoByID
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local EtherealForm = SSA.EtherealForm

-- Initialize Data Variables
EtherealForm.spellID = 210918
EtherealForm.pulseTime = 0
EtherealForm.condition = function()
	return select(10,GetPvpTalentInfoByID(1944)) and Auras:IsPvPZone()
end

EtherealForm:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,2,"1944")) then
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