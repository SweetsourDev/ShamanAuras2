local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local GetTalentInfo = GetTalentInfo

-- Cache Global Addon Variables
local ElementalBlast = SSA.ElementalBlast

-- Initialize Data Variables
ElementalBlast.spellID = 117014
ElementalBlast.pulseTime = 0
ElementalBlast.elapsed = 0
ElementalBlast.condition = function()
	local spec = GetSpecialization()
	local selected = false

	if (spec == 1) then
		_,_,_,selected = GetTalentInfo(2,3,1)
	elseif (spec == 2) then
		_,_,_,selected = GetTalentInfo(1,3,1)
	end
	
	return selected
end

ElementalBlast:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
		self.elapsed = 0
		
		if (((Auras:CharacterCheck(self,1) or Auras:CharacterCheck(self,2)) and self.condition()) or Auras:IsPreviewingAura(self)) then
			local groupID = Auras:GetAuraGroupID(self,self:GetName())
			local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
			
			Auras:SetGlowStartTime(self,start,duration,self.spellID,"cooldown")
			Auras:GlowHandler(self)
			Auras:ToggleAuraVisibility(self,true,'showhide')
			Auras:SpellRangeCheck(self,self.spellID,true)
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