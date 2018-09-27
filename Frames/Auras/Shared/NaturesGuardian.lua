local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW Functions
local GetTalentInfo = GetTalentInfo
local GetTime = GetTime

-- Cache Global Addon Variables
local NaturesGuardian = SSA.NaturesGuardian

-- Initialize Data Variables
NaturesGuardian.spellID = 30884
NaturesGuardian.start = 0
NaturesGuardian.duration = 45
NaturesGuardian.condition = function()
	return select(4,GetTalentInfo(5,1,1))
end

NaturesGuardian:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,0,5,1)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		--local start,duration
		--local start,duration = GetSpellCooldown(Auras:GetSpellName(31616))
		--start = self.natureGuardianCastTime or nil
		
		--[[if (self.natureGuardianCastTime) then
			duration = 45
		else 
			duration = nil
		end]]
		
		if (GetTime() > (self.start + self.duration)) then
			self.start = 0
		end
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,groupID,self.start,self.duration)
			
		if (Auras:IsPlayerInCombat()) then
			if (self.start > 0) then
				self:SetAlpha(1)
			else
				self:SetAlpha(0.5)
			end
		else
			Auras:NoCombatDisplay(self,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)