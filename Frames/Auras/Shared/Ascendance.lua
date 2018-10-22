local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local GetTalentInfo = GetTalentInfo

-- Cache Global Addon Variables
local Ascendance = SSA.Ascendance

-- Initialize Data Variables
Ascendance.spellID = 114050
Ascendance.pulseTime = 0
Ascendance.condition = function()
	return select(4,GetTalentInfo(7,3,1))
end

Ascendance:SetScript('OnUpdate',function(self)
	self.spellID = (SSA.spec == 1 and 114050) or (SSA.spec == 2 and 114051) or (SSA.spec == 3 and 114052)
	
	if (Auras:CharacterCheck(self,0,7,3)) then
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