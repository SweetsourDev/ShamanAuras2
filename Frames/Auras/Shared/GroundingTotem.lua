local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetPvpTalentInfoByID = GetPvpTalentInfoByID
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local GroundingTotem = SSA.GroundingTotem

-- Initialize Data Variables
GroundingTotem.spellID = 204336
GroundingTotem.pulseTime = 0
GroundingTotem.condition = function()
	local talentID = (SSA.spec == 1 and 3620) or (SSA.spec == 2 and 3622) or (SSA.spec == 3 and 715)
	
	return select(10,GetPvpTalentInfoByID(talentID)) and Auras:IsPvPZone()
end

GroundingTotem:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,"3620") or Auras:CharacterCheck(self,2,"3622") or Auras:CharacterCheck(self,3,"715")) then
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