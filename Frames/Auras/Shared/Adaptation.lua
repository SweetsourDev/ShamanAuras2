local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetPvpTalentInfoByID = GetPvpTalentInfoByID

--local GetSpecialization = GetSpecialization
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local Adaptation = SSA.Adaptation

-- Initialize Data Variables
Adaptation.spellID = 214027
Adaptation.condition = function()
	--local spec = GetSpecialization()
	local talentID = (SSA.spec == 1 and 3597) or (SSA.spec == 2 and 3552) or (SSA.spec == 3 and 3485)
	SSA.DataFrame.text:SetText("TALENT ID: "..tostring(talentID).." ("..tostring(SSA.spec)..")")
	return select(10,GetPvpTalentInfoByID(talentID)) and Auras:IsPvPZone()
end

Adaptation:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,"3597") or Auras:CharacterCheck(self,2,"3552") or Auras:CharacterCheck(self,3,"3485")) then
		--local spec,groupID = Auras:GetAuraInfo(self,self:GetName())
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		--Auras:CooldownHandler(self,spec,groupID,start,duration)
		Auras:CooldownHandler(self,groupID,start,duration)
			
		if (Auras:IsPlayerInCombat()) then
			self:SetAlpha(1)
		else
			--Auras:NoCombatDisplay(self,spec,groupID)
			Auras:NoCombatDisplay(self,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)