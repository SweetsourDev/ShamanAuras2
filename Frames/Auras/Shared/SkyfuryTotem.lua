local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetPvpTalentInfoByID = GetPvpTalentInfoByID
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local SkyfuryTotem = SSA.SkyfuryTotem

-- Initilize Data Variables
SkyfuryTotem.spellID = 204330
SkyfuryTotem.pulseTime = 0
SkyfuryTotem.elapsed = 0
SkyfuryTotem.condition = function()
	local talentID = (SSA.spec == 1 and 3488) or (SSA.spec == 2 and 3487) or (SSA.spec == 3 and 707)
	local _,_,_,_,_,_,_,_,_,selected = GetPvpTalentInfoByID(talentID)
	
	return selected and Auras:IsPvPZone()
end

SkyfuryTotem:SetScript('OnUpdate',function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
			self.elapsed = 0
			
			if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingAura(self)) then
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