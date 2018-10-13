local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetPvpTalentInfoByID = GetPvpTalentInfoByID
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local SkyfuryTotem = SSA.SkyfuryTotem

-- Initilize Data Variables
SkyfuryTotem.spellID = 204330
SkyfuryTotem.pulseTime = 0
SkyfuryTotem.condition = function()
	local talentID = (SSA.spec == 1 and 3488) or (SSA.spec == 2 and 3487) or (SSA.spec == 3 and 707)
	
	return select(10,GetPvpTalentInfoByID(talentID)) and Auras:IsPvPZone()
end

SkyfuryTotem:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,"3488") or Auras:CharacterCheck(self,2,"3487") or Auras:CharacterCheck(self,3,"707")) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
		
		Auras:SetAuraStartTime(self,duration,self.spellID,"cooldown")
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