local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local GetTalentInfo = GetTalentInfo
local IsSpellKnown = IsSpellKnown

-- Cache Global Addon Variables
local FireElemental = SSA.FireElemental

-- Initialize Data Variables
FireElemental.spellID = 198067
FireElemental.pulseTime = 0
FireElemental.condition = function()
	return not select(4,GetTalentInfo(4,2,1)) and IsSpellKnown(198067)
end

FireElemental:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,self.spellID) and self.condition()) then
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
		print("Fire Elemental: "..tostring(not Auras:CharacterCheck(self,1,4,2)))
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)