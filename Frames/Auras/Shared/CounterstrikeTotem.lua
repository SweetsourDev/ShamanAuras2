local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown

-- Cache Global Addon Variables
local CounterstrikeTotem = SSA.CounterstrikeTotem

-- Initialize Data Variables
CounterstrikeTotem.spellID = 204331
CounterstrikeTotem.pulseTime = 0
CounterstrikeTotem.elapsed = 0
CounterstrikeTotem.condition = function()
	local talentID = (SSA.spec == 1 and 3490) or (SSA.spec == 2 and 3489) or (SSA.spec == 3 and 708)
	local _,_,_,_,_,_,_,_,_,selected = GetPvpTalentInfoByID(talentID)
	
	return selected and Auras:IsPvPZone()
end

CounterstrikeTotem:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
		self.elapsed = 0
		
		if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingAura(self)) then
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
	else
		self.elapsed = self.elapsed + elapsed
	end
end)