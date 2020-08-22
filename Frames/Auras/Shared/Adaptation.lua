local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetPvpTalentInfoByID = GetPvpTalentInfoByID

--local GetSpecialization = GetSpecialization
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local Adaptation = SSA.Adaptation

-- Initialize Data Variables
Adaptation.spellID = 214027
Adaptation.pulseTime = 0
Adaptation.elapsed = 0
Adaptation.condition = function()
	local talentID = (SSA.spec == 1 and 3597) or (SSA.spec == 2 and 3552) or (SSA.spec == 3 and 3485)
	local _,_,_,_,_,_,_,_,_,selected = GetPvpTalentInfoByID(talentID)
	
	return selected and Auras:IsPvPZone()
end

Adaptation:SetScript('OnUpdate',function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
			self.elapsed = 0
			
			if (Auras:CharacterCheck(self,1,"3597") or Auras:CharacterCheck(self,2,"3552") or Auras:CharacterCheck(self,3,"3485")) then
				local groupID = Auras:GetAuraGroupID(self,self:GetName())
				local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
				
				Auras:SetGlowStartTime(self,start,duration,self.spellID,"cooldown")
				Auras:GlowHandler(self,groupID)
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
		else
			self.elapsed = self.elapsed + elapsed
		end
	end
end)