local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local IsSpellKnown = IsSpellKnown
local UnitCastingInfo = UnitCastingInfo

-- Cache Global Addon Variables
local WindShear = SSA.WindShear

-- Initialize Data Variables
WindShear.spellID = 57994
WindShear.pulseTime = 0
WindShear.isInterruptible = false
WindShear.condition = function()
	return IsSpellKnown(57994)
end

WindShear:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,0,self.spellID)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
		local name,_,_,_,_,_,_,interrupt = UnitCastingInfo('target')
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:SpellRangeCheck(self,self.spellID,true)
		Auras:CooldownHandler(self,groupID,start,duration)
		Auras:SetAuraStartTime(self,duration,self.spellID,"cooldown")
		
		if (name and not interrupt and (start or 0) == 0 and Auras:IsTargetEnemy()) then
			self.isInterruptible = true
		else
			self.isInterruptible = false
		end
		
		
		Auras:GlowHandler(self)
		
		if (Auras:IsPlayerInCombat()) then
			self:SetAlpha(1)
		else
			Auras:NoCombatDisplay(self,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)